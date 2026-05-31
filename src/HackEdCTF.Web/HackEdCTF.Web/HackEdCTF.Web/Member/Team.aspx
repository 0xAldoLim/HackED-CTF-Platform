<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Team.aspx.cs" Inherits="Member_Team" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>My Team – HackEd</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous" />
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;700;800&family=Inter:wght@400;700&family=JetBrains+Mono:wght@400;700&display=swap" rel="stylesheet" />
    <link href="~/css/site.css" rel="stylesheet" />
    <style>
        .team-stats-row {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: var(--space-6);
            margin-bottom: var(--space-8);
        }
        .team-body-grid {
            display: grid;
            grid-template-columns: minmax(0, 1fr) minmax(0, 1fr);
            gap: var(--space-6);
            margin-bottom: var(--space-6);
        }
        .team-section-card {
            padding: var(--space-6);
            background: rgba(26, 35, 51, 0.9);
            border: 1px solid var(--color-border);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-panel);
        }
        .team-section-title {
            color: var(--color-text-strong);
            font-family: var(--font-heading);
            font-size: 1.125rem;
            font-weight: 700;
            margin-bottom: var(--space-5);
        }
        .teams-browse-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(18rem, 1fr));
            gap: var(--space-5);
        }
        .teams-browse-card {
            transition: border-color 0.2s ease, box-shadow 0.2s ease;
        }
        .teams-browse-card:hover {
            border-color: var(--color-mint);
            box-shadow: 0 0 0 1px var(--color-mint-border);
        }
        @media (max-width: 56rem) {
            .team-stats-row { grid-template-columns: 1fr; }
            .team-body-grid { grid-template-columns: 1fr; }
            .teams-browse-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">

        <nav class="navbar">
            <a href="~/Default.aspx" runat="server" class="navbar-brand">
                <img src="../white.png" alt="HackEd" class="navbar-logo" />
            </a>
            <ul class="navbar-menu">
                <li><a href="~/Member/Dashboard.aspx" runat="server" class="navbar-link active">Dashboard</a></li>
                <li><a href="~/Training/ModuleListing.aspx" runat="server" class="navbar-link">Training</a></li>
                <li><a href="~/Challenges/Index.aspx" runat="server" class="navbar-link">Challenges</a></li>
                <li><a href="~/Scoreboard.aspx" runat="server" class="navbar-link">Scoreboard</a></li>
                <li><a href="~/Blog/Index.aspx" runat="server" class="navbar-link">Blog</a></li>
            </ul>
            <div class="navbar-user">
                <a href="~/Member/Profile.aspx" runat="server" class="navbar-link">
                    <asp:Label ID="lblNavUsername" runat="server"></asp:Label>
                </a>
                <span class="role-pill">USER</span>
                <asp:LinkButton ID="lnkLogout" runat="server" CssClass="btn btn-ghost btn-small" OnClick="lnkLogout_Click">Logout</asp:LinkButton>
            </div>
        </nav>

        <main class="container section">

            <asp:Panel ID="pnlAlert" runat="server" Visible="false" style="margin-bottom:1.5rem;">
                <asp:Label ID="lblAlert" runat="server"></asp:Label>
            </asp:Panel>

            <%--Create/Join--%>
            <asp:Panel ID="pnlNoTeam" runat="server">
                <div class="page-header">
                    <h1 class="page-title">My Team</h1>
                    <p class="page-subtitle">Create a new team or join an existing one with an invite code.</p>
                </div>
                <div class="two-column-layout">
                    <div class="card">
                        <h2 class="card-title" style="margin-bottom:var(--space-5);">Create a new team</h2>
                        <div class="form-group">
                            <label class="form-label">Team Name</label>
                            <asp:TextBox ID="txtTeamName" runat="server" CssClass="form-control"
                                placeholder="ByteBenders" MaxLength="100"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvTeamName" runat="server"
                                ControlToValidate="txtTeamName" ValidationGroup="Create"
                                ErrorMessage="Team name is required." CssClass="validation-message" Display="Dynamic" />
                        </div>
                        <asp:Button ID="btnCreate" runat="server" Text="Create Team"
                            CssClass="btn btn-primary" ValidationGroup="Create"
                            OnClick="btnCreate_Click" style="margin-top:var(--space-3);" />
                    </div>
                    <div class="card">
                        <h2 class="card-title" style="margin-bottom:var(--space-5);">Join an existing team</h2>
                        <div class="form-group">
                            <label class="form-label">Invite Code</label>
                            <asp:TextBox ID="txtInviteCode" runat="server" CssClass="form-control"
                                placeholder="Enter invite code" MaxLength="20"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvInviteCode" runat="server"
                                ControlToValidate="txtInviteCode" ValidationGroup="Join"
                                ErrorMessage="Invite code is required." CssClass="validation-message" Display="Dynamic" />
                        </div>
                        <asp:Button ID="btnJoin" runat="server" Text="Join Team"
                            CssClass="btn btn-secondary" ValidationGroup="Join"
                            OnClick="btnJoin_Click" style="margin-top:var(--space-3);" />
                    </div>
                </div>

                <%--EXISTING TEAMS LIST--%>
                <div style="margin-top:var(--space-10);">
                    <h2 class="page-title" style="font-size:1.5rem; margin-bottom:var(--space-2);">Existing Teams</h2>
                    <p class="page-subtitle" style="margin-bottom:var(--space-6);">Browse all active teams and view their profiles.</p>

                    <asp:Panel ID="pnlNoTeamsFound" runat="server" Visible="false">
                        <p style="color:var(--color-text-muted);">No teams have been created yet. Be the first!</p>
                    </asp:Panel>

                    <div class="teams-browse-grid">
                        <asp:Repeater ID="rptAllTeams" runat="server" OnItemCommand="rptAllTeams_ItemCommand">
                            <ItemTemplate>
                                <div class="card teams-browse-card">
                                    <h3 class="card-title" style="margin-bottom:var(--space-1);"><%# Eval("TeamName") %></h3>
                                    <p style="color:var(--color-text-muted); font-size:0.875rem; margin-bottom:var(--space-4);">
                                        Team score: <%# string.Format("{0:N0}", Eval("TeamScore")) %> &nbsp;&bull;&nbsp;
                                        Solves: <%# Eval("Solves") %> &nbsp;&bull;&nbsp;
                                        Ranking: #<%# Eval("Ranking") %> &nbsp;&bull;&nbsp;
                                        Members: <%# Eval("MemberCount") %>
                                    </p>
                                    <asp:LinkButton ID="lnkViewTeam" runat="server"
                                        CommandName="ViewTeam"
                                        CommandArgument='<%# Eval("TeamID") %>'
                                        CssClass="btn btn-primary btn-small">View Team Profile</asp:LinkButton>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </div>
            </asp:Panel>

            <%--Team Profile--%>
            <asp:Panel ID="pnlHasTeam" runat="server" Visible="false">

                <asp:Panel ID="pnlBackToTeams" runat="server" Visible="false" style="margin-bottom:var(--space-6);">
                    <asp:LinkButton ID="lnkBackToTeams" runat="server" CssClass="btn btn-ghost btn-small" OnClick="lnkBackToTeams_Click">
                        ← Back to Teams
                    </asp:LinkButton>
                </asp:Panel>

                <div class="page-header">
                    <p style="color:var(--color-text-muted); font-size:0.875rem; margin-bottom:var(--space-1);">Team Profile Page</p>
                    <h1 class="page-title"><asp:Label ID="lblTeamName" runat="server"></asp:Label></h1>
                </div>

                <div class="team-stats-row">
                    <div class="stat-card">
                        <strong class="stat-value"><asp:Label ID="lblTeamScore" runat="server">0</asp:Label></strong>
                        <span class="stat-label">Team Score</span>
                    </div>
                    <div class="stat-card">
                        <strong class="stat-value"><asp:Label ID="lblTeamSolves" runat="server">0</asp:Label></strong>
                        <span class="stat-label">Team Solves</span>
                    </div>
                    <div class="stat-card">
                        <strong class="stat-value">#<asp:Label ID="lblTeamRank" runat="server">—</asp:Label></strong>
                        <span class="stat-label">Ranking</span>
                    </div>
                    <div class="stat-card">
                        <strong class="stat-value"><asp:Label ID="lblMemberCount" runat="server">0</asp:Label></strong>
                        <span class="stat-label">Members</span>
                    </div>
                </div>

                <div class="team-body-grid">
                    <div class="team-section-card">
                        <h2 class="team-section-title">Team members</h2>
                        <div class="table-wrapper">
                            <table class="crud-table">
                                <thead>
                                    <tr>
                                        <th>Member</th>
                                        <th>Role</th>
                                        <th>Score</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <asp:Repeater ID="rptMembers" runat="server">
                                        <ItemTemplate>
                                            <tr>
                                                <td><strong><%# Eval("Username") %></strong></td>
                                                <td style="color:var(--color-text-muted);"><%# (bool)Eval("IsLeader") ? "Captain" : "Member" %></td>
                                                <td class="text-mint"><%# string.Format("{0:N0}", Eval("TotalScore")) %></td>
                                            </tr>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="team-section-card">
                        <h2 class="team-section-title">Recent solves</h2>
                        <div class="table-wrapper">
                            <table class="crud-table">
                                <thead>
                                    <tr>
                                        <th>Challenge</th>
                                        <th>Member</th>
                                        <th>Points</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <asp:Repeater ID="rptRecentSolves" runat="server">
                                        <ItemTemplate>
                                            <tr>
                                                <td><strong><%# Eval("ChallengeName") %></strong></td>
                                                <td style="color:var(--color-text-muted);"><%# Eval("Username") %></td>
                                                <td class="text-mint"><%# Eval("Points") %></td>
                                            </tr>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <div class="team-section-card">
                    <div style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:var(--space-4);">
                        <p class="text-mint" style="font-family:var(--font-code); font-size:0.875rem;">Team actions</p>
                        <div style="display:flex; gap:var(--space-3);">
                            <asp:Button ID="btnManageTeam" runat="server" Text="Manage Team"
                                CssClass="btn btn-primary btn-small" OnClick="btnManageTeam_Click" />
                            <asp:Button ID="btnLeave" runat="server" Text="Leave Team"
                                CssClass="btn btn-secondary btn-small"
                                OnClick="btnLeave_Click"
                                OnClientClick="return confirm('Are you sure you want to leave this team?');" />
                        </div>
                    </div>
                </div>

                <asp:Panel ID="pnlInviteCode" runat="server" Visible="false" style="margin-top:var(--space-6);">
                    <div class="card" style="background:rgba(34,255,181,0.04); border-color:var(--color-mint-border);">
                        <p style="color:var(--color-text-muted); font-size:0.875rem; margin-bottom:var(--space-2);">Invite Code — share with teammates</p>
                        <p class="terminal-label" style="font-size:1.25rem; letter-spacing:0.12em;">
                            <asp:Label ID="lblInviteCode" runat="server"></asp:Label>
                        </p>
                    </div>
                </asp:Panel>

            </asp:Panel>

        </main>

        <footer class="footer">
            <div style="display:flex; justify-content:space-between; align-items:flex-start; flex-wrap:wrap; gap:1rem;">
                <div>
                    <p class="footer-brand">HackEd</p>
                    <p style="color:var(--color-text-muted); font-size:0.875rem; margin-top:0.25rem;">Structured cybersecurity learning with integrated CTF simulation.</p>
                </div>
                <nav class="footer-links">
                    <a href="~/Training/ModuleListing.aspx" runat="server">Training</a>
                    <a href="~/Challenges/Index.aspx" runat="server">Challenges</a>
                    <a href="~/Blog/Index.aspx" runat="server">Blog</a>
                </nav>
            </div>
        </footer>

    </form>
</body>
</html>
