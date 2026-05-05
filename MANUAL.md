# WK Rotor Control — User Manual

## 1. Overview

WK Rotor Control is a desktop application for pointing Yaesu G-600 (and compatible) antenna rotators. It communicates with the rotator using the **GS-232** serial protocol and runs as a self-contained native Windows window — no web browser required.

When no hardware is connected, the app runs in **simulation mode**, letting you explore all functions without a rotator. The compass display can show your actual azimuth heading overlaid on a custom map or an NS6T-generated azimuthal projection.

## 2. System Requirements

- **Windows 10 or Windows 11** (64-bit)
- **Edge WebView2 Runtime** — pre-installed on updated systems; if missing, the app will prompt you to install it
- A **USB-to-serial adapter** if connecting to a physical rotator (the Yaesu G-600 uses RS-232)
- No installation required for the standalone `.exe`

## 3. Installation

### Option A — Standalone executable (recommended)

1. Download `WKRotorControl.exe`.
2. Double-click to run. That's it.

The `.exe` is a portable, self-contained file. You can place it anywhere — Desktop, USB drive, etc. No install wizard, no registry changes.

### Option B — Run from source

1. Install **Python 3.x** from [python.org](https://www.python.org/downloads/) (ensure "Add Python to PATH" is checked).
2. Open a terminal in the app folder and run `start.bat`.

The script creates a virtual environment, installs dependencies (`pywebview`, `PyMuPDF`, `Pillow`), and launches the app.

## 4. Interface Guide

The main window is a single panel (620 × 950 px default, resizable) with a dark theme and the following elements, top to bottom:

### Title bar (top)
- **App title** — Displays *WK Rotor Control* by default. Click the title text to rename it. The custom name persists across restarts.
- **COM port selector** — Dropdown listing COM1 through COM10. Select the port your USB-serial adapter appears as.
- **Baud rate selector** — Dropdown with 1200, 2400, 4800, 9600 (default), 19200, and 38400 baud.
- **Power button** — Toggles the rotator power state. Label reads **ON** (green) or **OFF** (grey). The adjacent **LED** indicator glows green when powered on.

### Locator row
- **LOCATOR input** — Text field for a Maidenhead grid locator (e.g. `JN61fv`). Maximum 6 characters.
- **GENERATE MAP button** — Fetches and renders an azimuthal map centered on the entered locator from NS6T.net. Available only in the desktop app.

### Compass display
- **Canvas** — Large circular compass showing the current heading via a yellow needle. When a map is loaded, it appears in the background; otherwise a stylized world map is drawn as a fallback.
- **+ overlay** — Appears when no map is loaded. Click it to upload a map image (PNG, JPG) or a PDF.
- **Double-click** the compass to **clear** the current map and show the upload overlay again.
- **Drag and drop** — You can drag an image or PDF file directly onto the compass to upload it.

### Readouts
- **TARGET** — Orange text showing the desired azimuth (000–360°).
- **CURRENT** — Large yellow digital readout showing the actual heading in real time.

### Step buttons
- Four buttons: **-10**, **-5**, **+5**, **+10**. Each adjusts the target azimuth by that increment. If power is on, the rotator begins moving immediately.

### Action buttons
- **GO** — Starts rotation toward the current target azimuth.
- **STOP** — Halts rotation immediately. The current position becomes the new target.

### Preset panel
A 5×2 grid of quick-launch heading buttons: **0°, 45°, 90°, 135°, 180°, 225°, 270°, 315°, 360°**, plus a **Park** button pointing the antenna to 0°.

### Footer
- Link to **IU2VWK.com** and a copyright notice.

## 5. Generating Azimuthal Maps

The app can generate an azimuthal projection map centered on your station's location via **NS6T.net**:

1. Enter your **Maidenhead grid locator** in the LOCATOR field (e.g. `JN61fv`).
2. Click **GENERATE MAP**.
3. The app sends a request to NS6T.net, receives a PDF, converts it to a high-resolution PNG, and displays it inside the compass circle.
4. The map is saved to disk and will be restored automatically the next time you launch the app.
5. A spinner appears during generation. Large maps may take a few seconds.

> **Note:** Map generation requires the desktop app (`WKRotorControl.exe` or `start.bat`). It will not work if you open `index.html` directly in a web browser, because the browser lacks the Python bridge for PDF conversion.

## 6. Uploading Custom Maps

You can use your own azimuthal map image instead of the NS6T-generated one:

- **Click the +** in the center of the compass and select a file.
- **Drag and drop** a file directly onto the compass area.

Supported formats:
- **PNG, JPG, JPEG** — Loaded directly.
- **PDF** — Converted to PNG on the fly (requires PyMuPDF, included in the packaged app).

To remove a custom map, **double-click** anywhere on the compass.

## 7. Serial Connection

To control a physical rotator via the Web Serial API:

1. Plug in your USB-to-serial adapter (e.g. FTDI, CH340, or the Yaesu-supplied cable).
2. Open **Device Manager** → **Ports (COM & LPT)** and note the assigned COM port.
3. In the app, select the matching **COM** port and the correct **baud rate** (consult your rotator manual — the G-600 default is typically 9600).
4. Click the **Power** button. The app will prompt for serial port permission via the browser-backed Web Serial API.
5. The app sends GS-232 commands (`Mxxx` to set heading, `S` to stop) and reads responses (`+0xxx` for current azimuth).

Supported baud rates: **1200, 2400, 4800, 9600, 19200, 38400**.

The Web Serial API works natively in Edge WebView2 (used by the `pywebview` wrapper). No driver installation is needed beyond the standard USB-serial adapter driver.

## 8. Simulation Mode

When no serial port is connected (or when Power is toggled without a COM port), the app runs a simulation:

- A 50 ms timer updates the heading at a rate of **1.2° per tick (24°/sec)**.
- The needle moves smoothly toward the target and stops without overshoot.
- All UI controls — step, preset, GO, STOP — work identically to hardware mode.
- This lets you test workflows, practice operation, or demo the app without a rotator.

Simulation is always active. Connecting serial hardware automatically overlays real data while keeping the simulation running as a UI driver.

## 9. Keyboard Shortcuts

| Key       | Action |
|-----------|--------|
| **Enter** | GO — starts rotation toward the target |
| **Space** | STOP — halts rotation immediately |

Pressing Enter while focused in the locator field will trigger map generation instead.

## 10. Troubleshooting

| Problem | Likely Cause & Solution |
|---------|--------------------------|
| App doesn't start (`python not found`) | Install Python 3.x and ensure "Add Python to PATH" is checked during installation. |
| `WebView2 not found` error | Download and install the **Edge WebView2 Runtime** from Microsoft (Evergreen Standalone Installer). |
| "Web Serial API not supported" | This message appears when opening `index.html` in a non-Edge/Chrome browser. Run the `.exe` (it uses Edge WebView2 internally). |
| Serial port not listed | Open Device Manager, verify the adapter appears under "Ports (COM & LPT)". Install the manufacturer's driver if missing. |
| Rotator doesn't respond | Confirm the correct COM port and baud rate are selected. Check that the cable is wired correctly (the Yaesu G-600 uses TTL-level RS-232; a level converter may be needed). |
| Map generation fails | Check your internet connection. NS6T.net must be reachable. Verify the locator format (4–6 characters, e.g. `JN61fv`). |
| "Cannot convert PDF" alert | The packaged `.exe` includes PyMuPDF. If running from source, ensure `pymupdf` is installed (`pip install pymupdf`). |
| Map doesn't persist | Ensure `assets/yaesu_map.b64` is writable. The app saves there when running as `.exe` or via `start.bat`. |
| Window is too small | Resize the window by dragging its edges; the layout adapts. |

For further help, visit [IU2VWK.com](https://iu2vwk.com).

## 11. Credits

- **Author:** IU2VWK — [iu2vwk.com](https://iu2vwk.com)
- **Map generation:** Powered by [NS6T.net](https://ns6t.net) azimuthal map service
- **PDF conversion:** PyMuPDF (Artifex MuPDF)
- **Desktop wrapper:** [pywebview](https://pywebview.flowrl.com/) + Edge WebView2
- **Fonts:** Orbitron (The League of Moveable Type), Share Tech Mono (Carrois Apostrophe)

---

&copy; 2026 IU2VWK — All rights reserved.
