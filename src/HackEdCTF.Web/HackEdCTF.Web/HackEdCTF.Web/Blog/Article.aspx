<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Article.aspx.cs" Inherits="Blog_Article" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Article – HackEd</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous" />
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;700;800&family=Inter:wght@400;700&family=JetBrains+Mono:wght@400;700&display=swap" rel="stylesheet" />
    <link href="~/css/site.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">

        <nav class="navbar">
            <a href="~/Default.aspx" runat="server" class="navbar-brand">
                <img src="../white.png" alt="HackEd" class="navbar-logo" />
            </a>
            <ul class="navbar-menu">
                <li><a href="~/Default.aspx" runat="server" class="navbar-link">Home</a></li>
                <li><a href="~/Training/Index.aspx" runat="server" class="navbar-link">Training</a></li>
                <li><a href="~/Challenges/Index.aspx" runat="server" class="navbar-link">Challenges</a></li>
                <li><a href="~/Scoreboard.aspx" runat="server" class="navbar-link">Scoreboard</a></li>
                <li><a href="~/Blog/Index.aspx" runat="server" class="navbar-link active">Blog</a></li>
                <li><a href="~/FAQ.aspx" runat="server" class="navbar-link">FAQ</a></li>
                <li><a href="~/About.aspx" runat="server" class="navbar-link">About</a></li>
            </ul>
        </nav>

        <main class="container section">

            <asp:Panel ID="pnlArticle" runat="server">
                <div class="page-header">
                    <h1 class="page-title"><asp:Label ID="lblTitle" runat="server"></asp:Label></h1>
                    <p class="text-mint" style="font-size:0.9rem;">
                        By <asp:Label ID="lblAuthor" runat="server"></asp:Label>
                        &bull; <asp:Label ID="lblDate" runat="server"></asp:Label>
                        &bull; <asp:Label ID="lblCategory" runat="server"></asp:Label>
                    </p>
                </div>

                <div class="card" style="max-width:760px;">
                    <h2 class="card-title">Article content</h2>
                    <p class="card-text" style="white-space:pre-line;">
                        <asp:Label ID="lblContent" runat="server"></asp:Label>
                    </p>
                    <div style="margin-top:var(--space-6);">
                        <a href="Index.aspx" class="btn btn-secondary btn-small">Back to Blog</a>
                    </div>
                </div>
            </asp:Panel>

            <asp:Panel ID="pnlNotFound" runat="server" Visible="false"
                style="text-align:center; padding:var(--space-10) 0; color:var(--color-text-muted);">
                <h2 class="card-title">Article not found</h2>
                <p>This article may have been removed or is not published.</p>
                <a href="Index.aspx" class="btn btn-secondary btn-small" style="margin-top:var(--space-4);">Back to Blog</a>
            </asp:Panel>

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
                    <a href="~/FAQ.aspx" runat="server">FAQ</a>
                    <a href="~/About.aspx" runat="server">About</a>
                </nav>
            </div>
        </footer>

    </form>
</body>
</html>
