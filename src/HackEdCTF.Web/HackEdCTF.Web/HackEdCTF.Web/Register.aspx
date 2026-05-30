<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="Register" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Register – HackEd</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous" />
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;700;800&family=Inter:wght@400;700&family=JetBrains+Mono:wght@400;700&display=swap" rel="stylesheet" />
    <link href="~/css/site.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">

        <%-- ===== NAVBAR ===== --%>
        <nav class="navbar">
            <a href="Default.aspx" class="navbar-brand">
                <img src="white.png" alt="HackEd" class="navbar-logo" />
            </a>
            <ul class="navbar-menu">
                <li><a href="Default.aspx" class="navbar-link">Home</a></li>
                <li><a href="Training/Index.aspx" class="navbar-link">Training</a></li>
                <li><a href="Challenges/Index.aspx" class="navbar-link">Challenges</a></li>
                <li><a href="Scoreboard.aspx" class="navbar-link">Scoreboard</a></li>
                <li><a href="Blog/Index.aspx" class="navbar-link">Blog</a></li>
                <li><a href="FAQ.aspx" class="navbar-link">FAQ</a></li>
                <li><a href="About.aspx" class="navbar-link">About</a></li>
            </ul>
            <div class="navbar-actions">
                <a href="Register.aspx" class="btn btn-primary">Get Started</a>
            </div>
        </nav>

        <%-- ===== REGISTER CARD ===== --%>
        <div class="centered-panel">
            <div class="auth-card">

                <img src="white.png" alt="HackEd" class="auth-logo" />

                <h1 class="auth-title">Create your HackEd account</h1>

                <%-- Alert panel for server-side messages --%>
                <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert alert-danger" style="margin-bottom:1.25rem;">
                    <asp:Label ID="lblAlert" runat="server"></asp:Label>
                </asp:Panel>

                <%-- Username --%>
                <div class="form-group">
                    <label class="form-label" for="<%= txtUsername.ClientID %>">Username</label>
                    <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="cyber_student" MaxLength="50"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvUsername" runat="server" ControlToValidate="txtUsername"
                        ErrorMessage="Username is required." CssClass="validation-message" Display="Dynamic" />
                    <asp:RegularExpressionValidator ID="revUsername" runat="server" ControlToValidate="txtUsername"
                        ValidationExpression="^[a-zA-Z0-9_]{3,50}$"
                        ErrorMessage="3–50 characters, letters, numbers, or underscores only."
                        CssClass="validation-message" Display="Dynamic" />
                    <asp:CustomValidator ID="cvUsername" runat="server" ControlToValidate="txtUsername"
                        ErrorMessage="That username is already taken." CssClass="validation-message" Display="Dynamic"
                        OnServerValidate="cvUsername_ServerValidate" />
                </div>

                <%-- Email --%>
                <div class="form-group">
                    <label class="form-label" for="<%= txtEmail.ClientID %>">Email</label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="student@example.com" MaxLength="100"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail"
                        ErrorMessage="Email is required." CssClass="validation-message" Display="Dynamic" />
                    <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail"
                        ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                        ErrorMessage="Please enter a valid email address." CssClass="validation-message" Display="Dynamic" />
                    <asp:CustomValidator ID="cvEmail" runat="server" ControlToValidate="txtEmail"
                        ErrorMessage="That email is already registered." CssClass="validation-message" Display="Dynamic"
                        OnServerValidate="cvEmail_ServerValidate" />
                </div>

                <%-- Password --%>
                <div class="form-group">
                    <label class="form-label" for="<%= txtPassword.ClientID %>">Password</label>
                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="••••••••" MaxLength="100"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword"
                        ErrorMessage="Password is required." CssClass="validation-message" Display="Dynamic" />
                    <asp:RegularExpressionValidator ID="revPassword" runat="server" ControlToValidate="txtPassword"
                        ValidationExpression="^.{8,}$"
                        ErrorMessage="Password must be at least 8 characters." CssClass="validation-message" Display="Dynamic" />
                </div>

                <%-- Confirm Password --%>
                <div class="form-group">
                    <label class="form-label" for="<%= txtConfirmPassword.ClientID %>">Confirm password</label>
                    <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="••••••••" MaxLength="100"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvConfirmPassword" runat="server" ControlToValidate="txtConfirmPassword"
                        ErrorMessage="Please confirm your password." CssClass="validation-message" Display="Dynamic" />
                    <asp:CompareValidator ID="cpvPassword" runat="server" ControlToValidate="txtConfirmPassword" ControlToCompare="txtPassword"
                        ErrorMessage="Passwords do not match." CssClass="validation-message" Display="Dynamic" />
                </div>

                <%-- Role indicator (read-only, matches wireframe) --%>
                <div class="form-group">
                    <div class="badge badge-user" style="width:100%; justify-content:flex-start; padding:0.75rem 1rem; border-radius:var(--radius-md); font-size:0.9375rem;">
                        Default role: Student / User
                    </div>
                </div>

                <%-- Submit --%>
                <asp:Button ID="btnRegister" runat="server" Text="Register" CssClass="btn btn-primary btn-block"
                    OnClick="btnRegister_Click" style="margin-top:0.5rem;" />

                <p style="margin-top:1.25rem; text-align:center; color:var(--color-text-muted); font-size:0.9375rem;">
                    Already have an account? <a href="Login.aspx">Login</a>
                </p>

            </div>
        </div>

        <%-- ===== FOOTER ===== --%>
        <footer class="footer">
            <div style="display:flex; justify-content:space-between; align-items:flex-start; flex-wrap:wrap; gap:1rem;">
                <div>
                    <p class="footer-brand">HackEd</p>
                    <p style="color:var(--color-text-muted); font-size:0.875rem; margin-top:0.25rem;">Structured cybersecurity learning with integrated CTF simulation.</p>
                </div>
                <nav class="footer-links">
                    <a href="Training/Index.aspx">Training</a>
                    <a href="Challenges/Index.aspx">Challenges</a>
                    <a href="Blog/Index.aspx">Blog</a>
                    <a href="FAQ.aspx">FAQ</a>
                    <a href="About.aspx">About</a>
                </nav>
            </div>
        </footer>

    </form>
</body>
</html>

