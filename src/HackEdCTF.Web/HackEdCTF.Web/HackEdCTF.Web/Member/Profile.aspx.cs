using System;
using System.Data;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;
using System.Web.UI;

public partial class Member_Profile : Page
{
    private string ConnStr
    {
        get { return System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString; }
    }

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
        if (Session["UserID"] == null)
        {
            Response.Redirect("~/Login.aspx");
            return;
        }

        if (!IsPostBack)
            LoadProfile();
    }

    protected void lnkLogout_Click(object sender, EventArgs e)
    {
        Session.Abandon();
        Response.Redirect("~/Login.aspx");
    }

    protected void btnShowEdit_Click(object sender, EventArgs e)
    {
        int userID = int.Parse(Session["UserID"].ToString());

        using (SqlConnection conn = new SqlConnection(ConnStr))
        {
            conn.Open();
            SqlCommand cmd = new SqlCommand(
                "SELECT [Username], [Email] FROM [Users] WHERE [UserID] = @UID", conn);
            cmd.Parameters.AddWithValue("@UID", userID);
            SqlDataReader r = cmd.ExecuteReader();
            if (r.Read())
            {
                txtEditUsername.Text = r["Username"].ToString();
                txtEditEmail.Text = r["Email"].ToString();
            }
            r.Close();
        }

        pnlView.Visible = false;
        pnlEdit.Visible = true;
        pnlSuccess.Visible = false;
        pnlError.Visible = false;
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        pnlEdit.Visible = false;
        pnlView.Visible = true;
        pnlSuccess.Visible = false;
        pnlError.Visible = false;
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        int userID = int.Parse(Session["UserID"].ToString());
        string newUsername = txtEditUsername.Text.Trim();
        string newEmail = txtEditEmail.Text.Trim();
        string currentPwd = txtCurrentPassword.Text;
        string newPwd = txtNewPassword.Text;
        string confirmPwd = txtConfirmPassword.Text;

        using (SqlConnection conn = new SqlConnection(ConnStr))
        {
            conn.Open();

            //Check username
            SqlCommand cmdCheckUser = new SqlCommand(
                "SELECT COUNT(*) FROM [Users] WHERE [Username] = @Name AND [UserID] <> @UID", conn);
            cmdCheckUser.Parameters.AddWithValue("@Name", newUsername);
            cmdCheckUser.Parameters.AddWithValue("@UID", userID);
            if ((int)cmdCheckUser.ExecuteScalar() > 0)
            {
                ShowError("That username is already taken.");
                return;
            }

            //Check email
            SqlCommand cmdCheckEmail = new SqlCommand(
                "SELECT COUNT(*) FROM [Users] WHERE [Email] = @Email AND [UserID] <> @UID", conn);
            cmdCheckEmail.Parameters.AddWithValue("@Email", newEmail);
            cmdCheckEmail.Parameters.AddWithValue("@UID", userID);
            if ((int)cmdCheckEmail.ExecuteScalar() > 0)
            {
                ShowError("That email address is already in use.");
                return;
            }

            //password change
            bool changingPassword = !string.IsNullOrEmpty(newPwd) || !string.IsNullOrEmpty(currentPwd);

            if (changingPassword)
            {
                if (string.IsNullOrEmpty(currentPwd))
                {
                    ShowError("Please enter your current password to set a new one.");
                    return;
                }
                if (newPwd.Length < 6)
                {
                    ShowError("New password must be at least 6 characters.");
                    return;
                }
                if (newPwd != confirmPwd)
                {
                    ShowError("New passwords do not match.");
                    return;
                }

                // Verify current password
                SqlCommand cmdGetHash = new SqlCommand(
                    "SELECT [PasswordHash] FROM [Users] WHERE [UserID] = @UID", conn);
                cmdGetHash.Parameters.AddWithValue("@UID", userID);
                string storedHash = cmdGetHash.ExecuteScalar()?.ToString() ?? "";

                string enteredHash = HashPassword(currentPwd);
                if (!string.Equals(storedHash, enteredHash, StringComparison.OrdinalIgnoreCase))
                {
                    ShowError("Current password is incorrect.");
                    return;
                }

                string newHash = HashPassword(newPwd);
                SqlCommand cmdUpdateAll = new SqlCommand(
                    "UPDATE [Users] SET [Username]=@Name, [Email]=@Email, [PasswordHash]=@Hash WHERE [UserID]=@UID", conn);
                cmdUpdateAll.Parameters.AddWithValue("@Name", newUsername);
                cmdUpdateAll.Parameters.AddWithValue("@Email", newEmail);
                cmdUpdateAll.Parameters.AddWithValue("@Hash", newHash);
                cmdUpdateAll.Parameters.AddWithValue("@UID", userID);
                cmdUpdateAll.ExecuteNonQuery();
            }
            else
            {
                SqlCommand cmdUpdate = new SqlCommand(
                    "UPDATE [Users] SET [Username]=@Name, [Email]=@Email WHERE [UserID]=@UID", conn);
                cmdUpdate.Parameters.AddWithValue("@Name", newUsername);
                cmdUpdate.Parameters.AddWithValue("@Email", newEmail);
                cmdUpdate.Parameters.AddWithValue("@UID", userID);
                cmdUpdate.ExecuteNonQuery();
            }
        }

        // Update session username in case it changed
        Session["Username"] = newUsername;

        // Clear password fields
        txtCurrentPassword.Text = "";
        txtNewPassword.Text = "";
        txtConfirmPassword.Text = "";

        // Reload view panel with fresh data
        LoadProfile();
        pnlEdit.Visible = false;
        pnlView.Visible = true;
        ShowSuccess("Profile updated successfully!");
    }

    private void LoadProfile()
    {
        int userID = int.Parse(Session["UserID"].ToString());
        lblNavUsername.Text = Session["Username"].ToString();

        using (SqlConnection conn = new SqlConnection(ConnStr))
        {
            conn.Open();

            SqlCommand cmdUser = new SqlCommand(
                "SELECT [Username], [Email], [Role], [TotalScore], [CreatedAt] FROM [Users] WHERE [UserID] = @UID", conn);
            cmdUser.Parameters.AddWithValue("@UID", userID);
            SqlDataReader r = cmdUser.ExecuteReader();

            if (r.Read())
            {
                lblUsername.Text = r["Username"].ToString();
                lblEmail.Text = r["Email"].ToString();
                lblRole.Text = r["Role"].ToString();
                lblScore.Text = string.Format("{0:N0}", r["TotalScore"]);
                lblJoined.Text = Convert.ToDateTime(r["CreatedAt"]).ToString("MMM yyyy");
            }
            r.Close();

            SqlCommand cmdTeam = new SqlCommand(
                @"SELECT t.[TeamName] FROM [Teams] t
                  INNER JOIN [TeamMembers] tm ON t.[TeamID] = tm.[TeamID]
                  WHERE tm.[UserID] = @UID", conn);
            cmdTeam.Parameters.AddWithValue("@UID", userID);
            object team = cmdTeam.ExecuteScalar();
            lblTeam.Text = team != null ? team.ToString() : "None";

            SqlCommand cmdActivity = new SqlCommand(
                @"SELECT TOP 5
                    s.[SubmittedAt],
                    'Solved ' + c.[Title]                              AS [Action],
                    '+' + CAST(s.[PointsAwarded] AS VARCHAR) + ' pts'  AS [Result]
                  FROM [Submissions] s
                  INNER JOIN [Challenges] c ON s.[ChallengeID] = c.[ChallengeID]
                  WHERE s.[UserID] = @UID AND s.[IsCorrect] = 1
                  ORDER BY s.[SubmittedAt] DESC", conn);
            cmdActivity.Parameters.AddWithValue("@UID", userID);
            SqlDataAdapter da = new SqlDataAdapter(cmdActivity);
            DataTable dt = new DataTable();
            da.Fill(dt);

            dt.Columns.Add("DateLabel", typeof(string));
            foreach (DataRow row in dt.Rows)
            {
                DateTime d = Convert.ToDateTime(row["SubmittedAt"]);
                if (d.Date == DateTime.Today)
                    row["DateLabel"] = "Today";
                else if (d.Date == DateTime.Today.AddDays(-1))
                    row["DateLabel"] = "Yesterday";
                else
                    row["DateLabel"] = d.ToString("MMM d");
            }

            rptActivity.DataSource = dt;
            rptActivity.DataBind();
        }
    }

    private void ShowSuccess(string msg)
    {
        lblSuccess.Text = msg;
        pnlSuccess.Visible = true;
        pnlError.Visible = false;
    }

    private void ShowError(string msg)
    {
        lblError.Text = msg;
        pnlError.Visible = true;
        pnlEdit.Visible = true;
        pnlView.Visible = false;
    }
}
