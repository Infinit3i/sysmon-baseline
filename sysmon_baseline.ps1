# Created by Matthew Iverson

# Import the PSGumshoe module
Import-Module PSGumshoe

# Set up parameters
$SysmonLogPath = "C:\Logs\Sysmon.evtx"  # Path to Sysmon logs (optional for exported logs)
$OutputPath = "C:\Reports\SysmonBaseline.csv"  # Path to save the baseline report

# Check if the module is installed
if (-not (Get-Module -Name PSGumshoe -ListAvailable)) {
    Write-Output "PSGumshoe is not installed. Installing now..."
    Install-Module -Name PSGumshoe -Scope CurrentUser -Force
    Import-Module PSGumshoe
}

# Ensure the output directory exists
$OutputDir = Split-Path $OutputPath
if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir | Out-Null
}

# Load Sysmon logs from Event Viewer or a file
if (Test-Path $SysmonLogPath) {
    Write-Output "Loading Sysmon logs from file: $SysmonLogPath"
    $SysmonLogs = Get-WinEvent -Path $SysmonLogPath
} else {
    Write-Output "Loading Sysmon logs from Event Viewer..."
    $SysmonLogs = Get-WinEvent -LogName "Microsoft-Windows-Sysmon/Operational"
}

# Analyze Sysmon logs for baseline events
Write-Output "Analyzing Sysmon logs for baseline activity..."
$Baseline = Invoke-GumshoeBaseline -LogData $SysmonLogs -IncludeSysmon

# Save the baseline report
Write-Output "Saving baseline report to: $OutputPath"
$Baseline | Export-Csv -Path $OutputPath -NoTypeInformation

Write-Output "Baseline analysis complete. Report saved to $OutputPath."
