<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="Member_Dashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Dashboard – HackEd</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous" />
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;700;800&family=Inter:wght@400;700&family=JetBrains+Mono:wght@400;700&display=swap" rel="stylesheet" />
    <link href="~/css/site.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">

        <nav class="navbar">
            <a href="../Default.aspx" runat="server" class="navbar-brand">
                <img src="../white.png" alt="HackEd" class="navbar-logo" />
            </a>
            <ul class="navbar-menu">
                <li><a href="~/Member/Dashboard.aspx" runat="server" class="navbar-link active">Dashboard</a></li>
                <li><a href="~/Training/ModuleListing.aspx" runat="server" class="navbar-link">Training</a></li>
                <li><a href="~/Challenges/Index.aspx" runat="server" class="navbar-link">Challenges</a></li>
                <li><a href="~/Scoreboard.aspx" runat="server" class="navbar-link">Scoreboard</a></li>
                <li><a href="~/Blog/Index.aspx" runat="server" class="navbar-link">Blog</a></li>
                <li><a href="~/FAQ.aspx" runat="server" class="navbar-link">FAQ</a></li>
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

            <div class="page-header">
                <h1 class="page-title">User Dashboard</h1>
                <p class="page-subtitle">
                    Welcome back, <asp:Label ID="lblWelcome" runat="server" CssClass="text-mint"></asp:Label>.
                    Here's a quick overview of your activity.
                </p>
            </div>

            <div class="dashboard-grid" style="margin-bottom:var(--space-8);">

                <div class="stat-card">
                    <span class="stat-value">
                        <asp:Label ID="lblProgress" runat="server">0%</asp:Label>
                    </span>
                    <span class="stat-label">Progress</span>
                </div>

                <div class="stat-card">
                    <span class="stat-value">
                        <asp:Label ID="lblSolved" runat="server">0</asp:Label>
                    </span>
                    <span class="stat-label">Solved Challenges</span>
                </div>

                <div class="stat-card">
                    <span class="stat-value" style="font-size:1.4rem;">
                        <asp:Label ID="lblCurrentModule" runat="server">—</asp:Label>
                    </span>
                    <span class="stat-label">Current Module</span>
                </div>

                <a href="~/Member/Team.aspx" runat="server" class="stat-card" style="text-decoration:none;">
                    <span class="stat-value" style="font-size:1.4rem;">
                        <asp:Label ID="lblTeamStatus" runat="server">No Team</asp:Label>
                    </span>
                    <span class="stat-label">Team Status</span>
                </a>

            </div>

            <div class="two-column-layout" style="margin-bottom:var(--space-10);">

                <div class="card">
                    <h2 class="card-title" style="margin-bottom:var(--space-4);">Recent announcements</h2>
                    <asp:Repeater ID="rptAnnouncements" runat="server">
                        <ItemTemplate>
                            <div class="announcement-item">
                                <span><%# Eval("Title") %></span>
                                <span class="badge badge-event">Event</span>
                            </div>
                        </ItemTemplate>
                        <FooterTemplate>
                            <asp:Panel ID="pnlNoAnnounce" runat="server" Visible='<%# rptAnnouncements.Items.Count == 0 %>'>
                                <p style="color:var(--color-text-muted); font-size:0.9375rem; padding:var(--space-4) 0;">No announcements yet.</p>
                            </asp:Panel>
                        </FooterTemplate>
                    </asp:Repeater>
                </div>

            </div>

            <%--QUICK LINKS--%>
            <h2 style="margin-bottom:var(--space-5);">Quick links</h2>
            <div class="dashboard-grid">
                <a href="~/Training/ModuleListing.aspx" runat="server" class="quick-link-card" style="text-decoration:none;">
                    <h3 class="card-title">Training</h3>
                    <p class="card-text">Jump straight into the section without spelunking through menus.</p>
                </a>
                <a href="~/Challenges/Index.aspx" runat="server" class="quick-link-card" style="text-decoration:none;">
                    <h3 class="card-title">Challenges</h3>
                    <p class="card-text">Jump straight into the section without spelunking through menus.</p>
                </a>
                <a href="../Scoreboard.aspx" runat="server" class="quick-link-card" style="text-decoration:none;">
                    <h3 class="card-title">Scoreboard</h3>
                    <p class="card-text">Jump straight into the section without spelunking through menus.</p>
                </a>
                <a href="~/Blog/Index.aspx" runat="server" class="quick-link-card" style="text-decoration:none;">
                    <h3 class="card-title">Blog</h3>
                    <p class="card-text">Jump straight into the section without spelunking through menus.</p>
                </a>
                <a href="~/Member/Team.aspx" runat="server" class="quick-link-card" style="text-decoration:none;">
                    <h3 class="card-title">Team</h3>
                    <p class="card-text">Create or join a squad to compete together.</p>
                </a>
            </div>

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
                    <a href="~/FAQ.aspx" runat="server">FAQ</a>
                    <a href="~/About.aspx" runat="server">About</a>
                </nav>
            </div>
        </footer>

    </form>
</body>
</html>

