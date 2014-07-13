@echo off

PowerShell -NoProfile -NoLogo -ExecutionPolicy Unrestricted -Command "& '%~dp0scriptcs.ps1' %*"
