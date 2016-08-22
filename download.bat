@echo off
bash -c "curl -# -o %fname%.tmp "%URL%""
tasklist /FI "IMAGENAME eq bash.exe" 2>NUL | find /I /N "bash.exe">NUL 
if errorlevel 0 (
rename %fname%.tmp %fname%%fnameext%
exit
)