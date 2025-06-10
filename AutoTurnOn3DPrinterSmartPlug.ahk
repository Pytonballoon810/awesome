; filepath: c:\Users\Philipp\Documents\GitHub\awesome\AutoTurnOn3DPrinterSmartPlug.ahk
; AutoHotkey v2 script to monitor for slicer apps and turn on 3D printer power

; ===== CONFIGURATION =====
; Load configuration from .env file
LoadEnvFile()

; Target applications to monitor for
SlicerProcesses := ["orca-slicer.exe", "bambu-studio.exe"]
LastState := false ; Tracks if a slicer was running in the previous check

; Check every 5 seconds
SetTimer(CheckForSlicers, 5000)
DetectHiddenWindows(true)

; ===== FUNCTIONS =====
LoadEnvFile() {
    global HomeAssistantURL, AuthToken, SmartPlugEntityId
    
    envFilePath := A_ScriptDir . "\.env"
    
    ; Check if .env file exists
    if !FileExist(envFilePath) {
        MsgBox("Error: .env file not found at " . envFilePath . "`nPlease create the .env file with your configuration.")
        ExitApp()
    }
    
    ; Read the .env file
    try {
        envContent := FileRead(envFilePath)
        
        ; Parse each line
        for line in StrSplit(envContent, "`n", "`r") {
            line := Trim(line)
            
            ; Skip empty lines and comments
            if (line = "" || SubStr(line, 1, 1) = "#" || SubStr(line, 1, 2) = "//")
                continue
                
            ; Parse key=value pairs
            if (InStr(line, "=")) {
                parts := StrSplit(line, "=", , 2)
                key := Trim(parts[1])
                value := Trim(parts[2])
                
                ; Remove quotes if present
                if (SubStr(value, 1, 1) = '"' && SubStr(value, -1) = '"')
                    value := SubStr(value, 2, StrLen(value) - 2)
                
                ; Assign values to global variables
                switch key {
                    case "HomeAssistantURL":
                        HomeAssistantURL := value
                    case "AuthToken":
                        AuthToken := value
                    case "SmartPlugEntityId":
                        SmartPlugEntityId := value
                }
            }
        }
        
        ; Validate that all required variables are loaded
        if (!HomeAssistantURL || !AuthToken || !SmartPlugEntityId) {
            MsgBox("Error: Missing required configuration in .env file.`nRequired: HomeAssistantURL, AuthToken, SmartPlugEntityId")
            ExitApp()
        }
        
    } catch as e {
        MsgBox("Error reading .env file: " . e.Message)
        ExitApp()
    }
}

CheckForSlicers() {
    global LastState, SlicerProcesses
    
    slicerIsRunning := false
    
    ; Check if any of the target processes are running
    for process in SlicerProcesses {
        if ProcessExist(process) {
            slicerIsRunning := true
            break
        }
    }
    
    ; If a slicer just started and wasn't running before, turn on the smart plug
    if (slicerIsRunning && !LastState) {
        TurnOnSmartPlug()
        TrayTip("3D Printer Smart Plug", "Turning on printer smart plug", 5)
    }
    
    ; Update the last state
    LastState := slicerIsRunning
}

TurnOnSmartPlug() {
    global HomeAssistantURL, AuthToken, SmartPlugEntityId
    
    ; Create the URL for the service call
    url := HomeAssistantURL . "/api/services/switch/turn_on"
    
    ; Prepare the payload
    payload := '{"entity_id": "' . SmartPlugEntityId . '"}'
    
    ; Send the HTTP request
    try {
        http := ComObject("WinHttp.WinHttpRequest.5.1")
        http.Open("POST", url, false)
        http.SetRequestHeader("Authorization", "Bearer " . AuthToken)
        http.SetRequestHeader("Content-Type", "application/json")
        http.Send(payload)
        
        ; Check if the request was successful (2xx status code)
        if (http.Status >= 200 && http.Status < 300) {
            return true
        } else {
            MsgBox("Failed to turn on smart plug.`nStatus code: " . http.Status . "`nResponse: " . http.ResponseText)
            return false
        }
    } catch as e {
        MsgBox("Error sending request: " . e.Message)
        return false
    }
}

; Display a notification when the script starts
TrayTip("3D Printer Smart Plug Monitor", "Script is now monitoring for slicer applications", 5)