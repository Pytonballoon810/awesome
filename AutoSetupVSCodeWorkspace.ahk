#Requires AutoHotkey v2
#SingleInstance Force
#Warn All, StdOut  ; Enable warnings for debugging

; Create an invisible GUI to keep the script running
myGui := Gui("+AlwaysOnTop -Caption +ToolWindow")
myGui.Show("w0 h0 x0 y0")

; Add debug log function
DebugLog(msg) {
    FileAppend(FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss") . " " . msg . "`n", A_ScriptDir . "\VSCodeSetupLog.txt")
}

DebugLog("Script started")

; Load Windows API function
global hHook1 := 0, hHook2 := 0, hHook3 := 0

; Event constants
EVENT_OBJECT_CREATE := 0x8000
EVENT_OBJECT_SHOW := 0x8002  ; Add SHOW event to catch windows that might not trigger CREATE
EVENT_SYSTEM_FOREGROUND := 0x0003  ; Detect when windows come to foreground
WINEVENT_OUTOFCONTEXT := 0x0000

; Start listening for multiple event types to ensure we catch VS Code windows
hHook1 := DllCall("SetWinEventHook", "UInt", EVENT_OBJECT_CREATE, "UInt", EVENT_OBJECT_CREATE, 
                "Ptr", 0, "Ptr", CallbackCreate(WinEventProc, "Fast"), 
                "UInt", 0, "UInt", 0, "UInt", WINEVENT_OUTOFCONTEXT)

hHook2 := DllCall("SetWinEventHook", "UInt", EVENT_OBJECT_SHOW, "UInt", EVENT_OBJECT_SHOW, 
                "Ptr", 0, "Ptr", CallbackCreate(WinEventProc, "Fast"), 
                "UInt", 0, "UInt", 0, "UInt", WINEVENT_OUTOFCONTEXT)

hHook3 := DllCall("SetWinEventHook", "UInt", EVENT_SYSTEM_FOREGROUND, "UInt", EVENT_SYSTEM_FOREGROUND, 
                "Ptr", 0, "Ptr", CallbackCreate(WinEventProc, "Fast"), 
                "UInt", 0, "UInt", 0, "UInt", WINEVENT_OUTOFCONTEXT)

if (!hHook1 || !hHook2 || !hHook3) {
    DebugLog("Failed to set one or more event hooks")
    MsgBox("Failed to set event hooks")
}

OnExit(Shutdown)

; Tray menu for control
try {
    TraySetIcon("shell32.dll", 44)
    A_TrayMenu.Add("Check Now", CheckVSCodeWindows)
    A_TrayMenu.Add()  ; Add a separator
    A_TrayMenu.Add("Exit", (*) => ExitApp())
    A_TrayMenu.ToolTip := "VS Code Auto-Setup Monitor"
    DebugLog("Tray menu setup complete")
} catch as e {
    DebugLog("Error setting up tray: " . e.Message)
}

; Set a timer to periodically check for VS Code windows as a fallback
SetTimer(CheckVSCodeWindows, 10000)  ; Check every 10 seconds

global processedWindows := Map()  ; Track windows we've already processed

; Function to check all open VS Code windows
CheckVSCodeWindows(*) {
    DebugLog("Checking for VS Code windows")
    DetectHiddenWindows(true)
    
    ; Try different approaches to find VS Code windows
    ; 1. By window class
    windowList := WinGetList("ahk_class Chrome_WidgetWin_1")
    
    ; 2. By process name
    processList := ProcessGetList("Code.exe")
    if (processList.Length > 0) {
        DebugLog("Found " . processList.Length . " VS Code processes")
    }
    
    ; Process windows found by class
    for hwnd in windowList {
        title := WinGetTitle("ahk_id " . hwnd)
        processName := WinGetProcessName("ahk_id " . hwnd)
        
        DebugLog("Found window: " . title . " (Process: " . processName . ")")
        
        if (InStr(title, "Visual Studio Code") || InStr(processName, "Code.exe")) {
            ; Check if we've processed this window before
            if (!processedWindows.Has(hwnd)) {
                ProcessVSCodeWindow(title)
                processedWindows[hwnd] := true
                DebugLog("Processed new VS Code window: " . title)
            }
        }
    }
}

; Process a VS Code window title
ProcessVSCodeWindow(fullTitle) {
    DebugLog("Processing VS Code window: " . fullTitle)
    
    ; Parse VS Code title with the workspace folder appearing before a '|' symbol
    titleParts := StrSplit(fullTitle, "|")
    if (titleParts.Length >= 2) {
        workspacePath := Trim(titleParts[1])  ; AHK v2 arrays are 1-based, not 0-based
        DebugLog("Found workspace path: " . workspacePath)
        
        ; Define template folder location
        templateDir := "C:\Users\Philipp\Documents\GitHub\awesome\Templates"
        
        ; Check if workspace directory exists
        if DirExist(workspacePath) {
            DebugLog("Workspace directory exists, copying files")
            ; Compare files and copy missing ones
            CopyMissingFiles(templateDir, workspacePath)
            TrayTip("Template files copied to workspace", "VS Code Auto-Setup")
        } else {
            DebugLog("Workspace directory doesn't exist: " . workspacePath)
        }
    } else {
        DebugLog("Title doesn't contain expected format: " . fullTitle)
    }
}

; Event callback
WinEventProc(hWinEventHook, event, hwnd, idObject, idChild, dwEventThread, dwmsEventTime) {
    if idObject != 0 or !WinExist("ahk_id " hwnd)
        return

    ; Log the event
    eventType := "Unknown"
    if (event = EVENT_OBJECT_CREATE)
        eventType := "CREATE"
    else if (event = EVENT_OBJECT_SHOW)
        eventType := "SHOW"
    else if (event = EVENT_SYSTEM_FOREGROUND)
        eventType := "FOREGROUND"
        
    DebugLog("Window event: " . eventType . " for window " . hwnd)

    ; Wait a moment for the window to fully initialize
    Sleep(100)
    
    className := WinGetClass("ahk_id " hwnd)
    processName := WinGetProcessName("ahk_id " hwnd)
    title := WinGetTitle("ahk_id " hwnd)
    
    DebugLog("Window info - Class: " . className . ", Process: " . processName . ", Title: " . title)
    
    ; Check for VS Code in multiple ways
    isVSCode := false
    if (InStr(title, "Visual Studio Code"))
        isVSCode := true
    else if (InStr(processName, "Code.exe"))
        isVSCode := true
    else if (className = "Chrome_WidgetWin_1" && InStr(title, "VS Code"))
        isVSCode := true
        
    if (isVSCode) {
        DebugLog("VS Code window detected: " . title)
        
        ; Check if we've processed this window before
        if (!processedWindows.Has(hwnd)) {
            ; Give more time for the window title to stabilize
            Sleep(1000)
            
            fullTitle := WinGetTitle("ahk_id " hwnd)
            ProcessVSCodeWindow(fullTitle)
            processedWindows[hwnd] := true
        }
    }
}

; Function to copy files missing in destination but present in template
CopyMissingFiles(sourceDir, destDir) {
    ; Ensure destination directory exists
    if !DirExist(destDir)
        DirCreate(destDir)
    
    ; Get all files in source directory
    Loop Files, sourceDir . "\*.*", "F" {
        sourceFile := A_LoopFileFullPath
        destFile := destDir . "\" . A_LoopFileName
        
        ; If file doesn't exist in destination, copy it
        if !FileExist(destFile) {
            FileCopy(sourceFile, destFile)
            TrayTip("Copied: " . A_LoopFileName, "Template File")
        }
    }
    
    ; Process subdirectories recursively
    Loop Files, sourceDir . "\*.*", "D" {
        subSourceDir := A_LoopFileFullPath
        subDestDir := destDir . "\" . A_LoopFileName
        
        CopyMissingFiles(subSourceDir, subDestDir)
    }
}

Shutdown(*) {
    if (hHook1)
        DllCall("UnhookWinEvent", "Ptr", hHook1)
    if (hHook2)
        DllCall("UnhookWinEvent", "Ptr", hHook2)
    if (hHook3)
        DllCall("UnhookWinEvent", "Ptr", hHook3)
    DebugLog("Script shutdown")
}

