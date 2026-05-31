using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

public partial class Announcements : Page
{
    private string ConnStr
    {
        get { return System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
            LoadAnnouncements(null);
    }

    protected void ddlPriority_Changed(object sender, EventArgs e)
    {
        LoadAnnouncements(ddlPriority.SelectedValue);
    }

    private void LoadAnnouncements(string priority)
    {
        using (SqlConnection conn = new SqlConnection(ConnStr))
        {
            conn.Open();

            LoadPinned(conn);

            string sql = @"SELECT [AnnouncementID], [Title], [Content], [Priority], [CreatedAt]
                           FROM [Announcements]
                           WHERE [Status] = 'Published' AND [IsPinned] = 0";

            if (!string.IsNullOrEmpty(priority))
                sql += " AND [Priority] = @Priority";

            sql += " ORDER BY [CreatedAt] DESC";

            SqlCommand cmd = new SqlCommand(sql, conn);
            if (!string.IsNullOrEmpty(priority))
                cmd.Parameters.AddWithValue("@Priority", priority);

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);

            rptAnnouncements.DataSource = dt;
            rptAnnouncements.DataBind();

            pnlEmpty.Visible = (dt.Rows.Count == 0 && !pnlPinned.Visible);
        }
    }

    private void LoadPinned(SqlConnection conn)
    {
        string sql = @"SELECT TOP 1 [Title], [Content]
                       FROM [Announcements]
                       WHERE [Status] = 'Published' AND [IsPinned] = 1
                       ORDER BY [CreatedAt] DESC";

        SqlCommand cmd = new SqlCommand(sql, conn);
        using (SqlDataReader r = cmd.ExecuteReader())
        {
            if (r.Read())
            {
                lblPinnedTitle.Text = r["Title"].ToString();
                lblPinnedContent.Text = r["Content"].ToString();
                pnlPinned.Visible = true;
            }
        }
    }

    protected string GetPreview(object content)
    {
        string text = content == null ? "" : content.ToString();
        if (text.Length > 100)
            return text.Substring(0, 100) + "...";
        return text;
    }
}
