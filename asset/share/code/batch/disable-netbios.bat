@ECHO OFF
REM ############################################################################
REM # Get administrative privileges.                                           #
REM ############################################################################
CACLS "%SYSTEMROOT%\System32\config\SYSTEM" >NUL 2>&1
IF "%ERRORLEVEL%" NEQ "0" (GOTO Elevate) ELSE (GOTO Run)

:Elevate
    SET UAC_SCRIPT="%TEMP%\%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%.VBS"
    ECHO Set UAC = CreateObject("Shell.Application")              > %UAC_SCRIPT%
    ECHO UAC.ShellExecute "%~dpnx0", "%*", "%~dp0", "runas", 1   >> %UAC_SCRIPT%
    CSCRIPT %UAC_SCRIPT%
    DEL /F /Q %UAC_SCRIPT%
    EXIT /B

:Run

REM ############################################################################
REM # Disable NetBIOS over TCP/IP on all interfaces.                           #
REM ############################################################################
ECHO Disabling NetBIOS over TCP/IP...
FOR /L %%I IN (1,1,64) DO (
    WMIC NICCONFIG WHERE INDEX=%%I CALL SETTCPIPNETBIOS 2
)
