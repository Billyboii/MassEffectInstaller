REM Set Window Parameters ----------------------------------
@echo off
cd /d "%~dp0"
TITLE ME Installation Tool
mode con: cols=221 lines=60
nircmd win center ititle "ME Installation Tool"

REM Initialize and Set Variables ---------------------------
set URL=null
set op=.
set fname=null
set fnameext=null
set Restart=no
set pcbit=null
set os=null
set spacing=          
set spacing2=  
set op2=.
set dance=0
set lc=1

REM Instructions--------------------------------------------
set spacing=                                                            
set spacing2=                              
set op=This program requires .NET Framework 4.0 or higher and Windows Powershell 2.0 or higher to operate.
set op2=The program will now detect if these have been installed on your machine and, if not, will walk you through the installation process. Press any key to continue...
call :clearScreen
pause >nul

set lc=0
set spacing=                                                                                         
set op2=                   

set dance=1
call :clearScreen
start dance.bat

call :checkWindowsVersion
call :checkNET
sleep 1000
set spacing=                                                                                             
call :checkPowershell
sleep 1000
call :cleanup
sleep 1000

nircmd.exe win close ititle "Dance Shepard, dance..."
set dance=0

set spacing=                                                                
set op= All requirements have been met. Press any key to continue with the installation...
call :clearScreen
pause >nul

REM CHOOSE MODULES TO INSTALL

set dance=1
call :clearScreen
start dance.bat

REM INSTALLATION INSTRUCTIONS


REM CLOSE EVERYTHING-----------------------------------------
sleep 1000
nircmd.exe win close ititle "Dance Shepard, dance..."
ENDLOCAL
GOTO :EOF
EXIT

REM ---------------------------------------------------------
:checkBits
IF EXIST "C:\Program Files (x86)" (
	set pcbit=64
) else (
	set pcbit=32
)
call :clearScreen
exit /b

REM ---------------------------------------------------------
:checkWindowsVersion
for /f "tokens=4-5 delims=. " %%i in ('ver') do set VERSION=%%i.%%j
call :clearScreen
exit /b

REM ---------------------------------------------------------
:checkNET
if /I "%version%" EQU "10.0" (
	set op=.NET Framework v.4.6.2 has been installed!
	call :clearScreen
) else (
	reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Client\1033" /v Version >nul 2>&1
	if %ERRORLEVEL% EQU 0 (
		set op=.NET Framework v.4.6.2 has been installed!
		call :clearScreen
	) else (
		set URL=https://download.microsoft.com/download/1/7/5/175E764B-E417-4FBB-95DF-62676FC7B2EA/NDP462-KB3120735-x86-x64-AllOS-ENU.exe
		set fname=NDP462-KB3120735-x86-x64-AllOS-ENU
		set fnameext=.exe
		set op=Downloading .NET Framework 4.6.2...
		call :clearScreen
		call :download
		set op=Installing .NET Framework 4.6.2...
		call :clearScreen
		"%cd%\%fname%%fnameext%"
		rename %fname%%fnameext% %fname%.tmp
		set Restart=yes
	)
)
exit /b

REM ---------------------------------------------------------
:checkPowershell
if /I "%version%" EQU "10.0" (
	set op=Windows Powershell is installed!
	call :clearScreen
) else (
	if exist "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" (
	for /f "skip=3 tokens=2 delims=:" %%A in ('powershell -command "get-host"') do (
		set /a n=!n!+1
		set c=%%A
		if !n!==1 set PSVersion=!c!
		)
		set PSVersion=!PSVersion: =!
		IF /I "%PSVersion%" EQU "5" (
			set op=Windows Powershell is installed!
			call :clearScreen
			sleep 1
		) else (
			call :installPowershell
		)
	) else (
		call :installPowershell
	)
)
exit /b


REM ---------------------------------------------------------
:installPowershell
set op=Downloading Powershell v.5...
call :clearScreen
set fnameext=.msu
set fname=powershelltemp
if /I "%pcbit%" EQU "32" (
	REM Windows 7-------------------------
	if /I "%version%" EQU "6.1" (
		set URL=https://download.microsoft.com/download/2/C/6/2C6E1B4A-EBE5-48A6-B225-2D2058A9CEFB/Win7-KB3134760-x86.msu
		call :download
	)
	REM Windows 8.1-----------------------
	if /I "%version%" EQU "6.3" (
		set URL=https://download.microsoft.com/download/2/C/6/2C6E1B4A-EBE5-48A6-B225-2D2058A9CEFB/Win8.1-KB3134758-x86.msu
		call :download
	)
)
if /I "%pcbit%" EQU "64" (
	REM Windows 7-------------------------
	if /I "%version%" EQU "6.1" (
		set URL=https://download.microsoft.com/download/2/C/6/2C6E1B4A-EBE5-48A6-B225-2D2058A9CEFB/Win7AndW2K8R2-KB3134760-x64.msu
		call :download
	)
	REM Windows 8.1-----------------------
	if /I "%version%" EQU "6.3" (
		set URL=https://download.microsoft.com/download/2/C/6/2C6E1B4A-EBE5-48A6-B225-2D2058A9CEFB/Win8.1AndW2K12R2-KB3134758-x64.msu
		call :download
	)
)
set op=Installing Powershell v.5...
call :clearScreen
"%cd%\%fname%%fnameext%"
rename %fname%%fnameext% %fname%.tmp
set Restart=yes
exit /b

REM ---------------------------------------------------------
:download
curl -# "%URL%" > %fname%.tmp
if errorlevel 0 (
rename %fname%.tmp %fname%%fnameext%
)
if errorlevel 1 (
set op=Download failed. Retrying...
sleep 1
call :download
)


REM ---------------------------------------------------------
:cleanup
set op=Cleaning up temporary files...
del /S *.tmp


REM ---------------------------------------------------------
:clearScreen
cls
type "%cd%\art\logo.txt"
echo(
echo(
echo(
if "%dance%" EQU "1" (
echo(
echo(
echo(
echo(
echo(
echo(
echo(
echo(
echo(
echo(
echo(
echo(
echo(
echo(
echo(
echo(
echo(
echo(
echo(
echo(
echo(
echo(
echo(
)
echo %spacing%%op%
if "%lc%" EQU "1" (
	echo %spacing2%%op2%
)