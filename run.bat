@echo off
setlocal
echo =======================================================
echo    Starting Gemini Computer Use Agent...
echo =======================================================

rem --- 自动查找虚拟环境（优先本项目 .venv，其次上级目录 .venv）---
set "VENV_PY="
if exist "%~dp0.venv\Scripts\python.exe" set "VENV_PY=%~dp0.venv\Scripts\python.exe"
if not defined VENV_PY if exist "%~dp0..\.venv\Scripts\python.exe" set "VENV_PY=%~dp0..\.venv\Scripts\python.exe"

if not defined VENV_PY (
    echo [ERROR] 未找到虚拟环境 .venv
    echo 请先在项目目录创建并安装依赖：
    echo     python -m venv .venv
    echo     .venv\Scripts\python.exe -m pip install -r backend\requirements.txt
    pause
    exit /b 1
)

echo Using virtual environment: %VENV_PY%
echo.

echo [1/2] Starting FastAPI Backend on port 8000...
start "Gemini Agent - Backend" cmd /k "cd /d "%~dp0backend" & %VENV_PY% -m pip install -r requirements.txt & %VENV_PY% -m uvicorn main:app --host 127.0.0.1 --port 8000"

echo [2/2] Starting React Frontend on port 5173...
start "Gemini Agent - Frontend" cmd /k "cd /d "%~dp0frontend" & npm install & npm run dev"

echo.
echo Both services are starting up in separate windows!
echo Once they are ready, you can access the UI at:
echo http://localhost:5173
echo.
pause
