Invoke-WebRequest https://raw.githubusercontent.com/kindtek/docker-to-wsl/dev/scripts/docker-wsl-install.ps1 -OutFile "docker-wsl-install.ps1"
$WebClient = New-Object System.Net.WebClient
$WebClient.DownloadFile("https://raw.githubusercontent.com/kindtek/docker-to-wsl/dev/scripts/get-latest-winget.ps1", "get-latest-winget.ps1")
# $user_name = kindtek
# $repo_name = docker-to-wsl
git clone 'https://github.com/kindtek/docker-to-wsl.git' --branch dev
# navigate to directory of repo
Set-Location docker-to-wsl
# return to original working dir
git submodule update --init
Set-Location ../
./docker-wsl-install.ps1

