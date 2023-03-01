# powershell version compatibility for PSScriptRoot
if (!$PSScriptRoot) { $PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent }
# jump to bottom line without clearing scrollback
Write-Output "$([char]27)[2J"

$github_domain = "https://raw.githubusercontent.com"
$repo_src_owner = 'kindtek'
$repo_src_name = 'devels-workshop'
$repo_src_branch = 'windows'
$devels_advocate = "devels-advocate"
$devels_playground = "devels-playground"
$choco = "choco"

$dir_host_devels_workshop = "$repo_src_owner/$repo_src_name/$repo_src_branch"
$dir_host_devels_workshop_scripts = "$dir_host_devels_workshop/scripts"
$dir_host_devels_advocate = "$repo_src_owner/$devels_advocate/$repo_src_name"
$dir_host_devels_playground = "$repo_src_owner/$devels_playground/$repo_src_name/scripts"
$dir_host_choco = "$repo_src_owner/$choco/refresh-env"

$local_dir_scripts = "$repo_src_name/scripts"
$local_devels_playground = "$repo_src_name/$devels_playground/scripts"
$local_devels_advocate = "$local_dir_scripts/$devels_advocate"
$local_choco = "$local_dir_scripts/$choco"
$install_everything = "install-everything.ps1"
$get_latest_winget = "get-latest-winget.ps1"
$wsl_import = "wsl-import-docker-image.cmd"
$refresh_env = "refresh-env.cmd"
$add_windows_features = "add-windows-features.ps1"


$WebClient = New-Object System.Net.WebClient

# simulate structure of incoming repo
$null = New-Item -Path "$repo_src_name" -ItemType Directory -Force -ErrorAction SilentlyContinue 
Push-Location "$repo_src_name"
$null = New-Item -Path "$devels_playground/scripts" -ItemType Directory -Force -ErrorAction SilentlyContinue 
$null = New-Item -Path "scripts/$choco" -ItemType Directory -Force -ErrorAction SilentlyContinue 
$null = New-Item -Path "scripts/$devels_advocate" -ItemType Directory -Force -ErrorAction SilentlyContinue 


Write-Host "`n`rDownloading: $github_domain/$dir_host_devels_workshop_scripts/$install_everything`r`nDestination: $local_dir_scripts/$install_everything" -ForegroundColor Magenta 
$WebClient.DownloadFile("$github_domain/$dir_host_devels_workshop_scripts/$install_everything", "$local_dir_scripts/$install_everything")
Write-Host "`n`rDownloading: $github_domain/$dir_host_devels_advocate/$get_latest_winget`r`nDestination: $local_devels_advocate/$get_latest_winget" -ForegroundColor Magenta 
$WebClient.DownloadFile("$github_domain/$dir_host_devels_advocate/$get_latest_winget", "$local_devels_advocate/$get_latest_winget")
Write-Host "`n`rDownloading: $github_domain/$dir_host_devels_playground/$wsl_import`r`nDestination: $local_devels_playground/$wsl_import" -ForegroundColor Magenta 
$WebClient.DownloadFile("$github_domain/$dir_host_devels_playground/$wsl_import", "$local_devels_playground/$wsl_import")
Write-Host "`n`rDownloading: $github_domain/$dir_host_choco/$refresh_env`r`nDestination: $local_choco/$refresh_env" -ForegroundColor Magenta 
$WebClient.DownloadFile("$github_domain/$dir_host_choco/$refresh_env", "$local_choco/$refresh_env")
Write-Host "`n`rDownloading: $github_domain/$dir_host_devels_advocate/$add_windows_features`r`nDestination: $local_devels_advocate/$add_windows_features`n`r" -ForegroundColor Magenta 
$WebClient.DownloadFile("$github_domain/$dir_host_devels_advocate/$add_windows_features", "$local_devels_advocate/$add_windows_features")

# return to original working dir
$file = "scripts/$install_everything"
powershell -Command $file