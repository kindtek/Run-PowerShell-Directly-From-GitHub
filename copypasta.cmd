powershell.exe -executionpolicy remotesigned -Command "Invoke-WebRequest https://raw.githubusercontent.com/kindtek/powerhell/dvl-works/download-everything-and-install.ps1 -OutFile install-kindtek-devels-workshop.ps1; powershell.exe -executionpolicy remotesigned -File install-kindtek-devels-workshop.ps1 ubuntu-dind"

