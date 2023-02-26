$repo_src_owner = 'kindtek'
$repo_src_name = 'docker-to-wsl'
$repo_src_branch = 'dev'
$dir_host = "$repo_src_owner/$repo_src_name/$repo_src_branch/scripts"
$dir_local = "$repo_src_name/scripts"
$download1 = "docker-wsl-install.ps1"
$download2 = "get-latest-winget.ps1"
$add_wsl_windows_features = "add-wsl-windows-features"
$download3 = "$add_wsl_windows_features/$repo_src_name/add-features.ps1"

# make directory tree for incoming repo
$null = New-Item -Path $repo_src_name -ItemType Directory -Force -ErrorAction SilentlyContinue 
Push-Location $repo_src_name
$null = New-Item -Path scripts -ItemType Directory -Force -ErrorAction SilentlyContinue 
Push-Location scripts
$null = New-Item -Path $add_wsl_windows_features -ItemType Directory -Force -ErrorAction SilentlyContinue 

Pop-Location
Pop-Location

$WebClient = New-Object System.Net.WebClient
$WebClient.DownloadFile("https://raw.githubusercontent.com/$dir_host/$download1", "$dir_local/$download1")
Write-Host "`n`rDownloading: https://raw.githubusercontent.com/$dir_host/$download1`r`nDestination: $dir_local/$download1" -ForegroundColor Magenta 
$WebClient.DownloadFile("https://raw.githubusercontent.com/$dir_host/$download2", "$dir_local/$download2")
Write-Host "`n`rDownloading: https://raw.githubusercontent.com/$dir_host/$download2`r`nDestination: $dir_local/$download2" -ForegroundColor Magenta 
$WebClient.DownloadFile("https://raw.githubusercontent.com/$repo_src_owner/$download3", "$add_wsl_windows_features/add-features.ps1")
Write-Host "`n`rDownloading: https://raw.githubusercontent.com/$repo_src_owner/$download3`r`nDestination: $add_wsl_windows_features/add-features.ps1`n`r" -ForegroundColor Magenta 

Set-Location $repo_src_name
# return to original working dir
$file = "scripts/$download1"
Write-Output $file
powershell -Command $file
