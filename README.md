# Redneck Rampage Launcher

A native Windows 10 / 11 launcher for the **GOG Redneck Rampage Collection**. You don't need DOSBox: the games run on the modern [Raze](https://github.com/ZDoom/Raze) engine, in HD, with the original CD soundtrack. A **trainer** is built into the in-game menu.

> This project contains **no game data**. You need your own copy of *Redneck Rampage Collection* (GOG).

## Features

### Launcher
- Plays **Redneck Rampage**, **Suckin' Grits on Route 66** and **Redneck Rampage Rides Again**
- Downloads the Raze engine automatically on first launch, so there's nothing to install by hand
- Plays the **original CD soundtrack**: tracks are extracted once from the GOG CD images (`.inst` / `.gog`) and looped in game
- Native resolution, fullscreen, V-Sync, FPS limit, OpenGL / Vulkan
- **HD upscale**: renders internally at a higher resolution (up to 4K) and fits the image to your screen (supersampling)
- Smooth textures, HD cinematics, option to skip intros
- Custom keys (AZERTY / QWERTY friendly), mouse sensitivity / invert, auto-run, auto-aim, crosshair, FPS counter
- "No monsters" mode
- Animated interface with optional background music

### In-game trainer
During a game, press **Esc** and choose **Trainer** in the menu:

| Option | Key | Effect |
|---|---|---|
| Infinite Health | `H` | Invincible, health always at maximum |
| Infinite Ammo | `J` | Every weapon stays fully loaded |
| Infinite Inventory | `K` | Whiskey, moonshine, beer, cow pie, boots… refill when used up |
| Fly Mode | `L` | Jump to take off, then move while looking up / down to climb / dive |
| No Clip | `N` | Walk through walls |
| Remove Enemies | `U` | Makes every enemy of the level disappear |
| Erase Buildings | `O` | Flattens the map (reload the level to restore it) |
| Resync | `P` | Re-displays the state of the script options |

Each option shows **ON** (green) / **OFF** (red) in the menu, and you can toggle it at any time. The keys use the physical key position, so they work the same way on AZERTY and QWERTY keyboards.

> The trainer is disabled by the game itself at the highest difficulty level, because the game blocks cheats there.

## Installation

1. Download `Redneck-Rampage-Launcher-vX.Y.Z.zip` from the [Releases](../../releases) page.
2. Extract it **into your game folder** (for example `C:\GOG Games\Redneck Rampage Collection`). The archive adds:
   ```
   Redneck Rampage Launcher.exe
   Redneck Rampage Launcher.cmd
   Launcher\
   Trainer\
   ```
3. Run **Redneck Rampage Launcher.exe**. If Windows SmartScreen warns about an unknown publisher, choose *More info → Run anyway*. As an alternative, you can start `Redneck Rampage Launcher.cmd`.
4. On first launch, accept the download of the Raze engine (about 20 MB).

Optional additions:
- **Launcher background:** put a 1920×1080 image named `background.jpg` in `Launcher\`.
- **Launcher music:** put an MP3 named `music.mp3` in `Launcher\`.

These files aren't included for copyright reasons.

## How it works

| Part | Description |
|---|---|
| `Launcher/RR_Launcher.ps1` | The launcher (PowerShell + WinForms, with embedded C# for the animated UI and CD audio extraction). It builds the Raze command line from your settings. |
| `Trainer/addon/rrtrainer.con` | A CON script add-on loaded with `-addcon`. Small invisible "command" actors (tiles 29100-29114) toggle the options. A controller actor applies them on every game tick. |
| `Trainer/addon/menudef.txt` | Adds the **Trainer** entry to the in-game Esc menu (`AddListMenu "IngameMenu"`) and the trainer submenu. |
| `Trainer/addon/zscript.txt` | The ON/OFF menu item (`OptionMenuItemRRToggle`). |
| `Trainer/rrtrainer.cfg` | Console aliases and key bindings. The launcher executes it at game start. |
| `tools/gen_con.py` | Generates `rrtrainer.con`, which contains long unrolled loops for *Erase Buildings*. |
| `src/Launcher.cs` | Source of the tiny `.exe` wrapper that starts the PowerShell launcher. |

Building the `.exe` wrapper:
```
C:\Windows\Microsoft.NET\Framework64\v4.0.30319\csc.exe /target:winexe /out:"Redneck Rampage Launcher.exe" src\Launcher.cs
```

## Requirements
- Windows 10 or 11 (Windows PowerShell 5.1, included in Windows)
- *Redneck Rampage Collection* from GOG
- An internet connection on first launch (Raze download)

## Credits
- [Raze](https://github.com/ZDoom/Raze) by the ZDoom team (GPL), which is downloaded, not redistributed
- *Ultra* font by Astigmatic (Apache License 2.0), see `Launcher/Ultra-LICENSE.txt`
- *Redneck Rampage* © Xatrix Entertainment / Interplay. This project is not affiliated with them or with GOG.

## License
MIT. See [LICENSE](LICENSE). This license covers the launcher and trainer code only, not the games.
