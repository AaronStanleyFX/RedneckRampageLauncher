# Redneck Rampage Launcher

A native Windows 10 / 11 launcher for the **GOG Redneck Rampage Collection**. You don't need DOSBox: the games run on the modern [Raze](https://github.com/ZDoom/Raze) engine, in HD, with the original CD soundtrack. A **Trainer** and a **Dev Mode** are built straight into the in-game menu.

> This project contains **no game data**. You need your own copy of *Redneck Rampage Collection* from GOG.

---

## ✨ Features

### 🚀 Launcher
- Plays **Redneck Rampage**, **Suckin' Grits on Route 66** and **Redneck Rampage Rides Again**
- Downloads the Raze engine automatically on first launch, so there's nothing to install by hand
- Plays the **original CD soundtrack**, extracted once from the GOG CD images (`.inst` / `.gog`)
- Native resolution, fullscreen, V-Sync, FPS limit, OpenGL / Vulkan
- **HD upscale**: renders internally at a higher resolution (up to 4K) and fits the image to your screen
- Smooth textures, HD cinematics, option to skip intros
- Custom keys (AZERTY & QWERTY), mouse sensitivity / invert, auto-run, auto-aim, crosshair, FPS counter
- "No monsters" mode, plus an animated interface with optional music

### 🛠️ In-game Trainer — `Esc` → **Trainer**

| Option | Key | Effect |
|---|---|---|
| Infinite Health | `H` | Invincible, health always at maximum |
| Infinite Ammo | `J` | Every weapon stays fully loaded |
| Infinite Inventory | `K` | Whiskey, moonshine, beer, cow pie, boots… refill when used up |
| Fly Mode | `L` | Jump to take off, then move while looking up / down |
| No Clip | `N` | Walk through walls |
| Remove Enemies | `U` | Every enemy of the level disappears |
| Erase Buildings | `O` | Flattens the map (reload the level to restore it) |

The keys use the physical key position, so they work the same way on AZERTY and QWERTY keyboards.

### 🧪 Dev Mode — `Esc` → **Dev Mode**
Every option has its own **ON / OFF** switch. Turning an option OFF puts the level back exactly as it was.

| Category | Options |
|---|---|
| **Remove** | Trees · Cars · Enemies · Weapons · Items · Walls · Doors · Map Architecture · Sky |
| **Add** | Enemies · Bubba · Pig · Cow · Boat · Motorcycle · Leonard |
| **Graphics** | Original Graphics · Raze Graphics · Enhanced Lighting |

<details>
<summary><b>What each option does</b></summary>

| Option | Details |
|---|---|
| Remove Trees | Tree sprites and the rows of trees drawn as see-through walls |
| Remove Cars | Cars built as raised blocks in the map (cars painted on solid walls stay) |
| Remove Enemies / Weapons / Items | Hidden and frozen. Keys are never removed, so you can't get stuck |
| Remove Walls | Fences, bars, windows, grates and wall decorations |
| Remove Doors | Doors open and stay open (ceiling and floor doors) |
| Remove Map Architecture | Flattens the whole level |
| Remove Sky | Black sky |
| Add Enemies | 5 enemies appear in front of you |
| Add Bubba / Pig / Cow / Leonard | Appear in front of you (Leonard is a still figure) |
| Add Boat / Motorcycle | *Rides Again* only |
| Original Graphics | Software-like look: palette colors, sharp pixels, no voxels / models |
| Raze Graphics | Raze's modern rendering |
| Enhanced Lighting | Ambient occlusion (SSAO) + bloom + tone mapping |

</details>

> Ray tracing and NVIDIA RTX Remix are not possible with this game. Raze has no ray tracing, and RTX Remix only works with DirectX 8/9 games, while Raze uses OpenGL / Vulkan. *Enhanced Lighting* is the closest alternative.

> The game itself blocks the trainer at the highest difficulty level. After a level change, Dev Mode re-applies itself as soon as you jump, shoot or crouch.

---

## 📦 Installation

1. Download `Redneck-Rampage-Launcher-vX.Y.Z.zip` from the [Releases](../../releases) page.
2. Extract it **into your game folder**, the one that contains `REDNECK.GRP` (for example `C:\GOG Games\Redneck Rampage Collection`).
3. Run **`Redneck Rampage Launcher.exe`**. If Windows SmartScreen warns about an unknown publisher, choose *More info → Run anyway*. As an alternative, you can start `Redneck Rampage Launcher.cmd`.
4. On first launch, accept the download of the Raze engine (about 20 MB).

Optional additions:
- **Launcher background:** put your own `background.jpg` (1920×1080) in `Launcher\`.
- **Launcher music:** put your own `music.mp3` in `Launcher\`.

These files aren't included for copyright reasons.

### Folder layout after installation
```
Redneck Rampage Collection\
├─ Redneck Rampage Launcher.exe
├─ Redneck Rampage Launcher.cmd
├─ Launcher\          launcher (PowerShell) + font
└─ Trainer\
   ├─ rrtrainer.cfg   trainer keys / console aliases
   ├─ rrdevmode.cfg   Dev Mode console aliases
   └─ addon\          CON + ZScript + MENUDEF add-on loaded into Raze
```

---

## ⚙️ How it works

| File | Role |
|---|---|
| `Launcher/RR_Launcher.ps1` | The launcher (PowerShell + WinForms, with embedded C# for the animated UI and CD audio extraction). It builds the Raze command line and loads the add-on. |
| `Trainer/addon/rrtrainer.con` | CON add-on (`-addcon`). Invisible command actors (tiles 29100-29114) and a controller apply the trainer options every tick. It also re-creates the Dev Mode controller after a level change. |
| `Trainer/addon/zscript.txt` | `OptionMenuItemRRToggle` (the ON/OFF menu line), `RRDevMode` (the Dev Mode controller, which stores and restores everything it changes) and `RRDevLeonard`. |
| `Trainer/addon/menudef.txt` | The in-game Esc menu with the **Trainer** and **Dev Mode** entries, plus both submenus. |
| `Trainer/addon/rmapinfo.txt` | Maps spawn ID 29120 to `RRDevMode`. |
| `Trainer/*.cfg` | Console aliases and key bindings. The launcher executes them at game start. |
| `tools/gen_con.py` | Generates `rrtrainer.con` (long unrolled loops). |
| `src/Launcher.cs` | Source of the small `.exe` wrapper that starts the PowerShell launcher. |

Build the `.exe` wrapper:
```
C:\Windows\Microsoft.NET\Framework64\v4.0.30319\csc.exe /target:winexe /out:"Redneck Rampage Launcher.exe" src\Launcher.cs
```

## 🧩 Troubleshooting
- **An option stays OFF or a menu entry is missing:** close the launcher completely, reopen it, then start the game again.
- **Something else:** check `Trainer\rrtrainer.log`, which is the game's console log for the current session.

## Requirements
- Windows 10 or 11 (Windows PowerShell 5.1, included in Windows)
- *Redneck Rampage Collection* from GOG
- An internet connection on first launch (Raze download)

## Credits
- [Raze](https://github.com/ZDoom/Raze) by the ZDoom team (GPL), which is downloaded, not redistributed
- *Ultra* font by Astigmatic (Apache License 2.0), see `Launcher/Ultra-LICENSE.txt`
- *Redneck Rampage* © Xatrix Entertainment / Interplay. This project is not affiliated with them or with GOG.

## License
MIT. See [LICENSE](LICENSE). This license covers the launcher, trainer and Dev Mode code only, not the games.
