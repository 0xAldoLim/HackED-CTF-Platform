<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Scoreboard.aspx.cs" Inherits="Scoreboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Scoreboard – HackEd</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous" />
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;700;800&family=Inter:wght@400;700&family=JetBrains+Mono:wght@400;700&display=swap" rel="stylesheet" />
    <link href="~/css/site.css" rel="stylesheet" />
    <style>
        .scoreboard-top-three {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: var(--space-6);
            margin-bottom: var(--space-8);
        }
        .top-player-card {
            padding: var(--space-6);
            background: rgba(26, 35, 51, 0.9);
            border: 1px solid var(--color-border);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-panel);
        }
        .top-player-card:first-child {
            border-color: var(--color-mint-border);
            box-shadow: var(--shadow-mint);
        }
        .top-player-card .rank-name {
            color: var(--color-mint);
            font-family: var(--font-heading);
            font-size: 1.375rem;
            font-weight: 800;
            margin-bottom: var(--space-2);
        }
        .top-player-card .rank-meta {
            color: var(--color-text-muted);
            font-size: 0.9375rem;
        }
        .scoreboard-search {
            margin-bottom: var(--space-6);
        }
        .scoreboard-search label {
            display: block;
            color: var(--color-text-muted);
            font-size: 0.875rem;
            margin-bottom: var(--space-2);
        }
        .scoreboard-layout {
            display: grid;
            grid-template-columns: minmax(0, 1fr) 22rem;
            gap: var(--space-8);
            align-items: start;
        }
        .chart-placeholder {
            padding: var(--space-6);
            background: rgba(26, 35, 51, 0.9);
            border: 1px solid var(--color-border);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-panel);
        }
        .chart-placeholder-title {
            color: var(--color-text-strong);
            font-family: var(--font-heading);
            font-weight: 700;
            font-size: 1.125rem;
            margin-bottom: var(--space-5);
        }
        .chart-bars {
            display: flex;
            align-items: flex-end;
            gap: var(--space-2);
            height: 9rem;
        }
        .chart-bar {
            flex: 1;
            background: var(--color-mint);
            border-radius: var(--radius-xs) var(--radius-xs) 0 0;
            opacity: 0.85;
        }
        .tab-toggle {
            display: flex;
            gap: var(--space-2);
            padding: var(--space-2);
            background: rgba(16, 24, 38, 0.72);
            border: 1px solid var(--color-border);
            border-radius: var(--radius-pill);
            margin-bottom: var(--space-8);
            width: fit-content;
        }
        @media (max-width: 60rem) {
            .scoreboard-layout { grid-template-columns: 1fr; }
            .scoreboard-top-three { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">

        <nav class="navbar">
            <a href="Default.aspx" class="navbar-brand">
                <img src="white.png" alt="HackEd" class="navbar-logo" />
            </a>
            <ul class="navbar-menu">
                <li><a href="Member/Dashboard.aspx" class="navbar-link">Dashboard</a></li>
                <li><a href="Training/Index.aspx" class="navbar-link">Training</a></li>
                <li><a href="Challenges/Index.aspx" class="navbar-link">Challenges</a></li>
                <li><a href="Scoreboard.aspx" class="navbar-link active">Scoreboard</a></li>
                <li><a href="Blog/Index.aspx" class="navbar-link">Blog</a></li>
                <li><a href="FAQ.aspx" class="navbar-link">FAQ</a></li>
            </ul>
            <div class="navbar-user">
                <asp:Panel ID="pnlNavAuth" runat="server" style="display:flex; gap:var(--space-3); align-items:center;">
                    <asp:HyperLink ID="lnkNavDashboard" runat="server" CssClass="navbar-link"></asp:HyperLink>
                    <span class="role-pill">USER</span>
                    <asp:LinkButton ID="lnkLogout" runat="server" CssClass="btn btn-ghost btn-small" OnClick="lnkLogout_Click" Visible="false">Logout</asp:LinkButton>
                </asp:Panel>
                <asp:HyperLink ID="lnkGetStarted" runat="server" CssClass="btn btn-primary" NavigateUrl="~/Register.aspx">Get Started</asp:HyperLink>
            </div>
        </nav>

        <main class="container section">

            <div class="page-header">
                <h1 class="page-title">Scoreboard</h1>
                <p class="page-subtitle">Individual and team rankings across the platform.</p>
            </div>

            <div class="tab-toggle">
                <asp:LinkButton ID="btnTabPlayers" runat="server" CssClass="filter-pill active" OnClick="btnTabPlayers_Click">Individual Scoreboard</asp:LinkButton>
                <asp:LinkButton ID="btnTabTeams" runat="server" CssClass="filter-pill" OnClick="btnTabTeams_Click">Team Scoreboard</asp:LinkButton>
            </div>

            <%-- PLAYERS VIEW --%>
            <asp:Panel ID="pnlPlayers" runat="server">
                <div class="scoreboard-top-three">
                    <asp:Repeater ID="rptTopPlayers" runat="server">
                        <ItemTemplate>
                            <div class="top-player-card">
                                <p class="rank-name">#<%# Eval("RowNum") %> <%# Eval("Username") %></p>
                                <p class="rank-meta">Solves <%# Eval("SolvedCount") %> &bull; Score <%# string.Format("{0:N0}", Eval("TotalScore")) %></p>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>

                <div class="scoreboard-search">
                    <label>Search/filter</label>
                    <asp:TextBox ID="txtSearchPlayers" runat="server" CssClass="form-control"
                        placeholder="Find user or team" style="max-width:20rem;"
                        AutoPostBack="true" OnTextChanged="txtSearchPlayers_TextChanged"></asp:TextBox>
                </div>

                <div class="scoreboard-layout">
                    <div>
                        <div class="table-wrapper">
                            <table class="scoreboard-table">
                                <thead>
                                    <tr>
                                        <th style="width:4rem;">Rank</th>
                                        <th>User/Team</th>
                                        <th>Solves</th>
                                        <th>Score</th>
                                        <th>Last Solve</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <asp:Repeater ID="rptPlayers" runat="server">
                                        <ItemTemplate>
                                            <tr class='<%# Convert.ToInt32(Eval("RowNum")) <= 3 ? "scoreboard-top" : "" %>'>
                                                <td class="rank-cell"><%# Eval("RowNum") %></td>
                                                <td><strong><%# Eval("Username") %></strong></td>
                                                <td><%# Eval("SolvedCount") %></td>
                                                <td class="text-mint" style="font-weight:700;"><%# string.Format("{0:N0}", Eval("TotalScore")) %></td>
                                                <td style="color:var(--color-text-muted);"><%# Eval("LastSolve") ?? "—" %></td>
                                            </tr>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </tbody>
                            </table>
                        </div>
                        <asp:Panel ID="pnlNoPlayers" runat="server" Visible="false"
                            style="text-align:center; padding:var(--space-10) 0; color:var(--color-text-muted);">
                            No players yet.
                        </asp:Panel>
                    </div>

                    <div class="chart-placeholder">
                        <p class="chart-placeholder-title">Score progression chart<br />placeholder</p>
                        <div class="chart-bars">
                            <div class="chart-bar" style="height:35%;"></div>
                            <div class="chart-bar" style="height:52%;"></div>
                            <div class="chart-bar" style="height:68%;"></div>
                            <div class="chart-bar" style="height:80%;"></div>
                            <div class="chart-bar" style="height:95%;"></div>
                            <div class="chart-bar" style="height:100%;"></div>
                            <div class="chart-bar" style="height:88%;"></div>
                            <div class="chart-bar" style="height:72%;"></div>
                            <div class="chart-bar" style="height:60%;"></div>
                            <div class="chart-bar" style="height:45%;"></div>
                        </div>
                    </div>
                </div>
            </asp:Panel>

            <%-- TEAMS VIEW --%>
            <asp:Panel ID="pnlTeams" runat="server" Visible="false">
                <div class="scoreboard-top-three">
                    <asp:Repeater ID="rptTopTeams" runat="server">
                        <ItemTemplate>
                            <div class="top-player-card">
                                <p class="rank-name">#<%# Eval("RowNum") %> <%# Eval("TeamName") %></p>
                                <p class="rank-meta">Members <%# Eval("MemberCount") %> &bull; Score <%# string.Format("{0:N0}", Eval("TeamScore")) %></p>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>

                <div class="scoreboard-search">
                    <label>Search/filter</label>
                    <asp:TextBox ID="txtSearchTeams" runat="server" CssClass="form-control"
                        placeholder="Find user or team" style="max-width:20rem;"
                        AutoPostBack="true" OnTextChanged="txtSearchTeams_TextChanged"></asp:TextBox>
                </div>

                <div class="scoreboard-layout">
                    <div>
                        <div class="table-wrapper">
                            <table class="scoreboard-table">
                                <thead>
                                    <tr>
                                        <th style="width:4rem;">Rank</th>
                                        <th>Team</th>
                                        <th>Members</th>
                                        <th>Score</th>
                                        <th>Leader</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <asp:Repeater ID="rptTeams" runat="server">
                                        <ItemTemplate>
                                            <tr class='<%# Convert.ToInt32(Eval("RowNum")) <= 3 ? "scoreboard-top" : "" %>'>
                                                <td class="rank-cell"><%# Eval("RowNum") %></td>
                                                <td><strong><%# Eval("TeamName") %></strong></td>
                                                <td><%# Eval("MemberCount") %></td>
                                                <td class="text-mint" style="font-weight:700;"><%# string.Format("{0:N0}", Eval("TeamScore")) %></td>
                                                <td style="color:var(--color-text-muted);"><%# Eval("LeaderName") %></td>
                                            </tr>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </tbody>
                            </table>
                        </div>
                        <asp:Panel ID="pnlNoTeams" runat="server" Visible="false"
                            style="text-align:center; padding:var(--space-10) 0; color:var(--color-text-muted);">
                            No teams yet.
                        </asp:Panel>
                    </div>

                    <div class="chart-placeholder">
                        <p class="chart-placeholder-title">Score progression chart<br />placeholder</p>
                        <div class="chart-bars">
                            <div class="chart-bar" style="height:35%;"></div>
                            <div class="chart-bar" style="height:52%;"></div>
                            <div class="chart-bar" style="height:68%;"></div>
                            <div class="chart-bar" style="height:80%;"></div>
                            <div class="chart-bar" style="height:95%;"></div>
                            <div class="chart-bar" style="height:100%;"></div>
                            <div class="chart-bar" style="height:88%;"></div>
                            <div class="chart-bar" style="height:72%;"></div>
                            <div class="chart-bar" style="height:60%;"></div>
                            <div class="chart-bar" style="height:45%;"></div>
                        </div>
                    </div>
                </div>
            </asp:Panel>

        </main>

        <footer class="footer">
            <div style="display:flex; justify-content:space-between; align-items:flex-start; flex-wrap:wrap; gap:1rem;">
                <div>
                    <p class="footer-brand">HackEd</p>
                    <p style="color:var(--color-text-muted); font-size:0.875rem; margin-top:0.25rem;">Structured cybersecurity learning with integrated CTF simulation.</p>
                </div>
                <nav class="footer-links">
                    <a href="Training/Index.aspx">Training</a>
                    <a href="Challenges/Index.aspx">Challenges</a>
                    <a href="Blog/Index.aspx">Blog</a>
                    <a href="FAQ.aspx">FAQ</a>
                    <a href="About.aspx">About</a>
                </nav>
            </div>
        </footer>

    </form>
</body>
</html>