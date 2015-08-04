ECHO OFF

ECHO.
ECHO Copy of required files...
ECHO.

set PATCHTEMP=%CD%
cd %PATCHTEMP%
echo y | copy %WINDIR%\SYSTEM32\winload.exe %PATCHTEMP%\osloader.exe
echo y | copy %WINDIR%\SYSTEM32\ntoskrnl.exe %PATCHTEMP%\ntkrnlmp.exe

set OLD_GUID={46595952-454E-4F50-4747-554944FFFFFF}
set ENTRY_GUID={46595952-454E-4F50-4747-554944FEEEEE}

ECHO.
ECHO Delete BCD Entries, if existing...
bcdedit -delete %ENTRY_GUID%
bcdedit -delete %OLD_GUID%
ECHO.

ECHO.
ECHO Creating BCD Entry...
ECHO.

bcdedit -create %ENTRY_GUID% -d "[AA]Bypass-GG MPGH" -application OSLOADER
bcdedit -set %ENTRY_GUID% device partition=%SYSTEMDRIVE%
bcdedit -set %ENTRY_GUID% osdevice partition=%SYSTEMDRIVE%
bcdedit -set %ENTRY_GUID% systemroot \Windows
bcdedit -set %ENTRY_GUID% path \Windows\system32\osloader.exe
bcdedit -set %ENTRY_GUID% kernel ntkrnlmp.exe
bcdedit -set %ENTRY_GUID% recoveryenabled 0
bcdedit -set %ENTRY_GUID% nx OptIn
bcdedit -set %ENTRY_GUID% nointegritychecks 1
bcdedit -set %ENTRY_GUID% inherit {bootloadersettings}

bcdedit -displayorder %ENTRY_GUID% -addlast
bcdedit -timeout 10

ECHO.
ECHO Setting PEAUTH service to manual... (avoid BSOD at login screen)
ECHO.
sc config peauth start= demand

ECHO.
ECHO Calling patcher!  Please press "Patch", next "Exit" before continue here...
ECHO.
%PATCHTEMP%\no_ds_pg.exe
ECHO.
ECHO.

ECHO.
ECHO Copy of required files...
ECHO.
echo y | copy %PATCHTEMP%\osloader.exe %WINDIR%\SYSTEM32\osloader.exe
echo y | copy %PATCHTEMP%\ntkrnlmp.exe %WINDIR%\SYSTEM32\ntkrnlmp.exe
ECHO.

ECHO.
ECHO Process complete.  Upon reboot system and select "[AA]Bypass-GG MPGH".
ECHO.

pause