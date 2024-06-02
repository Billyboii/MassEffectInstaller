# Remove Windows Terminal Title Bar

Add-Type -TypeDefinition @"
    using System;
    using System.Runtime.InteropServices;

    public class User32 {
        [DllImport("user32.dll", SetLastError = true)]
        public static extern int GetWindowLong(IntPtr hWnd, int nIndex);

        [DllImport("user32.dll")]
        public static extern int SetWindowLong(IntPtr hWnd, int nIndex, int dwNewLong);

        [DllImport("user32.dll", SetLastError=true)]
        public static extern bool SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter, int X, int Y, int cx, int cy, uint uFlags);

        [DllImport("user32.dll", SetLastError = true)]
        public static extern IntPtr FindWindow(string lpClassName, string lpWindowName);

        [DllImport("user32.dll", SetLastError = true)]
        public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
    }
"@

function Remove-WindowTitleBar {
    $HWND = (Get-Process -Name "WindowsTerminal" | Select-Object -First 1).MainWindowHandle
    $GWL_STYLE = -16
    $WS_CAPTION = 0x00C00000

    $style = [User32]::GetWindowLong($HWND, $GWL_STYLE)
    $style = $style -band (-bnot $WS_CAPTION)
    [User32]::SetWindowLong($HWND, $GWL_STYLE, $style) | Out-Null
    [User32]::SetWindowPos($HWND, [IntPtr]::Zero, 0, 0, 0, 0, 0x0027) | Out-Null
}

Remove-WindowTitleBar
