#Requires AutoHotkey v2.0

^+v:: {  ; Ctrl+Shift+V hotkey
    ClipSaved := ClipboardAll()  ; Save full clipboard content (all formats)
    ClipText := A_Clipboard      ; Get clipboard text using the built-in variable

    ; Comprehensive escaping - order is important!
    ; First escape backslashes (\ to \\)
    ClipText := StrReplace(ClipText, "\", "\\")
    
    ; Also escape forward slashes (/ to \/) if needed for paths
    ClipText := StrReplace(ClipText, "/", "\/")
    
    ; Then escape double quotes (")
    ClipText := StrReplace(ClipText, '"', '\"')
    
    ; Escape other special characters if needed
    ClipText := StrReplace(ClipText, "`t", "\t")
    ClipText := StrReplace(ClipText, "`r`n", "\n")
    ClipText := StrReplace(ClipText, "`n", "\n")
    
    ; Temporarily set clipboard to the escaped text
    A_Clipboard := ClipText
    
    ; Use a more reliable paste method with ClipWait
    Sleep 50  ; Small delay to ensure clipboard is ready
    Send "^v"  ; Send Ctrl+V to paste
    
    ; Wait a moment to ensure pasting completes
    Sleep 100
    
    ; Restore original clipboard
    A_Clipboard := ClipSaved
}
