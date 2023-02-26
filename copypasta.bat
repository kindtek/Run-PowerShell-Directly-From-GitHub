powershell -executionpolicy remotesigned -Command "Invoke-WebRequest https://raw.githubusercontent.com/kindtek/powershell-remote/docker-to-wsl/copypasta.ps1 -OutFile copypasta.ps1; powershell -executionpolicy remotesigned -File copypasta.ps1"

