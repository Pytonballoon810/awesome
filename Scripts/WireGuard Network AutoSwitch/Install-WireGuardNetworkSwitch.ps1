# Installer Script for WireGuard AutoSwitch

# Variables
$scriptPath = "C:\Scripts"
$psScript = "$scriptPath\Check-NetworkAndTunnel.ps1"
$tunnelName = "MyTunnel.conf"
$trustedNetwork = "MyHomeWiFi"
$taskName = "WireGuard Network AutoSwitch"
$wgExe = "C:\Program Files\WireGuard\wireguard.exe"

# Create Scripts directory if not exists
if (-Not (Test-Path $scriptPath)) {
    New-Item -ItemType Directory -Path $scriptPath | Out-Null
}

# Write the PowerShell script
@"
# Auto-switch WireGuard tunnel based on network connection

\$trustedNetwork = `"$trustedNetwork`"
\$wgExe = `"$wgExe`"
\$tunnelName = `"$tunnelName`"

\$currentNetwork = (Get-NetConnectionProfile | Where-Object {\$_.IPv4Connectivity -ne `"Disconnected`"} | Select-Object -First 1).Name

if (\$currentNetwork -like `"*\$trustedNetwork*`") {
    Start-Process \$wgExe -ArgumentList "/uninstalltunnelservice `"\$tunnelName`"" -NoNewWindow -Wait
} else {
    Start-Process \$wgExe -ArgumentList "/installtunnelservice `"\$tunnelName`"" -NoNewWindow -Wait
}
"@ | Set-Content -Path $psScript -Encoding UTF8

# Set Execution Policy (if needed)
try {
    Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force
} catch {
    Write-Host "Could not set execution policy. You may need to run this script as administrator."
}

# Create Scheduled Task Action
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$psScript`""

# Create Scheduled Task Trigger (on NetworkProfile event ID 10000)
$trigger = New-ScheduledTaskTrigger -AtStartup
$trigger.Enabled = $true

# Add event-based trigger for network connection (Event ID 10000)
$networkTrigger = New-ScheduledTaskTrigger -Subscription """
<QueryList>
  <Query Id=`"0`" Path=`"Microsoft-Windows-NetworkProfile/Operational`">
    <Select Path=`"Microsoft-Windows-NetworkProfile/Operational`">*[System[EventID=10000]]</Select>
  </Query>
</QueryList>
""" -Enabled $true

# Task principal (run as highest privileges)
$principal = New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -RunLevel Highest

# Register the Task
try {
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false -ErrorAction SilentlyContinue
} catch {}

Register-ScheduledTask -TaskName $taskName -Action $action -Trigger @($trigger, $networkTrigger) -Principal $principal

Write-Host "✅ WireGuard Network AutoSwitch installed successfully."
Write-Host "   - Script path: $psScript"
Write-Host "   - Tunnel config: $tunnelName"
Write-Host "   - Trusted network: $trustedNetwork"
Write-Host "   - Scheduled Task: $taskName"
