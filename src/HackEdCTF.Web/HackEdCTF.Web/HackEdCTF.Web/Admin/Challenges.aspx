<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Challenges.aspx.cs" Inherits="Admin_Challenges" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Manage Challenges - HackEd</title>
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
                <li><a href="~/Training/Index.aspx" runat="server" class="navbar-link">Training</a></li>
                <li><a href="~/Challenges/Index.aspx" runat="server" class="navbar-link">Challenges</a></li>
                <li><a href="~/Admin/Challenges.aspx" runat="server" class="navbar-link active">Manage Challenges</a></li>
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
                <h1 class="page-title">Manage Challenges</h1>
                <p style="color:var(--color-text-muted);">Create, edit, and deactivate CTF challenges.</p>
            </div>

            <asp:Panel ID="pnlAlert" runat="server" Visible="false" style="margin-bottom:1.5rem;">
                <asp:Label ID="lblAlert" runat="server"></asp:Label>
            </asp:Panel>

            <div style="display:flex; justify-content:space-between; gap:var(--space-3); flex-wrap:wrap; margin-bottom:var(--space-6);">
                <asp:HyperLink ID="lnkAddChallenge" runat="server" NavigateUrl="~/Admin/ChallengeEdit.aspx" CssClass="btn btn-primary">Add new challenge</asp:HyperLink>
                <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Search challenges..." AutoPostBack="true" OnTextChanged="txtSearch_TextChanged" style="max-width:320px;"></asp:TextBox>
            </div>

            <div class="table-wrapper">
                <table class="crud-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Title</th>
                            <th>Category</th>
                            <th>Difficulty</th>
                            <th>Points</th>
                            <th>Status</th>
                            <th>Created</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="rptChallenges" runat="server" OnItemCommand="rptChallenges_ItemCommand">
                            <ItemTemplate>
                                <tr>
                                    <td style="color:var(--color-text-muted);"><%# Eval("ChallengeID") %></td>
                                    <td><strong><%# Server.HtmlEncode(Eval("Title").ToString()) %></strong></td>
                                    <td><span class='<%# GetCategoryBadgeClass(Eval("Category").ToString()) %>'><%# Server.HtmlEncode(Eval("Category").ToString()) %></span></td>
                                    <td><span class='<%# GetDifficultyBadgeClass(Eval("Difficulty").ToString()) %>'><%# Server.HtmlEncode(Eval("Difficulty").ToString()) %></span></td>
                                    <td class="text-mint" style="font-weight:700;"><%# Eval("Points") %></td>
                                    <td>
                                        <span class='<%# Convert.ToBoolean(Eval("IsActive")) ? "badge badge-easy" : "badge badge-hard" %>'>
                                            <%# Convert.ToBoolean(Eval("IsActive")) ? "Active" : "Inactive" %>
                                        </span>
                                    </td>
                                    <td style="color:var(--color-text-muted);"><%# FormatDate(Eval("CreatedAt")) %></td>
                                    <td>
                                        <div style="display:flex; gap:var(--space-2); flex-wrap:wrap;">
                                            <asp:HyperLink runat="server" CssClass="btn btn-secondary btn-small"
                                                NavigateUrl='<%# "~/Admin/ChallengeEdit.aspx?id=" + Eval("ChallengeID") %>'>Edit</asp:HyperLink>
                                            <asp:LinkButton runat="server"
                                                CommandName="ToggleActive"
                                                CommandArgument='<%# Eval("ChallengeID") %>'
                                                CssClass="btn btn-ghost btn-small">
                                                <%# Convert.ToBoolean(Eval("IsActive")) ? "Deactivate" : "Activate" %>
                                            </asp:LinkButton>
                                        </div>
                                    </td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>

            <asp:Panel ID="pnlEmpty" runat="server" Visible="false" style="text-align:center; padding:var(--space-10) 0; color:var(--color-text-muted);">
                No challenges found.
            </asp:Panel>
        </main>
    </form>
</body>
</html>
