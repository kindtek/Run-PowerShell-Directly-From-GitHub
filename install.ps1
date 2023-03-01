# powershell version compatibility for PSScriptRoot
if (!$PSScriptRoot) { $PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent }
# jump to bottom line without clearing scrollback
Write-Output "$([char]27)[2J"

$repo_src_owner = 'kindtek'
$repo_src_name = 'devels-workshop'
$repo_src_branch = 'windows'
$dir_host = "$repo_src_owner/$repo_src_name/$repo_src_branch"
$dir_host_scripts = "$dir_host/scripts"
$local_dir_scripts = "$repo_src_name/scripts"
$local_devels_playground = "$repo_src_name/devel_playground"
$devels_advocate = "devels-advocate"
$local_devels_advocate = "$local_dir_scripts/$devels_advocate"
$local_powerhell = "$local_dir_scripts/powerhell-remote"
$local_choco = "$local_dir_scripts/choco"
$install_everything = "install-everything.ps1"
$get_latest_winget = "$devels_advocate/get-latest-winget.ps1"
$wsl_import = "devels_playground/scripts/wsl-import.bat"
$refresh_env = "choco/refresh-env/refresh-env.cmd"
$add_windows_features = "$devels_advocate/$repo_src_name/add-windows-features.ps1"

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

Write-Host "`n`rDownloading: https://raw.githubusercontent.com/$dir_host_scripts/$install_everything`r`nDestination: $local_dir_scripts/$install_everything" -ForegroundColor Magenta 
$WebClient.DownloadFile("https://raw.githubusercontent.com/$dir_host_scripts/$install_everything", "$local_dir_scripts/$install_everything")
Write-Host "`n`rDownloading: https://raw.githubusercontent.com/$dir_host_scripts/$get_latest_winget`r`nDestination: $local_dir_scripts/$get_latest_winget" -ForegroundColor Magenta 
$WebClient.DownloadFile("https://raw.githubusercontent.com/$dir_host_scripts/$get_latest_winget", "$local_dir_scripts/$get_latest_winget")
Write-Host "`n`rDownloading: https://raw.githubusercontent.com/$dir_host_scripts/$wsl_import`r`nDestination: $local_dir_scripts/$wsl_import" -ForegroundColor Magenta 
$WebClient.DownloadFile("https://raw.githubusercontent.com/$dir_host_scripts/$wsl_import", "$local_dir_scripts/$wsl_import")
Write-Host "`n`rDownloading: $refresh_env`r`nDestination: $local_dir_scripts/$refresh_env" -ForegroundColor Magenta 
$WebClient.DownloadFile("$refresh_env", "$local_dir_scripts/$refresh_env")
Write-Host "`n`rDownloading: https://raw.githubusercontent.com/$repo_src_owner/$add_windows_features`r`nDestination: $local_dir_scripts/$devels_advocate/add-windows-features.ps1`n`r" -ForegroundColor Magenta 
$WebClient.DownloadFile("https://raw.githubusercontent.com/$repo_src_owner/$add_windows_features", "$local_dir_scripts/$devels_advocate/add-windows-features.ps1")

Pop-Location

# return to original working dir
$file = "scripts/$install_everything"
powershell -Command $file