@ECHO OFF
SETLOCAL
%SYSTEMDRIVE%
ECHO %PROCESSOR_ARCHITECTURE% | FINDSTR AMD64>NUL && SET ARCH=AMD64 || SET ARCH=x86
IF %ARCH%==AMD64 SET "DIRECTORY=%PROGRAMFILES(X86)%"
IF %ARCH%==x86 SET "DIRECTORY=%PROGRAMFILES%"
:: CD "%DIRECTORY%"
CD /D "%DIRECTORY%"
:: FOR /f %%x IN (
:: 'DIR /AD /B * ^| FINDSTR "^sox-[0-9].*$"'
:: ) DO SET SOXDIR=%DIRECTORY%\%%x
FOR /f "delims=" %%x IN (
    'DIR /AD /B * ^| FINDSTR "^sox-[0-9].*$"'
    ) DO SET "SOXDIR=%DIRECTORY%\%%x"
%~D1
CD /D "%~DP1"
MKDIR converted
@ECHO ON

:: make sure you comment-out the previously used output when un-commenting a new one
:: just put 2 colons at the start of the line like these have

:: to save a log of the sox settings used, un-comment the line starting with "@echo" associated with your selected output

:: uncomment next line to perform bit depth reduction only, no resampling -- 24-bit/44.1kHz and 24-bit/48kHz sources
::FOR %%A IN (%*) DO "%SOXDIR%\sox.exe" -S %%A -R -G -b 16 "converted/%%~nxA" dither
::@echo Dithered to 16-bit using SoX v14.4.2: sox input.flac -R -G -b 16 output.flac dither>"converted/downsample.txt"

:: uncomment next line to output 16-bit/44.1kHz
 FOR %%A IN (%*) DO "%SOXDIR%\sox.exe" -S %%A -R -t flac -G -b 16 "converted/%%~nxA" rate -v -L 44100 dither
::@echo Downsampled using SoX v14.4.2: sox input.flac -R -G -b 16 output.flac rate -v -L 44100 dither>"converted/downsample.txt"

:: uncomment next line to output 16-bit/48kHz
:: FOR %%A IN (%*) DO "%SOXDIR%\sox.exe" -S %%A -R -G -b 16 "converted/%%~nxA" rate -v -L 48000 dither
::@echo Downsampled using SoX v14.4.2: sox input.flac -R -G -b 16 output.flac rate -v -L 48000 dither>"converted/downsample.txt"

:: uncomment next line to output 24-bit/88.2kHz -- 24-bit/176kHz sources
::FOR %%A IN (%*) DO "%SOXDIR%\sox.exe" -S %%A -R -G -b 24 "converted/%%~nxA" rate -v -L 88200 dither
::@echo Downsampled using SoX v14.4.2: sox input.flac -R -G -b 24 output.flac rate -v -L 88200 dither>"converted/downsample.txt"

:: uncomment next line to output 24-bit/96kHz -- 24-bit/192kHz sources
::FOR %%A IN (%*) DO "%SOXDIR%\sox.exe" -S %%A -R -G -b 24 "converted/%%~nxA" rate -v -L 96000 dither
::@echo Downsampled using SoX v14.4.2: sox input.flac -R -G -b 24 output.flac rate -v -L 96000 dither>"converted/downsample.txt"

@PAUSE