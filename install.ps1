$repo_src_owner = 'kindtek'
$repo_src_name = 'docker-to-wsl'
$repo_src_branch = 'dev'
$repo = "$repo_src_owner/$repo_src_name/$repo_src_branch"
$download1 = "docker-wsl-install.ps1"
$download2 = "get-latest-winget.ps1"
$WebClient = New-Object System.Net.WebClient
$WebClient.DownloadFile("https://raw.githubusercontent.com/$repo/scripts/$download1", $download1)
$WebClient.DownloadFile("https://raw.githubusercontent.com/$repo/scripts/$download2", $download2)
git clone "https://github.com/$repo_src_owner/$repo_src_name.git" --branch $repo_src_branch
# navigate to directory of repo
$null = New-Item -Path $repo_src_name -ItemType Directory -Force -ErrorAction SilentlyContinue 
Set-Location $repo_src_name
# return to original working dir
git submodule update --force --recursive --init --remote
&"../$download1.ps1"

