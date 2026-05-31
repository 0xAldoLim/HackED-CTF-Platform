<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Announcements.aspx.cs" Inherits="Announcements" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Announcements – HackEd</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous" />
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;700;800&family=Inter:wght@400;700&family=JetBrains+Mono:wght@400;700&display=swap" rel="stylesheet" />
    <link href="~/css/site.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">

        <nav class="navbar">
            <a href="~/Default.aspx" runat="server" class="navbar-brand">
                <img src="white.png" alt="HackEd" class="navbar-logo" />
            </a>
            <ul class="navbar-menu">
                <li><a href="~/Default.aspx" runat="server" class="navbar-link">Home</a></li>
                <li><a href="~/Training/ModuleListing.aspx" runat="server" class="navbar-link">Training</a></li>
                <li><a href="~/Challenges/Index.aspx" runat="server" class="navbar-link">Challenges</a></li>
                <li><a href="~/Scoreboard.aspx" runat="server" class="navbar-link">Scoreboard</a></li>
                <li><a href="~/Blog/Index.aspx" runat="server" class="navbar-link">Blog</a></li>
                <li><a href="~/FAQ.aspx" runat="server" class="navbar-link">FAQ</a></li>
                <li><a href="~/About.aspx" runat="server" class="navbar-link">About</a></li>
            </ul>
        </nav>

        <main class="container section">

            <div class="page-header">
                <h1 class="page-title">Announcements</h1>
                <p style="color:var(--color-text-muted);">Platform updates, events, and maintenance notices.</p>
            </div>

            <%-- Priority filter --%>
            <div style="display:flex; gap:var(--space-3); margin-bottom:var(--space-6); align-items:center; flex-wrap:wrap;">
                <asp:DropDownList ID="ddlPriority" runat="server" CssClass="form-control" style="max-width:200px;"
                    AutoPostBack="true" OnSelectedIndexChanged="ddlPriority_Changed">
                    <asp:ListItem Text="All" Value="" />
                    <asp:ListItem Text="Important" Value="Important" />
                    <asp:ListItem Text="Event" Value="Event" />
                    <asp:ListItem Text="Maintenance" Value="Maintenance" />
                    <asp:ListItem Text="Info" Value="Info" />
                </asp:DropDownList>
            </div>

            <%-- Pinned announcement --%>
            <asp:Panel ID="pnlPinned" runat="server" Visible="false" style="margin-bottom:var(--space-6);">
                <div class="announcement-card" style="border-color:var(--color-mint);">
                    <span class="badge badge-pinned">Pinned</span>
                    <h2 class="card-title" style="margin-top:var(--space-2);">
                        <asp:Label ID="lblPinnedTitle" runat="server"></asp:Label>
                    </h2>
                    <p class="card-text"><asp:Label ID="lblPinnedContent" runat="server"></asp:Label></p>
                </div>
            </asp:Panel>

            <%-- Announcement list --%>
            <div class="stack">
                <asp:Repeater ID="rptAnnouncements" runat="server">
                    <ItemTemplate>
                        <div class="announcement-card" style="display:flex; justify-content:space-between; align-items:flex-start; gap:1rem;">
                            <div>
                                <h3 class="card-title"><%# Eval("Title") %></h3>
                                <p style="color:var(--color-text-muted); font-size:0.85rem;">
                                    <%# Convert.ToDateTime(Eval("CreatedAt")).ToString("MMM dd, yyyy") %>
                                    &bull; <%# GetPreview(Eval("Content")) %>
                                </p>
                            </div>
                            <span class="badge badge-info"><%# Eval("Priority") %></span>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>

            <asp:Panel ID="pnlEmpty" runat="server" Visible="false"
                style="text-align:center; padding:var(--space-10) 0; color:var(--color-text-muted);">
                No announcements found.
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
                    <a href="~/FAQ.aspx" runat="server">FAQ</a>
                    <a href="~/About.aspx" runat="server">About</a>
                </nav>
            </div>
        </footer>

    </form>
</body>
</html>
