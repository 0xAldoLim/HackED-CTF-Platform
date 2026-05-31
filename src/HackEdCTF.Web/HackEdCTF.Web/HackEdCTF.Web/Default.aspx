<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>HackEd – Structured Cybersecurity Learning</title>
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
                <li><a href="Default.aspx" class="navbar-link active">Home</a></li>
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

        <%-- ===== HERO ===== --%>
        <section class="container section">
            <div class="split-layout">

                <%-- Left: text + buttons --%>
                <div>
                    <h1 style="font-family:var(--font-heading); font-size:clamp(2rem,5vw,3.25rem); font-weight:800; line-height:1.1; color:var(--color-text-strong); margin-bottom:var(--space-5);">
                        Structured learning.<br />Real hacking skills.
                    </h1>
                    <p style="color:var(--color-text-muted); font-size:1.0625rem; max-width:480px; margin-bottom:var(--space-10);">
                        Hands-on training paths, realistic challenges, news, teams,
                        and leaderboards for cybersecurity learners.
                    </p>
                    <div style="display:flex; gap:var(--space-4); flex-wrap:wrap;">
                        <a href="Register.aspx" class="btn btn-primary">Start Learning</a>
                        <a href="Challenges/Index.aspx" class="btn btn-secondary">Explore Challenges</a>
                    </div>
                </div>

                <%-- Right: terminal --%>
                <div class="terminal-panel" style="transition: transform 0.2s ease, box-shadow 0.2s ease; cursor:default;"
                     onmouseover="this.style.transform='translateY(-4px)'; this.style.boxShadow='0 8px 32px rgba(0,255,163,0.15)'"
                     onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow=''">
                    <div class="terminal-label">TERMINAL</div>
                    <div style="background:rgba(11,16,32,0.8); border:1px solid var(--color-border); border-radius:var(--radius-md); padding:var(--space-5); font-family:var(--font-code); line-height:2;">
                        <p style="margin:0;">&gt; nmap -sV hacked.local</p>
                        <p style="margin:0;">&gt; gobuster dir -u /training</p>
                        <p style="margin:0;">[+] Lesson unlocked: Web Basics</p>
                        <p style="margin:0;">[+] CTF practice ready</p>
                    </div>
                </div>

            </div>
        </section>

        <%-- ===== INTRO ===== --%>
        <section class="container section">
            <h2 style="font-family:var(--font-heading); font-size:1.5rem; font-weight:700; color:var(--color-text-strong); margin-bottom:var(--space-3);">
                Short platform introduction
            </h2>
            <p style="color:var(--color-text-muted); max-width:700px; margin-bottom:var(--space-8);">
                HackEd combines structured modules with CTF simulation so students can
                learn, practice, submit flags, join teams, and track progress in one
                clean ASP.NET web app.
            </p>

            <%-- Feature cards --%>
            <div class="card-grid" style="margin-bottom:var(--space-10);">
                <div class="feature-card">
                    <h3 class="card-title">Training</h3>
                    <p class="card-text">Guided modules by level</p>
                </div>
                <div class="feature-card">
                    <h3 class="card-title">CTF Challenges</h3>
                    <p class="card-text">Category-based flags and hints</p>
                </div>
                <div class="feature-card">
                    <h3 class="card-title">Blog</h3>
                    <p class="card-text">News, updates, and writeups</p>
                </div>
                <div class="feature-card">
                    <h3 class="card-title">Team</h3>
                    <p class="card-text">Create or join a squad</p>
                </div>
                <div class="feature-card">
                    <h3 class="card-title">Scoreboard</h3>
                    <p class="card-text">Individual and team ranks</p>
                </div>
            </div>

            <%-- Stats row --%>
            <div class="dashboard-grid">
                <div class="stat-card">
                    <span class="stat-value">1,250+</span>
                    <span class="stat-label">Students</span>
                </div>
                <div class="stat-card">
                    <span class="stat-value">4,300+</span>
                    <span class="stat-label">Challenges</span>
                </div>
                <div class="stat-card">
                    <span class="stat-value">950+</span>
                    <span class="stat-label">Completions</span>
                </div>
                <div class="stat-card">
                    <span class="stat-value">12K+</span>
                    <span class="stat-label">Community</span>
                </div>
            </div>
        </section>

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