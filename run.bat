@echo off
setlocal
echo =======================================================
echo    Starting Gemini Computer Use Agent...
echo =======================================================

rem --- Write debug log so we can tell if this script actually ran ---
echo %date% %time% > "%~dp0run_debug.log"

rem --- Auto-detect virtual environment (project .venv first, then parent) ---
set "VENV_PY="
if exist "%~dp0.venv\Scripts\python.exe" set "VENV_PY=%~dp0.venv\Scripts\python.exe"
if not defined VENV_PY if exist "%~dp0..\.venv\Scripts\python.exe" set "VENV_PY=%~dp0..\.venv\Scripts\python.exe"

if not defined VENV_PY (
    echo [ERROR] Virtual environment .venv not found.
    echo Create one first:
    echo     python -m venv .venv
    echo     .venv\Scripts\python.exe -m pip install -r backend\requirements.txt
    pause
    exit /b 1
)

echo Using virtual environment: %VENV_PY% >> "%~dp0run_debug.log"
echo Using virtual environment: %VENV_PY%
echo.

echo [1/2] Starting FastAPI Backend on port 8000...
start "Gemini Agent - Backend" cmd /k "cd /d "%~dp0backend" & %VENV_PY% -m uvicorn main:app --host 127.0.0.1 --port 8000"

echo [2/2] Starting React Frontend on port 5173...
start "Gemini Agent - Frontend" cmd /k "cd /d "%~dp0frontend" & npm run dev"

echo.
echo Both services are starting up in separate windows!
echo Waiting for services to come up, then opening browser...

rem --- Give services time to start, then auto-open the dashboard ---
timeout /t 20 /nobreak > nul
start "" http://localhost:5173

echo.
echo If the browser did not open, visit manually:
echo   Backend : http://127.0.0.1:8000
echo   Frontend: http://localhost:5173
echo.
pause
