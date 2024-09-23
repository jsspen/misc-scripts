@echo off 
cd /d "%~dp0"
for /f "eol=: delims=" %%f in ('dir /b /a-d *^|findstr /live ".bat"') do (
    mkdir "%%~nf"
    move /y "%%f" "%%~nf\"
)
pause