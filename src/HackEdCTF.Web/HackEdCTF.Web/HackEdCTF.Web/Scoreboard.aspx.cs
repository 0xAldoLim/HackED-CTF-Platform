using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

public partial class Scoreboard : Page
{
    private string ConnStr
    {
        get { return System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            SetupNav();
            LoadPlayers();
        }
    }

    private void SetupNav()
    {
        if (Session["UserID"] != null)
        {
            lnkNavDashboard.Text = Session["Username"].ToString();
            lnkNavDashboard.NavigateUrl = Session["Role"].ToString() == "Admin"
                ? "~/Admin/Dashboard.aspx" : "~/Member/Dashboard.aspx";
            lnkLogout.Visible = true;
            lnkGetStarted.Visible = false;
        }
        else
        {
            lnkNavDashboard.Visible = false;
            lnkGetStarted.Visible = true;
        }
    }

    protected void lnkLogout_Click(object sender, EventArgs e)
    {
        Session.Abandon();
        Response.Redirect("~/Login.aspx");
    }

    protected void btnTabPlayers_Click(object sender, EventArgs e)
    {
        pnlPlayers.Visible = true;
        pnlTeams.Visible = false;
        btnTabPlayers.CssClass = "filter-pill active";
        btnTabTeams.CssClass = "filter-pill";
        LoadPlayers();
    }

    protected void btnTabTeams_Click(object sender, EventArgs e)
    {
        pnlPlayers.Visible = false;
        pnlTeams.Visible = true;
        btnTabPlayers.CssClass = "filter-pill";
        btnTabTeams.CssClass = "filter-pill active";
        LoadTeams();
    }

    protected void txtSearchPlayers_TextChanged(object sender, EventArgs e)
    {
        LoadPlayers(txtSearchPlayers.Text.Trim());
    }

    protected void txtSearchTeams_TextChanged(object sender, EventArgs e)
    {
        LoadTeams(txtSearchTeams.Text.Trim());
    }

    private void LoadPlayers(string search = "")
    {
        using (SqlConnection conn = new SqlConnection(ConnStr))
        {
            conn.Open();
            SqlCommand cmd = new SqlCommand(@"
                WITH Ranked AS (
                    SELECT
                        ROW_NUMBER() OVER (ORDER BY u.[TotalScore] DESC) AS RowNum,
                        u.[Username],
                        u.[TotalScore],
                        COUNT(s.[SubmissionID]) AS SolvedCount,
                        MAX(s.[SubmittedAt]) AS LastSolveDate,
                        t.[TeamName]
                    FROM [Users] u
                    LEFT JOIN [Submissions] s ON u.[UserID] = s.[UserID] AND s.[IsCorrect] = 1
                    LEFT JOIN [TeamMembers] tm ON u.[UserID] = tm.[UserID]
                    LEFT JOIN [Teams] t ON tm.[TeamID] = t.[TeamID]
                    WHERE u.[Role] = 'Player' AND u.[IsActive] = 1
                    GROUP BY u.[Username], u.[TotalScore], t.[TeamName]
                )
                SELECT RowNum, Username, TotalScore, SolvedCount, TeamName,
                    CASE
                        WHEN DATEDIFF(MINUTE, LastSolveDate, GETDATE()) < 60
                            THEN CAST(DATEDIFF(MINUTE, LastSolveDate, GETDATE()) AS VARCHAR) + 'm ago'
                        WHEN DATEDIFF(HOUR, LastSolveDate, GETDATE()) < 24
                            THEN CAST(DATEDIFF(HOUR, LastSolveDate, GETDATE()) AS VARCHAR) + 'h ago'
                        WHEN LastSolveDate IS NULL THEN NULL
                        ELSE CONVERT(VARCHAR, LastSolveDate, 107)
                    END AS LastSolve
                FROM Ranked
                WHERE (@Search = '' OR Username LIKE '%' + @Search + '%')
                ORDER BY RowNum", conn);

            cmd.Parameters.AddWithValue("@Search", search);

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);

            DataTable top3 = dt.Clone();
            for (int i = 0; i < Math.Min(3, dt.Rows.Count); i++)
                top3.ImportRow(dt.Rows[i]);

            rptTopPlayers.DataSource = top3;
            rptTopPlayers.DataBind();

            rptPlayers.DataSource = dt;
            rptPlayers.DataBind();
            pnlNoPlayers.Visible = (dt.Rows.Count == 0);
        }
    }

    private void LoadTeams(string search = "")
    {
        using (SqlConnection conn = new SqlConnection(ConnStr))
        {
            conn.Open();
            SqlCommand cmd = new SqlCommand(@"
                SELECT
                    ROW_NUMBER() OVER (ORDER BY t.[TeamScore] DESC) AS RowNum,
                    t.[TeamName],
                    t.[TeamScore],
                    COUNT(tm.[UserID]) AS MemberCount,
                    u.[Username] AS LeaderName
                FROM [Teams] t
                INNER JOIN [Users] u ON t.[LeaderUserID] = u.[UserID]
                LEFT JOIN [TeamMembers] tm ON t.[TeamID] = tm.[TeamID]
                WHERE (@Search = '' OR t.[TeamName] LIKE '%' + @Search + '%')
                GROUP BY t.[TeamName], t.[TeamScore], u.[Username]
                ORDER BY t.[TeamScore] DESC", conn);

            cmd.Parameters.AddWithValue("@Search", search);

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);

            DataTable top3 = dt.Clone();
            for (int i = 0; i < Math.Min(3, dt.Rows.Count); i++)
                top3.ImportRow(dt.Rows[i]);

            rptTopTeams.DataSource = top3;
            rptTopTeams.DataBind();

            rptTeams.DataSource = dt;
            rptTeams.DataBind();
            pnlNoTeams.Visible = (dt.Rows.Count == 0);
        }
    }
}