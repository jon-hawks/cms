################################################################################
# Open an application then set its position and size.                          #
################################################################################
param(
    [parameter(Mandatory=$true)][string]$bin,
    [string]$title = "$((Get-Culture).TextInfo.ToTitleCase([io.path]::GetFileNameWithoutExtension($bin)))",
    [string]$arguments = "",
    [int]$wait = 2,
    [int]$x = 72,
    [int]$y = 72,
    [int]$width = 1295,
    [int]$height = 657
)

# Add .NET Win32 type if it doesn't already exist.
if(-not([System.Management.Automation.PSTypeName]"Win32").Type){Add-Type @"
    using System;
    using System.Runtime.InteropServices;
    public class Win32 {
        [DllImport("user32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool GetWindowRect(IntPtr hWnd, out RECT lpRect);
        [DllImport("user32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool MoveWindow(IntPtr hWnd, int X, int Y, int nWidth, int nHeight, bool bRepaint);
        [DllImport("user32.dll")]
        public static extern IntPtr FindWindow(string ClassName, IntPtr  TitleApp);
        [DllImport("user32.dll")]
        public static extern bool ShowWindow(int handle, int state);
    }
    public struct RECT {
        public int Left;
        public int Top;
        public int Right;
        public int Bottom;
    }
"@}

# Hide this PowerShell window.
[void][Win32]::ShowWindow(([System.Diagnostics.Process]::GetCurrentProcess() | Get-Process).MainWindowHandle, 0)

# Open application.
if($arguments -eq ""){
    Start-Process -FilePath $bin
}else{
    Start-Process -FilePath $bin -ArgumentList $arguments
}

# Try to get window for up to 1 minute; we do this because applications update
# themselves, take a while to draw their windows, etc.
[float]$tick = 0
[bool]$success = $false
while(!$success -and $tick -lt 60){
    try{

        # Grab window (adjust to match a portion of the application's title).
        $window = (Get-Process | where {$_.mainWindowTitle -match $title}).MainWindowHandle

        # Bind RECT object to window.
        [void][Win32]::GetWindowRect($window, [ref](New-Object RECT))

        # Set window position and size.
        [void][Win32]::MoveWindow($window, $x, $y, $width, $height, $true)

        # We did it!
        $success = $true
    }catch{}

    # Wait 50ms.
    Start-Sleep -Milliseconds 50
    $tick += .05
}

# Try to resize for x seconds; we do this because some windows resize themselves
# after being drawn.
$tick = 0
while($tick -lt $wait){
    try{
        # Set window position and size.
        [void][Win32]::MoveWindow($window, $x, $y, $width, $height, $true)
    }catch{}

    # Wait 50ms.
    Start-Sleep -Milliseconds 50
    $tick += .05
}
