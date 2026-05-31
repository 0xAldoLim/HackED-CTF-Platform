<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Profile.aspx.cs" Inherits="Member_Profile" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>My Profile – HackEd</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous" />
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;700;800&family=Inter:wght@400;700&family=JetBrains+Mono:wght@400;700&display=swap" rel="stylesheet" />
    <link href="~/css/site.css" rel="stylesheet" />
    <style>
        .profile-field-row {
            display: flex;
            flex-direction: column;
            gap: var(--space-1);
            margin-bottom: var(--space-4);
        }
        .profile-field-label {
            color: var(--color-text-muted);
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 0.06em;
        }
        .profile-field-value {
            font-size: 1rem;
        }
        .edit-section-title {
            color: var(--color-text-strong);
            font-family: var(--font-heading);
            font-size: 0.875rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            color: var(--color-mint);
            margin: var(--space-5) 0 var(--space-3);
            padding-top: var(--space-5);
            border-top: 1px solid var(--color-border);
        }
        .edit-section-title:first-of-type {
            margin-top: var(--space-4);
            padding-top: 0;
            border-top: none;
        }
        .password-hint {
            font-size: 0.8rem;
            color: var(--color-text-muted);
            margin-top: var(--space-1);
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">

        <nav class="navbar">
            <a href="../Default.aspx" runat="server" class="navbar-brand">
                <img src="../white.png" alt="HackEd" class="navbar-logo" />
            </a>
            <ul class="navbar-menu">
                <li><a href="~/Member/Dashboard.aspx" runat="server" class="navbar-link active">Dashboard</a></li>
                <li><a href="~/Training/ModuleListing.aspx" runat="server" class="navbar-link">Training</a></li>
                <li><a href="~/Challenges/Index.aspx" runat="server" class="navbar-link">Challenges</a></li>
                <li><a href="~/Scoreboard.aspx" runat="server" class="navbar-link">Scoreboard</a></li>
                <li><a href="~/Blog/Index.aspx" runat="server" class="navbar-link">Blog</a></li>
                <li><a href="~/FAQ.aspx" runat="server" class="navbar-link">FAQ</a></li>
            </ul>
            <div class="navbar-user">
                <asp:Label ID="lblNavUsername" runat="server"></asp:Label>
                <span class="role-pill">USER</span>
                <asp:LinkButton ID="lnkLogout" runat="server" CssClass="btn btn-ghost btn-small" OnClick="lnkLogout_Click">Logout</asp:LinkButton>
            </div>
        </nav>

        <main class="container section">

            <div class="page-header">
                <h1 class="page-title">User Profile / Account Page</h1>
            </div>

            <asp:Panel ID="pnlSuccess" runat="server" Visible="false" CssClass="alert alert-success" style="margin-bottom:1.5rem;">
                <asp:Label ID="lblSuccess" runat="server"></asp:Label>
            </asp:Panel>
            <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="alert alert-danger" style="margin-bottom:1.5rem;">
                <asp:Label ID="lblError" runat="server"></asp:Label>
            </asp:Panel>

            <div class="two-column-layout">

                <div class="card">

                    <%--VIEW mode--%>
                    <asp:Panel ID="pnlView" runat="server">
                        <h2 class="card-title" style="margin-bottom:var(--space-5);">Account information</h2>

                        <div class="stack">
                            <p>Username: <strong><asp:Label ID="lblUsername" runat="server"></asp:Label></strong></p>
                            <p>Email: <asp:Label ID="lblEmail" runat="server"></asp:Label></p>
                            <p class="text-mint" style="font-weight:700;">Role: <asp:Label ID="lblRole" runat="server"></asp:Label></p>
                            <p>Joined: <asp:Label ID="lblJoined" runat="server"></asp:Label></p>
                            <p>Score: <strong><asp:Label ID="lblScore" runat="server">0</asp:Label></strong></p>
                            <p>Team: <asp:Label ID="lblTeam" runat="server">None</asp:Label></p>
                        </div>

                        <div class="form-actions" style="margin-top:var(--space-6);">
                            <asp:Button ID="btnShowEdit" runat="server" Text="Edit Profile"
                                CssClass="btn btn-secondary" OnClick="btnShowEdit_Click" />
                            <asp:LinkButton ID="lnkLogout2" runat="server" CssClass="btn btn-primary" OnClick="lnkLogout_Click">Logout</asp:LinkButton>
                        </div>
                    </asp:Panel>

                    <%--EDIT mode--%>
                    <asp:Panel ID="pnlEdit" runat="server" Visible="false">
                        <h2 class="card-title" style="margin-bottom:var(--space-5);">Edit Profile</h2>

                        <p class="edit-section-title">Account Details</p>

                        <div class="form-group">
                            <label class="form-label">Username</label>
                            <asp:TextBox ID="txtEditUsername" runat="server" CssClass="form-control" MaxLength="50"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvUsername" runat="server"
                                ControlToValidate="txtEditUsername" ValidationGroup="EditProfile"
                                ErrorMessage="Username is required." CssClass="validation-message" Display="Dynamic" />
                        </div>

                        <div class="form-group">
                            <label class="form-label">Email</label>
                            <asp:TextBox ID="txtEditEmail" runat="server" CssClass="form-control" TextMode="Email" MaxLength="200"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvEmail" runat="server"
                                ControlToValidate="txtEditEmail" ValidationGroup="EditProfile"
                                ErrorMessage="Email is required." CssClass="validation-message" Display="Dynamic" />
                            <asp:RegularExpressionValidator ID="revEmail" runat="server"
                                ControlToValidate="txtEditEmail" ValidationGroup="EditProfile"
                                ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$"
                                ErrorMessage="Enter a valid email address." CssClass="validation-message" Display="Dynamic" />
                        </div>

                        <p class="edit-section-title">Change Password</p>
                        <p class="password-hint" style="margin-bottom:var(--space-4);">Leave blank to keep your current password.</p>

                        <div class="form-group">
                            <label class="form-label">Current Password</label>
                            <asp:TextBox ID="txtCurrentPassword" runat="server" CssClass="form-control" TextMode="Password" MaxLength="200"></asp:TextBox>
                        </div>

                        <div class="form-group">
                            <label class="form-label">New Password</label>
                            <asp:TextBox ID="txtNewPassword" runat="server" CssClass="form-control" TextMode="Password" MaxLength="200"></asp:TextBox>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Confirm New Password</label>
                            <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control" TextMode="Password" MaxLength="200"></asp:TextBox>
                            <asp:CompareValidator ID="cvPasswords" runat="server"
                                ControlToValidate="txtConfirmPassword" ControlToCompare="txtNewPassword"
                                ValidationGroup="EditProfile"
                                ErrorMessage="Passwords do not match." CssClass="validation-message" Display="Dynamic" />
                        </div>

                        <div class="form-actions" style="margin-top:var(--space-6);">
                            <asp:Button ID="btnSave" runat="server" Text="Save Changes"
                                CssClass="btn btn-primary" ValidationGroup="EditProfile"
                                OnClick="btnSave_Click" />
                            <asp:Button ID="btnCancel" runat="server" Text="Cancel"
                                CssClass="btn btn-ghost" OnClick="btnCancel_Click"
                                CausesValidation="false" />
                        </div>
                    </asp:Panel>

                </div>

                <div class="card">
                    <h2 class="card-title" style="margin-bottom:var(--space-4);">Recent activity</h2>
                    <div class="table-wrapper" style="border:none; background:transparent; box-shadow:none;">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Date</th>
                                    <th>Action</th>
                                    <th>Result</th>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:Repeater ID="rptActivity" runat="server">
                                    <ItemTemplate>
                                        <tr>
                                            <td style="color:var(--color-text-muted);"><%# Eval("DateLabel") %></td>
                                            <td><%# Eval("Action") %></td>
                                            <td class="text-mint"><%# Eval("Result") %></td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </tbody>
                        </table>
                    </div>
                </div>

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
                    <a href="~/Blog/Index.aspx" runat="server">Blog</a>
                    <a href="~/FAQ.aspx" runat="server">FAQ</a>
                    <a href="~/About.aspx" runat="server">About</a>
                </nav>
            </div>
        </footer>

    </form>
</body>
</html>
