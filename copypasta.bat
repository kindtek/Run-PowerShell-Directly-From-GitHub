powershell -executionpolicy remotesigned -Command "Invoke-WebRequest https://raw.githubusercontent.com/kindtek/powershell-remote/devels-workshop/install.ps1 -OutFile install-kindtek-devels-workshop.ps1; powershell -executionpolicy remotesigned -File install-kindtek-devels-workshop.ps1"

