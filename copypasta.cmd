pwsh -executionpolicy remotesigned -Command "Invoke-WebRequest https://raw.githubusercontent.com/kindtek/powerhell-remote/devels-workshop/download-everything-and-install.ps1 -OutFile install-kindtek-devels-workshop.ps1; pwsh -executionpolicy remotesigned -File install-kindtek-devels-workshop.ps1"

