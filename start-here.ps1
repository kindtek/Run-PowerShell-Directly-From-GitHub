$PSCommandPath | Split-Path -Parent
$pwd_path = Split-Path -Path $PSCommandPath
$ScriptFromGitHub1 = Invoke-WebRequest https://raw.githubusercontent.com/kindtek/docker-to-wsl/dev/scripts/docker-wsl-install.ps1 -OutFile "docker-wsl-install.ps1"
Invoke-Expression $($ScriptFromGitHub1.Content)
$WebClient = New-Object System.Net.WebClient
$WebClient.DownloadFile("https://raw.githubusercontent.com/kindtek/docker-to-wsl/dev/scripts/get-latest-winget.ps1", "get-latest-winget.ps1")
# $ScriptFromGitHub2 = Invoke-WebRequest https://raw.githubusercontent.com/kindtek/docker-to-wsl/dev/scripts/get-latest-winget.ps1 -OutFile "docker-wsl-install.ps1"
# Invoke-Expression $($ScriptFromGitHub.Content2)
    # clone docker-to-wsl repo
    $user_name = kindtek
    $repo_name = docker-to-wsl
    git clone 'https://github.com/kindtek/docker-to-wsl.git' --branch dev
    git submodule update --init set-branch dev
    Set-Location $pwd_path/scripts/powershell-remote
    Start-Process -FilePath start-here.ps1
    Write-Output "pwd_path:$pwd_path"
./docker-wsl-install.ps1
