using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Admin_Posts : Page
{
    private string ConnStr
    {
        get { return System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        // Admin-only guard (same pattern as other admin pages)
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
            LoadAll();
    }

    protected void lnkLogout_Click(object sender, EventArgs e)
    {
        Session.Abandon();
        Response.Redirect("~/Login.aspx");
    }

    private void LoadAll()
    {
        using (SqlConnection conn = new SqlConnection(ConnStr))
        {
            conn.Open();

            // Posts
            string postSql = @"SELECT p.[PostID], p.[Title], p.[PostType], p.[Status], p.[CreatedAt],
                                      u.[Username] AS AuthorName
                               FROM [BlogPosts] p
                               INNER JOIN [Users] u ON p.[AuthorID] = u.[UserID]
                               ORDER BY p.[CreatedAt] DESC";
            rptPosts.DataSource = GetTable(conn, postSql);
            rptPosts.DataBind();

            // Announcements
            string annSql = @"SELECT a.[AnnouncementID], a.[Title], a.[Priority], a.[IsPinned],
                                     a.[Status], a.[CreatedAt], u.[Username] AS AuthorName
                              FROM [Announcements] a
                              INNER JOIN [Users] u ON a.[AuthorID] = u.[UserID]
                              ORDER BY a.[CreatedAt] DESC";
            rptAnnouncements.DataSource = GetTable(conn, annSql);
            rptAnnouncements.DataBind();
        }
    }

    private DataTable GetTable(SqlConnection conn, string sql)
    {
        SqlCommand cmd = new SqlCommand(sql, conn);
        SqlDataAdapter da = new SqlDataAdapter(cmd);
        DataTable dt = new DataTable();
        da.Fill(dt);
        return dt;
    }

    protected void rptPosts_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName == "DeletePost")
        {
            int id = int.Parse(e.CommandArgument.ToString());
            ExecNonQuery("DELETE FROM [BlogPosts] WHERE [PostID] = @ID", id);
            ShowAlert("Post deleted.", true);
            LoadAll();
        }
    }

    protected void rptAnnouncements_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName == "DeleteAnnouncement")
        {
            int id = int.Parse(e.CommandArgument.ToString());
            ExecNonQuery("DELETE FROM [Announcements] WHERE [AnnouncementID] = @ID", id);
            ShowAlert("Announcement deleted.", true);
            LoadAll();
        }
    }

    private void ExecNonQuery(string sql, int id)
    {
        using (SqlConnection conn = new SqlConnection(ConnStr))
        {
            conn.Open();
            SqlCommand cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@ID", id);
            cmd.ExecuteNonQuery();
        }
    }

    private void ShowAlert(string message, bool success)
    {
        lblAlert.Text = message;
        pnlAlert.CssClass = success ? "alert alert-success" : "alert alert-danger";
        pnlAlert.Visible = true;
    }
}
