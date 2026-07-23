# PSMacro

A Windows app that manages [AutoHotkey](https://www.autohotkey.com/) automation scripts for
[chiaki-ng](https://github.com/streetpea/chiaki-ng), an independent PS4/PS5 Remote Play client.
Pick a script, tell it what to look for on screen by dragging boxes over a screenshot, test that
it detects correctly, then run it. Build your own scripts visually with Script Maker, no
AutoHotkey knowledge needed.

This is a full rewrite of [PS4Macro](https://github.com/komefai/PS4Macro), not an update to
[chucklingcheese/PS4Macro](https://github.com/chucklingcheese/PS4Macro). Earlier versions tried
DLL injection and a virtual controller; neither held up. Driving chiaki-ng with real keyboard
input, the same way a person would, does.

**BETA.** Built and verified as thoroughly as possible. Please report anything that doesn't work.

## Getting started

**You'll need:** Windows 10/11, [Visual Studio 2022](https://visualstudio.microsoft.com/) (".NET
desktop development" workload), [AutoHotkey v2](https://www.autohotkey.com/), and
[chiaki-ng](https://streetpea.github.io/chiaki-ng/setup/installation/) installed and paired to
your PS4/PS5.

1. `git clone` this repository (a ZIP download can get blocked by Windows, see Troubleshooting).
2. Open `PSMacro.sln` in Visual Studio, build (Ctrl+Shift+B), and run (F5).
3. Follow the in-app **Tutorial** page.

## Using it

1. Launch chiaki-ng and connect to your console. Keep its window at one size and position, since
   Detection Points are saved as fixed screen coordinates.
2. On the **Automation** page, pick a script.
3. For each Detection Point, click "Pick Region...", click or drag over the matching spot in
   chiaki-ng, then click "Test" to confirm it works. A spot whose color jitters slightly from
   video streaming can check "Match by image instead of color" instead, comparing against a saved
   picture rather than one exact color.
4. Click "Start Script", then focus chiaki-ng and press the script's arm hotkey.

## Script Maker

Script Maker builds a script for you, step by step, no code involved. Add a few Detection
Points, then a sequence of steps: press a button, wait, wait for something to appear or
disappear, react to what's on screen, and more. Give it a name and click Save, and it shows up
on the Automation page ready to run.

For more advanced scripts, it also has flags, counters, and loops. Every field has a tooltip
explaining what it does, right there in the editor. Prefer to write AutoHotkey by hand instead?
Use the "Import .ahk Script" button to add your own file directly.

While a Script Maker-built script runs, the Automation page shows a live line of exactly what
it's doing, step by step, not just whether it's running. Want to share one you built? "Export
Script" on the Automation page saves it as a single file, detection points included. Anyone else
running PSMacro adds it straight back in with "Import Script Package".

## Settings

Beyond the controller key mapping and detection defaults, the Settings page has:

- **Discord notifications.** Add a webhook URL and PSMacro posts to your channel when a script
  starts, stops, or closes on its own.
- **Update checks.** On by default. The About page also has a manual "Check for Updates" button.
- **A global hotkey** to start or stop the selected script from anywhere, even while PSMacro isn't
  the focused window.
- **System tray and Windows startup** toggles, for running PSMacro out of the way in the background.
- **A window focus check**, off by default. Turn it on and a Script Maker script waits for
  chiaki-ng to actually be the active window before sending any key presses, instead of sending to
  whatever currently has focus. Only affects scripts saved (or re-saved) in Script Maker afterward.

## Troubleshooting

- **AutoHotkey not found.** Use "Browse..." on the Automation page to point PSMacro at it directly.
- **A Detection Point never matches.** Click "Test" and check the color it actually found. Raise
  Tolerance a little, or re-pick the region if it's way off.
- **Nothing happens in-game.** Click into the chiaki-ng window before pressing a script's arm
  hotkey. Scripts send keys to whatever window currently has focus, unless you turn on the window
  focus check in Settings.
- **Closing PSMacro doesn't stop a running script.** That's intentional, so it can't accidentally
  kill a run. Use "Stop Script" or the script's own quit hotkey.
- **Build fails after downloading a ZIP.** Windows blocks downloaded ZIPs. Right-click it,
  Properties, Unblock, or just `git clone` instead.

## Known limitations

- Script Maker has no reusable subroutines, and a condition combines at most two things at once.
- No keyboard/controller macro recorder yet.
- Not yet confirmed end to end on a wide range of Windows setups. Let us know if something breaks.
