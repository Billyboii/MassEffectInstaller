# Set Script Parameters ----------------------------------
$currentDirectory = Get-Location
$global:title = "ME Installation Tool"
[System.Console]::Title = $global:title

# Establish functions
# Check Windows Version
function checkWindowsVersion {
    $global:version = (Get-ComputerInfo).WindowsVersion
    Clear-Screen
}

function checkNET {
    if ($version -eq "10.0") {
        $global:op = ".NET Framework v.4.6.2 has been installed!"
        Clear-Screen
    } else {
        if (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Client" -Name "Version" -ErrorAction SilentlyContinue) {
            $global:op = ".NET Framework v.4.6.2 has been installed!"
            Clear-Screen
        } else {
            $global:URL = "https://download.microsoft.com/download/1/7/5/175E764B-E417-4FBB-95DF-62676FC7B2EA/NDP462-KB3120735-x86-x64-AllOS-ENU.exe"
            $global:fname = "NDP462-KB3120735-x86-x64-AllOS-ENU"
            $global:fnameext = ".exe"
            $global:op = "Downloading .NET Framework 4.6.2..."
            Clear-Screen
            download
            $global:op = "Installing .NET Framework 4.6.2..."
            Clear-Screen
            Start-Process -FilePath "$PSScriptRoot\$fname$fnameext" -Wait
            Rename-Item -Path "$PSScriptRoot\$fname$fnameext" -NewName "$fname.tmp"
            $global:Restart = "yes"
        }
    }
}

function checkPowershell {
    if ($version -eq "10.0") {
        $global:op = "Windows Powershell is installed!"
        Clear-Screen
    } else {
        if (Test-Path "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe") {
            $PSVersion = (powershell -command "(Get-Host).Version").Major
            if ($PSVersion -ge 5) {
                $global:op = "Windows Powershell is installed!"
                Clear-Screen
                Start-Sleep -Seconds 1
            } else {
                installPowershell
            }
        } else {
            installPowershell
        }
    }
}

function download {
    Invoke-WebRequest -Uri $URL -OutFile "$PSScriptRoot\$fname.tmp"
    if ($?) {
        Rename-Item -Path "$PSScriptRoot\$fname.tmp" -NewName "$fname$fnameext"
    } else {
        $global:op = "Download failed. Retrying..."
        Start-Sleep -Seconds 1
        download
    }
}

function cleanup {
    $global:op = "Cleaning up temporary files..."
    Remove-Item -Path "$PSScriptRoot\*.tmp" -Force
}

function Clear-Screen {
    Clear-Screen
    Get-Content "$pwd\art\logo.txt"
    Write-Host
    Write-Host
    Write-Host

    if ($dance -eq 1) {
        20..1 | ForEach-Object { Write-Host }
        if ($version -ne "10.0") {
            8..1 | ForEach-Object { Write-Host }
        }
    }

    Write-Host "$spacing$op"

    if ($lc -eq 1) {
        Write-Host "$spacing2$op2"
    }
}

# Checks if NirCMD is available
if (Test-Path "$currentDirectory\nircmd.exe") {
    Write-Host "NirCMD is available."
} 
else {
    # Define the URL of the ZIP file and the name of the file to extract
    $url = "https://www.nirsoft.net/utils/nircmd-x64.zip"
    $fileToExtract = "nircmd.exe"

    # Define the paths
    $tempZipPath = "$env:TEMP\nircmd-x64.zip"
    $currentDirectory = Get-Location

    # Download the ZIP file
    try {
        Invoke-WebRequest -Uri $url -OutFile $tempZipPath
    }
    catch {
        Write-Error "The script failed to download NirCMD: $_"
        Write-Error "Exiting..."
        exit
    }
    
    # Extract the specified file from the ZIP
    try {
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        [System.IO.Compression.ZipFile]::ExtractToDirectory($tempZipPath, $currentDirectory)

        # Move the specific file to the current directory
        $extractedFilePath = Join-Path -Path $currentDirectory -ChildPath $fileToExtract
        Move-Item -Path $extractedFilePath -Destination $currentDirectory -Force

        # Clean up the temporary ZIP file
        Remove-Item -Path $tempZipPath -Force
        Remove-Item -Path "$currentDirectory\nircmdc.exe" -Force
        Remove-Item -Path "$currentDirectory\NirCmd.chm" -Force

        Write-Output "File '$fileToExtract' has been extracted to '$currentDirectory'"
    }
    catch {
        Write-Error "The script failed to extract NirCMD from it's zip file: $_"
        Write-Error "Exiting..."
        exit
    }
}

[int]$width = 1920
[int]$height = 1080

# Use NirCmd to resize and center the window
Start-Process -FilePath "nircmd.exe" -ArgumentList "win setsize ititle $title $width $height"
Start-Process -FilePath "nircmd.exe" -ArgumentList "win center ititle $title"

# Initialize and Set Variables ---------------------------
$global:URL = $null
$global:op = "."
$global:fname = $null
$global:fnameext = $null
$global:Restart = "no"
$global:pcbit = $null
$global:os = $null
$global:spacing = "          "
$global:spacing2 = "  "
$global:op2 = "."
$global:dance = 0
$global:lc = 1

# Instructions--------------------------------------------
$global:spacing = "                                                 "
$global:spacing2 = "                              "
$global:op = "This program requires .NET Framework 4.0 or higher and Windows Powershell 2.0 or higher to operate."
$global:op2 = "The program will now detect if these have been installed on your machine and, if not, will walk you through the installation process. Press any key to continue..."
Clear-Screen
Pause

$global:lc = 0
$global:spacing = "                                                                                         "
$global:op2 = "                    "

$global:dance = 1
Clear-Screen
Start-Process -FilePath "dance.bat"

checkWindowsVersion
checkNET
Start-Sleep -Seconds 1
$global:spacing = "                                                                                              "
checkPowershell
Start-Sleep -Seconds 1
cleanup
Start-Sleep -Seconds 1

Start-Process -FilePath "nircmd.exe" -ArgumentList "win close title 'Dance Shepard, dance...'"
$global:dance = 0

$global:spacing = "                                                                 "
$global:op = "All requirements have been met. Press any key to continue with the installation..."
Clear-Screen
Pause

# CHOOSE MODULES TO INSTALL -------------------------------

# Start loading animation----------------------------------
$global:dance = 1
Clear-Screen
Start-Process -FilePath "dance.bat"

if ($version -ne "10.0") {
    Start-Process -FilePath "nircmd.exe" -ArgumentList "win move title 'Administrator: Dance Shepard, dance...' 0 100"
}

# INSTALLATION INSTRUCTIONS

# CLOSE EVERYTHING-----------------------------------------
Start-Sleep -Seconds 1
Start-Process -FilePath "nircmd.exe" -ArgumentList "win close title 'Dance Shepard, dance...'"
END

# Call the function
Clear-Screen
