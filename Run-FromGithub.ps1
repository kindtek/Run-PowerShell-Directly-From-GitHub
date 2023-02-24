$ScriptFromGitHub = Invoke-WebRequest https://github.com/kindtek/docker-to-wsl/tree/main/scripts/docker-wsl-install.ps1
Invoke-Expression $($ScriptFromGitHub.Content)
