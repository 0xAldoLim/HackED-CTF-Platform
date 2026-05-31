<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PostEdit.aspx.cs" Inherits="Admin_PostEdit" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Edit Content – HackEd</title>
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
                <h1 class="page-title"><asp:Label ID="lblHeading" runat="server"></asp:Label></h1>
            </div>

            <div class="card" style="max-width:760px;">

                <%-- Title (shared) --%>
                <div class="form-group">
                    <label class="form-label">Title</label>
                    <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" placeholder="Title" />
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtTitle"
                        ErrorMessage="Title is required." CssClass="text-mint" Display="Dynamic" />
                </div>

                <%-- ===== POST-ONLY fields ===== --%>
                <asp:Panel ID="pnlPostFields" runat="server">
                    <div class="form-group">
                        <label class="form-label">Type</label>
                        <asp:DropDownList ID="ddlPostType" runat="server" CssClass="form-control">
                            <asp:ListItem Text="Blog" Value="Blog" />
                            <asp:ListItem Text="News" Value="News" />
                        </asp:DropDownList>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Category</label>
                        <asp:TextBox ID="txtCategory" runat="server" CssClass="form-control" placeholder="Security / CTF / Platform" />
                    </div>
                    <div class="form-group">
                        <label class="form-check">
                            <asp:CheckBox ID="chkFeatured" runat="server" /> Feature this post on the blog page
                        </label>
                    </div>
                </asp:Panel>

                <%-- ===== ANNOUNCEMENT-ONLY fields ===== --%>
                <asp:Panel ID="pnlAnnouncementFields" runat="server" Visible="false">
                    <div class="form-group">
                        <label class="form-label">Priority</label>
                        <asp:DropDownList ID="ddlPriority" runat="server" CssClass="form-control">
                            <asp:ListItem Text="Important" Value="Important" />
                            <asp:ListItem Text="Event" Value="Event" />
                            <asp:ListItem Text="Maintenance" Value="Maintenance" />
                            <asp:ListItem Text="Info" Value="Info" />
                        </asp:DropDownList>
                    </div>
                    <div class="form-group">
                        <label class="form-check">
                            <asp:CheckBox ID="chkPinned" runat="server" /> Pin this announcement
                        </label>
                    </div>
                </asp:Panel>

                <%-- Content (shared) --%>
                <div class="form-group">
                    <label class="form-label">Content</label>
                    <asp:TextBox ID="txtContent" runat="server" CssClass="form-control" TextMode="MultiLine"
                        Rows="10" placeholder="Write the content here..." />
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtContent"
                        ErrorMessage="Content is required." CssClass="text-mint" Display="Dynamic" />
                </div>

                <%-- Status (shared) --%>
                <div class="form-group">
                    <label class="form-label">Status</label>
                    <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control">
                        <asp:ListItem Text="Draft" Value="Draft" />
                        <asp:ListItem Text="Published" Value="Published" />
                        <asp:ListItem Text="Archived" Value="Archived" />
                    </asp:DropDownList>
                </div>

                <div style="display:flex; gap:var(--space-3); margin-top:var(--space-6);">
                    <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="btn btn-primary" OnClick="btnSave_Click" />
                    <asp:HyperLink ID="lnkCancel" runat="server" NavigateUrl="Posts.aspx" CssClass="btn btn-ghost">Cancel</asp:HyperLink>
                </div>

            </div>

        </main>

        <footer class="footer">
            <div style="display:flex; justify-content:space-between; align-items:flex-start; flex-wrap:wrap; gap:1rem;">
                <div>
                    <p class="footer-brand">HackEd</p>
                    <p style="color:var(--color-text-muted); font-size:0.875rem; margin-top:0.25rem;">Structured cybersecurity learning with integrated CTF simulation.</p>
                </div>
            </div>
        </footer>

    </form>
</body>
</html>
