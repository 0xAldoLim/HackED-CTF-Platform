using System;
using System.Web.UI;

public partial class _Default : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // If already logged in, redirect to appropriate dashboard
        if (Session["UserID"] != null)
        {
            if (Session["Role"].ToString() == "Admin")
                Response.Redirect("~/Admin/Dashboard.aspx");
            else
                Response.Redirect("~/Member/Dashboard.aspx");
        }
    }
}