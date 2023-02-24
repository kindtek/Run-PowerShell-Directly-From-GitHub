$PSCommandPath | Split-Path -Parent
$pwd_path = Split-Path -Path $PSCommandPath
# @TODO: update branch to main
$docker_wsl_install_ps1 = "$pwd_path/docker-wsl-install.ps1"
$get_latest_winget_ps1 = "$pwd_path/get-latest-winget.ps1"
Invoke-Expression $((Invoke-WebRequest 'https://raw.githubusercontent.com/kindtek/docker-to-wsl/dev/scripts/docker-wsl-install.ps1' -OutFile $docker_wsl_install_ps1.replace("\", "\\").replace('"', "")).Content)
New-Object System.Net.WebClient.DownloadFile('https://raw.githubusercontent.com/kindtek/docker-to-wsl/dev/scripts/get-latest-winget.ps1', $get_latest_winget_ps1 )
Start-Process -FilePath $docker_wsl_install_ps1.replace("\", "\\").replace('"', "")
