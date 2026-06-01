<%@ Page Language="C#" AutoEventWireup="true" CodeFile="About.aspx.cs" Inherits="About" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>About – HackEd</title>
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
                <li><a href="~/FAQ.aspx" runat="server" class="navbar-link">FAQ</a></li>
                <li><a href="~/About.aspx" runat="server" class="navbar-link active">About</a></li>
            </ul>
        </nav>

        <main class="container section">

            <div class="page-header">
                <h1 class="page-title">About HackEd</h1>
                <p style="color:var(--color-text-muted);">A learning platform built around CTF challenges.</p>
            </div>

            <div class="card" style="max-width:820px; margin-bottom:var(--space-8);">
                <h2 class="card-title">Mission</h2>
                <p class="card-text">
                    HackEd pairs short training modules with CTF challenges on the same topic, so you can read about something and try it right after. We built it for our Web Apps module — the idea was one place where the theory and the hands-on practice live together instead of in two separate tabs.
                </p>
            </div>

            <div class="card" style="max-width:820px; margin-bottom:var(--space-8);">
                <h2 class="card-title">What you can do</h2>
                <ul class="card-text" style="line-height:2;">
                    <li>Read training modules grouped by topic and difficulty</li>
                    <li>Take on CTF challenges across web, crypto, forensics, OSINT and more</li>
                    <li>Create or join a team and compete together</li>
                    <li>Track your score (and your team's) on a live scoreboard</li>
                    <li>Catch platform news and writeups on the blog and announcements pages</li>
                </ul>
            </div>

            <div class="card" style="max-width:820px; margin-bottom:var(--space-8);">
                <h2 class="card-title">Tech Stack</h2>
                <ul class="card-text" style="line-height:2;">
                    <li>Frontend: HTML, CSS, JavaScript</li>
                    <li>Backend: ASP.NET Web Forms (C#, .NET 4.8)</li>
                    <li>Database: SQL Server LocalDB</li>
                    <li>Dev: Visual Studio 2022, Git</li>
                </ul>
            </div>

            <div class="card" style="max-width:820px;">
                <h2 class="card-title">The Team</h2>
                <p class="card-text">HackEd was built by Group 24, Tutorial 3, intake APD2F2509CS(CYB), for the Web Applications (CT050-3-2-WAPP) module at Asia Pacific University of Technology and Innovation.</p>
                <ul class="card-text" style="line-height:2;">
                    <li>Hansen Nicholas Can (TP075390) | Group Leader, Training Modules</li>
                    <li>Archie Nicholaus Yiedri (TP081430) | Auth, Dashboards, User Management</li>
                    <li>Aldo Lim Saputra (TP078139) | CTF Challenges, Flag Submission, Admin Challenge Management</li>
                    <li>Darren Elsington (TP079965) | Blog, News, Announcements, FAQ, About, Admin Content Management</li>
                </ul>
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
