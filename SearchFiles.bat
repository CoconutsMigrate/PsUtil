@echo off
title Search Files
SET mypath=%~dp0
powershell.exe -Command %mypath:~0,-1%\seachFiles.ps1 "%1 %2 %3 %4 %5 %6 %7 %8 %9"
