<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Users.aspx.cs" Inherits="Admin_Users" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Manage Users – HackEd</title>
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
                <li><a href="~/Admin/TrainingCRUD.aspx" runat="server" class="navbar-link">Training</a></li>
                <li><a href="~/Challenges/Index.aspx" runat="server" class="navbar-link">Challenges</a></li>
                <li><a href="~/Admin/Posts.aspx" runat="server" class="navbar-link">Posts</a></li>
                <li><a href="~/Admin/Users.aspx" runat="server" class="navbar-link active">Users</a></li>
            </ul>
            <div class="navbar-user">
                <asp:Label ID="lblNavUsername" runat="server" CssClass="navbar-link" style="pointer-events:none;"></asp:Label>
                <span class="role-pill role-pill-admin">ADMIN</span>
                <asp:LinkButton ID="lnkLogout" runat="server" CssClass="btn btn-ghost btn-small" OnClick="lnkLogout_Click">Logout</asp:LinkButton>
            </div>
        </nav>

        <main class="container section">

            <div class="page-header">
                <h1 class="page-title">Manage Users</h1>
                <p style="color:var(--color-text-muted);">View, edit roles, and manage account status for all users.</p>
            </div>

            <%-- Alert --%>
            <asp:Panel ID="pnlAlert" runat="server" Visible="false" style="margin-bottom:1.5rem;">
                <asp:Label ID="lblAlert" runat="server"></asp:Label>
            </asp:Panel>

            <%-- Search bar --%>
            <div style="display:flex; gap:var(--space-3); margin-bottom:var(--space-6); align-items:center;">
                <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control"
                    placeholder="Search by username or email..."
                    style="max-width:360px;" />
                <asp:Button ID="btnSearch" runat="server" Text="Search"
                    CssClass="btn btn-secondary" OnClick="btnSearch_Click" />
                <asp:Button ID="btnReset" runat="server" Text="Reset"
                    CssClass="btn btn-ghost btn-small" OnClick="btnReset_Click" />
            </div>

            <%-- Users table --%>
            <div class="table-wrapper">
                <table class="crud-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Username</th>
                            <th>Email</th>
                            <th>Role</th>
                            <th>Score</th>
                            <th>Status</th>
                            <th>Joined</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="rptUsers" runat="server" OnItemCommand="rptUsers_ItemCommand">
                            <ItemTemplate>
                                <tr>
                                    <td style="color:var(--color-text-muted);"><%# Eval("UserID") %></td>
                                    <td><strong><%# Eval("Username") %></strong></td>
                                    <td style="color:var(--color-text-muted);"><%# Eval("Email") %></td>
                                    <td>
                                        <span class='<%# Eval("Role").ToString() == "Admin" ? "badge badge-admin" : "badge badge-user" %>'>
                                            <%# Eval("Role") %>
                                        </span>
                                    </td>
                                    <td><%# Eval("TotalScore") %></td>
                                    <td>
                                        <span class='<%# (bool)Eval("IsActive") ? "badge badge-easy" : "badge badge-hard" %>'>
                                            <%# (bool)Eval("IsActive") ? "Active" : "Inactive" %>
                                        </span>
                                    </td>
                                    <td style="color:var(--color-text-muted);"><%# Convert.ToDateTime(Eval("CreatedAt")).ToString("MMM dd, yyyy") %></td>
                                    <td>
                                        <div style="display:flex; gap:var(--space-2); flex-wrap:wrap;">
                                            <%-- Toggle Role --%>
                                            <asp:LinkButton runat="server"
                                                CommandName='<%# Eval("Role").ToString() == "Admin" ? "Demote" : "Promote" %>'
                                                CommandArgument='<%# Eval("UserID") %>'
                                                CssClass='<%# Eval("Role").ToString() == "Admin" ? "btn btn-ghost btn-small" : "btn btn-secondary btn-small" %>'>
                                                <%# Eval("Role").ToString() == "Admin" ? "Make Player" : "Make Admin" %>
                                            </asp:LinkButton>
                                            <%-- Toggle Active --%>
                                            <asp:LinkButton runat="server"
                                                CommandName='<%# (bool)Eval("IsActive") ? "Deactivate" : "Activate" %>'
                                                CommandArgument='<%# Eval("UserID") %>'
                                                CssClass='<%# (bool)Eval("IsActive") ? "btn btn-ghost btn-small" : "btn btn-secondary btn-small" %>'>
                                                <%# (bool)Eval("IsActive") ? "Deactivate" : "Activate" %>
                                            </asp:LinkButton>
                                            <%-- Delete --%>
                                            <asp:LinkButton runat="server"
                                                CommandName="Delete"
                                                CommandArgument='<%# Eval("UserID") %>'
                                                CssClass="btn btn-ghost btn-small"
                                                style="color:var(--color-red, #ff4d4d);"
                                                OnClientClick="return confirm('Are you sure you want to delete this user? This cannot be undone.');">
                                                Delete
                                            </asp:LinkButton>
                                        </div>
                                    </td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>

            <%-- Empty state --%>
            <asp:Panel ID="pnlEmpty" runat="server" Visible="false"
                style="text-align:center; padding:var(--space-10) 0; color:var(--color-text-muted);">
                No users found.
            </asp:Panel>

        </main>

        <footer class="footer">
            <div style="display:flex; justify-content:space-between; align-items:flex-start; flex-wrap:wrap; gap:1rem;">
                <div>
                    <p class="footer-brand">HackEd</p>
                    <p style="color:var(--color-text-muted); font-size:0.875rem; margin-top:0.25rem;">Structured cybersecurity learning with integrated CTF simulation.</p>
                </div>
                <nav class="footer-links">
                    <a href="~/Admin/TrainingCRUD.aspx" runat="server">Training</a>
                    <a href="~/Challenges/Index.aspx" runat="server">Challenges</a>
                    <a href="~/FAQ.aspx" runat="server">FAQ</a>
                    <a href="~/About.aspx" runat="server">About</a>
                </nav>
            </div>
        </footer>

    </form>
</body>
</html>