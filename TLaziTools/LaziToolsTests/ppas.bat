@echo off
SET THEFILE=JsonBaseTest.exe
echo Linking %THEFILE%
C:\lazarus124.32\fpc\2.6.4\bin\i386-win32\ld.exe -b pei-i386 -m i386pe  --gc-sections   --subsystem windows --entry=_WinMainCRTStartup    -o JsonBaseTest.exe link.res
if errorlevel 1 goto linkend
C:\lazarus124.32\fpc\2.6.4\bin\i386-win32\postw32.exe --subsystem gui --input JsonBaseTest.exe --stack 16777216
if errorlevel 1 goto linkend
goto end
:asmend
echo An error occured while assembling %THEFILE%
goto end
:linkend
echo An error occured while linking %THEFILE%
:end
