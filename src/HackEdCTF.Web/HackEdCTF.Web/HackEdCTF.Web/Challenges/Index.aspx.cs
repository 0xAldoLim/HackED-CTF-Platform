using System;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Challenges_Index : Page
{
    private string ConnStr
    {
        get { return System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString; }
    }

    private int? SelectedChallengeID
    {
        get { return ViewState["SelectedChallengeID"] == null ? (int?)null : (int)ViewState["SelectedChallengeID"]; }
        set { ViewState["SelectedChallengeID"] = value; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        SetupNav();
        pnlLoginNotice.Visible = !IsLoggedIn;

        if (!IsPostBack)
        {
            LoadCategories();
            LoadChallenges();
        }
    }

    protected void Filter_Changed(object sender, EventArgs e)
    {
        LoadChallenges();
    }

    protected void btnReset_Click(object sender, EventArgs e)
    {
        ddlCategory.SelectedValue = "";
        ddlDifficulty.SelectedValue = "";
        txtSearch.Text = "";
        LoadChallenges();
    }

    protected void rptChallenges_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName != "SelectChallenge") return;

        SelectedChallengeID = int.Parse(e.CommandArgument.ToString());
        pnlFlagFeedback.Visible = false;
        txtFlag.Text = "";
        LoadChallengeDetail(SelectedChallengeID.Value);
    }

    protected void btnCloseDetail_Click(object sender, EventArgs e)
    {
        pnlDetail.Visible = false;
        pnlFlagFeedback.Visible = false;
        SelectedChallengeID = null;
        txtFlag.Text = "";
    }

    protected void btnSubmitFlag_Click(object sender, EventArgs e)
    {
        if (!IsLoggedIn)
        {
            ShowFlagFeedback("You need to log in before submitting a flag.", false);
            return;
        }

        if (!SelectedChallengeID.HasValue)
        {
            ShowAlert("Please select a challenge first.", false);
            return;
        }

        Page.Validate("SubmitFlag");
        if (!Page.IsValid) return;

        string submittedFlag = txtFlag.Text.Trim();
        if (submittedFlag.Length == 0)
        {
            ShowFlagFeedback("Flag cannot be empty.", false);
            return;
        }

        int userID = int.Parse(Session["UserID"].ToString());
        SubmitFlag(userID, SelectedChallengeID.Value, submittedFlag);
        txtFlag.Text = "";
        LoadChallenges();
        LoadChallengeDetail(SelectedChallengeID.Value);
    }

    private bool IsLoggedIn
    {
        get { return Session["UserID"] != null; }
    }

    private void SetupNav()
    {
        if (!IsLoggedIn)
        {
            lnkDashboard.Visible = false;
            lnkLogin.Visible = true;
            return;
        }

        lnkLogin.Visible = false;
        lnkDashboard.Visible = true;
        lnkDashboard.Text = Session["Username"] == null ? "Dashboard" : Session["Username"].ToString();
        lnkDashboard.NavigateUrl = Session["Role"] != null && Session["Role"].ToString() == "Admin"
            ? "~/Admin/Dashboard.aspx"
            : "~/Member/Dashboard.aspx";
    }

    private void LoadCategories()
    {
        ddlCategory.Items.Clear();
        ddlCategory.Items.Add(new ListItem("All categories", ""));

        using (SqlConnection conn = new SqlConnection(ConnStr))
        {
            conn.Open();
            SqlCommand cmd = new SqlCommand(
                "SELECT DISTINCT [Category] FROM [Challenges] WHERE [IsActive] = 1 ORDER BY [Category]",
                conn);
            SqlDataReader reader = cmd.ExecuteReader();
            while (reader.Read())
                ddlCategory.Items.Add(new ListItem(reader["Category"].ToString(), reader["Category"].ToString()));
        }
    }

    private void LoadChallenges()
    {
        using (SqlConnection conn = new SqlConnection(ConnStr))
        {
            conn.Open();
            SqlCommand cmd = new SqlCommand(@"
                SELECT
                    c.[ChallengeID],
                    c.[Title],
                    c.[Category],
                    c.[Difficulty],
                    c.[Points],
                    CAST(CASE WHEN EXISTS (
                        SELECT 1 FROM [Submissions] s
                        WHERE s.[ChallengeID] = c.[ChallengeID]
                          AND s.[UserID] = @UserID
                          AND s.[IsCorrect] = 1
                    ) THEN 1 ELSE 0 END AS BIT) AS [IsSolved]
                FROM [Challenges] c
                WHERE c.[IsActive] = 1
                  AND (@Category = '' OR c.[Category] = @Category)
                  AND (@Difficulty = '' OR c.[Difficulty] = @Difficulty)
                  AND (@Search = '' OR c.[Title] LIKE '%' + @Search + '%')
                ORDER BY
                    CASE c.[Difficulty] WHEN 'Easy' THEN 1 WHEN 'Medium' THEN 2 WHEN 'Hard' THEN 3 ELSE 4 END,
                    c.[Points],
                    c.[Title]", conn);

            cmd.Parameters.AddWithValue("@UserID", IsLoggedIn ? int.Parse(Session["UserID"].ToString()) : -1);
            cmd.Parameters.AddWithValue("@Category", ddlCategory.SelectedValue);
            cmd.Parameters.AddWithValue("@Difficulty", ddlDifficulty.SelectedValue);
            cmd.Parameters.AddWithValue("@Search", txtSearch.Text.Trim());

            DataTable dt = new DataTable();
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);

            rptChallenges.DataSource = dt;
            rptChallenges.DataBind();
            pnlEmpty.Visible = dt.Rows.Count == 0;
        }
    }

    private void LoadChallengeDetail(int challengeID)
    {
        using (SqlConnection conn = new SqlConnection(ConnStr))
        {
            conn.Open();
            SqlCommand cmd = new SqlCommand(@"
                SELECT
                    c.[ChallengeID],
                    c.[Title],
                    c.[Description],
                    c.[Category],
                    c.[Difficulty],
                    c.[Points],
                    c.[Hint],
                    c.[FileUrl],
                    CAST(CASE WHEN EXISTS (
                        SELECT 1 FROM [Submissions] s
                        WHERE s.[ChallengeID] = c.[ChallengeID]
                          AND s.[UserID] = @UserID
                          AND s.[IsCorrect] = 1
                    ) THEN 1 ELSE 0 END AS BIT) AS [IsSolved]
                FROM [Challenges] c
                WHERE c.[ChallengeID] = @ChallengeID AND c.[IsActive] = 1", conn);
            cmd.Parameters.AddWithValue("@ChallengeID", challengeID);
            cmd.Parameters.AddWithValue("@UserID", IsLoggedIn ? int.Parse(Session["UserID"].ToString()) : -1);

            SqlDataReader reader = cmd.ExecuteReader();
            if (!reader.Read())
            {
                ShowAlert("Challenge was not found or is inactive.", false);
                pnlDetail.Visible = false;
                return;
            }

            lblDetailTitle.Text = HttpUtility.HtmlEncode(reader["Title"].ToString());
            lblDetailCategory.Text = "<span class=\"" + GetCategoryBadgeClass(reader["Category"].ToString()) + "\">" + HttpUtility.HtmlEncode(reader["Category"].ToString()) + "</span>";
            lblDetailDifficulty.Text = "<span class=\"" + GetDifficultyBadgeClass(reader["Difficulty"].ToString()) + "\">" + HttpUtility.HtmlEncode(reader["Difficulty"].ToString()) + "</span>";
            lblDetailPoints.Text = reader["Points"] + " pts";
            lblDetailStatus.Text = "<span class=\"" + GetStatusBadgeClass(reader["IsSolved"]) + "\">" + GetSolvedStatus(reader["IsSolved"]) + "</span>";
            litDescription.Text = "<p style=\"white-space:pre-wrap;\">" + HttpUtility.HtmlEncode(reader["Description"].ToString()) + "</p>";

            string hint = reader["Hint"] == DBNull.Value ? "" : reader["Hint"].ToString();
            pnlHint.Visible = hint.Trim().Length > 0;
            lblHint.Text = HttpUtility.HtmlEncode(hint);

            string fileUrl = reader["FileUrl"] == DBNull.Value ? "" : reader["FileUrl"].ToString();
            pnlFile.Visible = fileUrl.Trim().Length > 0;
            if (pnlFile.Visible)
            {
                lnkFile.Text = HttpUtility.HtmlEncode(fileUrl);
                lnkFile.NavigateUrl = fileUrl;
            }

            bool solved = Convert.ToBoolean(reader["IsSolved"]);
            pnlSubmitLogin.Visible = !IsLoggedIn;
            pnlSubmitForm.Visible = IsLoggedIn && !solved;
            pnlDetail.Visible = true;
        }
    }

    private void SubmitFlag(int userID, int challengeID, string submittedFlag)
    {
        using (SqlConnection conn = new SqlConnection(ConnStr))
        {
            conn.Open();
            SqlTransaction tx = conn.BeginTransaction();

            try
            {
                bool hasLegacyFlagColumn = ChallengeColumnExists(conn, tx, "Flag");
                string challengeSql = hasLegacyFlagColumn
                    ? @"SELECT COALESCE(NULLIF([CorrectFlag], ''), [Flag]) AS [CorrectFlag], [Points]
                        FROM [Challenges]
                        WHERE [ChallengeID] = @ChallengeID AND [IsActive] = 1"
                    : @"SELECT [CorrectFlag], [Points]
                        FROM [Challenges]
                        WHERE [ChallengeID] = @ChallengeID AND [IsActive] = 1";

                SqlCommand cmdChallenge = new SqlCommand(challengeSql, conn, tx);
                cmdChallenge.Parameters.AddWithValue("@ChallengeID", challengeID);

                SqlDataReader reader = cmdChallenge.ExecuteReader();
                if (!reader.Read())
                {
                    reader.Close();
                    tx.Rollback();
                    ShowFlagFeedback("Challenge is not available.", false);
                    return;
                }

                string correctFlag = reader["CorrectFlag"].ToString();
                int points = Convert.ToInt32(reader["Points"]);
                reader.Close();

                bool isCorrect = string.Equals(submittedFlag, correctFlag, StringComparison.Ordinal);

                SqlCommand cmdSolved = new SqlCommand(@"
                    SELECT COUNT(*)
                    FROM [Submissions] WITH (UPDLOCK, HOLDLOCK)
                    WHERE [UserID] = @UserID
                      AND [ChallengeID] = @ChallengeID
                      AND [IsCorrect] = 1", conn, tx);
                cmdSolved.Parameters.AddWithValue("@UserID", userID);
                cmdSolved.Parameters.AddWithValue("@ChallengeID", challengeID);
                bool alreadySolved = (int)cmdSolved.ExecuteScalar() > 0;

                if (isCorrect && alreadySolved)
                {
                    tx.Commit();
                    ShowFlagFeedback("Already solved. Score was not awarded again.", true);
                    return;
                }

                SqlCommand cmdInsert = new SqlCommand(@"
                    INSERT INTO [Submissions] ([UserID], [ChallengeID], [SubmittedFlag], [IsCorrect], [PointsAwarded], [SubmittedAt])
                    VALUES (@UserID, @ChallengeID, @SubmittedFlag, @IsCorrect, @PointsAwarded, GETDATE())", conn, tx);
                cmdInsert.Parameters.AddWithValue("@UserID", userID);
                cmdInsert.Parameters.AddWithValue("@ChallengeID", challengeID);
                cmdInsert.Parameters.AddWithValue("@SubmittedFlag", submittedFlag);
                cmdInsert.Parameters.AddWithValue("@IsCorrect", isCorrect);
                cmdInsert.Parameters.AddWithValue("@PointsAwarded", isCorrect ? points : 0);
                cmdInsert.ExecuteNonQuery();

                if (isCorrect)
                {
                    SqlCommand cmdScore = new SqlCommand(
                        "UPDATE [Users] SET [TotalScore] = [TotalScore] + @Points WHERE [UserID] = @UserID",
                        conn, tx);
                    cmdScore.Parameters.AddWithValue("@Points", points);
                    cmdScore.Parameters.AddWithValue("@UserID", userID);
                    cmdScore.ExecuteNonQuery();

                    SqlCommand cmdTeam = new SqlCommand(@"
                        IF OBJECT_ID(N'dbo.Teams', N'U') IS NOT NULL
                           AND OBJECT_ID(N'dbo.TeamMembers', N'U') IS NOT NULL
                        BEGIN
                            UPDATE t
                            SET t.[TeamScore] = t.[TeamScore] + @Points
                            FROM [Teams] t
                            INNER JOIN [TeamMembers] tm ON t.[TeamID] = tm.[TeamID]
                            WHERE tm.[UserID] = @UserID
                        END", conn, tx);
                    cmdTeam.Parameters.AddWithValue("@Points", points);
                    cmdTeam.Parameters.AddWithValue("@UserID", userID);
                    cmdTeam.ExecuteNonQuery();
                }

                tx.Commit();
                ShowFlagFeedback(isCorrect ? "Correct flag. Points awarded." : "Incorrect flag. Try again.", isCorrect);
            }
            catch (Exception ex)
            {
                tx.Rollback();
                ShowFlagFeedback("Submission failed: " + HttpUtility.HtmlEncode(ex.Message), false);
            }
        }
    }

    private void ShowAlert(string message, bool success)
    {
        pnlAlert.CssClass = success ? "alert alert-success" : "alert alert-danger";
        lblAlert.Text = message;
        pnlAlert.Visible = true;
    }

    private void ShowFlagFeedback(string message, bool success)
    {
        pnlFlagFeedback.CssClass = success ? "flag-feedback correct" : "flag-feedback incorrect";
        lblFlagFeedback.Text = message;
        pnlFlagFeedback.Visible = true;
        pnlDetail.Visible = true;
    }

    private bool ChallengeColumnExists(SqlConnection conn, SqlTransaction tx, string columnName)
    {
        SqlCommand cmd = new SqlCommand(@"
            SELECT COUNT(*)
            FROM sys.columns
            WHERE object_id = OBJECT_ID(N'dbo.Challenges')
              AND name = @ColumnName",
            conn,
            tx);
        cmd.Parameters.AddWithValue("@ColumnName", columnName);
        return (int)cmd.ExecuteScalar() > 0;
    }

    public string GetCategoryBadgeClass(string category)
    {
        string normalized = category.ToLowerInvariant();
        if (normalized.Contains("web")) return "badge badge-web";
        if (normalized.Contains("crypto")) return "badge badge-crypto";
        if (normalized.Contains("forensics")) return "badge badge-forensics";
        if (normalized.Contains("osint")) return "badge badge-osint";
        if (normalized.Contains("reverse")) return "badge badge-reverse";
        if (normalized.Contains("binary") || normalized.Contains("pwn")) return "badge badge-pwn";
        return "badge badge-misc";
    }

    public string GetDifficultyBadgeClass(string difficulty)
    {
        if (difficulty == "Easy") return "badge badge-easy";
        if (difficulty == "Medium") return "badge badge-medium";
        if (difficulty == "Hard") return "badge badge-hard";
        return "badge badge-info";
    }

    public string GetStatusBadgeClass(object solved)
    {
        return Convert.ToBoolean(solved) ? "challenge-status" : "badge badge-info";
    }

    public string GetSolvedStatus(object solved)
    {
        return Convert.ToBoolean(solved) ? "Solved" : "Unsolved";
    }
}
