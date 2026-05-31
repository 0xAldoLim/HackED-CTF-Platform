using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Admin_ChallengeEdit : Page
{
    private string ConnStr
    {
        get { return System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString; }
    }

    private int? ChallengeID
    {
        get
        {
            int parsed;
            return int.TryParse(Request.QueryString["id"], out parsed) ? (int?)parsed : null;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!RequireAdmin()) return;

        lblNavUsername.Text = Session["Username"].ToString();
        if (!IsPostBack)
        {
            if (ChallengeID.HasValue)
            {
                lblPageTitle.Text = "Edit Challenge";
                LoadChallenge(ChallengeID.Value);
            }
            else
            {
                lblPageTitle.Text = "Add Challenge";
                chkIsActive.Checked = true;
            }
        }
    }

    protected void lnkLogout_Click(object sender, EventArgs e)
    {
        Session.Abandon();
        Response.Redirect("~/Login.aspx");
    }

    protected void cvCorrectFlag_ServerValidate(object source, ServerValidateEventArgs args)
    {
        args.IsValid = ChallengeID.HasValue || args.Value.Trim().Length > 0;
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        Page.Validate("SaveChallenge");
        if (!Page.IsValid) return;

        int points;
        if (!int.TryParse(txtPoints.Text.Trim(), out points) || points <= 0)
        {
            ShowAlert("Points must be a positive number.", false);
            return;
        }

        if (ChallengeID.HasValue)
            UpdateChallenge(ChallengeID.Value, points);
        else
            CreateChallenge(points);
    }

    private bool RequireAdmin()
    {
        if (Session["UserID"] == null)
        {
            Response.Redirect("~/Login.aspx");
            return false;
        }
        if (Session["Role"] == null || Session["Role"].ToString() != "Admin")
        {
            Response.Redirect("~/Member/Dashboard.aspx");
            return false;
        }
        return true;
    }

    private void LoadChallenge(int challengeID)
    {
        using (SqlConnection conn = new SqlConnection(ConnStr))
        {
            conn.Open();
            SqlCommand cmd = new SqlCommand(@"
                SELECT [Title], [Description], [Category], [Difficulty], [Points], [Hint], [FileUrl], [IsActive]
                FROM [Challenges]
                WHERE [ChallengeID] = @ChallengeID", conn);
            cmd.Parameters.AddWithValue("@ChallengeID", challengeID);

            SqlDataReader reader = cmd.ExecuteReader();
            if (!reader.Read())
            {
                reader.Close();
                ShowAlert("Challenge not found.", false);
                btnSave.Enabled = false;
                return;
            }

            txtTitle.Text = reader["Title"].ToString();
            txtDescription.Text = reader["Description"].ToString();
            SetDropDownValue(ddlCategory, reader["Category"].ToString());
            SetDropDownValue(ddlDifficulty, reader["Difficulty"].ToString());
            txtPoints.Text = reader["Points"].ToString();
            txtHint.Text = reader["Hint"] == DBNull.Value ? "" : reader["Hint"].ToString();
            txtFileUrl.Text = reader["FileUrl"] == DBNull.Value ? "" : reader["FileUrl"].ToString();
            chkIsActive.Checked = Convert.ToBoolean(reader["IsActive"]);
        }
    }

    private void CreateChallenge(int points)
    {
        using (SqlConnection conn = new SqlConnection(ConnStr))
        {
            conn.Open();
            Dictionary<string, bool> columns = GetChallengeColumns(conn);
            string sql = BuildInsertSql(columns);

            SqlCommand cmd = new SqlCommand(sql, conn);
            AddCommonParameters(cmd, points);
            cmd.Parameters.AddWithValue("@CorrectFlag", txtCorrectFlag.Text.Trim());
            cmd.Parameters.AddWithValue("@CreatedByUserID", int.Parse(Session["UserID"].ToString()));
            cmd.ExecuteNonQuery();
        }

        Response.Redirect("~/Admin/Challenges.aspx?saved=1");
    }

    private void UpdateChallenge(int challengeID, int points)
    {
        using (SqlConnection conn = new SqlConnection(ConnStr))
        {
            conn.Open();
            Dictionary<string, bool> columns = GetChallengeColumns(conn);
            string sql = @"
                UPDATE [Challenges]
                SET [Title] = @Title,
                    [Description] = @Description,
                    [Category] = @Category,
                    [Difficulty] = @Difficulty,
                    [Points] = @Points,
                    [Hint] = @Hint,
                    [FileUrl] = @FileUrl,
                    [IsActive] = @IsActive";

            if (txtCorrectFlag.Text.Trim().Length > 0)
            {
                sql += ", [CorrectFlag] = @CorrectFlag";
                if (columns.ContainsKey("Flag"))
                    sql += ", [Flag] = @CorrectFlag";
            }

            sql += " WHERE [ChallengeID] = @ChallengeID";

            SqlCommand cmd = new SqlCommand(sql, conn);
            AddCommonParameters(cmd, points);
            cmd.Parameters.AddWithValue("@ChallengeID", challengeID);
            cmd.Parameters.AddWithValue("@CreatedByUserID", int.Parse(Session["UserID"].ToString()));
            if (txtCorrectFlag.Text.Trim().Length > 0)
                cmd.Parameters.AddWithValue("@CorrectFlag", txtCorrectFlag.Text.Trim());

            cmd.ExecuteNonQuery();
        }

        Response.Redirect("~/Admin/Challenges.aspx?saved=1");
    }

    private void AddCommonParameters(SqlCommand cmd, int points)
    {
        cmd.Parameters.AddWithValue("@Title", txtTitle.Text.Trim());
        cmd.Parameters.AddWithValue("@Description", txtDescription.Text.Trim());
        cmd.Parameters.AddWithValue("@Category", ddlCategory.SelectedValue);
        cmd.Parameters.AddWithValue("@Difficulty", ddlDifficulty.SelectedValue);
        cmd.Parameters.AddWithValue("@Points", points);
        cmd.Parameters.AddWithValue("@Hint", string.IsNullOrWhiteSpace(txtHint.Text) ? (object)DBNull.Value : txtHint.Text.Trim());
        cmd.Parameters.AddWithValue("@FileUrl", string.IsNullOrWhiteSpace(txtFileUrl.Text) ? (object)DBNull.Value : txtFileUrl.Text.Trim());
        cmd.Parameters.AddWithValue("@IsActive", chkIsActive.Checked);
    }

    private string BuildInsertSql(Dictionary<string, bool> columns)
    {
        List<string> insertColumns = new List<string>();
        List<string> values = new List<string>();

        AddInsertColumn(insertColumns, values, columns, "Title", "@Title");
        AddInsertColumn(insertColumns, values, columns, "Description", "@Description");
        AddInsertColumn(insertColumns, values, columns, "Category", "@Category");
        AddInsertColumn(insertColumns, values, columns, "Difficulty", "@Difficulty");
        AddInsertColumn(insertColumns, values, columns, "Points", "@Points");
        AddInsertColumn(insertColumns, values, columns, "CorrectFlag", "@CorrectFlag");
        AddInsertColumn(insertColumns, values, columns, "Flag", "@CorrectFlag");
        AddInsertColumn(insertColumns, values, columns, "Hint", "@Hint");
        AddInsertColumn(insertColumns, values, columns, "FileUrl", "@FileUrl");
        AddInsertColumn(insertColumns, values, columns, "IsActive", "@IsActive");
        AddInsertColumn(insertColumns, values, columns, "CreatedAt", "GETDATE()");
        AddInsertColumn(insertColumns, values, columns, "CreatedByUserID", "@CreatedByUserID");

        return "INSERT INTO [Challenges] (" + string.Join(", ", insertColumns) + ") VALUES (" + string.Join(", ", values) + ")";
    }

    private void AddInsertColumn(List<string> insertColumns, List<string> values, Dictionary<string, bool> columns, string columnName, string valueExpression)
    {
        if (!columns.ContainsKey(columnName)) return;

        insertColumns.Add("[" + columnName + "]");
        values.Add(valueExpression);
    }

    private Dictionary<string, bool> GetChallengeColumns(SqlConnection conn)
    {
        SqlCommand cmd = new SqlCommand(@"
            SELECT name
            FROM sys.columns
            WHERE object_id = OBJECT_ID(N'dbo.Challenges')",
            conn);
        SqlDataReader reader = cmd.ExecuteReader();
        Dictionary<string, bool> columns = new Dictionary<string, bool>(StringComparer.OrdinalIgnoreCase);
        while (reader.Read())
            columns[reader["name"].ToString()] = true;
        reader.Close();
        return columns;
    }

    private void SetDropDownValue(DropDownList ddl, string value)
    {
        ListItem item = ddl.Items.FindByValue(value);
        if (item != null)
            ddl.SelectedValue = value;
    }

    private void ShowAlert(string message, bool success)
    {
        pnlAlert.CssClass = success ? "alert alert-success" : "alert alert-danger";
        lblAlert.Text = HttpUtility.HtmlEncode(message);
        pnlAlert.Visible = true;
    }
}
