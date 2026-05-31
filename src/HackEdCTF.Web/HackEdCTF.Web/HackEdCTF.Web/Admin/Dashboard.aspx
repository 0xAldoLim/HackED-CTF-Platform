<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Dashboard.aspx.cs" Inherits="Admin_Dashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Admin Dashboard – HackEd</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous" />
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;700;800&family=Inter:wght@400;700&family=JetBrains+Mono:wght@400;700&display=swap" rel="stylesheet" />
    <link href="~/css/site.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">

        <%--NAVBAR--%>
        <nav class="navbar">
            <a href="../Default.aspx" runat="server" class="navbar-brand">
                <img src="../white.png" alt="HackEd" class="navbar-logo" />
            </a>
            <ul class="navbar-menu">
                <li><a href="~/Admin/Dashboard.aspx" runat="server" class="navbar-link active">Admin</a></li>
                <li><a href="~/Training/Index.aspx" runat="server" class="navbar-link">Training</a></li>
                <li><a href="~/Challenges/Index.aspx" runat="server" class="navbar-link">Challenges</a></li>
                <li><a href="~/Admin/Posts.aspx" runat="server" class="navbar-link">Posts</a></li>
                <li><a href="~/Admin/Users.aspx" runat="server" class="navbar-link">Users</a></li>
            </ul>
            <div class="navbar-user">
                <asp:Label ID="lblNavUsername" runat="server" CssClass="navbar-link" style="pointer-events:none;"></asp:Label>
                <span class="role-pill role-pill-admin">ADMIN</span>
                <asp:LinkButton ID="lnkLogout" runat="server" CssClass="btn btn-ghost btn-small" OnClick="lnkLogout_Click">Logout</asp:LinkButton>
            </div>
        </nav>

        <%--MAIN CONTENT--%>
        <main class="container section">

            <div class="page-header">
                <h1 class="page-title">Role-Based Admin Dashboard</h1>
                <p>
                    <span class="badge badge-admin" style="margin-right:0.75rem;">ADMIN ONLY</span>
                    Manage content, challenges, users, and announcements.
                </p>
            </div>

            <div class="dashboard-grid" style="margin-bottom:var(--space-8);">
                <div class="stat-card">
                    <span class="stat-value"><asp:Label ID="lblUserCount" runat="server">0</asp:Label></span>
                    <span class="stat-label">Users</span>
                </div>
                <div class="stat-card">
                    <span class="stat-value"><asp:Label ID="lblModuleCount" runat="server">0</asp:Label></span>
                    <span class="stat-label">Training Modules</span>
                </div>
                <div class="stat-card">
                    <span class="stat-value"><asp:Label ID="lblChallengeCount" runat="server">0</asp:Label></span>
                    <span class="stat-label">Challenges</span>
                </div>
                <div class="stat-card">
                    <span class="stat-value"><asp:Label ID="lblPostCount" runat="server">0</asp:Label></span>
                    <span class="stat-label">Forum Posts</span>
                </div>
            </div>

            <%--MANAGE CARDS--%>
            <div class="dashboard-grid" style="margin-bottom:var(--space-8);">
                <div class="feature-card">
                    <h2 class="card-title">Manage Training Content</h2>
                    <p class="card-text">Add, edit, or remove training modules and lessons.</p>
                </div>
                <div class="feature-card">
                    <h2 class="card-title">Manage Challenges</h2>
                    <p class="card-text">Create new CTF challenges or update existing ones.</p>
                </div>
                <div class="feature-card">
                    <h2 class="card-title">Manage Blog/News</h2>
                    <p class="card-text">Publish posts, edit drafts, or take down outdated articles.</p>
                </div>
                <div class="feature-card">
                    <h2 class="card-title">Manage Announcements</h2>
                    <p class="card-text">Post site-wide announcements visible to all users.</p>
                </div>
                    <a href="~/Admin/Users.aspx" runat="server" class="feature-card" style="text-decoration:none; display:block;">
                        <h2 class="card-title">Manage Users</h2>
                        <p class="card-text">View accounts, change roles, or suspend users.</p>
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
                    <a href="~/Training/Index.aspx" runat="server">Training</a>
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