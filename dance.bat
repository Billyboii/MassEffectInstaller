REM Set window parameters
@echo off
TITLE Dance Shepard, dance...
mode con: cols=80 lines=25
nircmd win center ititle "Dance Shepard, dance..."
nircmd win move ititle "Dance Shepard, dance..." 0 130 0
call :dance_load
call :dance

exit /b0

:dance
FOR /L %%G IN (0,1,64) DO (
cls
type "%cd%\art\frame_%%G.txt"
CSCRIPT SLEEP.VBS 50 >nul
)
call :dance

:dance_load

FOR /L %%G IN (0,1,64) DO (
cls
type "%cd%\art\frame_%%G.txt"
)