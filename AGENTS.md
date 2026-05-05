# AGENTS.md — WK Rotor Control

## What this is

A single-file desktop web app (HTML/CSS/JS + Canvas) packaged for Windows via **pywebview** (Edge WebView2). It is **not** a client-server app; Python only opens a native window that loads `index.html` from disk.

## Repo layout

```
yaesu-g600-controller/
├── app.py              # Launcher: pywebview window, no web server
├── index.html          # Single-page UI
├── css/style.css       # Dark theme, Orbitron/Share Tech Mono fonts
├── js/app.js           # Canvas compass, display updates, events
├── js/rotor.js         # GS-232 protocol, simulation, Web Serial API
├── start.bat           # Dev run: create venv, install, launch
├── build.bat           # Build dist/WKRotorControl.exe
├── requirements.txt
└── assets/             # Optional map image (map.png/jpg/jpeg)
```

## Developer commands

| Task | Command |
|------|---------|
| Run from source | `start.bat` or `.venv\Scripts\python app.py` |
| Build `.exe` | `build.bat` |
| Rebuild exe manually | `.venv\Scripts\python -m PyInstaller --onefile --windowed --name "WKRotorControl" --icon "assets/app_icon.ico" --add-data "index.html;." --add-data "css;css" --add-data "js;js" --hidden-import webview --hidden-import pythonnet --hidden-import clr_loader --hidden-import cffi --hidden-import fitz --hidden-import PIL --hidden-import PIL._imaging app.py` |

The PyInstaller command is the only non-obvious step; `build.bat` wraps it.

## Architecture gotchas

- **No HTTP server.** `app.py` calls `webview.create_window('index.html', ...)`. The UI runs at `file://` inside WebView2.
- **Serial hardware:** The frontend (`js/rotor.js`) talks to the rotator via the **Web Serial API**, which works inside WebView2/Edge. The Python side knows nothing about serial ports.
- **Simulation fallback:** If no serial port is connected, `rotor.js` runs a 50 ms timer that simulates azimuth movement. The app is fully usable without hardware.
- **Python 3.14 compat:** `pythonnet>=3.1.0rc0` is required because stable `pythonnet` wheels do not support CPython 3.14 yet.
- **NS6T map generation:** Uses PyMuPDF (`fitz`) + Pillow for PDF→PNG conversion.

## Build requirements

- Windows 10/11 with Edge WebView2 Runtime (pre-installed on updated systems)
- Python 3.x + venv
- PyInstaller bundles `index.html`, `css/`, and `js/` as data files; forgetting `--add-data` breaks the exe.

## Style / workflow notes

- The UI is intentionally left as-is unless the user explicitly asks to change it. The user has previously requested: *"non modificare l'app va bene cosi come interfaccia e funzioni."*
- There are **no tests, no lint config, no CI.** Verify by running the app or the exe directly.
- Map assets are optional; the canvas draws a stylized fallback world map if none is provided.
