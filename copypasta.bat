powershell -executionpolicy remotesigned -Command "Invoke-WebRequest https://raw.githubusercontent.com/kindtek/powershell-remote/docker-to-wsl/install-docker-wsl.ps1 -OutFile install-docker-wsl.ps1; powershell -executionpolicy remotesigned -File install-docker-wsl.ps1"

