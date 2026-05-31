using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

public partial class Blog_Index : Page
{
    private string ConnStr
    {
        get { return System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        // Public page - no login required.
        if (!IsPostBack)
            LoadPosts(null, null);
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        LoadPosts(txtSearch.Text.Trim(), ddlType.SelectedValue);
    }

    protected void btnReset_Click(object sender, EventArgs e)
    {
        txtSearch.Text = "";
        ddlType.SelectedIndex = 0;
        LoadPosts(null, null);
    }

    private void LoadPosts(string search, string type)
    {
        using (SqlConnection conn = new SqlConnection(ConnStr))
        {
            conn.Open();

            // Featured post (most recent published & featured)
            LoadFeatured(conn);

            string sql = @"SELECT p.[PostID], p.[Title], p.[Category], p.[Content],
                                  p.[CreatedAt], u.[Username] AS AuthorName
                           FROM [BlogPosts] p
                           INNER JOIN [Users] u ON p.[AuthorID] = u.[UserID]
                           WHERE p.[Status] = 'Published' AND p.[IsFeatured] = 0";

            if (!string.IsNullOrEmpty(search))
                sql += " AND (p.[Title] LIKE @Search OR p.[Content] LIKE @Search)";
            if (!string.IsNullOrEmpty(type))
                sql += " AND p.[PostType] = @Type";

            sql += " ORDER BY p.[CreatedAt] DESC";

            SqlCommand cmd = new SqlCommand(sql, conn);
            if (!string.IsNullOrEmpty(search))
                cmd.Parameters.AddWithValue("@Search", "%" + search + "%");
            if (!string.IsNullOrEmpty(type))
                cmd.Parameters.AddWithValue("@Type", type);

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);

            rptPosts.DataSource = dt;
            rptPosts.DataBind();

            pnlEmpty.Visible = (dt.Rows.Count == 0 && !pnlFeatured.Visible);
        }
    }

    private void LoadFeatured(SqlConnection conn)
    {
        string sql = @"SELECT TOP 1 p.[PostID], p.[Title], p.[Content]
                       FROM [BlogPosts] p
                       WHERE p.[Status] = 'Published' AND p.[IsFeatured] = 1
                       ORDER BY p.[CreatedAt] DESC";

        SqlCommand cmd = new SqlCommand(sql, conn);
        using (SqlDataReader r = cmd.ExecuteReader())
        {
            if (r.Read())
            {
                lblFeaturedTitle.Text = r["Title"].ToString();
                lblFeaturedExcerpt.Text = GetExcerpt(r["Content"]);
                lnkFeatured.NavigateUrl = "Article.aspx?id=" + r["PostID"].ToString();
                pnlFeatured.Visible = true;
            }
        }
    }

    // Shared helper: short preview of the content (used in markup too).
    protected string GetExcerpt(object content)
    {
        string text = content == null ? "" : content.ToString();
        if (text.Length > 120)
            return text.Substring(0, 120) + "...";
        return text;
    }
}
