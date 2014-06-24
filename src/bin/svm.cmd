@echo off

PowerShell -NoProfile -NoLogo -ExecutionPolicy Unrestricted -Command "& '%~dp0svm.ps1' %*"
