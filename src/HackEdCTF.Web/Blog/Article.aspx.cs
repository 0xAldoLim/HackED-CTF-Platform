using System;
using System.Data.SqlClient;
using System.Web.UI;

public partial class Blog_Article : Page
{
    private string ConnStr
    {
        get { return System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
            LoadArticle();
    }

    private void LoadArticle()
    {
        int postId;
        if (!int.TryParse(Request.QueryString["id"], out postId))
        {
            ShowNotFound();
            return;
        }

        using (SqlConnection conn = new SqlConnection(ConnStr))
        {
            conn.Open();

            string sql = @"SELECT p.[Title], p.[Category], p.[PostType], p.[Content],
                                  p.[CreatedAt], u.[Username] AS AuthorName
                           FROM [BlogPosts] p
                           INNER JOIN [Users] u ON p.[AuthorID] = u.[UserID]
                           WHERE p.[PostID] = @ID AND p.[Status] = 'Published'";

            SqlCommand cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@ID", postId);

            using (SqlDataReader r = cmd.ExecuteReader())
            {
                if (r.Read())
                {
                    lblTitle.Text = r["Title"].ToString();
                    lblAuthor.Text = r["AuthorName"].ToString();
                    lblDate.Text = Convert.ToDateTime(r["CreatedAt"]).ToString("MMM dd, yyyy");
                    lblCategory.Text = r["PostType"].ToString() + " / " + r["Category"].ToString();
                    lblContent.Text = r["Content"].ToString();
                }
                else
                {
                    ShowNotFound();
                }
            }
        }
    }

    private void ShowNotFound()
    {
        pnlArticle.Visible = false;
        pnlNotFound.Visible = true;
    }
}
