@echo off
setlocal
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0bsl-lint.ps1" %*
exit /b %ERRORLEVEL%
