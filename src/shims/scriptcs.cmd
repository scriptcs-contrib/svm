@echo off

PowerShell -NoProfile -NoLogo -ExecutionPolicy Unrestricted -Command "& '%~dp0scriptcs-script.ps1' -- %*"
EXIT /B %ERRORLEVEL%