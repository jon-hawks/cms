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
REM # Add a path the the PATH environment variable, if it doesn't already      #
REM # exist.                                                                   #
REM ############################################################################

REM Validate parameter exists.
IF "%~1"=="" (
    ECHO No parameter provided. Expects a valid path to a directory.
    EXIT /B
)

REM Validate parameter is a path to a directory that actually exists.
IF NOT EXIST %1\* (
    ECHO Is not a directory
    EXIT /B
)

REM Add parameter to PATH environment variable, if it doesn't already exist.
SET FOUND=N
FOR %%A IN ("%PATH:;=","%") DO IF /I "%%~A" EQU "%~1" SET FOUND=Y
IF "%FOUND%" EQU "N" (
    SETX /M PATH "%PATH%;%~1"
    ECHO "%~1" added to PATH environment variable.
    EXIT /B
)
ECHO "%~1" already exists in PATH environment variable.
