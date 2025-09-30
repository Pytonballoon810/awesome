#Requires AutoHotkey v2.0

^g::
{
    ; Copy selected text first
    Send("^c")
    Sleep 100
    
    ; Save clipboard content after copying (contains selected text)
    SelectedText := A_Clipboard
    ClipSaved := A_Clipboard
    
    ; Activate last active VS Code window
    DetectHiddenWindows true
    WinActivate("ahk_exe Code.exe")
    if !WinActive("ahk_exe Code.exe")
    {
        MsgBox "No active VS Code window found!"
        return
    }

    Sleep 150

    ; Open Command Palette
    Send("^+p")
    Sleep 250

    ; Run 'Chat: Open Chat (Ask)'
    Send("Chat: Open Chat (Ask)")
    Sleep 300
    Send("{Enter}")
    Sleep 300

    ; Paste selected text
    A_Clipboard := SelectedText
    Send("^v")
    Sleep 150

    ; Send Enter to submit
    Send("{Enter}")

    ; Restore clipboard
    A_Clipboard := ClipSaved
}

^+g::
{
    ; Copy selected text first
    Send("^c")
    Sleep 100
    
    ; Save clipboard content after copying (contains selected text)
    SelectedText := A_Clipboard
    ClipSaved := A_Clipboard
    
    ; Activate last active VS Code window
    DetectHiddenWindows true
    WinActivate("ahk_exe Code.exe")
    if !WinActive("ahk_exe Code.exe")
    {
        MsgBox "No active VS Code window found!"
        return
    }

    Sleep 150

    ; Open Command Palette
    Send("^+p")
    Sleep 250

    ; Run 'Chat: New Chat'
    Send("Chat: New Chat")
    Sleep 300
    Send("{Enter}")
    Sleep 300

    ; Change to 'Chat: Open Chat (Ask)'
    Send("Chat: Open Chat (Ask)")
    Sleep 300
    Send("{Enter}")
    Sleep 300

    ; Paste selected text
    A_Clipboard := SelectedText
    Send("^v")
    Sleep 150

    ; Send Enter to submit
    Send("{Enter}")

    ; Restore clipboard
    A_Clipboard := ClipSaved
}
