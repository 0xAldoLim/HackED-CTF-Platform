<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ModuleDetail.aspx.cs" Inherits="HackEdCTF.Web.Training.ModuleDetail" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Module - HackEd</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous" />
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;700;800&family=Inter:wght@400;700&family=JetBrains+Mono:wght@400;700&display=swap" rel="stylesheet" />
    <link href="~/css/site.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <%-- ===== NAVBAR (authenticated) ===== --%>
        <nav class="navbar">
            <a href="../Default.aspx" runat="server" class="navbar-brand">
                <img src="../white.png" alt="HackEd" class="navbar-logo" />
            </a>
            <ul class="navbar-menu">
                <li><a href="~/Member/Dashboard.aspx" runat="server" class="navbar-link">Dashboard</a></li>
                <li><a href="~/Training/ModuleListing.aspx" runat="server" class="navbar-link active">Training</a></li>
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

            <%-- Back link --%>
            <a href="~/Training/ModuleListing.aspx" runat="server" class="btn btn-ghost btn-small" style="margin-bottom:var(--space-5);">
                ← Back to modules
            </a>

            <%-- Page header --%>
            <div class="page-header">
                <div class="cluster" style="margin-top:var(--space-3);">
                    <asp:Label ID="lblLevel" runat="server" CssClass="badge" />
                    <asp:Label ID="lblCategory" runat="server" CssClass="badge" />
                </div>
                <h1 class="page-title">
                    <asp:Literal ID="litTitle" runat="server" />
                </h1>
            </div>

            <%-- Lesson content --%>
            <div class="card">
                <h3 class="card-title" style="margin-bottom:var(--space-4);">Lesson content</h3>

                <div class="article-content" style="margin-bottom:var(--space-6);">
                    <asp:Literal ID="litContent" runat="server" />
                </div>

                <%-- Prev / Next buttons --%>
                <div class="form-actions" style="margin-top:var(--space-6);">
                    <asp:Button ID="btnPrev" runat="server" Text="Previous Lesson"
                        CssClass="btn btn-secondary" OnClick="btnPrev_Click" />
                    <asp:Button ID="btnNext" runat="server" Text="Next Lesson"
                        CssClass="btn btn-primary" OnClick="btnNext_Click" />
                </div>
            </div>

            <%-- Not found state --%>
            <asp:Panel ID="pnlNotFound" runat="server" Visible="false" CssClass="access-denied-panel">
                <p class="error-code">404</p>
                <h2>Module not found</h2>
                <p>The module you're looking for doesn't exist or has been removed.</p>
                <a href="~/Training/ModuleListing.aspx" runat="server" class="btn btn-primary">Back to modules</a>
            </asp:Panel>

        </main>

        <%-- ===== FOOTER ===== --%>
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
