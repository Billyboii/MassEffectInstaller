REM Set Window Parameters ----------------------------------
@echo off
mode con: cols=220 lines=60
nircmd win center ititle "cmd.exe"

REM Initialize and Set Variables ---------------------------
set URL=https://download.microsoft.com/download/1/7/5/175E764B-E417-4FBB-95DF-62676FC7B2EA/NDP462-KB3120735-x86-x64-AllOS-ENU.exe
set center=                                                                         
set operation=Downloading
set output=.NET Framework 4.6.2...
set fname=NDP462-KB3120735-x86-x64-AllOS-ENU
set fnameext=.exe
set BASHinstalled=no
set NETinstalled=no
set Powershellinstalled=no

REM Check if Necesarry Programs are installed---------------


REM Run Commands--------------------------------------------
start "" /b "dance.bat"
start "" /b "download.bat"
bash -c "sleep 0.035"
GOTO :EOF
EXIT

:checkBASH
if exist "C:\Windows\System32\bash.exe" (
echo BASH is installed.