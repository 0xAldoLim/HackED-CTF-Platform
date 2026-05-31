<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TrainingEditCreate.aspx.cs" Inherits="HackEdCTF.Web.Admin.TrainingEditCreate" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Create/Edit Training Modules</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous" />
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;700;800&family=Inter:wght@400;700&family=JetBrains+Mono:wght@400;700&display=swap" rel="stylesheet" />
    <link href="~/css/site.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <%-- ===== NAVBAR (Admin) ===== --%>
        <nav class="navbar">
            <a href="~/Default.aspx" runat="server" class="navbar-brand">
                <img src="../white.png" alt="HackEd" class="navbar-logo" />
            </a>
            <ul class="navbar-menu">
                <li><a href="~/Admin/Dashboard.aspx" runat="server" class="navbar-link">Admin</a></li>
                <li><a href="~/Admin/TrainingCRUD.aspx" runat="server" class="navbar-link active">Training</a></li>
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
            <%-- Back link --%>
            <a href="~/Admin/TrainingCRUD.aspx" runat="server" class="btn btn-ghost btn-small" style="margin-bottom:var(--space-5);">
                ← Back to modules
            </a>

            <%-- Page Header --%>
            <div class="page-header">
                <h1 class="page-title">
                    <asp:Literal ID="litPageTitle" runat="server" Text="Admin Training Create/Edit Page" />
                </h1>
            </div>

            <%-- Feedback alert --%>
            <asp:Label ID="lblAlert" runat="server" Visible="false" CssClass="alert" />

            <%-- Form card --%>
            <div class="card">

                <div class="two-column-layout" style="grid-template-columns: 1fr 1fr; gap: var(--space-5);">

                    <%-- Title --%>
                    <div class="form-group">
                        <label class="form-label" for="<%= txtTitle.ClientID %>">Title</label>
                        <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control"
                            placeholder="Module title" MaxLength="100" />
                        <asp:RequiredFieldValidator runat="server"
                            ControlToValidate="txtTitle"
                            ValidationGroup="SaveModule"
                            ErrorMessage="Title is required."
                            CssClass="validation-message" Display="Dynamic" />
                    </div>

                    <%-- Level (dropdown) --%>
                    <div class="form-group">
                        <label class="form-label" for="<%= ddlLevel.ClientID %>">Level</label>
                        <asp:DropDownList ID="ddlLevel" runat="server" CssClass="form-select">
                            <asp:ListItem Value="" Text="-- Select level --" />
                            <asp:ListItem Value="Beginner" Text="Beginner" />
                            <asp:ListItem Value="Advanced" Text="Advanced" />
                            <asp:ListItem Value="Expert" Text="Expert" />
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator runat="server"
                            ControlToValidate="ddlLevel"
                            InitialValue=""
                            ValidationGroup="SaveModule"
                            ErrorMessage="Level is required."
                            CssClass="validation-message" Display="Dynamic" />
                    </div>

                    <%-- Category --%>
                    <div class="form-group">
                        <label class="form-label" for="<%= txtCategory.ClientID %>">Category</label>
                        <asp:TextBox ID="txtCategory" runat="server" CssClass="form-control"
                            placeholder="Web, Linux, Crypto..." MaxLength="50" />
                        <asp:RequiredFieldValidator runat="server"
                            ControlToValidate="txtCategory"
                            ValidationGroup="SaveModule"
                            ErrorMessage="Category is required."
                            CssClass="validation-message" Display="Dynamic" />
                    </div>
                </div>

                <%-- Content area (full width below) --%>
                <div class="form-group">
                    <label class="form-label" for="<%= txtContent.ClientID %>">Content editor area</label>
                    <asp:TextBox ID="txtContent" runat="server" CssClass="form-textarea"
                        TextMode="MultiLine" Rows="10"
                        placeholder="Rich text / Markdown editor placeholder" />
                    <asp:RequiredFieldValidator runat="server"
                        ControlToValidate="txtContent"
                        ValidationGroup="SaveModule"
                        ErrorMessage="Content is required."
                        CssClass="validation-message" Display="Dynamic" />
                </div>

                <%-- Action buttons --%>
                <div class="form-actions">
                    <asp:Button ID="btnSave" runat="server" Text="Save Module"
                        CssClass="btn btn-primary"
                        ValidationGroup="SaveModule"
                        OnClick="btnSave_Click" />
                    <asp:Button ID="btnCancel" runat="server" Text="Cancel"
                        CssClass="btn btn-secondary"
                        CausesValidation="false"
                        OnClick="btnCancel_Click" />
                </div>
            </div>
        </main>

        <%-- ===== FOOTER ===== --%>
        <footer class="footer">
            <div style="display:flex; justify-content:space-between; align-items:flex-start; flex-wrap:wrap; gap:1rem;">
                <div>
                    <p class="footer-brand">HackEd</p>
                    <p style="color:var(--color-text-muted); font-size:0.875rem; margin-top:0.25rem;">Structured cybersecurity learning with integrated CTF simulation.</p>
                </div>
                <nav class="footer-links">
                    <a href="~/Admin/TrainingCRUD.aspx" runat="server">Training</a>
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
