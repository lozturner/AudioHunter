$ErrorActionPreference = "Stop"
$RepoUrl = "https://github.com/TurnerWorks/AudioHunter"
$InstallBase = "$env:LOCALAPPDATA\AudioHunter"
$LauncherPath = "$InstallBase\launch.vbs"
$DesktopShortcut = "$env:USERPROFILE\Desktop\TurnerWorks Audio Hunter.lnk"
$RegistryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
$AppName = "AudioHunter"

Write-Host @"
===============================================
   TURNERWORKS AUDIO HUNTER - INSTALLER
   ===============================================
   "@ -ForegroundColor Cyan

   # 1. Prerequisite Check
   if (-not (Get-Command "python" -ErrorAction SilentlyContinue)) {
       Write-Warning "Python is not detected! Please install Python 3.10+ from python.org or the Microsoft Store."
       }

       # 2. Prepare Directory
       if (Test-Path $InstallBase) { Remove-Item $InstallBase -Recurse -Force -ErrorAction SilentlyContinue }
       New-Item -ItemType Directory -Path $InstallBase -Force | Out-Null
       Set-Location $InstallBase

       # 3. Download Source
       Write-Host "[1/5] Downloading latest source from GitHub..."
       $ZipUrl = "$RepoUrl/archive/refs/heads/main.zip"

       $ZipFile = "$InstallBase\source.zip"

       try {
           Invoke-WebRequest -Uri $ZipUrl -OutFile $ZipFile -UseBasicParsing
               Expand-Archive -Path $ZipFile -DestinationPath $InstallBase -Force
                   $SubDir = Get-ChildItem -Directory | Select-Object -First 1
                       Get-ChildItem -Path $SubDir.FullName | Move-Item -Destination $InstallBase
                           Remove-Item $SubDir.FullName -Recurse -Force
                               Remove-Item $ZipFile -Force
                               }
                               catch {
                                   Write-Error "Failed to download source. Please check your internet connection."
                                       exit 1
                                       }

                                       # 4. Setup Python Venv
                                       Write-Host "[2/5] Setting up Virtual Environment (Local)..."
                                       python -m venv venv
                                       if (-not (Test-Path "venv")) {
                                           Write-Error "Failed to create venv."
                                               exit 1
                                               }

                                               # 5. Install Dependencies
                                               Write-Host "[3/5] Installing Dependencies..."

                                               .\venv\Scripts\pip install -r requirements.txt --quiet --disable-pip-version-check

                                               # 6. Create Launcher
                                               Write-Host "[4/5] Creating Launcher..."
                                               $VbsContent = @"
                                               Set WshShell = CreateObject("WScript.Shell")
                                               WshShell.Run """$InstallBase\venv\Scripts\pythonw.exe"" ""$InstallBase\audio_mon.py""", 0, False
                                               "@
                                               Set-Content -Path $LauncherPath -Value $VbsContent

                                               # 7. Create Shortcut
                                               Write-Host "[5/5] creating Desktop Shortcut..."
                                               $WshShell = New-Object -ComObject WScript.Shell
                                               $Shortcut = $WshShell.CreateShortcut($DesktopShortcut)
                                               $Shortcut.TargetPath = "$env:SystemRoot\System32\wscript.exe"
                                               $Shortcut.Arguments = """$LauncherPath"""
                                               $Shortcut.IconLocation = "$env:SystemRoot\System32\SHELL32.dll,296"
                                               $Shortcut.Description = "Launch Audio Hunter"
                                               $Shortcut.Save()

                                               # 8. Registry Auto-Start
                                               Set-ItemProperty -Path $RegistryPath -Name $AppName -Value "wscript.exe `"$LauncherPath`""

                                               Write-Host @"
                                               ===============================================
                                                  INSTALLATION COMPLETE!
                                                     Shortcut created on Desktop.
                                                     ===============================================
                                                     "@ -ForegroundColor Green
                                                     Start-Process $DesktopShortcut
                                                     
