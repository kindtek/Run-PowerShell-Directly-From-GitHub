# powershell version compatibility for PSScriptRoot
if (!$PSScriptRoot) { $PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent }
# jump to bottom line without clearing scrollback
Write-Output "$([char]27)[2J"

$repo_src_owner = 'kindtek'
$repo_src_name = 'devels-workshop'
$repo_src_branch = 'main'
$dir_host = "$repo_src_owner/$repo_src_name/$repo_src_branch/scripts"
$dir_local = "$repo_src_name/scripts"
$download1 = "docker-wsl-install.ps1"
$download2 = "get-latest-winget.ps1"
$download3 = "wsl-import.bat"
$download4 = "https://raw.githubusercontent.com/kindtek/choco/develop/src/chocolatey.resources/redirects/RefreshEnv.cmd"
$devels_advocate = "devels-advocate"
$download5 = "$devels_advocate/$repo_src_name/add-windows-features.ps1"

# clear way for git clone
if (Test-Path -Path "$PSScriptRoot/$repo_src_name-temp") {
    Rename-Item "$PSScriptRoot/$repo_src_name-temp" "$PSScriptRoot/$repo_src_name-delete"
}

$WebClient = New-Object System.Net.WebClient

# simulate structure of incoming repo
$null = New-Item -Path "$repo_src_name" -ItemType Directory -Force -ErrorAction SilentlyContinue 
Push-Location "$repo_src_name"
$null = New-Item -Path scripts -ItemType Directory -Force -ErrorAction SilentlyContinue 
Push-Location scripts
$null = New-Item -Path $devels_advocate -ItemType Directory -Force -ErrorAction SilentlyContinue 

Write-Host "`n`rDownloading: https://raw.githubusercontent.com/$dir_host/$download1`r`nDestination: $dir_local/$download1" -ForegroundColor Magenta 
$WebClient.DownloadFile("https://raw.githubusercontent.com/$dir_host/$download1", "$dir_local/$download1")
Write-Host "`n`rDownloading: https://raw.githubusercontent.com/$dir_host/$download2`r`nDestination: $dir_local/$download2" -ForegroundColor Magenta 
$WebClient.DownloadFile("https://raw.githubusercontent.com/$dir_host/$download2", "$dir_local/$download2")
Write-Host "`n`rDownloading: https://raw.githubusercontent.com/$dir_host/$download3`r`nDestination: $dir_local/$download3" -ForegroundColor Magenta 
$WebClient.DownloadFile("https://raw.githubusercontent.com/$dir_host/$download3", "$dir_local/$download3")
Write-Host "`n`rDownloading: $download4`r`nDestination: $dir_local/$download4" -ForegroundColor Magenta 
$WebClient.DownloadFile("$download4", "$dir_local/RefreshEnv.cmd")
Push-Location $devels_advocate
Write-Host "`n`rDownloading: https://raw.githubusercontent.com/$repo_src_owner/$download5`r`nDestination: $dir_local/$devels_advocate/add-windows-features.ps1`n`r" -ForegroundColor Magenta 
$WebClient.DownloadFile("https://raw.githubusercontent.com/$repo_src_owner/$download5", "$dir_local/$devels_advocate/add-windows-features.ps1")

Pop-Location
Pop-Location

# return to original working dir
$file = "scripts/$download1"
powershell -Command $file