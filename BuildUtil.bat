@echo off
SET mypath=%~dp0
echo %mypath:~0,-1%
powershell.exe -Command %mypath:~0,-1%\BuildUtil.ps1 "%1 %2 %3 %4 %5 %6 %7 %8 %9"
