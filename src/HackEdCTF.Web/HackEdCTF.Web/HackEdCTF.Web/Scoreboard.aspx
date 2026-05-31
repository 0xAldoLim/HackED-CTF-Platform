<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Scoreboard.aspx.cs" Inherits="Scoreboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Scoreboard - HackEd</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous" />
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;700;800&family=Inter:wght@400;700&family=JetBrains+Mono:wght@400;700&display=swap" rel="stylesheet" />
    <link href="~/css/site.css" rel="stylesheet" />
    <style>
        .scoreboard-grid {
            display: grid;
            grid-template-columns: minmax(0, 1fr) minmax(22rem, 0.72fr);
            gap: var(--space-8);
            align-items: start;
        }

        .scoreboard-top-three {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: var(--space-5);
            margin-bottom: var(--space-8);
        }

        .top-player-card {
            padding: var(--space-5);
            background: rgba(26, 35, 51, 0.9);
            border: 1px solid var(--color-border);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-panel);
        }

        .top-player-card:first-child {
            border-color: var(--color-mint-border);
            box-shadow: var(--shadow-mint);
        }

        .rank-name {
            color: var(--color-mint);
            font-family: var(--font-heading);
            font-size: 1.125rem;
            font-weight: 800;
            margin-bottom: var(--space-2);
        }

        .rank-meta {
            color: var(--color-text-muted);
            font-size: 0.875rem;
        }

        .score-chart {
            padding: var(--space-6);
            background: rgba(26, 35, 51, 0.9);
            border: 1px solid var(--color-border);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-panel);
        }

        .score-chart-title {
            color: var(--color-text-strong);
            font-family: var(--font-heading);
            font-size: 1.125rem;
            font-weight: 700;
            margin-bottom: var(--space-5);
        }

        .score-bar-row {
            display: grid;
            grid-template-columns: 2rem minmax(0, 1fr) 3rem;
            gap: var(--space-3);
            align-items: center;
            margin-bottom: var(--space-3);
        }

        .score-bar-label {
            color: var(--color-text);
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .score-bar-track {
            height: 0.85rem;
            background: rgba(16, 24, 38, 0.95);
            border: 1px solid var(--color-border);
            border-radius: var(--radius-pill);
            overflow: hidden;
        }

        .score-bar-fill {
            height: 100%;
            min-width: 0.35rem;
            background: linear-gradient(90deg, var(--color-mint), #6fffd1);
            border-radius: var(--radius-pill);
        }

        .score-bar-value {
            color: var(--color-mint);
            font-family: var(--font-code);
            font-size: 0.875rem;
            text-align: right;
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

        @media (max-width: 64rem) {
            .scoreboard-grid,
            .scoreboard-top-three {
                grid-template-columns: 1fr;
            }
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
                <li><a href="Training/ModuleListing.aspx" class="navbar-link">Training</a></li>
                <li><a href="Challenges/Index.aspx" class="navbar-link">Challenges</a></li>
                <li><a href="Scoreboard.aspx" class="navbar-link active">Scoreboard</a></li>
                <li><a href="Blog/Index.aspx" class="navbar-link">Blog</a></li>
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
                <p class="page-subtitle">Top players ranked by solved challenges and score.</p>
            </div>

            <div class="tab-toggle">
                <asp:LinkButton ID="btnTabPlayers" runat="server" CssClass="filter-pill active" OnClick="btnTabPlayers_Click" CausesValidation="false">Users</asp:LinkButton>
                <asp:LinkButton ID="btnTabTeams" runat="server" CssClass="filter-pill" OnClick="btnTabTeams_Click" CausesValidation="false">Teams</asp:LinkButton>
            </div>

            <asp:Panel ID="pnlPlayers" runat="server">
                <div class="scoreboard-top-three">
                    <asp:Repeater ID="rptTopPlayers" runat="server">
                        <ItemTemplate>
                            <div class="top-player-card">
                                <p class="rank-name">#<%# Eval("RowNum") %> <%# Server.HtmlEncode(Eval("DisplayName").ToString()) %></p>
                                <p class="rank-meta"><%# Eval("Solves") %> solves &bull; <%# string.Format("{0:N0}", Eval("Score")) %> pts</p>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>

                <div class="scoreboard-grid">
                    <div>
                        <div class="table-wrapper">
                            <table class="scoreboard-table">
                                <thead>
                                    <tr>
                                        <th style="width:4rem;">Rank</th>
                                        <th>User</th>
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
                                                <td><strong><%# Server.HtmlEncode(Eval("DisplayName").ToString()) %></strong></td>
                                                <td><%# Eval("Solves") %></td>
                                                <td class="text-mint" style="font-weight:700;"><%# string.Format("{0:N0}", Eval("Score")) %></td>
                                                <td style="color:var(--color-text-muted);"><%# FormatDate(Eval("LastSolveDate")) %></td>
                                            </tr>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </tbody>
                            </table>
                        </div>
                        <asp:Panel ID="pnlNoPlayers" runat="server" Visible="false" CssClass="card" style="text-align:center; padding:var(--space-8);">
                            No solved challenges yet.
                        </asp:Panel>
                    </div>

                    <div class="score-chart">
                        <p class="score-chart-title">Top 10 Solves Chart</p>
                        <asp:Repeater ID="rptPlayerChart" runat="server">
                            <ItemTemplate>
                                <div class="score-bar-row">
                                    <span class="score-bar-value">#<%# Eval("RowNum") %></span>
                                    <div>
                                        <div class="score-bar-label"><%# Server.HtmlEncode(Eval("DisplayName").ToString()) %></div>
                                        <div class="score-bar-track">
                                            <div class="score-bar-fill" style='width:<%# Eval("BarWidth") %>%;'></div>
                                        </div>
                                    </div>
                                    <span class="score-bar-value"><%# Eval("Solves") %></span>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                        <asp:Panel ID="pnlNoPlayerChart" runat="server" Visible="false" style="color:var(--color-text-muted);">
                            Chart appears after the first correct solve.
                        </asp:Panel>
                    </div>
                </div>
            </asp:Panel>

            <asp:Panel ID="pnlTeams" runat="server" Visible="false">
                <div class="scoreboard-top-three">
                    <asp:Repeater ID="rptTopTeams" runat="server">
                        <ItemTemplate>
                            <div class="top-player-card">
                                <p class="rank-name">#<%# Eval("RowNum") %> <%# Server.HtmlEncode(Eval("DisplayName").ToString()) %></p>
                                <p class="rank-meta"><%# Eval("Solves") %> solves &bull; <%# string.Format("{0:N0}", Eval("Score")) %> pts &bull; <%# Eval("MemberCount") %> members</p>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>

                <div class="scoreboard-grid">
                    <div>
                        <div class="table-wrapper">
                            <table class="scoreboard-table">
                                <thead>
                                    <tr>
                                        <th style="width:4rem;">Rank</th>
                                        <th>Team</th>
                                        <th>Solves</th>
                                        <th>Score</th>
                                        <th>Members</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <asp:Repeater ID="rptTeams" runat="server">
                                        <ItemTemplate>
                                            <tr class='<%# Convert.ToInt32(Eval("RowNum")) <= 3 ? "scoreboard-top" : "" %>'>
                                                <td class="rank-cell"><%# Eval("RowNum") %></td>
                                                <td><strong><%# Server.HtmlEncode(Eval("DisplayName").ToString()) %></strong></td>
                                                <td><%# Eval("Solves") %></td>
                                                <td class="text-mint" style="font-weight:700;"><%# string.Format("{0:N0}", Eval("Score")) %></td>
                                                <td><%# Eval("MemberCount") %></td>
                                            </tr>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </tbody>
                            </table>
                        </div>
                        <asp:Panel ID="pnlNoTeams" runat="server" Visible="false" CssClass="card" style="text-align:center; padding:var(--space-8);">
                            No team solves yet.
                        </asp:Panel>
                    </div>

                    <div class="score-chart">
                        <p class="score-chart-title">Top 10 Team Solves</p>
                        <asp:Repeater ID="rptTeamChart" runat="server">
                            <ItemTemplate>
                                <div class="score-bar-row">
                                    <span class="score-bar-value">#<%# Eval("RowNum") %></span>
                                    <div>
                                        <div class="score-bar-label"><%# Server.HtmlEncode(Eval("DisplayName").ToString()) %></div>
                                        <div class="score-bar-track">
                                            <div class="score-bar-fill" style='width:<%# Eval("BarWidth") %>%;'></div>
                                        </div>
                                    </div>
                                    <span class="score-bar-value"><%# Eval("Solves") %></span>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                        <asp:Panel ID="pnlNoTeamChart" runat="server" Visible="false" style="color:var(--color-text-muted);">
                            Chart appears after the first team solve.
                        </asp:Panel>
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
                    <a href="Training/ModuleListing.aspx">Training</a>
                    <a href="Challenges/Index.aspx">Challenges</a>
                    <a href="Blog/Index.aspx">Blog</a>
                </nav>
            </div>
        </footer>

    </form>
</body>
</html>
