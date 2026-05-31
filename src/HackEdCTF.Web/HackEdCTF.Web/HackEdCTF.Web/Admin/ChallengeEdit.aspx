<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ChallengeEdit.aspx.cs" Inherits="Admin_ChallengeEdit" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Challenge Editor - HackEd</title>
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
                <li><a href="~/Challenges/Index.aspx" runat="server" class="navbar-link">Challenges</a></li>
                <li><a href="~/Admin/Challenges.aspx" runat="server" class="navbar-link active">Manage Challenges</a></li>
                <li><a href="~/Admin/Users.aspx" runat="server" class="navbar-link">Users</a></li>
            </ul>
            <div class="navbar-user">
                <asp:Label ID="lblNavUsername" runat="server" CssClass="navbar-link" style="pointer-events:none;"></asp:Label>
                <span class="role-pill role-pill-admin">ADMIN</span>
                <asp:LinkButton ID="lnkLogout" runat="server" CssClass="btn btn-ghost btn-small" OnClick="lnkLogout_Click" CausesValidation="false">Logout</asp:LinkButton>
            </div>
        </nav>

        <main class="container section">
            <div class="page-header">
                <h1 class="page-title"><asp:Label ID="lblPageTitle" runat="server">Add Challenge</asp:Label></h1>
                <p style="color:var(--color-text-muted);">Keep challenge content concise and testable.</p>
            </div>

            <asp:Panel ID="pnlAlert" runat="server" Visible="false" style="margin-bottom:1.5rem;">
                <asp:Label ID="lblAlert" runat="server"></asp:Label>
            </asp:Panel>

            <asp:ValidationSummary ID="ValidationSummary1" runat="server" CssClass="alert alert-danger" ValidationGroup="SaveChallenge" />

            <div class="card" style="display:grid; gap:var(--space-5);">
                <div class="form-group">
                    <label class="form-label" for="<%= txtTitle.ClientID %>">Title</label>
                    <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" MaxLength="150"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvTitle" runat="server" ControlToValidate="txtTitle"
                        ErrorMessage="Title is required." CssClass="validation-message" Display="Dynamic" ValidationGroup="SaveChallenge" />
                </div>

                <div class="form-group">
                    <label class="form-label" for="<%= txtDescription.ClientID %>">Description</label>
                    <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="6"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvDescription" runat="server" ControlToValidate="txtDescription"
                        ErrorMessage="Description is required." CssClass="validation-message" Display="Dynamic" ValidationGroup="SaveChallenge" />
                </div>

                <div style="display:grid; grid-template-columns:repeat(auto-fit, minmax(180px, 1fr)); gap:var(--space-4);">
                    <div class="form-group">
                        <label class="form-label" for="<%= ddlCategory.ClientID %>">Category</label>
                        <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">Select category</asp:ListItem>
                            <asp:ListItem>Web</asp:ListItem>
                            <asp:ListItem>Cryptography</asp:ListItem>
                            <asp:ListItem>Forensics</asp:ListItem>
                            <asp:ListItem>Reverse Engineering</asp:ListItem>
                            <asp:ListItem>Binary</asp:ListItem>
                            <asp:ListItem>Linux</asp:ListItem>
                            <asp:ListItem>Steganography</asp:ListItem>
                            <asp:ListItem>OSINT</asp:ListItem>
                            <asp:ListItem>Programming</asp:ListItem>
                            <asp:ListItem>Miscellaneous</asp:ListItem>
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="rfvCategory" runat="server" ControlToValidate="ddlCategory" InitialValue=""
                            ErrorMessage="Category is required." CssClass="validation-message" Display="Dynamic" ValidationGroup="SaveChallenge" />
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="<%= ddlDifficulty.ClientID %>">Difficulty</label>
                        <asp:DropDownList ID="ddlDifficulty" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">Select difficulty</asp:ListItem>
                            <asp:ListItem>Easy</asp:ListItem>
                            <asp:ListItem>Medium</asp:ListItem>
                            <asp:ListItem>Hard</asp:ListItem>
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="rfvDifficulty" runat="server" ControlToValidate="ddlDifficulty" InitialValue=""
                            ErrorMessage="Difficulty is required." CssClass="validation-message" Display="Dynamic" ValidationGroup="SaveChallenge" />
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="<%= txtPoints.ClientID %>">Points</label>
                        <asp:TextBox ID="txtPoints" runat="server" CssClass="form-control" TextMode="Number"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvPoints" runat="server" ControlToValidate="txtPoints"
                            ErrorMessage="Points are required." CssClass="validation-message" Display="Dynamic" ValidationGroup="SaveChallenge" />
                        <asp:RangeValidator ID="rvPoints" runat="server" ControlToValidate="txtPoints" Type="Integer" MinimumValue="1" MaximumValue="100000"
                            ErrorMessage="Points must be a positive number." CssClass="validation-message" Display="Dynamic" ValidationGroup="SaveChallenge" />
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="<%= txtCorrectFlag.ClientID %>">Correct flag</label>
                    <asp:TextBox ID="txtCorrectFlag" runat="server" CssClass="form-control flag-input" MaxLength="255"></asp:TextBox>
                    <asp:CustomValidator ID="cvCorrectFlag" runat="server" ControlToValidate="txtCorrectFlag"
                        ErrorMessage="Correct flag is required when creating a challenge." CssClass="validation-message" Display="Dynamic"
                        OnServerValidate="cvCorrectFlag_ServerValidate" ValidationGroup="SaveChallenge" />
                    <p style="color:var(--color-text-muted); font-size:0.875rem; margin-top:0.25rem;">Leave blank while editing to keep the existing flag.</p>
                </div>

                <div class="form-group">
                    <label class="form-label" for="<%= txtHint.ClientID %>">Hint</label>
                    <asp:TextBox ID="txtHint" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label class="form-label" for="<%= txtFileUrl.ClientID %>">File or link URL</label>
                    <asp:TextBox ID="txtFileUrl" runat="server" CssClass="form-control" MaxLength="500"></asp:TextBox>
                </div>

                <label class="form-check">
                    <asp:CheckBox ID="chkIsActive" runat="server" Checked="true" />
                    <span>Active and visible to users</span>
                </label>

                <div style="display:flex; gap:var(--space-3); flex-wrap:wrap;">
                    <asp:Button ID="btnSave" runat="server" Text="Save Challenge" CssClass="btn btn-primary"
                        OnClick="btnSave_Click" ValidationGroup="SaveChallenge" />
                    <asp:HyperLink ID="lnkCancel" runat="server" NavigateUrl="~/Admin/Challenges.aspx" CssClass="btn btn-ghost">Cancel</asp:HyperLink>
                </div>
            </div>
        </main>
    </form>
</body>
</html>
