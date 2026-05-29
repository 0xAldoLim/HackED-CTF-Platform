# HackEd CTF

HackEd CTF is a web-based cybersecurity learning system with integrated Capture the Flag learning features. The platform is planned to help users learn cybersecurity concepts through structured training modules, practical challenges, team participation, score tracking, and supporting learning content.

## Read This First Before Proceeding

This repository is for implementation only. Before building any page, team members must read the CSS style guide and use the shared global CSS from:

`src/HackEdCTF.Web/wwwroot/css/site.css`

Do not create separate page styling that ignores the shared theme. Use the provided classes for layout, buttons, cards, forms, tables, badges, modals, filters, navbar, and footer.

Keep the website visually consistent with the HackEd Figma wireframe and brand theme. The Figma reference is:

`https://www.figma.com/design/PQ137oFeiHKgabeI4XLMH6/HackEd?node-id=14-2&t=RjB7PnhA0zh8kgaZ-1`

This shared CSS is the main design compass for the team. The purpose is to prevent every teammate from creating a visually different webpage design. Main should stay stable, but this specific CSS foundation belongs in main because everyone needs it.

## Main Planned Features

- Training modules divided into Beginner, Advanced, and Expert levels
- CTF challenges divided into Easy, Medium, and Hard difficulties
- User registration and login
- Player dashboard
- Admin dashboard
- Team creation and joining
- Scoreboard
- Official writeups
- Blog or announcement content
- Cybersecurity news updates
- FAQ page
- Builder/about page

## Wireframe on Figma

- https://www.figma.com/design/PQ137oFeiHKgabeI4XLMH6/HackEd?node-id=14-2&t=RjB7PnhA0zh8kgaZ-1

## Planned Technology Stack

- Backend: ASP.NET Core / .NET
- Frontend: HTML5, CSS, JavaScript, Razor Pages or MVC depending on later decision
- Database: MS SQL Server
- Version control: Git and GitHub

## Team Members

- Aldo
- Hansen
- Archie
- Darren

## Repository Structure

- `src/` - Main application source code will be placed here later.
- `src/HackEdCTF.Web/` - Placeholder for the future ASP.NET Core web application project.
- `src/HackEdCTF.Web/wwwroot/css/site.css` - Shared global CSS system for the HackEd interface.
- `src/HackEdCTF.Web/wwwroot/css/STYLE_GUIDE.md` - Styling rules for all team members.
- `database/` - Future database planning and implementation files for schema and seed data.
- `assets/` - Future implementation assets such as images, icons, and wireframes.
- `tests/` - Future automated test projects and test-related files.

This repository is for program implementation only. Documentation, reports, meeting notes, and assignment writing are handled outside this repository.

## Branch Workflow

- `main` is the stable branch.
- Each team member works on their own branch:
  - `aldo`
  - `hansen`
  - `archie`
  - `darren`
- Changes should be merged into `main` only after review and testing.

## Current Status

This repository currently contains only implementation placeholders and no actual application code yet.
