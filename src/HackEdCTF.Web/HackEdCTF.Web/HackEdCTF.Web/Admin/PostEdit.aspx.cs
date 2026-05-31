using System;
using System.Data.SqlClient;
using System.Web.UI;

public partial class Admin_PostEdit : Page
{
    private string ConnStr
    {
        get { return System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString; }
    }

    // "post" (blog/news) or "announcement"
    private string Kind
    {
        get { return (Request.QueryString["kind"] ?? "post").ToLower(); }
    }

    // 0 when creating new; existing id when editing
    private int EditId
    {
        get { int id; return int.TryParse(Request.QueryString["id"], out id) ? id : 0; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        // Admin-only guard
        if (Session["UserID"] == null || Session["Role"] == null)
        {
            Response.Redirect("~/Login.aspx");
            return;
        }
        if (Session["Role"].ToString() != "Admin")
        {
            Response.Redirect("~/Member/Dashboard.aspx");
            return;
        }

        // username might not be set, default to empty
        lblNavUsername.Text = Session["Username"] != null ? Session["Username"].ToString() : "";

        if (!IsPostBack)
        {
            bool isAnnouncement = (Kind == "announcement");
            pnlPostFields.Visible = !isAnnouncement;
            pnlAnnouncementFields.Visible = isAnnouncement;

            string noun = isAnnouncement ? "Announcement" : "Post";
            lblHeading.Text = (EditId == 0 ? "Create " : "Edit ") + noun;

            if (EditId != 0)
                LoadExisting(isAnnouncement);
        }
    }

    protected void lnkLogout_Click(object sender, EventArgs e)
    {
        Session.Abandon();
        Response.Redirect("~/Login.aspx");
    }

    private void LoadExisting(bool isAnnouncement)
    {
        using (SqlConnection conn = new SqlConnection(ConnStr))
        {
            conn.Open();
            SqlCommand cmd;

            if (isAnnouncement)
            {
                cmd = new SqlCommand(
                    "SELECT [Title], [Content], [Priority], [IsPinned], [Status] FROM [Announcements] WHERE [AnnouncementID] = @ID", conn);
            }
            else
            {
                cmd = new SqlCommand(
                    "SELECT [Title], [Content], [PostType], [Category], [IsFeatured], [Status] FROM [BlogPosts] WHERE [PostID] = @ID", conn);
            }
            cmd.Parameters.AddWithValue("@ID", EditId);

            using (SqlDataReader r = cmd.ExecuteReader())
            {
                if (r.Read())
                {
                    txtTitle.Text = r["Title"].ToString();
                    txtContent.Text = r["Content"].ToString();
                    ddlStatus.SelectedValue = r["Status"].ToString();

                    if (isAnnouncement)
                    {
                        ddlPriority.SelectedValue = r["Priority"].ToString();
                        chkPinned.Checked = (bool)r["IsPinned"];
                    }
                    else
                    {
                        ddlPostType.SelectedValue = r["PostType"].ToString();
                        txtCategory.Text = r["Category"].ToString();
                        chkFeatured.Checked = (bool)r["IsFeatured"];
                    }
                }
            }
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        int authorId = int.Parse(Session["UserID"].ToString());
        bool isAnnouncement = (Kind == "announcement");

        using (SqlConnection conn = new SqlConnection(ConnStr))
        {
            conn.Open();
            SqlCommand cmd;

            if (isAnnouncement)
            {
                if (EditId == 0)
                {
                    cmd = new SqlCommand(@"INSERT INTO [Announcements]
                        ([Title],[Content],[Priority],[AuthorID],[IsPinned],[Status])
                        VALUES (@Title,@Content,@Priority,@AuthorID,@IsPinned,@Status)", conn);
                    cmd.Parameters.AddWithValue("@AuthorID", authorId);
                }
                else
                {
                    cmd = new SqlCommand(@"UPDATE [Announcements] SET
                        [Title]=@Title,[Content]=@Content,[Priority]=@Priority,
                        [IsPinned]=@IsPinned,[Status]=@Status
                        WHERE [AnnouncementID]=@ID", conn);
                    cmd.Parameters.AddWithValue("@ID", EditId);
                }
                cmd.Parameters.AddWithValue("@Priority", ddlPriority.SelectedValue);
                cmd.Parameters.AddWithValue("@IsPinned", chkPinned.Checked);
            }
            else
            {
                if (EditId == 0)
                {
                    cmd = new SqlCommand(@"INSERT INTO [BlogPosts]
                        ([Title],[PostType],[Category],[Content],[AuthorID],[Status],[IsFeatured])
                        VALUES (@Title,@PostType,@Category,@Content,@AuthorID,@Status,@IsFeatured)", conn);
                    cmd.Parameters.AddWithValue("@AuthorID", authorId);
                }
                else
                {
                    cmd = new SqlCommand(@"UPDATE [BlogPosts] SET
                        [Title]=@Title,[PostType]=@PostType,[Category]=@Category,
                        [Content]=@Content,[Status]=@Status,[IsFeatured]=@IsFeatured
                        WHERE [PostID]=@ID", conn);
                    cmd.Parameters.AddWithValue("@ID", EditId);
                }
                cmd.Parameters.AddWithValue("@PostType", ddlPostType.SelectedValue);
                cmd.Parameters.AddWithValue("@Category", txtCategory.Text.Trim());
                cmd.Parameters.AddWithValue("@IsFeatured", chkFeatured.Checked);
            }

            // Shared parameters
            cmd.Parameters.AddWithValue("@Title", txtTitle.Text.Trim());
            cmd.Parameters.AddWithValue("@Content", txtContent.Text.Trim());
            cmd.Parameters.AddWithValue("@Status", ddlStatus.SelectedValue);

            cmd.ExecuteNonQuery();
        }

        Response.Redirect("Posts.aspx");
    }
}
