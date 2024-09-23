@echo off
cd /d %~dp0
for %%F in (*.tif) do (
    magick convert "%%F" -compress LZW ".\Compressed\%%~nF.tif"
)
