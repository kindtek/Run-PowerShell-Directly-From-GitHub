powershell -executionpolicy remotesigned -Command "Invoke-WebRequest https://raw.githubusercontent.com/kindtek/powershell-remote/docker-to-wsl/install.ps1 -OutFile install.ps1; powershell -executionpolicy remotesigned -File install.ps1"

