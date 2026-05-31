<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TrainingCRUD.aspx.cs" Inherits="HackEdCTF.Web.Admin.TrainingCRUD" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Training CRUD List</title>
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
                <li><a href="~/Admin/Users.aspx" runat="server" class="navbar-link">Users</a></li>
            </ul>
            <div class="navbar-user">
                <asp:Label ID="lblNavUsername" runat="server" CssClass="navbar-link" style="pointer-events:none;"></asp:Label>
                <span class="role-pill role-pill-admin">ADMIN</span>
                <asp:LinkButton ID="lnkLogout" runat="server" CssClass="btn btn-ghost btn-small" OnClick="lnkLogout_Click">Logout</asp:LinkButton>
            </div>
        </nav>

        <main class="container section">
            <%-- Page Header --%>
            <div class="page-header">
                <h1 class="page-title">Training CRUD List</h1>
            </div>

            <%-- Search + Add Bar --%>
            <div class="filter-bar" style="margin-bottom:var(--space-8);">
                <div class="search-box">
                    <label class="form-label" for="<%= txtModuleSearch.ClientID %>">Search modules</label>
                    <asp:TextBox ID="txtModuleSearch" runat="server" CssClass="search-input"
                        placeholder="Search by title" MaxLength="100" />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="RequiredFieldValidator" ControlToValidate="txtModuleSearch" CssClass="validation-message" Display="Dynamic" ValidationGroup="Search">Please enter a search term.</asp:RequiredFieldValidator>
                </div>

                <div class="cluster">
                    <asp:Button ID="btnSearch" runat="server" Text="Search"
                        CssClass="btn btn-secondary" OnClick="btnSearch_Click" ValidationGroup="Search" />
                    <asp:Button ID="btnAddModule" runat="server" Text="Add New Module" 
                        CssClass="btn btn-primary" OnClick="BtnAddModule_Click" CausesValidation="false"/>
                </div>
            </div>

            <%-- Feedback message --%>
            <asp:Label ID="lblAlert" runat="server" Visible="false" CssClass="alert" />

            <%-- Modules table --%>
            <div class="table-wrapper">
                <asp:GridView ID="gvModules" runat="server"
                    AutoGenerateColumns="false"
                    CssClass="crud-table"
                    GridLines="None"
                    DataKeyNames="ModuleID"
                    OnRowCommand="gvModules_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="Title"      HeaderText="Title" />
                        <asp:BoundField DataField="Level"      HeaderText="Level" />
                        <asp:BoundField DataField="Category"   HeaderText="Category" />
                        <asp:BoundField DataField="CreatedAt"  HeaderText="Created Date"
                            DataFormatString="{0:MMM dd}" />
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <asp:LinkButton runat="server" CssClass="table-action-link"
                                    Text="Edit"
                                    CommandName="EditModule"
                                    CommandArgument='<%# Eval("ModuleID") %>'
                                    CausesValidation="false"/>
                                <asp:LinkButton runat="server" CssClass="table-action-link"
                                    Text="Delete"
                                    CommandName="DeleteModule"
                                    CommandArgument='<%# Eval("ModuleID") %>'
                                    CausesValidation="false"
                                    OnClientClick="return confirm('Delete this module? This cannot be undone.');" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <div style="padding:var(--space-6); text-align:center; color:var(--color-text-muted);">
                            No modules found.
                        </div>
                    </EmptyDataTemplate>
                </asp:GridView>
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
