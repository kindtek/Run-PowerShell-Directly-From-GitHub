$ScriptFromGitHub1 = Invoke-WebRequest 'https://raw.githubusercontent.com/kindtek/docker-to-wsl/dev/scripts/docker-wsl-install.ps1' -OutFile "docker-wsl-install.ps1"
Invoke-Expression $($ScriptFromGitHub1.Content)
$WebClient = New-Object System.Net.WebClient
$WebClient.DownloadFile("https://raw.githubusercontent.com/kindtek/docker-to-wsl/dev/scripts/get-latest-winget.ps1", "get-latest-winget.ps1")
# $ScriptFromGitHub2 = Invoke-WebRequest https://raw.githubusercontent.com/kindtek/docker-to-wsl/dev/scripts/get-latest-winget.ps1 -OutFile "docker-wsl-install.ps1"
# Invoke-Expression $($ScriptFromGitHub.Content2)
    # clone docker-to-wsl repo
    # $user_name = kindtek
    # $repo_name = docker-to-wsl
    git clone 'https://github.com/kindtek/docker-to-wsl.git' --branch dev
    Set-Location docker-to-wsl
    git submodule update --init
    Set-Location ../
    # Set-Location "$pwd_path/scripts/powershell-remote"
    # Start-Process -FilePath start-here.ps1
./docker-wsl-install.ps1
