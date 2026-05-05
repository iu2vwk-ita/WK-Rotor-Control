@echo off
chcp 65001 >nul
echo ================================================
echo   WK Rotor Control
echo ================================================
echo.

REM Verifica Python
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERRORE] Python non trovato.
    echo Installa Python da https://www.python.org/downloads/
    echo Assicurati di spuntare "Add Python to PATH" durante l'installazione.
    echo.
    pause
    exit /b 1
)

echo [OK] Python trovato.
echo.

REM Vai nella cartella dello script
pushd "%~dp0"

REM Crea/attiva venv
if not exist ".venv\Scripts\python.exe" (
    echo [INFO] Creazione ambiente virtuale...
    python -m venv .venv
    if %errorlevel% neq 0 (
        echo [ERRORE] Impossibile creare venv. Provo installazione globale...
        goto GLOBAL_INSTALL
    )
)

set PYTHON=.venv\Scripts\python.exe
set PIP=.venv\Scripts\pip.exe
goto INSTALL_DEPS

:GLOBAL_INSTALL
set PYTHON=python
set PIP=pip

:INSTALL_DEPS
echo [INFO] Installazione / aggiornamento dipendenze...
%PIP% install -r requirements.txt -q
if %errorlevel% neq 0 (
    echo [ERRORE] Installazione dipendenze fallita.
    pause
    exit /b 1
)

echo [OK] Dipendenze pronte.
echo.
echo ================================================
echo   Avvio app in finestra nativa...
echo ================================================
echo.
%PYTHON% app.py

popd
echo.
pause
