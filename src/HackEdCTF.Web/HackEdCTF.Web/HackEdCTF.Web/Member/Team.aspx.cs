using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

public partial class Member_Team : Page
{
    private string ConnStr
    {
        get { return System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["UserID"] == null) { Response.Redirect("~/Login.aspx"); return; }
        lblNavUsername.Text = Session["Username"].ToString();
        if (!IsPostBack) LoadTeamView();
    }

    protected void lnkLogout_Click(object sender, EventArgs e)
    {
        Session.Abandon();
        Response.Redirect("~/Login.aspx");
    }

    private void LoadTeamView()
    {
        int userID = int.Parse(Session["UserID"].ToString());

        using (SqlConnection conn = new SqlConnection(ConnStr))
        {
            conn.Open();

            SqlCommand cmdCheck = new SqlCommand(@"
                SELECT t.[TeamID], t.[TeamName], t.[InviteCode],
                       t.[TeamScore], t.[LeaderUserID], u.[Username] AS LeaderName
                FROM [Teams] t
                INNER JOIN [TeamMembers] tm ON t.[TeamID] = tm.[TeamID]
                INNER JOIN [Users] u ON t.[LeaderUserID] = u.[UserID]
                WHERE tm.[UserID] = @UID", conn);
            cmdCheck.Parameters.AddWithValue("@UID", userID);
            SqlDataReader r = cmdCheck.ExecuteReader();

            if (r.Read())
            {
                int teamID = (int)r["TeamID"];
                int leaderID = (int)r["LeaderUserID"];
                lblTeamName.Text = r["TeamName"].ToString();
                lblTeamScore.Text = string.Format("{0:N0}", r["TeamScore"]);
                lblInviteCode.Text = r["InviteCode"].ToString();
                r.Close();

                pnlNoTeam.Visible = false;
                pnlHasTeam.Visible = true;
                pnlBackToTeams.Visible = false;
                pnlInviteCode.Visible = (userID == leaderID);
                btnManageTeam.Visible = (userID == leaderID);
                btnLeave.Visible = true;

                LoadTeamDetails(conn, teamID, leaderID);
            }
            else
            {
                r.Close();
                pnlNoTeam.Visible = true;
                pnlHasTeam.Visible = false;
                LoadAllTeams(conn);
            }
        }
    }

    private void LoadAllTeams(SqlConnection conn)
    {
        SqlCommand cmdAll = new SqlCommand(@"
            WITH TeamSolves AS
            (
                SELECT tm.[TeamID], s.[ChallengeID]
                FROM [TeamMembers] tm
                INNER JOIN [Submissions] s ON tm.[UserID] = s.[UserID]
                WHERE s.[IsCorrect] = 1
                GROUP BY tm.[TeamID], s.[ChallengeID]
            ),
            TeamSolveCounts AS
            (
                SELECT [TeamID], COUNT([ChallengeID]) AS Solves
                FROM TeamSolves
                GROUP BY [TeamID]
            ),
            MemberCounts AS
            (
                SELECT [TeamID], COUNT(DISTINCT [UserID]) AS MemberCount
                FROM [TeamMembers]
                GROUP BY [TeamID]
            ),
            ScoreRows AS
            (
                SELECT
                    t.[TeamID],
                    t.[TeamName],
                    ISNULL(t.[TeamScore], 0) AS TeamScore,
                    ISNULL(mc.[MemberCount], 0) AS MemberCount,
                    ISNULL(tsc.[Solves], 0) AS Solves
                FROM [Teams] t
                LEFT JOIN MemberCounts mc ON t.[TeamID] = mc.[TeamID]
                LEFT JOIN TeamSolveCounts tsc ON t.[TeamID] = tsc.[TeamID]
            )
            SELECT
                [TeamID],
                [TeamName],
                [TeamScore],
                [MemberCount],
                [Solves],
                ROW_NUMBER() OVER (ORDER BY [Solves] DESC, [TeamScore] DESC, [TeamName] ASC) AS Ranking
            FROM ScoreRows
            ORDER BY Ranking", conn);
        SqlDataAdapter da = new SqlDataAdapter(cmdAll);
        DataTable dt = new DataTable();
        da.Fill(dt);
        rptAllTeams.DataSource = dt;
        rptAllTeams.DataBind();
        pnlNoTeamsFound.Visible = (dt.Rows.Count == 0);
    }

    private void LoadTeamDetails(SqlConnection conn, int teamID, int leaderID)
    {
        SqlCommand cmdCount = new SqlCommand(
            "SELECT COUNT(*) FROM [TeamMembers] WHERE [TeamID] = @TID", conn);
        cmdCount.Parameters.AddWithValue("@TID", teamID);
        lblMemberCount.Text = cmdCount.ExecuteScalar().ToString();

        SqlCommand cmdSolvesCount = new SqlCommand(@"
            SELECT COUNT(*)
            FROM (
                SELECT s.[ChallengeID]
                FROM [TeamMembers] tm
                INNER JOIN [Submissions] s ON tm.[UserID] = s.[UserID]
                WHERE tm.[TeamID] = @TID
                  AND s.[IsCorrect] = 1
                GROUP BY s.[ChallengeID]
            ) solved", conn);
        cmdSolvesCount.Parameters.AddWithValue("@TID", teamID);
        lblTeamSolves.Text = cmdSolvesCount.ExecuteScalar().ToString();

        SqlCommand cmdRank = new SqlCommand(@"
            SELECT Ranking FROM (
                SELECT
                    t.[TeamID],
                    ROW_NUMBER() OVER (
                        ORDER BY COUNT(DISTINCT s.[ChallengeID]) DESC, ISNULL(t.[TeamScore], 0) DESC, t.[TeamName] ASC
                    ) AS Ranking
                FROM [Teams] t
                LEFT JOIN [TeamMembers] tm ON t.[TeamID] = tm.[TeamID]
                LEFT JOIN [Submissions] s ON tm.[UserID] = s.[UserID] AND s.[IsCorrect] = 1
                GROUP BY t.[TeamID], t.[TeamName], t.[TeamScore]
            ) r WHERE [TeamID] = @TID", conn);
        cmdRank.Parameters.AddWithValue("@TID", teamID);
        object rank = cmdRank.ExecuteScalar();
        lblTeamRank.Text = rank != null ? rank.ToString() : "—";

        SqlCommand cmdMembers = new SqlCommand(@"
            SELECT u.[Username], u.[TotalScore], tm.[JoinedAt],
                   CAST(CASE WHEN u.[UserID] = @LeaderID THEN 1 ELSE 0 END AS BIT) AS IsLeader
            FROM [TeamMembers] tm
            INNER JOIN [Users] u ON tm.[UserID] = u.[UserID]
            WHERE tm.[TeamID] = @TID
            ORDER BY IsLeader DESC, u.[TotalScore] DESC", conn);
        cmdMembers.Parameters.AddWithValue("@TID", teamID);
        cmdMembers.Parameters.AddWithValue("@LeaderID", leaderID);
        SqlDataAdapter da = new SqlDataAdapter(cmdMembers);
        DataTable dtMembers = new DataTable();
        da.Fill(dtMembers);
        rptMembers.DataSource = dtMembers;
        rptMembers.DataBind();

        SqlCommand cmdSolves = new SqlCommand(@"
            WITH RankedSolves AS
            (
                SELECT
                    c.[Title] AS ChallengeName,
                    u.[Username],
                    c.[Points],
                    s.[SubmittedAt],
                    ROW_NUMBER() OVER (PARTITION BY s.[ChallengeID] ORDER BY s.[SubmittedAt] DESC) AS SolveRank
                FROM [Submissions] s
                INNER JOIN [Users] u ON s.[UserID] = u.[UserID]
                INNER JOIN [Challenges] c ON s.[ChallengeID] = c.[ChallengeID]
                INNER JOIN [TeamMembers] tm ON u.[UserID] = tm.[UserID]
                WHERE tm.[TeamID] = @TID AND s.[IsCorrect] = 1
            )
            SELECT TOP 10 [ChallengeName], [Username], [Points], [SubmittedAt]
            FROM RankedSolves
            WHERE SolveRank = 1
            ORDER BY [SubmittedAt] DESC", conn);
        cmdSolves.Parameters.AddWithValue("@TID", teamID);
        SqlDataAdapter daSolves = new SqlDataAdapter(cmdSolves);
        DataTable dtSolves = new DataTable();
        daSolves.Fill(dtSolves);
        rptRecentSolves.DataSource = dtSolves;
        rptRecentSolves.DataBind();
    }

    protected void rptAllTeams_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
    {
        if (e.CommandName != "ViewTeam") return;
        int teamID = int.Parse(e.CommandArgument.ToString());

        using (SqlConnection conn = new SqlConnection(ConnStr))
        {
            conn.Open();
            SqlCommand cmdTeam = new SqlCommand(@"
                SELECT t.[TeamID], t.[TeamName], t.[TeamScore], t.[LeaderUserID]
                FROM [Teams] t WHERE t.[TeamID] = @TID", conn);
            cmdTeam.Parameters.AddWithValue("@TID", teamID);
            SqlDataReader r = cmdTeam.ExecuteReader();
            if (!r.Read()) { r.Close(); return; }

            int leaderID = (int)r["LeaderUserID"];
            lblTeamName.Text = r["TeamName"].ToString();
            lblTeamScore.Text = string.Format("{0:N0}", r["TeamScore"]);
            r.Close();

            pnlNoTeam.Visible = false;
            pnlHasTeam.Visible = true;
            pnlBackToTeams.Visible = true;
            pnlInviteCode.Visible = false;
            btnManageTeam.Visible = false;
            btnLeave.Visible = false;

            LoadTeamDetails(conn, teamID, leaderID);
        }
    }

    protected void lnkBackToTeams_Click(object sender, EventArgs e)
    {
        pnlNoTeam.Visible = true;
        pnlHasTeam.Visible = false;
        using (SqlConnection conn = new SqlConnection(ConnStr))
        {
            conn.Open();
            LoadAllTeams(conn);
        }
    }

    protected void btnCreate_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;
        int userID = int.Parse(Session["UserID"].ToString());
        string name = txtTeamName.Text.Trim();
        string code = GenerateInviteCode();

        if (name.Length < 3)
        {
            ShowAlert("Team name must be at least 3 characters.", false);
            return;
        }

        using (SqlConnection conn = new SqlConnection(ConnStr))
        {
            conn.Open();
            SqlCommand cmdCheck = new SqlCommand(
                "SELECT COUNT(*) FROM [Teams] WHERE [TeamName] = @Name", conn);
            cmdCheck.Parameters.AddWithValue("@Name", name);
            if ((int)cmdCheck.ExecuteScalar() > 0) { ShowAlert("That team name is already taken.", false); return; }

            SqlCommand cmdAlreadyTeam = new SqlCommand(
                "SELECT COUNT(*) FROM [TeamMembers] WHERE [UserID] = @UID", conn);
            cmdAlreadyTeam.Parameters.AddWithValue("@UID", userID);
            if ((int)cmdAlreadyTeam.ExecuteScalar() > 0) { ShowAlert("You are already in a team.", false); return; }

            SqlCommand cmdCreate = new SqlCommand(@"
                INSERT INTO [Teams] ([TeamName], [LeaderUserID], [InviteCode])
                VALUES (@Name, @UID, @Code); SELECT SCOPE_IDENTITY();", conn);
            cmdCreate.Parameters.AddWithValue("@Name", name);
            cmdCreate.Parameters.AddWithValue("@UID", userID);
            cmdCreate.Parameters.AddWithValue("@Code", code);
            int teamID = (int)(decimal)cmdCreate.ExecuteScalar();

            SqlCommand cmdJoin = new SqlCommand(
                "INSERT INTO [TeamMembers] ([TeamID], [UserID]) VALUES (@TID, @UID)", conn);
            cmdJoin.Parameters.AddWithValue("@TID", teamID);
            cmdJoin.Parameters.AddWithValue("@UID", userID);
            cmdJoin.ExecuteNonQuery();
        }

        ShowAlert("Team created successfully!", true);
        LoadTeamView();
    }

    protected void btnJoin_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;
        int userID = int.Parse(Session["UserID"].ToString());
        string code = txtInviteCode.Text.Trim();

        using (SqlConnection conn = new SqlConnection(ConnStr))
        {
            conn.Open();
            SqlCommand cmdFind = new SqlCommand(
                "SELECT [TeamID] FROM [Teams] WHERE [InviteCode] = @Code", conn);
            cmdFind.Parameters.AddWithValue("@Code", code);
            object result = cmdFind.ExecuteScalar();
            if (result == null) { ShowAlert("Invalid invite code.", false); return; }

            int teamID = (int)result;
            SqlCommand cmdAlready = new SqlCommand(
                "SELECT COUNT(*) FROM [TeamMembers] WHERE [UserID] = @UID", conn);
            cmdAlready.Parameters.AddWithValue("@UID", userID);
            if ((int)cmdAlready.ExecuteScalar() > 0) { ShowAlert("You are already in a team.", false); return; }

            SqlCommand cmdJoin = new SqlCommand(
                "INSERT INTO [TeamMembers] ([TeamID], [UserID]) VALUES (@TID, @UID)", conn);
            cmdJoin.Parameters.AddWithValue("@TID", teamID);
            cmdJoin.Parameters.AddWithValue("@UID", userID);
            cmdJoin.ExecuteNonQuery();
        }

        ShowAlert("You joined the team!", true);
        LoadTeamView();
    }

    protected void btnManageTeam_Click(object sender, EventArgs e)
    {
        ShowAlert("Team management coming soon.", true);
    }

    protected void btnLeave_Click(object sender, EventArgs e)
    {
        int userID = int.Parse(Session["UserID"].ToString());

        using (SqlConnection conn = new SqlConnection(ConnStr))
        {
            conn.Open();
            SqlCommand cmdTeam = new SqlCommand(@"
                SELECT t.[TeamID], t.[LeaderUserID],
                       (SELECT COUNT(*) FROM [TeamMembers] WHERE [TeamID] = t.[TeamID]) AS MemberCount
                FROM [Teams] t
                INNER JOIN [TeamMembers] tm ON t.[TeamID] = tm.[TeamID]
                WHERE tm.[UserID] = @UID", conn);
            cmdTeam.Parameters.AddWithValue("@UID", userID);
            SqlDataReader r = cmdTeam.ExecuteReader();
            if (!r.Read()) { r.Close(); return; }

            int teamID = (int)r["TeamID"];
            int leaderID = (int)r["LeaderUserID"];
            int memberCount = (int)r["MemberCount"];
            r.Close();

            if (userID == leaderID && memberCount > 1)
            {
                ShowAlert("Transfer leadership before leaving.", false);
                return;
            }

            SqlCommand cmdLeave = new SqlCommand(
                "DELETE FROM [TeamMembers] WHERE [UserID] = @UID AND [TeamID] = @TID", conn);
            cmdLeave.Parameters.AddWithValue("@UID", userID);
            cmdLeave.Parameters.AddWithValue("@TID", teamID);
            cmdLeave.ExecuteNonQuery();

            if (memberCount == 1)
            {
                SqlCommand cmdDelete = new SqlCommand(
                    "DELETE FROM [Teams] WHERE [TeamID] = @TID", conn);
                cmdDelete.Parameters.AddWithValue("@TID", teamID);
                cmdDelete.ExecuteNonQuery();
            }
        }

        ShowAlert("You have left the team.", true);
        LoadTeamView();
    }

    private string GenerateInviteCode()
    {
        const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        var rng = new Random();
        var code = new char[8];
        for (int i = 0; i < code.Length; i++)
            code[i] = chars[rng.Next(chars.Length)];
        return new string(code);
    }

    private void ShowAlert(string message, bool success)
    {
        lblAlert.Text = message;
        pnlAlert.CssClass = success ? "alert alert-success" : "alert alert-danger";
        pnlAlert.Visible = true;
    }
}
