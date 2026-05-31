using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace HackEdCTF.Web.Training
{
    public partial class ModuleDetail : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadModule();
            }
        }

        private string ConnStr
        {
            get
            {
                return System.Configuration.ConfigurationManager
                .ConnectionStrings["ConnectionString"].ConnectionString;
            }
        }

        protected int CurrentModuleID
        {
            get { return (int)(ViewState["ModuleID"] ?? 0); }
            set { ViewState["ModuleID"] = value; }
        }

        private void LoadModule()
        {
            string idParam = Request.QueryString["id"];
            int moduleID;
            if (string.IsNullOrEmpty(idParam) || !int.TryParse(idParam, out moduleID))
            {
                ShowNotFound();
                return;
            }

            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand(
                    @"SELECT [Title], [Category], [Level], [Content], [CreatedAt]
                      FROM [Modules]
                      WHERE [ModuleID] = @ModuleID", conn);
                cmd.Parameters.AddWithValue("@ModuleID", moduleID);

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (!reader.Read())
                    {
                        ShowNotFound();
                        return;
                    }

                    CurrentModuleID = moduleID;

                    string title = reader["Title"].ToString();
                    string level = reader["Level"].ToString();
                    string category = reader["Category"].ToString();
                    string content = reader["Content"].ToString();

                    litTitle.Text = title;
                    litContent.Text = Server.HtmlEncode(content).Replace("\n", "<br />");

                    lblLevel.Text = level;
                    lblLevel.CssClass = "badge badge-" + level.ToLower();

                    lblCategory.Text = category;
                    lblCategory.CssClass = "badge badge-" + category.ToLower();

                    Page.Title = title + " - HackEd";

                }
            }

            btnPrev.Visible = GetAdjacentModuleID(moduleID, isNext: false) > 0;
            btnNext.Visible = GetAdjacentModuleID(moduleID, isNext: true) > 0;

            Page.DataBind();
        }

        private void ShowNotFound()
        {
            pnlNotFound.Visible = true;
        }

        protected void btnPrev_Click(object sender, EventArgs e)
        {
            int prevID = GetAdjacentModuleID(CurrentModuleID, isNext: false);
            if (prevID > 0)
                Response.Redirect("~/Training/ModuleDetail.aspx?id=" + prevID);
        }

        protected void btnNext_Click(object sender, EventArgs e)
        {
            int nextID = GetAdjacentModuleID(CurrentModuleID, isNext: true);
            if (nextID > 0)
                Response.Redirect("~/Training/ModuleDetail.aspx?id=" + nextID);
            else
                Response.Redirect("~/Training/ModuleListing.aspx");
        }

        private int GetAdjacentModuleID(int currentID, bool isNext)
        {
            string sql = isNext
                ? "SELECT TOP 1 [ModuleID] FROM [Modules] WHERE [ModuleID] > @ID ORDER BY [ModuleID] ASC"
                : "SELECT TOP 1 [ModuleID] FROM [Modules] WHERE [ModuleID] < @ID ORDER BY [ModuleID] DESC";

            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@ID", currentID);
                object result = cmd.ExecuteScalar();
                return result != null ? Convert.ToInt32(result) : 0;
            }
        }

        protected void lnkLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/Login.aspx");
        }
    }
}