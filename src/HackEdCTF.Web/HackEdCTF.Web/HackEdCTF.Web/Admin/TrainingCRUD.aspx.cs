using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace HackEdCTF.Web.Admin
{
    public partial class TrainingCRUD : System.Web.UI.Page
    {
        private string ConnStr
        {
            get
            {
                return System.Configuration.ConfigurationManager
                .ConnectionStrings["ConnectionString"].ConnectionString;
            }
        }

        private string CurrentSearch
        {
            get { return (ViewState["Search"] as string) ?? ""; }
            set { ViewState["Search"] = value; }
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
                LoadModules();
            }
        }

        protected void BtnAddModule_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Admin/TrainingEditCreate.aspx");
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;
            CurrentSearch = txtModuleSearch.Text.Trim();
            LoadModules();
        }

        protected void gvModules_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int moduleID;
            if (!int.TryParse(e.CommandArgument.ToString(), out moduleID))
                return;

            if (e.CommandName == "EditModule")
            {
                Response.Redirect("~/Admin/TrainingEditCreate.aspx?id=" + moduleID);
            }
            else if (e.CommandName == "DeleteModule")
            {
                DeleteModule(moduleID);
                LoadModules(); // refresh the table
            }
        }

        private void LoadModules()
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();

                string sql = @"SELECT [ModuleID], [Title], [Level], [Category], [CreatedAt]
                               FROM [Modules]
                               WHERE 1 = 1";

                if (!string.IsNullOrEmpty(CurrentSearch))
                    sql += " AND [Title] LIKE @Search";

                sql += " ORDER BY [CreatedAt] DESC";

                SqlCommand cmd = new SqlCommand(sql, conn);
                if (!string.IsNullOrEmpty(CurrentSearch))
                    cmd.Parameters.AddWithValue("@Search", "%" + CurrentSearch + "%");

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    DataTable dt = new DataTable();
                    dt.Load(reader);
                    gvModules.DataSource = dt;
                    gvModules.DataBind();
                }
            }
        }

        private void DeleteModule(int moduleID)
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand(
                    "DELETE FROM [Modules] WHERE [ModuleID] = @ID", conn);
                cmd.Parameters.AddWithValue("@ID", moduleID);

                int rows = cmd.ExecuteNonQuery();
                if (rows > 0)
                {
                    ShowAlert("Module deleted.", "alert alert-success");
                }
                else
                {
                    ShowAlert("Module not found.", "alert alert-warning");
                }
            }
        }

        private void ShowAlert(string message, string cssClass)
        {
            lblAlert.Text = message;
            lblAlert.CssClass = cssClass;
            lblAlert.Visible = true;
        }

        protected void lnkLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/Login.aspx");
        }

    }
}