using System;
using System.Data;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;
using System.Web.UI;

public partial class Login : Page
{
    private string ConnStr
    {
        get { return System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString; }
    }

    // SHA-256 helper compare
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
        {
            RedirectByRole(Session["Role"].ToString());
            return;
        }

        if (!IsPostBack && Request.QueryString["registered"] == "1")
            pnlSuccess.Visible = true;
    }

    protected void btnLogin_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid)
            return;

        string loginInput = txtLogin.Text.Trim();
        string passwordHash = HashPassword(txtPassword.Text);

        try
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();

                //Accept email OR username
                SqlCommand cmd = new SqlCommand(
                    @"SELECT [UserID], [Username], [Email], [Role], [IsActive]
                      FROM [Users]
                      WHERE ([Email] = @Login OR [Username] = @Login)
                        AND [PasswordHash] = @PasswordHash",
                    conn);

                cmd.Parameters.AddWithValue("@Login", loginInput);
                cmd.Parameters.AddWithValue("@PasswordHash", passwordHash);

                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    if (!Convert.ToBoolean(reader["IsActive"]))
                    {
                        ShowError("Your account has been deactivated. Please contact support.");
                        return;
                    }

                    //role is either 'Player' or 'Admin'
                    Session["UserID"] = reader["UserID"].ToString();
                    Session["Username"] = reader["Username"].ToString();
                    Session["Email"] = reader["Email"].ToString();
                    Session["Role"] = reader["Role"].ToString();

                    reader.Close();
                    RedirectByRole(Session["Role"].ToString());
                }
                else
                {
                    ShowError("Incorrect email/username or password.");
                }
            }
        }
        catch (Exception ex)
        {
            ShowError("Login failed: " + ex.Message);
        }
    }

    private void RedirectByRole(string role)
    {
        if (role == "Admin")
            Response.Redirect("~/Admin/Dashboard.aspx");
        else
            Response.Redirect("~/Member/Dashboard.aspx");
    }

    private void ShowError(string message)
    {
        pnlError.Visible = true;
        lblError.Text = message;
    }
}
