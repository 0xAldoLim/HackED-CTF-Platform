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
            ShowPlayers();
        }
    }

    private void SetupNav()
    {
        if (Session["UserID"] != null)
        {
            lnkNavDashboard.Text = Session["Username"].ToString();
            lnkNavDashboard.NavigateUrl = Session["Role"] != null && Session["Role"].ToString() == "Admin"
                ? "~/Admin/Dashboard.aspx"
                : "~/Member/Dashboard.aspx";
            lnkLogout.Visible = true;
            lnkGetStarted.Visible = false;
            pnlNavAuth.Visible = true;
        }
        else
        {
            pnlNavAuth.Visible = false;
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
        ShowPlayers();
    }

    protected void btnTabTeams_Click(object sender, EventArgs e)
    {
        ShowTeams();
    }

    private void ShowPlayers()
    {
        pnlPlayers.Visible = true;
        pnlTeams.Visible = false;
        btnTabPlayers.CssClass = "filter-pill active";
        btnTabTeams.CssClass = "filter-pill";
        LoadPlayers();
    }

    private void ShowTeams()
    {
        pnlPlayers.Visible = false;
        pnlTeams.Visible = true;
        btnTabPlayers.CssClass = "filter-pill";
        btnTabTeams.CssClass = "filter-pill active";
        LoadTeams();
    }

    private void LoadPlayers()
    {
        using (SqlConnection conn = new SqlConnection(ConnStr))
        {
            conn.Open();
            SqlCommand cmd = new SqlCommand(@"
                WITH CorrectSolves AS
                (
                    SELECT
                        s.[UserID],
                        s.[ChallengeID],
                        MAX(s.[SubmittedAt]) AS LastSolveDate
                    FROM [Submissions] s
                    WHERE s.[IsCorrect] = 1
                    GROUP BY s.[UserID], s.[ChallengeID]
                ),
                Ranked AS
                (
                    SELECT TOP 10
                        u.[Username] AS DisplayName,
                        COUNT(cs.[ChallengeID]) AS Solves,
                        ISNULL(u.[TotalScore], 0) AS Score,
                        MAX(cs.[LastSolveDate]) AS LastSolveDate
                    FROM [Users] u
                    LEFT JOIN CorrectSolves cs ON u.[UserID] = cs.[UserID]
                    WHERE ISNULL(u.[IsActive], 1) = 1
                      AND ISNULL(u.[Role], 'Player') <> 'Admin'
                    GROUP BY u.[UserID], u.[Username], u.[TotalScore]
                    ORDER BY COUNT(cs.[ChallengeID]) DESC, ISNULL(u.[TotalScore], 0) DESC, u.[Username] ASC
                )
                SELECT
                    ROW_NUMBER() OVER (ORDER BY Solves DESC, Score DESC, DisplayName ASC) AS RowNum,
                    DisplayName,
                    Solves,
                    Score,
                    LastSolveDate
                FROM Ranked
                ORDER BY RowNum", conn);

            DataTable dt = new DataTable();
            new SqlDataAdapter(cmd).Fill(dt);
            AddBarWidths(dt);

            DataTable chartRows = FilterRowsWithSolves(dt);
            DataTable top3 = CopyTopRows(chartRows, 3);
            rptTopPlayers.DataSource = top3;
            rptTopPlayers.DataBind();

            rptPlayers.DataSource = chartRows;
            rptPlayers.DataBind();

            rptPlayerChart.DataSource = chartRows;
            rptPlayerChart.DataBind();

            pnlNoPlayers.Visible = chartRows.Rows.Count == 0;
            pnlNoPlayerChart.Visible = chartRows.Rows.Count == 0;
        }
    }

    private void LoadTeams()
    {
        using (SqlConnection conn = new SqlConnection(ConnStr))
        {
            conn.Open();
            SqlCommand cmd = new SqlCommand(@"
                WITH TeamSolves AS
                (
                    SELECT
                        tm.[TeamID],
                        s.[ChallengeID],
                        MAX(s.[SubmittedAt]) AS LastSolveDate
                    FROM [TeamMembers] tm
                    INNER JOIN [Submissions] s ON tm.[UserID] = s.[UserID]
                    WHERE s.[IsCorrect] = 1
                    GROUP BY tm.[TeamID], s.[ChallengeID]
                ),
                TeamSolveCounts AS
                (
                    SELECT
                        [TeamID],
                        COUNT([ChallengeID]) AS Solves
                    FROM TeamSolves
                    GROUP BY [TeamID]
                ),
                MemberCounts AS
                (
                    SELECT
                        [TeamID],
                        COUNT(DISTINCT [UserID]) AS MemberCount
                    FROM [TeamMembers]
                    GROUP BY [TeamID]
                ),
                Ranked AS
                (
                    SELECT TOP 10
                        t.[TeamName] AS DisplayName,
                        ISNULL(tsc.[Solves], 0) AS Solves,
                        ISNULL(t.[TeamScore], 0) AS Score,
                        ISNULL(mc.[MemberCount], 0) AS MemberCount
                    FROM [Teams] t
                    LEFT JOIN TeamSolveCounts tsc ON t.[TeamID] = tsc.[TeamID]
                    LEFT JOIN MemberCounts mc ON t.[TeamID] = mc.[TeamID]
                    ORDER BY ISNULL(tsc.[Solves], 0) DESC, ISNULL(t.[TeamScore], 0) DESC, t.[TeamName] ASC
                )
                SELECT
                    ROW_NUMBER() OVER (ORDER BY Solves DESC, Score DESC, DisplayName ASC) AS RowNum,
                    DisplayName,
                    Solves,
                    Score,
                    MemberCount
                FROM Ranked
                ORDER BY RowNum", conn);

            DataTable dt = new DataTable();
            new SqlDataAdapter(cmd).Fill(dt);
            AddBarWidths(dt);

            DataTable chartRows = FilterRowsWithSolves(dt);
            DataTable top3 = CopyTopRows(chartRows, 3);
            rptTopTeams.DataSource = top3;
            rptTopTeams.DataBind();

            rptTeams.DataSource = chartRows;
            rptTeams.DataBind();

            rptTeamChart.DataSource = chartRows;
            rptTeamChart.DataBind();

            pnlNoTeams.Visible = chartRows.Rows.Count == 0;
            pnlNoTeamChart.Visible = chartRows.Rows.Count == 0;
        }
    }

    private static DataTable CopyTopRows(DataTable source, int count)
    {
        DataTable result = source.Clone();
        for (int i = 0; i < Math.Min(count, source.Rows.Count); i++)
            result.ImportRow(source.Rows[i]);
        return result;
    }

    private static DataTable FilterRowsWithSolves(DataTable source)
    {
        DataTable result = source.Clone();
        foreach (DataRow row in source.Rows)
        {
            if (Convert.ToInt32(row["Solves"]) > 0)
                result.ImportRow(row);
        }
        return result;
    }

    private static void AddBarWidths(DataTable table)
    {
        if (!table.Columns.Contains("BarWidth"))
            table.Columns.Add("BarWidth", typeof(int));

        int maxSolves = 0;
        foreach (DataRow row in table.Rows)
            maxSolves = Math.Max(maxSolves, Convert.ToInt32(row["Solves"]));

        foreach (DataRow row in table.Rows)
        {
            int solves = Convert.ToInt32(row["Solves"]);
            row["BarWidth"] = maxSolves == 0 ? 0 : Math.Max(8, (int)Math.Round((solves * 100.0) / maxSolves));
        }
    }

    public string FormatDate(object value)
    {
        if (value == null || value == DBNull.Value) return "-";
        return Convert.ToDateTime(value).ToString("dd MMM yyyy");
    }
}
