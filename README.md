# WK Rotor Control

App universale per gestire il rotore d'antenna **Yaesu G-600** e compatibili. Interfaccia replica del controller originale con bussola azimuthale, generazione mappa NS6T e supporto Web Serial API.

## Avvio rapido

### Eseguibile standalone (consigliato)
Vai nella cartella `dist` e fai doppio clic su **`WKRotorControl.exe`**.  
Non richiede Python né browser installati: usa il motore **Edge WebView2** integrato in Windows 10/11.

### Avvio da sorgenti
Clicca doppio su **`start.bat`** oppure apri `index.html` in Chrome / Edge / Firefox.

## Struttura

```
yaesu-g600-controller/
├── dist/
│   └── WKRotorControl.exe   # Eseguibile standalone (Windows)
├── start.bat                      # Avvio rapido da sorgenti
├── build.bat                      # Rigenera l'eseguibile
├── index.html                     # Interfaccia utente
├── css/
│   └── style.css                  # Stili tema scuro + font tecnici
├── js/
│   ├── rotor.js                   # Logica protocollo + simulazione
│   └── app.js                     # Canvas bussola + eventi UI
├── assets/
│   └── README.txt                 # Istruzioni per la mappa
└── README.md
```

## Come inserire la tua mappa

1. Salva la tua immagine (quadrata, es. 800x800 o superiore) in una di queste posizioni:
   - `assets/map.png`
   - `assets/map.jpg`
   - `assets/map.jpeg`
2. Ricarica la pagina (`F5`).
3. L’app ritaglia automaticamente il **cerchio del quadrante** dalla foto quadrata.

Se non carichi nessuna immagine, la bussola mostra una mappa stilizzata di fallback.

## Funzionalità

- **Bussola animata** con mappa del mondo (custom o fallback), aghi e scala 0-360°
- **Display Target / Current** in tempo reale con font digitale
- **Regolazione fine** (-10, -5, +5, +10)
- **GO / STOP** per avviare o fermare la rotazione
- **Preset rapidi**: 0, 45, 90, 135, 180, 225, 270, 315, 360, Park
- **Simulazione** integrata (funziona anche senza hardware)
- **Supporto seriale reale** via Web Serial API (Chrome/Edge/WebView2):
  - Seleziona COM e BAUD
  - Pulsante ON/OFF con LED
  - Protocollo GS-232 semplificato (`Mxxx`, `S`, `+xxx`)

## Comandi da tastiera

| Tasto | Azione |
|-------|--------|
| `Invio` | GO |
| `Spazio` | STOP |

## Protocollo seriale (GS-232)

L'app invia comandi compatibili con interfaccia GS-232:

| Comando | Azione |
|---------|--------|
| `Mxxx`  | Muovi ad azimuth `xxx` (0-360) |
| `S`     | Stop immediato |

In ricezione si attende una riga tipo `+0140` che indica l’heading attuale.

## Note

- L’eseguibile standalone richiede **Edge WebView2 Runtime** (presente di default su Windows 10/11 aggiornati).
- La comunicazione seriale richiede un browser/motore che supporti la **Web Serial API** (Chrome 89+, Edge 89+, WebView2).
- In assenza di porta seriale, l’app funziona in **modalità simulata** per testare l’interfaccia.
- Per usare COM fisici su Windows potrebbe essere necessario un adattatore USB-Serial con driver installati.

---
Progetto WK Rotor Control.
