#Requires AutoHotkey v2.0
#MaxThreadsPerHotkey 2

; Make sure AHK looks at the full screen for the UI elements
CoordMode "Pixel", "Screen"

SetKeyDelay 50, 100
Global ScriptActive := false

; ==========================================
; GLOBAL TIMERS & SETTINGS
; ==========================================
Global MissingHealthTicks := 0 ; Kept global so the 10-second check works correctly
Global MagQueuen := true

; ==========================================
; HELPER FUNCTIONS - regions/colors come from PSMacro's Automation page
; (each {{TOKEN}} below is replaced when generating with the configured
; value of the matching Detection Point)
; ==========================================
IsLobbyActive() {
    return PixelSearch(&FoundX, &FoundY, 204, 1286, 224, 1306, 0xF9ED0B, 10)
}

IsBrokenLobbyActive() {
    return PixelSearch(&FoundX, &FoundY, 197, 1261, 217, 1281, 0xFAF3FE, 10)
}

IsFriendsMenu() {
    return PixelSearch(&FoundX, &FoundY, 1797, 143, 1817, 163, 0x5C03AD, 10)
}

IsAlive() {
    return PixelSearch(&FoundX, &FoundY, 289, 1345, 309, 1365, 0x8EDE0A, 60)
}

IsSpectating() {
    return PixelSearch(&FoundX, &FoundY, 442, 1256, 462, 1276, 0x53BE14, 60)
}

IsGameActive() {
    return IsAlive() || IsSpectating()
}

IsAnyLobbyActive() {
    if (IsGameActive()) {
        return false
    }
    return IsLobbyActive() || IsBrokenLobbyActive()
}

; ==========================================
; THE SMART BRAIN (SMARTWAIT)
; ==========================================
SmartWait(ms, InGameMode := false) {
    Global MissingHealthTicks
    EndTime := A_TickCount + ms

    while (A_TickCount < EndTime && ScriptActive) {

        if (InGameMode) {
            ; If we're in a match:
            if (!IsGameActive()) {
                MissingHealthTicks++

                ; 1. Has the health bar been gone for 10 full seconds (100 ticks)? Then the match is 100% over!
                if (MissingHealthTicks >= 100) {
                    return true
                }

                ; 2. Only once the health bar has been gone for at least 3 seconds is it allowed to look for the Lobby.
                ; This stops a white explosion (BrokenLobby pixel) from breaking the script during lag.
                if (MissingHealthTicks >= 30) {
                    if (IsLobbyActive() || IsBrokenLobbyActive() || IsFriendsMenu()) {
                        return true
                    }
                }
            } else {
                ; Sees your health bar again? Reset the remembered timer immediately!
                MissingHealthTicks := 0
            }
        } else {
            ; If we're NOT in a match (queue mode), it's always allowed to look for the lobby
            if (IsAnyLobbyActive() || IsFriendsMenu()) {
                return true
            }
        }

        Sleep(100)
    }
    return false
}

; ==========================================
; BLIND LOOT FUNCTION
; ==========================================
BlindLoot() {
    SendEvent("{\ down}")
    if (SmartWait(1000, true)) {
        SendEvent("{\ up}")
        return true
    }
    SendEvent("{\ up}")

    Sleep(200)

    SendEvent("{c}")
    if (SmartWait(500, true)) {
        return true
    }

    return false
}

