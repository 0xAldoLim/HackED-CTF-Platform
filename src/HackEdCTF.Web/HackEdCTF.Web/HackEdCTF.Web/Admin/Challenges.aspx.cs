using System;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Admin_Challenges : Page
{
    private string ConnStr
    {
        get { return System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!RequireAdmin()) return;

        lblNavUsername.Text = Session["Username"].ToString();
        if (!IsPostBack)
        {
            if (Request.QueryString["saved"] == "1")
                ShowAlert("Challenge saved successfully.", true);
            LoadChallenges();
        }
    }

    protected void lnkLogout_Click(object sender, EventArgs e)
    {
        Session.Abandon();
        Response.Redirect("~/Login.aspx");
    }

    protected void txtSearch_TextChanged(object sender, EventArgs e)
    {
        LoadChallenges();
    }

    protected void rptChallenges_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName != "ToggleActive") return;

        int challengeID = int.Parse(e.CommandArgument.ToString());
        using (SqlConnection conn = new SqlConnection(ConnStr))
        {
            conn.Open();
            SqlCommand cmd = new SqlCommand(@"
                UPDATE [Challenges]
                SET [IsActive] = CASE WHEN [IsActive] = 1 THEN 0 ELSE 1 END
                WHERE [ChallengeID] = @ChallengeID", conn);
            cmd.Parameters.AddWithValue("@ChallengeID", challengeID);
            cmd.ExecuteNonQuery();
        }

        ShowAlert("Challenge status updated.", true);
        LoadChallenges();
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

    private void LoadChallenges()
    {
        using (SqlConnection conn = new SqlConnection(ConnStr))
        {
            conn.Open();
            SqlCommand cmd = new SqlCommand(@"
                SELECT [ChallengeID], [Title], [Category], [Difficulty], [Points], [IsActive], [CreatedAt]
                FROM [Challenges]
                WHERE (@Search = '' OR [Title] LIKE '%' + @Search + '%' OR [Category] LIKE '%' + @Search + '%')
                ORDER BY [IsActive] DESC, [CreatedAt] DESC, [Title]", conn);
            cmd.Parameters.AddWithValue("@Search", txtSearch.Text.Trim());

            DataTable dt = new DataTable();
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);

            rptChallenges.DataSource = dt;
            rptChallenges.DataBind();
            pnlEmpty.Visible = dt.Rows.Count == 0;
        }
    }

    private void ShowAlert(string message, bool success)
    {
        pnlAlert.CssClass = success ? "alert alert-success" : "alert alert-danger";
        lblAlert.Text = message;
        pnlAlert.Visible = true;
    }

    public string FormatDate(object value)
    {
        if (value == DBNull.Value) return "-";
        return Convert.ToDateTime(value).ToString("MMM dd, yyyy");
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
}
