# $$$$$$\            $$$$$$\  $$\           $$\   $$\      $$$$$$\  $$\ 
# \_$$  _|          $$  __$$\ \__|          \__|  $$ |    $$ ___$$\ \__|
#   $$ |  $$$$$$$\  $$ /  \__|$$\ $$$$$$$\  $$\ $$$$$$\   \_/   $$ |$$\ 
#   $$ |  $$  __$$\ $$$$\     $$ |$$  __$$\ $$ |\_$$  _|    $$$$$ / $$ |
#   $$ |  $$ |  $$ |$$  _|    $$ |$$ |  $$ |$$ |  $$ |      \___$$\ $$ |
#   $$ |  $$ |  $$ |$$ |      $$ |$$ |  $$ |$$ |  $$ |$$\ $$\   $$ |$$ |
# $$$$$$\ $$ |  $$ |$$ |      $$ |$$ |  $$ |$$ |  \$$$$  |\$$$$$$  |$$ |
# \______|\__|  \__|\__|      \__|\__|  \__|\__|   \____/  \______/ \__|
         

# Functionality for sysmon scripts
install-module -name PSGumshoe

# Needed to have PSGumshoe
Set-ExecutionPolicy RemoteSigned


# will watch all these files
sysmon -c -l a.exe
sysmon -c -l ab.exe
sysmon -c -l update.vbs

# Look if anyone is trying to change permissions on a file
sysmon -c -k lsass.exe
sysmon -c -k sysmon.exe

$processcreation = Get-SysmonProcessCreateEvent | select user,parentcommandline,commandline -Unique
# $processcreation | Out-GridView # will show process creation in csv viewer
$processcreation | Export-Csv .\processdata.csv
$processcreation | ConvertTo-SysmonRule

Get-SysmonFileTime | select image -Unique


# Video 7