; ==========================================
; F8: Start/Toggle the Macro
; ==========================================
F8:: {
    Global ScriptActive
    Global MagQueuen
    Global MissingHealthTicks
    ScriptActive := !ScriptActive

    if (!ScriptActive) {
        ToolTip("Macro Stopped.")
        Sleep(1500)
        ToolTip()
        return
    }

    MagQueuen := true

    ; ==========================================
    ; MAIN LOOP
    ; ==========================================
    Loop {
        if (!ScriptActive)
            break

        ; 0A. CHECK & FIX FRIENDS MENU OVERLAY
        if (IsFriendsMenu() && !IsGameActive()) {
            ToolTip("Friends Menu detected! Closing it with Circle...")
            SendEvent("{Backspace}")
            Sleep(1500)
            MagQueuen := true
        }

        ; 0B. CHECK & FIX BROKEN LOBBY
        if (IsBrokenLobbyActive() && !IsGameActive()) {
            ToolTip("White lobby button detected! Fixing macro...")
            SendEvent("{c}")
            Sleep(500)
            SendEvent("{Backspace}")
            Sleep(1500)
            MagQueuen := true
        }

        ; 1. START QUEUE
        if (IsLobbyActive() && MagQueuen && !IsGameActive()) {
            ToolTip("Lobby detected: Queue started! (1x Enter)")
            SendEvent("{Enter}")
            MagQueuen := false
            Sleep(5000)
        }

        ; 2. PATIENTLY WAITING FOR THE GAME
        ToolTip("In queue... waiting for the game to start.")
        InGame := false
        QueueStartTime := A_TickCount

        while (!InGame && ScriptActive) {
            if (IsGameActive()) {
                InGame := true
                MagQueuen := true
                MissingHealthTicks := 0 ; Cleanly reset the timer for the new match
                ToolTip("Game started! Beginning the 8-minute routine...")
                break
            }

            if (IsBrokenLobbyActive() || IsFriendsMenu()) {
                break
            }

            if (A_TickCount - QueueStartTime > 240000) {
                ToolTip("4 minutes in queue! Pressing Enter once...")
                SendEvent("{Enter}")
                QueueStartTime := A_TickCount
                ToolTip("In queue... waiting for the game to start.")
            }

            Sleep(500)
        }

        if (!ScriptActive)
            break

        ; 3. THE IN-GAME ROUTINE
        if (InGame) {
            StartTime := A_TickCount
            MatchDuration := 8 * 60 * 1000
            SweepCounter := 0
            TrianglePressed := false

            while (A_TickCount - StartTime < MatchDuration && ScriptActive) {

                ; --- AUTO-RESPAWN CHECK ---
                if (IsSpectating()) {
                    ToolTip("Spectate mode detected! Respawning (Enter)...")
                    SendEvent("{Enter}")
                    if (SmartWait(2000, true)) {
                        break
                    }
                }

                ; --- SWEEP RIGHT ---
                SendEvent("{\ down}")
                SendEvent("{] down}")

                RandomMoveRight := Random(500, 3500)
                if (SmartWait(RandomMoveRight, true)) {
                    SendEvent("{] up}")
                    SendEvent("{\ up}")
                    break
                }

                SendEvent("{Up}")
                if (SmartWait(500, true)) {
                    SendEvent("{] up}")
                    SendEvent("{\ up}")
                    break
                }
                SendEvent("{] up}")
                SendEvent("{\ up}")

                if (BlindLoot()) {
                    break
                }

                ; --- AUTO-RESPAWN CHECK ---
                if (IsSpectating()) {
                    ToolTip("Spectate mode detected! Respawning (Enter)...")
                    SendEvent("{Enter}")
                    if (SmartWait(2000, true)) {
                        break
                    }
                }

                ; --- SWEEP LEFT ---
                SendEvent("{\ down}")
                SendEvent("{[ down}")

                RandomMoveLeft := Random(500, 3500)
                if (SmartWait(RandomMoveLeft, true)) {
                    SendEvent("{[ up}")
                    SendEvent("{\ up}")
                    break
                }

                SendEvent("{Up}")
                if (SmartWait(500, true)) {
                    SendEvent("{[ up}")
                    SendEvent("{\ up}")
                    break
                }
                SendEvent("{[ up}")
                SendEvent("{\ up}")

                if (BlindLoot()) {
                    break
                }

                SweepCounter++

                if (SweepCounter >= 10 && !TrianglePressed) {
                    ; Check the timer safeguard before accidentally pressing Triangle
                    if (MissingHealthTicks >= 30)
                        break

                    ToolTip("10 sweeps reached: pressing Triangle (c) once.")
                    SendEvent("{c}")
                    if (SmartWait(1000, true))
                        break

                    TrianglePressed := true
                    ToolTip("Game in progress! Looking for crates...")
                }
            }

            if (!ScriptActive)
                break

            ; 4. END OF THE MATCH (END SCREEN)
            if (!IsAnyLobbyActive() && !IsFriendsMenu()) {
                ToolTip("Match over! Forcing return to lobby...")

                SendEvent("{\ down}")
                SmartWait(3000, false)
                SendEvent("{\ up}")

                ToolTip("Waiting for the End Screen to pass (max 3 min)...")

                LobbyWaitTime := A_TickCount
                while (A_TickCount - LobbyWaitTime < 180000 && ScriptActive) {
                    if (IsAnyLobbyActive() || IsFriendsMenu()) {
                        break
                    }
                    Sleep(1000)
                }
            }
        }

        Sleep(1000)
    }
}

F9:: {
    Global ScriptActive := false
    Reload()
}

Esc::ExitApp()
