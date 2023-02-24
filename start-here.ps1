$PSCommandPath | Split-Path -Parent
$pwd_path = Split-Path -Path $PSCommandPath
# @TODO: update branch to main
$ScriptFromGitHub = Invoke-WebRequest 'https://raw.githubusercontent.com/kindtek/docker-to-wsl/dev/scripts/docker-wsl-install.ps1' -OutFile $pwd_path/docker-wsl-install.ps1
Invoke-Expression $($ScriptFromGitHub.Content)
$WebClient = New-Object System.Net.WebClient
$WebClient.DownloadFile('https://raw.githubusercontent.com/kindtek/docker-to-wsl/dev/scripts/get-latest-winget.ps1', "$pwd_path/get-latest-winget.ps1" )
# $ScriptFromGitHub2 = Invoke-WebRequest https://raw.githubusercontent.com/kindtek/docker-to-wsl/dev/scripts/get-latest-winget.ps1 -OutFile "docker-wsl-install.ps1"
# Invoke-Expression $($ScriptFromGitHub2.Content)
./$pwd_path/docker-wsl-install.ps1
