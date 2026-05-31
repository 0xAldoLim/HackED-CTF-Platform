<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FAQ.aspx.cs" Inherits="FAQ" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>FAQ – HackEd</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous" />
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;700;800&family=Inter:wght@400;700&family=JetBrains+Mono:wght@400;700&display=swap" rel="stylesheet" />
    <link href="~/css/site.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">

        <nav class="navbar">
            <a href="~/Default.aspx" runat="server" class="navbar-brand">
                <img src="white.png" alt="HackEd" class="navbar-logo" />
            </a>
            <ul class="navbar-menu">
                <li><a href="~/Default.aspx" runat="server" class="navbar-link">Home</a></li>
                <li><a href="~/Training/ModuleListing.aspx" runat="server" class="navbar-link">Training</a></li>
                <li><a href="~/Challenges/Index.aspx" runat="server" class="navbar-link">Challenges</a></li>
                <li><a href="~/Scoreboard.aspx" runat="server" class="navbar-link">Scoreboard</a></li>
                <li><a href="~/Blog/Index.aspx" runat="server" class="navbar-link">Blog</a></li>
                <li><a href="~/FAQ.aspx" runat="server" class="navbar-link active">FAQ</a></li>
                <li><a href="~/About.aspx" runat="server" class="navbar-link">About</a></li>
            </ul>
        </nav>

        <main class="container section">

            <div class="page-header">
                <h1 class="page-title">FAQ</h1>
                <p style="color:var(--color-text-muted);">Quick answers to the stuff people ask most.</p>
            </div>

            <div class="stack" style="margin-bottom:var(--space-8);">

                <div class="card">
                    <h3 class="card-title">How do I make an account?</h3>
                    <p class="card-text">Hit <strong>Register</strong> up top, pick a username, email, and password. You're in straight after.</p>
                </div>

                <div class="card">
                    <h3 class="card-title">Where do I start as a beginner?</h3>
                    <p class="card-text">Open <strong>Training</strong> and grab any beginner module. Each one comes with a matching challenge so you can try the thing right after reading about it.</p>
                </div>

                <div class="card">
                    <h3 class="card-title">What's the flag format?</h3>
                    <p class="card-text">Usually <code>HackEd{...}</code>, but check the challenge brief — submit exactly what it says.</p>
                </div>

                <div class="card">
                    <h3 class="card-title">Do hints cost points?</h3>
                    <p class="card-text">Yeah, each one shaves off a few points. The cost shows before you reveal it.</p>
                </div>

                <div class="card">
                    <h3 class="card-title">How do teams work?</h3>
                    <p class="card-text">Create one or join from your <strong>Team</strong> page. Solves count toward both your personal score and the team's.</p>
                </div>

                <div class="card">
                    <h3 class="card-title">How often does the scoreboard update?</h3>
                    <p class="card-text">Live — every correct flag bumps it. Just refresh to see the latest.</p>
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
                    <a href="~/FAQ.aspx" runat="server">FAQ</a>
                    <a href="~/About.aspx" runat="server">About</a>
                </nav>
            </div>
        </footer>

    </form>
</body>
</html>
