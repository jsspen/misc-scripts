@echo off
setlocal enabledelayedexpansion

rem Get the directory path of the dragged folder
set "folder=%~1"

rem Check if the dragged item is a folder
if exist "%folder%\." (

    rem Change directory to the dragged folder
    pushd "%folder%"

    rem Create the .cbr archive with the name of the folder
    "C:\Program Files\WinRAR\rar.exe" a "!folder!.cbr" *.jpg *.jpeg *.png *.gif *.webp *.tif *.tiff *.jfif

    rem Restore the original directory
    popd

) else (
    echo Please drag a folder onto this script to create a CBR archive.
)

pause
