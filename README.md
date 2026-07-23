# PSMacro

A Windows app that manages [AutoHotkey](https://www.autohotkey.com/) automation scripts for
[chiaki-ng](https://github.com/streetpea/chiaki-ng), an independent PS4/PS5 Remote Play client.
Pick a script, tell it what to look for on screen by dragging boxes over a screenshot, test that
it detects correctly, then run it. Build your own scripts visually with Script Maker, no
AutoHotkey knowledge needed.

**BETA.** Built and verified as thoroughly as possible. Please report anything that doesn't work.

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

* **Discord notifications.** Add a webhook URL and PSMacro posts to your channel when a script
starts, stops, or closes on its own.
* **Update checks.** On by default. The About page also has a manual "Check for Updates" button.
* **A global hotkey** to start or stop the selected script from anywhere, even while PSMacro isn't
the focused window.
* **System tray and Windows startup** toggles, for running PSMacro out of the way in the background.
* **A window focus check**, off by default. Turn it on and a Script Maker script waits for
chiaki-ng to actually be the active window before sending any key presses, instead of sending to
whatever currently has focus. Only affects scripts saved (or re-saved) in Script Maker afterward.

## 

