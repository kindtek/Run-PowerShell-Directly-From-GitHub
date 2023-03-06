$host.UI.RawUI.ForegroundColor = "White"
$host.UI.RawUI.BackgroundColor = "Black"
# powershell version compatibility for PSScriptRoot
if (!$PSScriptRoot) { $PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent }
# jump to bottom line without clearing scrollback
Write-Host "$([char]27)[2J"

$github_domain = "https://raw.githubusercontent.com"
$repo_src_owner = 'kindtek'
$repo_src_name = 'devels-workshop'
$repo_src_branch = 'main'
$devels_advocate = "devels-advocate"
$devels_playground = "devels-playground"
$choco = "choco"

$host_devels_workshop = "$repo_src_owner/$repo_src_name/$repo_src_branch"
$host_devels_workshop_scripts = "$host_devels_workshop/scripts"
$host_devels_advocate = "$repo_src_owner/$devels_advocate/$repo_src_name"
$host_devels_playground = "$repo_src_owner/$devels_playground/$repo_src_name/scripts"
$host_choco = "$repo_src_owner/$choco/devels-workshop/src/chocolatey.resources/redirects"


$local_dir_scripts = "$repo_src_owner/$repo_src_name-temp/scripts"
$local_devels_playground = "$repo_src_owner/$repo_src_name-temp/$devels_playground/scripts"
$local_devels_advocate = "$local_dir_scripts/$devels_advocate"
$local_choco = "$local_dir_scripts/$choco/src/chocolatey.resources/redirects"
$install_everything = "install-everything.ps1"
$get_latest_winget = "get-latest-winget.ps1"
$get_latest_choco = "get-latest-choco.ps1"
$wsl_import = "wsl-docker-import.cmd"
$refresh_env = "RefreshEnv.cmd"
$get_latest_choco = "get-latest-choco.ps1"
$add_windows_features = "add-windows-features.ps1"

$WebClient = New-Object System.Net.WebClient

$start_over = 'n'
do {
    # simulate structure of incoming repo
    $null = New-Item -Path "$repo_src_owner" -ItemType Directory -Force -ErrorAction SilentlyContinue 
    Push-Location "$repo_src_owner"
    $null = New-Item -Path "$repo_src_name-temp" -ItemType Directory -Force -ErrorAction SilentlyContinue 
    Push-Location "$repo_src_name-temp"
    $null = New-Item -Path "$devels_playground/scripts" -ItemType Directory -Force -ErrorAction SilentlyContinue 
    $null = New-Item -Path "scripts/$choco" -ItemType Directory -Force -ErrorAction SilentlyContinue 
    $null = New-Item -Path "scripts/$devels_advocate" -ItemType Directory -Force -ErrorAction SilentlyContinue 
    $null = New-Item -Path "scripts/$choco/src/chocolatey.resources/redirects" -ItemType Directory -Force -ErrorAction SilentlyContinue 

    Pop-Location

    Write-Host "`n`rDownloading: $github_domain/$host_devels_workshop_scripts/$install_everything`r`nDestination: $local_dir_scripts/$install_everything" -ForegroundColor Magenta 
    $WebClient.DownloadFile("$github_domain/$host_devels_workshop_scripts/$install_everything", "$local_dir_scripts/$install_everything")
    Write-Host "`n`rDownloading: $github_domain/$host_devels_advocate/$get_latest_winget`r`nDestination: $local_devels_advocate/$get_latest_winget" -ForegroundColor Magenta 
    $WebClient.DownloadFile("$github_domain/$host_devels_advocate/$get_latest_winget", "$local_devels_advocate/$get_latest_winget")
    Write-Host "`n`rDownloading: $github_domain/$host_devels_playground/$wsl_import`r`nDestination: $local_devels_playground/$wsl_import" -ForegroundColor Magenta 
    $WebClient.DownloadFile("$github_domain/$host_devels_playground/$wsl_import", "$local_devels_playground/$wsl_import")
    Write-Host "`n`rDownloading: $github_domain/$host_devels_advocate/$get_latest_choco`r`nDestination: $local_devels_advocate/$get_latest_choco" -ForegroundColor Magenta 
    $WebClient.DownloadFile("$github_domain/$host_devels_advocate/$get_latest_choco", "$local_devels_advocate/$get_latest_choco")
    Write-Host "`n`rDownloading: $github_domain/$host_choco/$refresh_env`r`nDestination: $local_choco/$refresh_env" -ForegroundColor Magenta 
    $WebClient.DownloadFile("$github_domain/$host_choco/$refresh_env", "$local_choco/$refresh_env")
    Write-Host "`n`rDownloading: $github_domain/$host_devels_advocate/$add_windows_features`r`nDestination: $local_devels_advocate/$add_windows_features`n`r" -ForegroundColor Magenta 
    $WebClient.DownloadFile("$github_domain/$host_devels_advocate/$add_windows_features", "$local_devels_advocate/$add_windows_features")

    Pop-Location

    # return to original working dir
    $file = "$local_dir_scripts/$install_everything"
    $host.UI.RawUI.ForegroundColor = "Yello"
    $host.UI.RawUI.BackgroundColor = "Magenta"
    $confirmation = Read-Host "`r`nRestarts may be required as new applications are installed. Save your work now.`r`n`r`n`tHit ENTER to continue`r`n`r`n`tpowershell.exe -Command $file" 


    if ($confirmation -eq "") {
        powershell.exe -Command $file
        Write-Host "`r`n"
        $start_over = Read-Host "`r`nWould you like to start over? (y/[n])" 
    }
} while ($start_over -ieq 'y')

Write-Host "`r`nGoodbye!`r`n"
