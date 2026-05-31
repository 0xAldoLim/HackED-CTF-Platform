using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Admin_Users : Page
{
    private string ConnStr
    {
        get { return System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
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
            LoadUsers(null);
    }

    protected void lnkLogout_Click(object sender, EventArgs e)
    {
        Session.Abandon();
        Response.Redirect("~/Login.aspx");
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        LoadUsers(txtSearch.Text.Trim());
    }

    protected void btnReset_Click(object sender, EventArgs e)
    {
        txtSearch.Text = "";
        LoadUsers(null);
    }

    private void LoadUsers(string search)
    {
        using (SqlConnection conn = new SqlConnection(ConnStr))
        {
            conn.Open();

            string sql = @"SELECT [UserID], [Username], [Email], [Role],
                                  [TotalScore], [IsActive], [CreatedAt]
                           FROM [Users]";

            if (!string.IsNullOrEmpty(search))
                sql += " WHERE [Username] LIKE @Search OR [Email] LIKE @Search";

            sql += " ORDER BY [CreatedAt] DESC";

            SqlCommand cmd = new SqlCommand(sql, conn);
            if (!string.IsNullOrEmpty(search))
                cmd.Parameters.AddWithValue("@Search", "%" + search + "%");

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);

            rptUsers.DataSource = dt;
            rptUsers.DataBind();

            pnlEmpty.Visible = (dt.Rows.Count == 0);
        }
    }

    protected void rptUsers_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        int targetUserID = int.Parse(e.CommandArgument.ToString());
        int currentUserID = int.Parse(Session["UserID"].ToString());

        // Prevent admin from modifying their own account
        if (targetUserID == currentUserID)
        {
            ShowAlert("You cannot modify your own account.", false);
            return;
        }

        using (SqlConnection conn = new SqlConnection(ConnStr))
        {
            conn.Open();
            SqlCommand cmd = null;

            switch (e.CommandName)
            {
                case "Promote":
                    cmd = new SqlCommand("UPDATE [Users] SET [Role] = 'Admin' WHERE [UserID] = @UID", conn);
                    break;
                case "Demote":
                    cmd = new SqlCommand("UPDATE [Users] SET [Role] = 'Player' WHERE [UserID] = @UID", conn);
                    break;
                case "Activate":
                    cmd = new SqlCommand("UPDATE [Users] SET [IsActive] = 1 WHERE [UserID] = @UID", conn);
                    break;
                case "Deactivate":
                    cmd = new SqlCommand("UPDATE [Users] SET [IsActive] = 0 WHERE [UserID] = @UID", conn);
                    break;
                case "Delete":
                    // Delete submissions first to avoid FK constraint errors
                    SqlCommand delSubs = new SqlCommand("DELETE FROM [Submissions] WHERE [UserID] = @UID", conn);
                    delSubs.Parameters.AddWithValue("@UID", targetUserID);
                    delSubs.ExecuteNonQuery();
                    cmd = new SqlCommand("DELETE FROM [Users] WHERE [UserID] = @UID", conn);
                    break;
            }

            if (cmd != null)
            {
                cmd.Parameters.AddWithValue("@UID", targetUserID);
                cmd.ExecuteNonQuery();
                ShowAlert("User updated successfully.", true);
            }
        }

        LoadUsers(txtSearch.Text.Trim());
    }

    private void ShowAlert(string message, bool success)
    {
        lblAlert.Text = message;
        pnlAlert.CssClass = success ? "alert alert-success" : "alert alert-danger";
        pnlAlert.Visible = true;
    }
}