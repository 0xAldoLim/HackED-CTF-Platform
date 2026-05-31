using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace HackEdCTF.Web.Admin
{
    public partial class TrainingEditCreate : System.Web.UI.Page
    {
        private string ConnStr
        {
            get
            {
                return System.Configuration.ConfigurationManager
                .ConnectionStrings["ConnectionString"].ConnectionString;
            }
        }

        private int ModuleID
        {
            get { return (int)(ViewState["ModuleID"] ?? 0); }
            set { ViewState["ModuleID"] = value; }
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
            {
                string idParam = Request.QueryString["id"];
                int id;
                if (!string.IsNullOrEmpty(idParam) && int.TryParse(idParam, out id))
                {
                    ModuleID = id;
                    LoadModule(id);
                    litPageTitle.Text = "Edit Training Module";
                }
                else
                {
                    ModuleID = 0;
                    litPageTitle.Text = "Create Training Module";
                }
            }
        }

        private void LoadModule(int id)
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand(
                    @"SELECT [Title], [Level], [Category], [Content]
                      FROM [Modules]
                      WHERE [ModuleID] = @ID", conn);
                cmd.Parameters.AddWithValue("@ID", id);

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        // Prefill the form with existing values
                        txtTitle.Text = reader["Title"].ToString();
                        ddlLevel.SelectedValue = reader["Level"].ToString();
                        txtCategory.Text = reader["Category"].ToString();
                        txtContent.Text = reader["Content"].ToString();
                    }
                    else
                    {
                        // No matching module exists
                        ShowAlert("Module not found. Creating a new one instead.", "alert alert-warning");
                        ModuleID = 0;
                        litPageTitle.Text = "Create Training Module";
                    }
                }
            }
        }

        protected void lnkLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/Login.aspx");
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string title = txtTitle.Text.Trim();
            string level = ddlLevel.SelectedValue;
            string category = txtCategory.Text.Trim();
            string content = txtContent.Text.Trim();

            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();
                SqlCommand cmd;

                if (ModuleID == 0)
                {
                    cmd = new SqlCommand(
                        @"INSERT INTO [Modules]
                            ([Title], [Level], [Category], [Content], [CreatedByUserID], [CreatedAt])
                          VALUES
                            (@Title, @Level, @Category, @Content, @UserID, GETDATE())", conn);
                    cmd.Parameters.AddWithValue("@UserID", Convert.ToInt32(Session["UserID"]));
                }
                else
                {
                    cmd = new SqlCommand(
                        @"UPDATE [Modules]
                          SET [Title] = @Title,
                              [Level] = @Level,
                              [Category] = @Category,
                              [Content] = @Content
                          WHERE [ModuleID] = @ID", conn);
                    cmd.Parameters.AddWithValue("@ID", ModuleID);
                }

                cmd.Parameters.AddWithValue("@Title", title);
                cmd.Parameters.AddWithValue("@Level", level);
                cmd.Parameters.AddWithValue("@Category", category);
                cmd.Parameters.AddWithValue("@Content", content);

                cmd.ExecuteNonQuery();
            }

            Response.Redirect("~/Admin/TrainingCRUD.aspx");
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Admin/TrainingCRUD.aspx");
        }

        private void ShowAlert(string message, string cssClass)
        {
            lblAlert.Text = message;
            lblAlert.CssClass = cssClass;
            lblAlert.Visible = true;
        }


    }
}