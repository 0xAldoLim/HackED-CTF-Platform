<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Posts.aspx.cs" Inherits="Admin_Posts" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Manage Posts – HackEd</title>
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
                <li><a href="~/Admin/Dashboard.aspx" runat="server" class="navbar-link">Admin</a></li>
                <li><a href="~/Training/ModuleListing.aspx" runat="server" class="navbar-link">Training</a></li>
                <li><a href="~/Challenges/Index.aspx" runat="server" class="navbar-link">Challenges</a></li>
                <li><a href="~/Admin/Posts.aspx" runat="server" class="navbar-link active">Posts</a></li>
                <li><a href="~/Admin/Users.aspx" runat="server" class="navbar-link">Users</a></li>
            </ul>
            <div class="navbar-user">
                <asp:Label ID="lblNavUsername" runat="server" CssClass="navbar-link" style="pointer-events:none;"></asp:Label>
                <span class="role-pill role-pill-admin">ADMIN</span>
                <asp:LinkButton ID="lnkLogout" runat="server" CssClass="btn btn-ghost btn-small" OnClick="lnkLogout_Click">Logout</asp:LinkButton>
            </div>
        </nav>

        <main class="container section">

            <div class="page-header">
                <h1 class="page-title">Manage Blog / News / Announcements</h1>
                <p style="color:var(--color-text-muted);">Create, edit, and delete platform content.</p>
            </div>

            <asp:Panel ID="pnlAlert" runat="server" Visible="false" style="margin-bottom:1.5rem;">
                <asp:Label ID="lblAlert" runat="server"></asp:Label>
            </asp:Panel>

            <%-- ============ BLOG / NEWS POSTS ============ --%>
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:var(--space-4);">
                <h2 class="card-title">Blog &amp; News</h2>
                <a href="PostEdit.aspx?kind=post" class="btn btn-primary btn-small">Add New Post</a>
            </div>

            <div class="table-wrapper" style="margin-bottom:var(--space-10);">
                <table class="crud-table">
                    <thead>
                        <tr>
                            <th>Title</th><th>Type</th><th>Author</th><th>Date</th><th>Status</th><th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="rptPosts" runat="server" OnItemCommand="rptPosts_ItemCommand">
                            <ItemTemplate>
                                <tr>
                                    <td><strong><%# Eval("Title") %></strong></td>
                                    <td><%# Eval("PostType") %></td>
                                    <td style="color:var(--color-text-muted);"><%# Eval("AuthorName") %></td>
                                    <td style="color:var(--color-text-muted);"><%# Convert.ToDateTime(Eval("CreatedAt")).ToString("MMM dd") %></td>
                                    <td><span class="badge badge-info"><%# Eval("Status") %></span></td>
                                    <td>
                                        <div style="display:flex; gap:var(--space-2);">
                                            <a href='<%# "PostEdit.aspx?kind=post&id=" + Eval("PostID") %>' class="btn btn-secondary btn-small">Edit</a>
                                            <asp:LinkButton runat="server" CommandName="DeletePost" CommandArgument='<%# Eval("PostID") %>'
                                                CssClass="btn btn-ghost btn-small" style="color:var(--color-red, #ff4d4d);"
                                                OnClientClick="return confirm('Delete this post?');">Delete</asp:LinkButton>
                                        </div>
                                    </td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>

            <%-- ============ ANNOUNCEMENTS ============ --%>
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:var(--space-4);">
                <h2 class="card-title">Announcements</h2>
                <a href="PostEdit.aspx?kind=announcement" class="btn btn-primary btn-small">Add Announcement</a>
            </div>

            <div class="table-wrapper">
                <table class="crud-table">
                    <thead>
                        <tr>
                            <th>Title</th><th>Priority</th><th>Author</th><th>Date</th><th>Status</th><th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="rptAnnouncements" runat="server" OnItemCommand="rptAnnouncements_ItemCommand">
                            <ItemTemplate>
                                <tr>
                                    <td><strong><%# Eval("Title") %></strong></td>
                                    <td><%# Eval("Priority") %><%# (bool)Eval("IsPinned") ? " (Pinned)" : "" %></td>
                                    <td style="color:var(--color-text-muted);"><%# Eval("AuthorName") %></td>
                                    <td style="color:var(--color-text-muted);"><%# Convert.ToDateTime(Eval("CreatedAt")).ToString("MMM dd") %></td>
                                    <td><span class="badge badge-info"><%# Eval("Status") %></span></td>
                                    <td>
                                        <div style="display:flex; gap:var(--space-2);">
                                            <a href='<%# "PostEdit.aspx?kind=announcement&id=" + Eval("AnnouncementID") %>' class="btn btn-secondary btn-small">Edit</a>
                                            <asp:LinkButton runat="server" CommandName="DeleteAnnouncement" CommandArgument='<%# Eval("AnnouncementID") %>'
                                                CssClass="btn btn-ghost btn-small" style="color:var(--color-red, #ff4d4d);"
                                                OnClientClick="return confirm('Delete this announcement?');">Delete</asp:LinkButton>
                                        </div>
                                    </td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
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
                    <a href="~/FAQ.aspx" runat="server">FAQ</a>
                    <a href="~/About.aspx" runat="server">About</a>
                </nav>
            </div>
        </footer>

    </form>
</body>
</html>
