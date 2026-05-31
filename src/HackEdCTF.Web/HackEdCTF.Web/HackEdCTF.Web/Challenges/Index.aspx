<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Index.aspx.cs" Inherits="Challenges_Index" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Challenges - HackEd</title>
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
                <li><a href="~/Challenges/Index.aspx" runat="server" class="navbar-link active">Challenges</a></li>
                <li><a href="~/Scoreboard.aspx" runat="server" class="navbar-link">Scoreboard</a></li>
                <li><a href="~/Blog/Index.aspx" runat="server" class="navbar-link">Blog</a></li>
                <li><a href="~/FAQ.aspx" runat="server" class="navbar-link">FAQ</a></li>
            </ul>
            <div class="navbar-actions">
                <asp:HyperLink ID="lnkDashboard" runat="server" CssClass="btn btn-ghost btn-small" Visible="false">Dashboard</asp:HyperLink>
                <asp:HyperLink ID="lnkLogin" runat="server" NavigateUrl="~/Login.aspx" CssClass="btn btn-primary">Login</asp:HyperLink>
            </div>
        </nav>

        <main class="container section">
            <div class="page-header">
                <h1 class="page-title">CTF Challenges</h1>
                <p class="page-subtitle">Practice web, crypto, forensics, reverse engineering, and other cybersecurity skills.</p>
            </div>

            <asp:Panel ID="pnlAlert" runat="server" Visible="false" style="margin-bottom:1.5rem;">
                <asp:Label ID="lblAlert" runat="server"></asp:Label>
            </asp:Panel>

            <div style="display:flex; gap:var(--space-3); flex-wrap:wrap; align-items:end; margin-bottom:var(--space-6);">
                <div class="form-group" style="margin:0; min-width:220px;">
                    <label class="form-label" for="<%= ddlCategory.ClientID %>">Category</label>
                    <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="Filter_Changed"></asp:DropDownList>
                </div>
                <div class="form-group" style="margin:0; min-width:180px;">
                    <label class="form-label" for="<%= ddlDifficulty.ClientID %>">Difficulty</label>
                    <asp:DropDownList ID="ddlDifficulty" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="Filter_Changed">
                        <asp:ListItem Value="">All difficulties</asp:ListItem>
                        <asp:ListItem>Easy</asp:ListItem>
                        <asp:ListItem>Medium</asp:ListItem>
                        <asp:ListItem>Hard</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="form-group" style="margin:0; min-width:240px; flex:1;">
                    <label class="form-label" for="<%= txtSearch.ClientID %>">Search</label>
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Search challenge title..." AutoPostBack="true" OnTextChanged="Filter_Changed"></asp:TextBox>
                </div>
                <asp:Button ID="btnReset" runat="server" Text="Reset" CssClass="btn btn-ghost btn-small" OnClick="btnReset_Click" />
            </div>

            <asp:Panel ID="pnlLoginNotice" runat="server" Visible="false" CssClass="alert alert-info" style="margin-bottom:var(--space-6);">
                Log in to submit flags and track solved status. <a href="../Login.aspx">Go to login</a>
            </asp:Panel>

            <div class="dashboard-grid" style="margin-bottom:var(--space-8);">
                <asp:Repeater ID="rptChallenges" runat="server" OnItemCommand="rptChallenges_ItemCommand">
                    <ItemTemplate>
                        <asp:LinkButton runat="server" CssClass="challenge-card" style="text-align:left; text-decoration:none; border-style:solid;"
                            CommandName="SelectChallenge" CommandArgument='<%# Eval("ChallengeID") %>'>
                            <span class='<%# GetStatusBadgeClass(Eval("IsSolved")) %>'><%# GetSolvedStatus(Eval("IsSolved")) %></span>
                            <h2 class="card-title"><%# Server.HtmlEncode(Eval("Title").ToString()) %></h2>
                            <div class="challenge-meta">
                                <span class='<%# GetCategoryBadgeClass(Eval("Category").ToString()) %>'><%# Server.HtmlEncode(Eval("Category").ToString()) %></span>
                                <span class='<%# GetDifficultyBadgeClass(Eval("Difficulty").ToString()) %>'><%# Server.HtmlEncode(Eval("Difficulty").ToString()) %></span>
                                <span class="text-mint" style="font-weight:700;"><%# Eval("Points") %> pts</span>
                            </div>
                        </asp:LinkButton>
                    </ItemTemplate>
                </asp:Repeater>
            </div>

            <asp:Panel ID="pnlEmpty" runat="server" Visible="false" CssClass="card" style="text-align:center; padding:var(--space-10);">
                <h2 class="card-title">No challenges found</h2>
                <p style="color:var(--color-text-muted); margin-top:var(--space-3);">Try a different filter or check back after an admin adds challenges.</p>
            </asp:Panel>

            <asp:Panel ID="pnlDetail" runat="server" Visible="false" CssClass="modal-backdrop">
                <div class="modal">
                    <div class="modal-header">
                        <div>
                            <asp:Label ID="lblDetailTitle" runat="server" CssClass="modal-title"></asp:Label>
                            <div class="challenge-meta" style="margin-top:var(--space-2);">
                                <asp:Label ID="lblDetailCategory" runat="server"></asp:Label>
                                <asp:Label ID="lblDetailDifficulty" runat="server"></asp:Label>
                                <asp:Label ID="lblDetailPoints" runat="server" CssClass="text-mint" style="font-weight:700;"></asp:Label>
                                <asp:Label ID="lblDetailStatus" runat="server"></asp:Label>
                            </div>
                        </div>
                        <asp:LinkButton ID="btnCloseDetail" runat="server" CssClass="modal-close" OnClick="btnCloseDetail_Click" CausesValidation="false">x</asp:LinkButton>
                    </div>
                    <div class="modal-body">
                        <asp:Literal ID="litDescription" runat="server"></asp:Literal>

                        <asp:Panel ID="pnlHint" runat="server" Visible="false" CssClass="flag-feedback">
                            <strong>Hint:</strong>
                            <asp:Label ID="lblHint" runat="server"></asp:Label>
                        </asp:Panel>

                        <asp:Panel ID="pnlFile" runat="server" Visible="false" CssClass="flag-feedback">
                            <strong>Resource:</strong>
                            &nbsp;
                            <asp:HyperLink ID="lnkFile" runat="server" Target="_blank" rel="noopener noreferrer"></asp:HyperLink>
                        </asp:Panel>

                        <asp:Panel ID="pnlSubmitLogin" runat="server" Visible="false" CssClass="alert alert-info">
                            You need to <a href="../Login.aspx">log in</a> before submitting a flag.
                        </asp:Panel>

                        <asp:Panel ID="pnlSubmitForm" runat="server">
                            <div class="form-group">
                                <label class="form-label" for="<%= txtFlag.ClientID %>">Flag</label>
                                <asp:TextBox ID="txtFlag" runat="server" CssClass="form-control flag-input" MaxLength="255" placeholder="HackEd{...}"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvFlag" runat="server" ControlToValidate="txtFlag"
                                    ErrorMessage="Flag cannot be empty." CssClass="validation-message" Display="Dynamic"
                                    ValidationGroup="SubmitFlag" />
                            </div>
                            <asp:Button ID="btnSubmitFlag" runat="server" Text="Submit Flag" CssClass="btn btn-primary"
                                OnClick="btnSubmitFlag_Click" ValidationGroup="SubmitFlag" />
                        </asp:Panel>

                        <asp:Panel ID="pnlFlagFeedback" runat="server" Visible="false">
                            <asp:Label ID="lblFlagFeedback" runat="server"></asp:Label>
                        </asp:Panel>
                    </div>
                </div>
            </asp:Panel>
        </main>
    </form>
</body>
</html>
