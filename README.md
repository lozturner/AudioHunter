# TurnerWorks Audio Hunter

A lightweight, system-wide audio monitor that shows you exactly which app is making noise and lets you **mutem** or **focus** it instantly.

## Installation

### The Magic One-Liner (PowerShell)
Copy and paste this into PowerShell to install automatically:

```powershell
irm https://raw.githubusercontent.com/TurnerWorks/AudioHunter/main/install.ps1 | iex
```

*Note: Requires Python to be installed.*

## Features
-   **Live Audio Meter** for every specific process.
-   -   **Focus Button**: Bring the noisy app to the front (even Chrome tabs!).
    -   -   **Mute**: Toggle mute per-app.
        -   -   **Stealth Mode**: Runs silently in the background, minimizing to tray (WIP).
         
            -   ## Portable Usage (No Install Required)
            -   1.  Download the **`AudioHunter_Portable.zip`** release.
                2.  2.  Unzip it to any folder.
                    3.  3.  Run **`AudioHunter.exe`** inside.
                        4.      *   *Note: You must keep the entire folder together. Do not move the .exe out of the folder.*
                      
                        5.  ## Manual Run (Dev)
                        6.  1.  Clone repo.
                            2.  2.  `pip install -r requirements.txt`
                                3.  3.  `python audio_mon.py`
                                  
                                    4.  ---
                                    5.  *Created by TurnerWorks*
                                    6.  
