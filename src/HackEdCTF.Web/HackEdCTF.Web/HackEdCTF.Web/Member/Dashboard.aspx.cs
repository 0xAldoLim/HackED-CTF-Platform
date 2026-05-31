using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

public partial class Member_Dashboard : Page
{
    private string ConnStr
    {
        get { return System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        //Session guard: must be logged in as Player
        if (Session["UserID"] == null)
        {
            Response.Redirect("~/Login.aspx");
            return;
        }
        if (Session["Role"].ToString() == "Admin")
        {
            Response.Redirect("~/Admin/Dashboard.aspx");
            return;
        }

        if (!IsPostBack)
            LoadDashboard();
    }

    protected void lnkLogout_Click(object sender, EventArgs e)
    {
        Session.Abandon();
        Response.Redirect("~/Login.aspx");
    }

    private void LoadDashboard()
    {
        int userID = int.Parse(Session["UserID"].ToString());
        string username = Session["Username"].ToString();

        lblNavUsername.Text = username;
        lblWelcome.Text = username;

        using (SqlConnection conn = new SqlConnection(ConnStr))
        {
            conn.Open();

            //Solved challenges
            SqlCommand cmdSolved = new SqlCommand(
                "SELECT COUNT(*) FROM [Submissions] WHERE [UserID] = @UID AND [IsCorrect] = 1", conn);
            cmdSolved.Parameters.AddWithValue("@UID", userID);
            int solved = (int)cmdSolved.ExecuteScalar();
            lblSolved.Text = solved.ToString();

            //total active challenges
            SqlCommand cmdTotal = new SqlCommand(
                "SELECT COUNT(*) FROM [Challenges] WHERE [IsActive] = 1", conn);
            int total = (int)cmdTotal.ExecuteScalar();

            if (total > 0)
            {
                int pct = (int)Math.Round((double)solved / total * 100);
                lblProgress.Text = pct + "%";
            }
            else
            {
                lblProgress.Text = "0%";
            }

            //Team membership
            SqlCommand cmdTeam = new SqlCommand(
                @"SELECT t.[TeamName] FROM [Teams] t
                  INNER JOIN [TeamMembers] tm ON t.[TeamID] = tm.[TeamID]
                  WHERE tm.[UserID] = @UID", conn);
            cmdTeam.Parameters.AddWithValue("@UID", userID);
            object teamName = cmdTeam.ExecuteScalar();
            lblTeamStatus.Text = teamName != null ? teamName.ToString() : "No Team";

            SqlCommand cmdModule = new SqlCommand(
                "SELECT TOP 1 [Title] FROM [Modules] ORDER BY [CreatedAt] DESC", conn);
            object moduleTitle = cmdModule.ExecuteScalar();
            if (moduleTitle != null)
            {
                lblCurrentModule.Text = moduleTitle.ToString();
            }
            else
            {
                lblCurrentModule.Text = "—";
            }

            //Recent announcements
            SqlCommand cmdAnnounce = new SqlCommand(
                "SELECT TOP 3 [Title] FROM [Announcements] ORDER BY [CreatedAt] DESC", conn);
            SqlDataAdapter da = new SqlDataAdapter(cmdAnnounce);
            DataTable dt = new DataTable();
            da.Fill(dt);
            rptAnnouncements.DataSource = dt;
            rptAnnouncements.DataBind();
        }
    }
}
