#Requires AutoHotkey v2.0
#MaxThreadsPerHotkey 2

SetKeyDelay 50, 100
Global ScriptActive := false

F8:: {
    Global ScriptActive
    ScriptActive := !ScriptActive

    if (ScriptActive) {
        SendEvent("{4 down}")
        ToolTip("Holding R2. Press F8 to stop.")
    } else {
        SendEvent("{4 up}")
        ToolTip("Stopped.")
        Sleep(1000)
        ToolTip()
    }
}

Esc:: {
    SendEvent("{4 up}")
    ExitApp()
}
