# HackEd CSS Style Guide

All team members must use `site.css` before creating custom CSS. The shared file is the visual foundation for HackEd and should be treated as the design compass for every page.

## Rules

- Do not hardcode random colors. Use the CSS variables in `site.css`.
- Use the existing layout, button, card, form, table, badge, modal, navbar, footer, filter, and dashboard classes first.
- Create new CSS only when no reusable class already solves the layout or component need.
- Keep page designs aligned with the HackEd Figma wireframe and dark cybersecurity SaaS brand theme.
- Use the navbar and footer consistently across public, authenticated, and admin pages.
- Use modal styling for CTF challenge details and flag submission where possible.
- Use the difficulty badge classes consistently: `.badge-easy`, `.badge-medium`, `.badge-hard`, `.badge-beginner`, `.badge-advanced`, and `.badge-expert`.
- Use category badge classes consistently for challenge types: `.badge-web`, `.badge-crypto`, `.badge-forensics`, `.badge-osint`, `.badge-reverse`, `.badge-pwn`, and `.badge-misc`.
- Use `.filter-pill` and `.filter-pill.active` for category and difficulty filters.
- Use `.table`, `.crud-table`, `.scoreboard-table`, and `.table-wrapper` for admin CRUD and scoreboard pages.
- Use `.stat-card`, `.progress-card`, `.dashboard-grid`, and `.quick-link-card` for dashboard pages.
- Extend the existing design system when new styling is needed. Do not replace it with a separate page theme.
- Before creating a new page, check whether an existing class already handles the needed layout, component, or state.

## Shared CSS Path

Use this file on every page:

```text
src/HackEdCTF.Web/wwwroot/css/site.css
```
