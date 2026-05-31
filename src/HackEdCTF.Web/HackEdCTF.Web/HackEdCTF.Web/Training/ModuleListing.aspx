<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ModuleListing.aspx.cs" Inherits="HackEdCTF.Web.Training.ModuleListing" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Module Listing - HackEd</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous" />
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;700;800&family=Inter:wght@400;700&family=JetBrains+Mono:wght@400;700&display=swap" rel="stylesheet" />
    <link href="~/css/site.css" rel="stylesheet" />
    <style>

    </style>
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

            <asp:Panel ID="pnlAlert" runat="server" Visible="false" style="margin-bottom:1.5rem;">
                <asp:Label ID="lblAlert" runat="server"></asp:Label>
            </asp:Panel>

            <div class="page-header">
                <h1 class="page-title">Training Module Listing Page</h1>
            </div>

            <%-- Search + Filter Bar --%>
            <div class="filter-bar" style="margin-bottom:var(--space-8);">
                <div class="search-box">
                    <label class="form-label" for="<%= txtModuleSearch.ClientID %>">Search modules</label>
                    <asp:TextBox ID="txtModuleSearch" runat="server" CssClass="search-input"
                        placeholder="Search by title" MaxLength="100" />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="RequiredFieldValidator" ControlToValidate="txtModuleSearch" CssClass="validation-message" Display="Dynamic" ValidationGroup="Search">Please enter a search term.</asp:RequiredFieldValidator>
                </div>

                <div class="filter-group">
                    <asp:LinkButton ID="lnkLvlAll" runat="server" CssClass="filter-pill active" OnClick="LnkLevel_Click" CommandArgument="" CausesValidation="false">All Levels</asp:LinkButton>
                    <asp:LinkButton ID="lnkLvlBeginner" runat="server" CssClass="filter-pill" OnClick="LnkLevel_Click" CommandArgument="Beginner" CausesValidation="false">Beginner</asp:LinkButton>
                    <asp:LinkButton ID="lnkLvlAdvanced" runat="server" CssClass="filter-pill" OnClick="LnkLevel_Click" CommandArgument="Advanced" CausesValidation="false">Advanced</asp:LinkButton>
                    <asp:LinkButton ID="lnkLvlExpert" runat="server" CssClass="filter-pill" OnClick="LnkLevel_Click" CommandArgument="Expert" CausesValidation="false">Expert</asp:LinkButton>
                </div>

                <div class="filter-group">
                    <asp:LinkButton ID="lnkCatAll" runat="server" CssClass="filter-pill active" OnClick="LnkCategory_Click" CommandArgument="" CausesValidation="false">All Categories</asp:LinkButton>
                    <asp:LinkButton ID="lnkCatWeb" runat="server" CssClass="filter-pill" OnClick="LnkCategory_Click" CommandArgument="Web" CausesValidation="false">Web</asp:LinkButton>
                    <asp:LinkButton ID="lnkCatNetwork" runat="server" CssClass="filter-pill" OnClick="LnkCategory_Click" CommandArgument="Network" CausesValidation="false">Network</asp:LinkButton>
                    <asp:LinkButton ID="lnkCatLinux" runat="server" CssClass="filter-pill" OnClick="LnkCategory_Click" CommandArgument="Linux" CausesValidation="false">Linux</asp:LinkButton>
                    <asp:LinkButton ID="lnkCatCrypto" runat="server" CssClass="filter-pill" OnClick="LnkCategory_Click" CommandArgument="Crypto" CausesValidation="false">Crypto</asp:LinkButton>
                </div>

                <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-primary"
                    OnClick="BtnSearch_Click" ValidationGroup="Search" />
            </div>

            <%-- No results message --%>
            <asp:Label ID="lblNoResults" runat="server" Visible="false" CssClass="alert alert-info" />

            <%-- Module Cards --%>
            <asp:Repeater ID="rptModules" runat="server">
                <HeaderTemplate>
                    <div class="content-grid">
                </HeaderTemplate>
                <ItemTemplate>
                    <div class="challenge-card">
                        <div class="cluster">
                            <span class='badge badge-<%# Eval("Level").ToString().ToLower() %>'>
                                <%# Eval("Level") %>
                            </span>
                            <span class='badge badge-<%# Eval("Category").ToString().ToLower() %>'>
                                <%# Eval("Category") %>
                            </span>
                        </div>
                        <h3 class="card-title"><%# Eval("Title") %></h3>
                        <p class="card-text"><%# Eval("ShortDescription") %></p>
                        <div class="challenge-meta">
                            <span>Created: <%# Eval("CreatedAt", "{0:yyyy-MM-dd}") %></span>
                        </div>
                        <asp:HyperLink runat="server" CssClass="btn btn-primary btn-small"
                            NavigateUrl='<%# "~/Training/ModuleDetail.aspx?id=" + Eval("ModuleID") %>'
                            Text="Start Module" />
                    </div>
                </ItemTemplate>
                <FooterTemplate>
                    </div>
                </FooterTemplate>
            </asp:Repeater>
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
