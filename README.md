# SysGuard — Portfolio Website

A premium, single-page portfolio site for **SysGuard: Linux System Health & Alert Manager** — a Bash-based Unix Lab project that monitors CPU, memory, disk, network, and uptime, then colour-codes the result and writes a report.

Built with plain **HTML5, CSS3, and vanilla JavaScript** — no frameworks, no build step, no backend. Works by simply opening `index.html`, and is ready to deploy on GitHub Pages as-is.

## 🗂️ Structure

```
.
├── index.html      # All page markup and content
├── style.css       # Design tokens, layout, components, animations
├── script.js       # Scroll reveal, particles, nav, ripple, copy button
├── assets/         # Reserved for real screenshots / icons
│   └── icons/
└── README.md
```

## 🎨 Design system

- **Palette** — dark terminal-navy base (`#0a0e14`) with the project's own ANSI status colours as accents: green `#29d398` (healthy), yellow `#f2c94c` (moderate), red `#ff5c72` (critical), plus a cool blue `#5b8def` for informational elements.
- **Type** — `JetBrains Mono` for headings and data (nods to the terminal-first nature of the tool), `Inter` for body copy.
- **Signature element** — the hero's mini terminal readout mirrors the actual `sysguard.sh` health-report output.

## 🚀 Run locally

No install required:

```bash
git clone <this-repo>
cd sysguard-portfolio
open index.html      # or just double-click it
```

## 📤 Deploy to GitHub Pages

1. Push this folder to a repository.
2. In **Settings → Pages**, set the source to the `main` branch, root folder.
3. Your site will be live at `https://<username>.github.io/<repo>/`.

## 🖼️ Swapping in real screenshots

Replace the placeholder frames in the **Screenshots** section (`#screenshots` in `index.html`) with `<img>` tags pointing at files inside `assets/` once you have real terminal captures.

## 📝 License

MIT — same as the underlying SysGuard project.
