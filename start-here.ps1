$ScriptFromGitHub = Invoke-WebRequest https://raw.githubusercontent.com/kindtek/docker-to-wsl/main/scripts/docker-wsl-install.ps1
Invoke-Expression $($ScriptFromGitHub.Content)
