using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

public partial class Admin_Dashboard : Page
{
    private string ConnStr
    {
        get { return System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        // Only admins can see this page
        if (Session["UserID"] == null)
        {
            Response.Redirect("~/Login.aspx");
            return;
        }
        if (Session["Role"].ToString() != "Admin")
        {
            Response.Redirect("~/Member/Dashboard.aspx");
            return;
        }

        lblNavUsername.Text = Session["Username"].ToString();

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
        using (SqlConnection conn = new SqlConnection(ConnStr))
        {
            conn.Open();

            // Counts
            lblUserCount.Text = GetCount(conn, "SELECT COUNT(*) FROM [Users]");
            lblModuleCount.Text = GetCount(conn, "SELECT COUNT(*) FROM [Modules]");
            lblChallengeCount.Text = GetCount(conn, "SELECT COUNT(*) FROM [Challenges]");
            lblPostCount.Text = GetCount(conn, "SELECT COUNT(*) FROM [ForumPosts]");
        }

        // Static preview table (matches wireframe)
        DataTable dt = new DataTable();
        dt.Columns.Add("Area");
        dt.Columns.Add("RecentItem");
        dt.Columns.Add("Status");
        dt.Columns.Add("Action");

        dt.Rows.Add("Training", "Linux Basics", "Published", "Edit");
        dt.Rows.Add("Challenge", "JWT Confusion", "Draft", "Review");
        dt.Rows.Add("Blog", "CTF etiquette", "Published", "Edit");
        dt.Rows.Add("User", "new_student", "Active", "Manage");

        rptPreview.DataSource = dt;
        rptPreview.DataBind();
    }

    private string GetCount(SqlConnection conn, string sql)
    {
        SqlCommand cmd = new SqlCommand(sql, conn);
        return cmd.ExecuteScalar().ToString();
    }
}