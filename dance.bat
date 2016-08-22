@echo off
TITLE Dance Shepard, Dance
FOR /L %%H IN (0,1,64) DO (
cls
type "%cd%\art\frame%%H.txt"
)
call :loop
exit

:loop
FOR /L %%G IN (0,1,64) DO (
call :clearScreen
echo(
type "%cd%\art\frame%%G.txt"
echo(
echo %center%                %operation% %output%
echo(
bash -c "sleep 0.035"
if exist "%fname%%fnameext%" (
goto :break
)
)
goto loop

:break

:clearScreen
cls
type "%cd%\art\logo.txt"