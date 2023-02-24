$PSCommandPath | Split-Path -Parent
$ScriptFromGitHub1 = Invoke-WebRequest https://raw.githubusercontent.com/kindtek/docker-to-wsl/dev/scripts/docker-wsl-install.ps1 -OutFile "docker-wsl-install.ps1"
Invoke-Expression $($ScriptFromGitHub1.Content)
$WebClient = New-Object System.Net.WebClient
$WebClient.DownloadFile("https://raw.githubusercontent.com/kindtek/docker-to-wsl/dev/scripts/get-latest-winget.ps1", "get-latest-winget.ps1")
# $ScriptFromGitHub2 = Invoke-WebRequest https://raw.githubusercontent.com/kindtek/docker-to-wsl/dev/scripts/get-latest-winget.ps1 -OutFile "docker-wsl-install.ps1"
# Invoke-Expression $($ScriptFromGitHub.Content2)
./docker-wsl-install.ps1
