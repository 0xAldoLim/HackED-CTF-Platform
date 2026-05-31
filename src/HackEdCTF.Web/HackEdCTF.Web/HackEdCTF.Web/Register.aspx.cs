using System;
using System.Data;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;
using System.Web.UI;

public partial class Register : Page
{
    private string ConnStr
    {
        get { return System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString; }
    }

    // SHA-256 helper
    private string HashPassword(string password)
    {
        using (SHA256 sha256 = SHA256.Create())
        {
            byte[] bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password));
            StringBuilder sb = new StringBuilder();
            foreach (byte b in bytes)
                sb.Append(b.ToString("x2"));
            return sb.ToString();
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["UserID"] != null)
            Response.Redirect("~/Member/Dashboard.aspx");
    }

    //username uniqueness
    protected void cvUsername_ServerValidate(object source, System.Web.UI.WebControls.ServerValidateEventArgs args)
    {
        using (SqlConnection conn = new SqlConnection(ConnStr))
        {
            conn.Open();
            SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM [Users] WHERE [Username] = @Username", conn);
            cmd.Parameters.AddWithValue("@Username", txtUsername.Text.Trim());
            args.IsValid = ((int)cmd.ExecuteScalar() == 0);
        }
    }

    //email uniqueness
    protected void cvEmail_ServerValidate(object source, System.Web.UI.WebControls.ServerValidateEventArgs args)
    {
        using (SqlConnection conn = new SqlConnection(ConnStr))
        {
            conn.Open();
            SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM [Users] WHERE [Email] = @Email", conn);
            cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
            args.IsValid = ((int)cmd.ExecuteScalar() == 0);
        }
    }

    protected void btnRegister_Click(object sender, EventArgs e)
    {
        cvUsername.Validate();
        cvEmail.Validate();

        if (!Page.IsValid)
            return;

        try
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();

                SqlCommand cmd = new SqlCommand(
                    @"INSERT INTO [Users] ([Username], [Email], [PasswordHash], [Role], [TotalScore], [CreatedAt], [IsActive])
                      VALUES (@Username, @Email, @PasswordHash, 'Player', 0, @CreatedAt, 1)",
                    conn);

                cmd.Parameters.AddWithValue("@Username", txtUsername.Text.Trim());
                cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                cmd.Parameters.AddWithValue("@PasswordHash", HashPassword(txtPassword.Text));
                cmd.Parameters.AddWithValue("@CreatedAt", DateTime.Now);

                cmd.ExecuteNonQuery();
            }

            Response.Redirect("Login.aspx?registered=1");
        }
        catch (Exception ex)
        {
            pnlAlert.Visible = true;
            lblAlert.Text = "Registration failed: " + ex.Message;
        }
    }
}
