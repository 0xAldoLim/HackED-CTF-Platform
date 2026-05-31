<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Index.aspx.cs" Inherits="Blog_Index" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Blog &amp; News – HackEd</title>
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

            <div class="page-header">
                <h1 class="page-title">Blog &amp; News</h1>
                <p style="color:var(--color-text-muted);">News, updates, and writeups from the HackEd team.</p>
            </div>

            <%-- Search + category filter --%>
            <div style="display:flex; gap:var(--space-3); margin-bottom:var(--space-6); align-items:center; flex-wrap:wrap;">
                <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control"
                    placeholder="Search blog/news..." style="max-width:320px;" />
                <asp:DropDownList ID="ddlType" runat="server" CssClass="form-control" style="max-width:180px;">
                    <asp:ListItem Text="All" Value="" />
                    <asp:ListItem Text="Blog" Value="Blog" />
                    <asp:ListItem Text="News" Value="News" />
                </asp:DropDownList>
                <asp:Button ID="btnSearch" runat="server" Text="Search"
                    CssClass="btn btn-secondary" OnClick="btnSearch_Click" />
                <asp:Button ID="btnReset" runat="server" Text="Reset"
                    CssClass="btn btn-ghost btn-small" OnClick="btnReset_Click" />
            </div>

            <%-- Featured post --%>
            <asp:Panel ID="pnlFeatured" runat="server" Visible="false" style="margin-bottom:var(--space-6);">
                <div class="featured-article">
                    <span class="badge badge-info">Featured</span>
                    <h2 class="card-title" style="margin-top:var(--space-2);">
                        <asp:Label ID="lblFeaturedTitle" runat="server"></asp:Label>
                    </h2>
                    <p class="card-text"><asp:Label ID="lblFeaturedExcerpt" runat="server"></asp:Label></p>
                    <asp:HyperLink ID="lnkFeatured" runat="server" CssClass="btn btn-primary btn-small">Read More</asp:HyperLink>
                </div>
            </asp:Panel>

            <%-- Article grid --%>
            <div class="content-grid">
                <asp:Repeater ID="rptPosts" runat="server">
                    <ItemTemplate>
                        <article class="article-card">
                            <span class="badge badge-info"><%# Eval("Category") %></span>
                            <h3 class="card-title"><%# Eval("Title") %></h3>
                            <p class="card-text"><%# GetExcerpt(Eval("Content")) %></p>
                            <p style="color:var(--color-text-muted); font-size:0.8rem;">
                                <%# Eval("AuthorName") %> &bull; <%# Convert.ToDateTime(Eval("CreatedAt")).ToString("MMM dd, yyyy") %>
                            </p>
                            <a href='<%# "Article.aspx?id=" + Eval("PostID") %>' class="text-mint">Read More</a>
                        </article>
                    </ItemTemplate>
                </asp:Repeater>
            </div>

            <asp:Panel ID="pnlEmpty" runat="server" Visible="false"
                style="text-align:center; padding:var(--space-10) 0; color:var(--color-text-muted);">
                No articles found.
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
