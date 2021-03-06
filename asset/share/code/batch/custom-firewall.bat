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
REM # Run this at startup and it acts like a sort of "iptables for Windows".   #
REM ############################################################################
NETSH ADVFIREWALL SET ALLPROFILES STATE ON
NETSH ADVFIREWALL FIREWALL DELETE RULE NAME=ALL

REM ####################################
REM # Inbound Rules:                   #
REM ####################################

REM TCP
NETSH ADVFIREWALL FIREWALL ADD RULE ACTION="ALLOW" DIR="IN" NAME="HTTP"  PROTOCOL="TCP" LOCALPORT="80,8000,8080,8100,8888"
NETSH ADVFIREWALL FIREWALL ADD RULE ACTION="ALLOW" DIR="IN" NAME="IMAP"  PROTOCOL="TCP" LOCALPORT="143"
NETSH ADVFIREWALL FIREWALL ADD RULE ACTION="ALLOW" DIR="IN" NAME="HTTPS" PROTOCOL="TCP" LOCALPORT="443"

REM UDP
NETSH ADVFIREWALL FIREWALL ADD RULE ACTION="ALLOW" DIR="IN" NAME="DHCP" PROTOCOL="UDP" LOCALPORT="68" REMOTEPORT="67"

REM Test
NETSH ADVFIREWALL FIREWALL ADD RULE ACTION="ALLOW" DIR="IN"  NAME="Battle.net" PROTOCOL="TCP" LOCALPORT="1120"
NETSH ADVFIREWALL FIREWALL ADD RULE ACTION="ALLOW" DIR="IN"  NAME="Battle.net" PROTOCOL="UDP" LOCALPORT="1120"

REM ####################################
REM # Outbound Rules:                  #
REM ####################################

REM TCP
NETSH ADVFIREWALL FIREWALL ADD RULE ACTION="ALLOW" DIR="OUT" NAME="SSH"             PROTOCOL="TCP" REMOTEPORT="22"
NETSH ADVFIREWALL FIREWALL ADD RULE ACTION="ALLOW" DIR="OUT" NAME="SMTP"            PROTOCOL="TCP" REMOTEPORT="25"
NETSH ADVFIREWALL FIREWALL ADD RULE ACTION="ALLOW" DIR="OUT" NAME="HTTP"            PROTOCOL="TCP" REMOTEPORT="80,8000,8080,8100,8888"
NETSH ADVFIREWALL FIREWALL ADD RULE ACTION="ALLOW" DIR="OUT" NAME="VPN"             PROTOCOL="TCP" REMOTEPORT="89"
NETSH ADVFIREWALL FIREWALL ADD RULE ACTION="ALLOW" DIR="OUT" NAME="Video Streaming" PROTOCOL="TCP" REMOTEPORT="182,187,1935,8777"
NETSH ADVFIREWALL FIREWALL ADD RULE ACTION="ALLOW" DIR="OUT" NAME="HTTPS"           PROTOCOL="TCP" REMOTEPORT="443"
NETSH ADVFIREWALL FIREWALL ADD RULE ACTION="ALLOW" DIR="OUT" NAME="Battle.net"      PROTOCOL="TCP" REMOTEPORT="1119,1120,3724"
NETSH ADVFIREWALL FIREWALL ADD RULE ACTION="ALLOW" DIR="OUT" NAME="Crypto Mining"   PROTOCOL="TCP" REMOTEPORT="3340,3737,3833,4233,4933,8383,8533"
NETSH ADVFIREWALL FIREWALL ADD RULE ACTION="ALLOW" DIR="OUT" NAME="VNC"             PROTOCOL="TCP" REMOTEPORT="5800,5900"
NETSH ADVFIREWALL FIREWALL ADD RULE ACTION="ALLOW" DIR="OUT" NAME="Websocket"       PROTOCOL="TCP" REMOTEPORT="9001,8081"

REM UDP
NETSH ADVFIREWALL FIREWALL ADD RULE ACTION="ALLOW" DIR="OUT" NAME="DNS"        PROTOCOL="UDP"                  REMOTEPORT="53"
NETSH ADVFIREWALL FIREWALL ADD RULE ACTION="ALLOW" DIR="OUT" NAME="DHCP"       PROTOCOL="UDP" LOCALPORT="68"   REMOTEPORT="67"
NETSH ADVFIREWALL FIREWALL ADD RULE ACTION="ALLOW" DIR="OUT" NAME="Bittorrent" PROTOCOL="UDP" LOCALPORT="6881"

REM Test
NETSH ADVFIREWALL FIREWALL ADD RULE ACTION="ALLOW" DIR="OUT" NAME="Battle.net" PROTOCOL="UDP" LOCALPORT="1120"

REM Other Protocols
NETSH ADVFIREWALL FIREWALL ADD RULE ACTION="ALLOW" DIR="OUT" NAME="Ping" PROTOCOL="ICMPv4"

REM ####################################
REM # Prompt suppression rules:        #
REM ####################################
NETSH ADVFIREWALL FIREWALL ADD RULE ACTION="ALLOW" DIR="OUT" NAME="Apache"      PROGRAM="D:\warez\xampp\apache\bin\httpd.exe"
NETSH ADVFIREWALL FIREWALL ADD RULE ACTION="BLOCK" DIR="OUT" NAME="FileZilla"   PROGRAM="D:\warez\xampp\filezillaftp\filezillaserver.exe"
NETSH ADVFIREWALL FIREWALL ADD RULE ACTION="BLOCK" DIR="OUT" NAME="Mercury"     PROGRAM="D:\warez\xampp\mercurymail\mercury.exe"
NETSH ADVFIREWALL FIREWALL ADD RULE ACTION="ALLOW" DIR="OUT" NAME="MobaXterm"   PROGRAM="D:\warez\mobaxterm\slash\bin\xwin_mobax.exe"
NETSH ADVFIREWALL FIREWALL ADD RULE ACTION="BLOCK" DIR="OUT" NAME="MySQL"       PROGRAM="D:\warez\xampp\mysql\bin\mysqld.exe"
NETSH ADVFIREWALL FIREWALL ADD RULE ACTION="BLOCK" DIR="OUT" NAME="node.js"     PROGRAM="D:\warez\nodejs\app\node.exe"
NETSH ADVFIREWALL FIREWALL ADD RULE ACTION="ALLOW" DIR="OUT" NAME="qBittorrent" PROGRAM="D:\warez\qbittorrent\app\qbittorrent\qbittorrent.exe"


REM ####################################
REM # Privacy rules:                   #
REM ####################################
