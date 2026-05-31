<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Login" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Login – HackEd</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous" />
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;700;800&family=Inter:wght@400;700&family=JetBrains+Mono:wght@400;700&display=swap" rel="stylesheet" />
    <link href="~/css/site.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">

        <nav class="navbar">
            <a href="Default.aspx" class="navbar-brand">
                <img src="white.png" alt="HackEd" class="navbar-logo" />
            </a>
            <ul class="navbar-menu">
                <li><a href="Default.aspx" class="navbar-link">Home</a></li>
                <li><a href="Training/ModuleListing.aspx" class="navbar-link">Training</a></li>
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

        <div class="centered-panel">
            <div class="auth-card">

                <img src="white.png" alt="HackEd" class="auth-logo" />

                <h1 class="auth-title">Welcome back</h1>

                <asp:Panel ID="pnlSuccess" runat="server" Visible="false" CssClass="alert alert-success" style="margin-bottom:1.25rem;">
                    Account created! You can now log in.
                </asp:Panel>

                <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="alert alert-danger" style="margin-bottom:1.25rem;">
                    <asp:Label ID="lblError" runat="server"></asp:Label>
                </asp:Panel>

                <div class="form-group">
                    <label class="form-label" for="<%= txtLogin.ClientID %>">Email or username</label>
                    <asp:TextBox ID="txtLogin" runat="server" CssClass="form-control" placeholder="aldo@example.com" MaxLength="100"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvLogin" runat="server" ControlToValidate="txtLogin"
                        ErrorMessage="Email or username is required." CssClass="validation-message" Display="Dynamic" />
                </div>

                <div class="form-group">
                    <label class="form-label" for="<%= txtPassword.ClientID %>">Password</label>
                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="••••••••" MaxLength="100"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword"
                        ErrorMessage="Password is required." CssClass="validation-message" Display="Dynamic" />
                </div>

                <div class="form-group">
                    <label class="form-check">
                        <asp:CheckBox ID="chkRemember" runat="server" />
                        <span>Remember me</span>
                    </label>
                </div>

                <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn btn-primary btn-block"
                    OnClick="btnLogin_Click" />

                <p style="margin-top:1.25rem; text-align:center; color:var(--color-text-muted); font-size:0.9375rem;">
                    No account yet? <a href="Register.aspx">Register</a>
                </p>

            </div>
        </div>

        <footer class="footer">
            <div style="display:flex; justify-content:space-between; align-items:flex-start; flex-wrap:wrap; gap:1rem;">
                <div>
                    <p class="footer-brand">HackEd</p>
                    <p style="color:var(--color-text-muted); font-size:0.875rem; margin-top:0.25rem;">Structured cybersecurity learning with integrated CTF simulation.</p>
                </div>
                <nav class="footer-links">
                    <a href="Training/ModuleListing.aspx">Training</a>
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
