using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace HackEdCTF.Web.Training
{
    public partial class ModuleListing : System.Web.UI.Page
    {

        private string ConnStr
        {
            get { return System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString; }
        }


        private string CurrentLevel
        {
            get { return (ViewState["Level"] as string) ?? ""; }
            set { ViewState["Level"] = value; }
        }
        private string CurrentCategory
        {
            get { return (ViewState["Category"] as string) ?? ""; }
            set { ViewState["Category"] = value; }
        }
        private string CurrentSearch
        {
            get { return (ViewState["Search"] as string) ?? ""; }
            set { ViewState["Search"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // ---- Session guard: must be logged in ----
            if (Session["UserID"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadModules();
            }
        }

        protected void BtnSearch_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;
            CurrentSearch = txtModuleSearch.Text.Trim();
            LoadModules();
        }

        protected void LnkLevel_Click(object sender, EventArgs e)
        {
            LinkButton clicked = (LinkButton)sender;
            CurrentLevel = clicked.CommandArgument;
            SetActivePill(clicked, new[] { lnkLvlAll, lnkLvlBeginner, lnkLvlAdvanced, lnkLvlExpert });
            LoadModules();
        }

        protected void LnkCategory_Click(object sender, EventArgs e)
        {
            LinkButton clicked = (LinkButton)sender;
            CurrentCategory = clicked.CommandArgument;
            SetActivePill(clicked, new[] { lnkCatAll, lnkCatWeb, lnkCatNetwork, lnkCatLinux, lnkCatCrypto });
            LoadModules();
        }

        private void SetActivePill(LinkButton active, LinkButton[] group)
        {
            foreach (LinkButton lb in group)
                lb.CssClass = "filter-pill";
            active.CssClass = "filter-pill active";
        }

        private void LoadModules()
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();

                // Build SQL dynamically — only add WHERE clauses for active filters
                string sql = @"SELECT [ModuleID], [Title], [Category], [Level], [Content], [CreatedAt]
                               FROM [Modules]
                               WHERE 1 = 1";

                if (!string.IsNullOrEmpty(CurrentSearch))
                    sql += " AND [Title] LIKE @Search";
                if (!string.IsNullOrEmpty(CurrentLevel))
                    sql += " AND [Level] = @Level";
                if (!string.IsNullOrEmpty(CurrentCategory))
                    sql += " AND [Category] = @Category";

                sql += " ORDER BY [Title]";

                SqlCommand cmd = new SqlCommand(sql, conn);

                if (!string.IsNullOrEmpty(CurrentSearch))
                    cmd.Parameters.AddWithValue("@Search", "%" + CurrentSearch + "%");
                if (!string.IsNullOrEmpty(CurrentLevel))
                    cmd.Parameters.AddWithValue("@Level", CurrentLevel);
                if (!string.IsNullOrEmpty(CurrentCategory))
                    cmd.Parameters.AddWithValue("@Category", CurrentCategory);

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    DataTable dt = new DataTable();
                    dt.Load(reader);

                    // Add a short description column derived from Content
                    dt.Columns.Add("ShortDescription", typeof(string));
                    foreach (DataRow row in dt.Rows)
                    {
                        string content = row["Content"] != DBNull.Value
                            ? row["Content"].ToString()
                            : "";
                        row["ShortDescription"] = content.Length > 140
                            ? content.Substring(0, 140) + "..."
                            : content;
                    }

                    if (dt.Rows.Count == 0)
                    {
                        rptModules.Visible = false;
                        lblNoResults.Visible = true;
                        lblNoResults.Text = "No modules found. Try adjusting your filters.";
                    }
                    else
                    {
                        lblNoResults.Visible = false;
                        rptModules.Visible = true;
                        rptModules.DataSource = dt;
                        rptModules.DataBind();
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
    }
}