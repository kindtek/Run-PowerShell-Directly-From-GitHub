$env:WSL_UTF8 = 1
$global:FAILSAFE_WSL_DISTRO = 'kalilinux-kali-rolling-latest'
# Install-Module -Name Pscx -RequiredVersion 3.3.2 -Force -AllowClobber

function get_default_wsl_distro {
    $default_wsl_distro = wsl --list | Where-Object { $_ -and $_ -ne '' -and $_ -match '(.*)\(' }
    $default_wsl_distro = $default_wsl_distro -replace '^(.*)\s.*$', '$1'
    return $default_wsl_distro
}

function revert_default_wsl_distro {
    $FAILSAFE_WSL_DISTRO = 'kalilinux-kali-rolling-latest'
    try {
        wsl -s $FAILSAFE_WSL_DISTRO
    }
    catch {
        try {
            run_devels_playground "$git_path" "default"
        }
        catch {
            Write-Host "error reverting to $FAILSAFE_WSL_DISTRO as default wsl distro"
            return $false
        }
    }
    if ( (get_default_wsl_distro) -eq $FAILSAFE_WSL_DISTRO ) {
        return $true
    }
    else {
        return $false
    }
}
function set_default_wsl_distro {
    param (
        $new_wsl_default_distro
    )
    try {
        $git_path = "$env:USERPROFILE/repos/kindtek/dvlw"
        $old_wsl_default_distro = get_default_wsl_distro
        try {
            wsl -s $new_wsl_default_distro
        }
        catch {
            try {
                run_devels_playground "$git_path" "default"
            }
            catch {
                Write-Host "error setting $new_wsl_default_distro as default wsl distro"
            }
        }
        # handle failed installations
        if ( (get_default_wsl_distro) -ne $new_wsl_default_distro -Or (is_docker_desktop_online) -eq $false ) {
            Write-Host "ERROR: docker desktop failed to start with $new_wsl_default_distro as default"
            Start-Sleep 3
            Write-Host "reverting to $old_wsl_default_distro as default wsl distro ..."
            try {
                wsl -s $old_wsl_default_distro
            }
            catch {
                try {
                    run_devels_playground "$git_path" "default"
                }
                catch {
                    Write-Host "error setting $old_wsl_default_distro as default wsl distro"
                }
            }
            # wsl_docker_restart
            wsl_docker_restart_new_win
            Start-Process powershell -WindowStyle hidden -LoadUserProfile -ArgumentList "-command &{Set-Location -literalPath $env:USERPROFILE;. $git_path/scripts/devel-tools.ps1;require_docker_online;exit;}" -Wait 
            return $false
        }
        else {
            return $true
        }
    }
    catch {
        return $false
    }
}
function install_winget {
    param (
        $git_parent_path
    )
    $software_name = "WinGet"
    Write-Host "`r`n"
    if (!(Test-Path -Path "$git_parent_path/.winget-installed" -PathType Leaf)) {
        $file = "$git_parent_path/get-latest-winget.ps1"
        Invoke-WebRequest "https://raw.githubusercontent.com/kindtek/dvl-adv/dvl-works/get-latest-winget.ps1" -OutFile $file;
        Start-Process powershell -WindowStyle hidden -LoadUserProfile -ArgumentList "-command &{powershell.exe -executionpolicy remotesigned -File $file}" -Wait
        # install winget and use winget to install everything else
        Write-Host "Installing $software_name ..." -ForegroundColor DarkCyan
        # $p = Get-Process -Name "PackageManagement"
        # Stop-Process -InputObject $p
        # Get-Process | Where-Object { $_.HasExited }
        Write-Host "$software_name installed" -ForegroundColor DarkCyan | Out-File -FilePath "$git_parent_path/.winget-installed"
    }
    else {
        Write-Host "$software_name already installed" -ForegroundColor DarkCyan
    }
}

function install_git {
    param (
        $git_parent_path, $git_path, $repo_src_owner, $repo_src_name, $repo_dir_name, $repo_src_branch 
    )
    $software_name = "Github CLI"
    $refresh_envs = "$env:USERPROFILE/repos/kindtek/RefreshEnv.cmd"
    $global:progress_flag = 'silentlyContinue'
    $orig_progress_flag = $progress_flag 
    $progress_flag = 'SilentlyContinue'
    Invoke-WebRequest "https://raw.githubusercontent.com/kindtek/choco/ac806ee5ce03dea28f01c81f88c30c17726cb3e9/src/chocolatey.resources/redirects/RefreshEnv.cmd" | Out-Null
    $progress_flag = $orig_progress_flag
    if (!(Test-Path -Path "$git_parent_path/.github-installed" -PathType Leaf)) {
        Write-Host "Installing $software_name ..." -ForegroundColor DarkCyan
        Start-Process powershell -WindowStyle hidden -LoadUserProfile -ArgumentList "-command &{winget install --exact --id GitHub.cli --silent --locale en-US --accept-package-agreements --accept-source-agreements;winget upgrade --exact --id GitHub.cli --silent --locale en-US --accept-package-agreements --accept-source-agreements;winget install --id Git.Git --source winget --silent --locale en-US --accept-package-agreements --accept-source-agreements;winget upgrade --id Git.Git --source winget --silent --locale en-US --accept-package-agreements --accept-source-agreements;}" -Wait
        Write-Host "$software_name installed" -ForegroundColor DarkCyan | Out-File -FilePath "$git_parent_path/.github-installed"; `
    
    }
    else {
        Write-Host "$software_name already installed" -ForegroundColor DarkCyan
    }
    # allow git to be used in same window immediately after installation
   powershell.exe -Command $refresh_envs | Out-Null
    ([void]( New-Item -path alias:git -Value 'C:\Program Files\Git\bin\git.exe' -ErrorAction SilentlyContinue | Out-Null ))
    Start-Process powershell -LoadUserProfile -WindowStyle hidden -ArgumentList "-command &{. $git_path/scripts/devel-tools.ps1;sync_repo $git_parent_path;exit;}" -Wait
    return $new_install
}

function sync_repo {
    param (
        $git_parent_path
    )
    Write-Host "making sure git command works" -ForegroundColor DarkCyan
    ([void]( New-Item -path alias:git -Value 'C:\Program Files\Git\bin\git.exe' -ErrorAction SilentlyContinue | Out-Null ))
    Write-Host "synchronizing kindtek github repos ..." -ForegroundColor DarkCyan
    Push-Location $git_parent_path
    ((git -C $repo_dir_name pull --progress) -Or `
    (git clone "https://github.com/$repo_src_owner/$repo_src_name" --branch $repo_src_branch --progress -- $repo_dir_name) -And `
    ($new_install = $true)) 
    Push-Location $repo_dir_name
    ((git submodule update --remote --progress -- dvlp dvl-adv powerhell) -Or `
    (git submodule update --init --remote --progress -- dvlp dvl-adv powerhell) -And `
    ($new_install = $true)) 
    Set-Location dvlp
    ((git submodule update --init --progress -- mnt kernels) -Or `
    (git submodule update --init --progress -- mnt kernels))
    Pop-Location
}

function run_devels_playground {
    param (
        $git_path, $img_name_tag, $non_interactive, $default_distro
    )
    try {
        . $git_path/scripts/devel-tools.ps1
        $software_name = "docker devel"
        # if (!(Test-Path -Path "$git_path/.dvlp-installed" -PathType Leaf)) {
        Write-Host "establishing a connection with docker desktop ...`r`n" 
        Write-Host "`r`nIMPORTANT: keep docker desktop running or the import will fail`r`n" 
        if (is_docker_desktop_online -eq $true) {
            Write-Host "now connected to docker desktop ...`r`n"
            # Write-Host "&$devs_playground $global:img_name_tag"
            # Write-Host "$([char]27)[2J"
            # Write-Host "`r`npowershell.exe -Command `"$git_path/dvlp/scripts/wsl-docker-import.cmd`" $img_name_tag`r`n"
            $img_name_tag = $img_name_tag.replace("\s+", '')
            # write-host `$img_name_tag $img_name_tag
            # write-host `$non_interactive $non_interactive
            # write-host `$default_distro $default_distro
            # $current_process = [System.Diagnostics.Process]::GetCurrentProcess() | Select-Object -ExpandProperty ID
            # $current_process_object = Get-Process -id $current_process
            # Set-ForegroundWindow $current_process_object.MainWindowHandle
            # Set-ForegroundWindow ($current_process_object).MainWindowHandle
            powershell.exe -Command "$git_path/dvlp/scripts/wsl-docker-import.cmd" "$img_name_tag" "$non_interactive" "$default_distro"
            # &$devs_playground = "$git_path/dvlp/scripts/wsl-docker-import.cmd $global:img_tag"
            if (!(Test-Path -Path "$git_path/.dvlp-installed" -PathType Leaf)) {
                Write-Host "$software_name installed`r`n" | Out-File -FilePath "$git_path/.dvlp-installed"
            }
        }
        else {
            Write-Host "`r`nmake sure docker desktop is running"
            Write-Host "still not working? try: `r`n`t- restart WSL`r`n`t- change your default distro (ie: wsl -s kalilinux-kali-rolling-latest )"
        }
        
        # }
    }
    catch {}
}
function install_everything {  
    param (
        $img_tag
    )
    $host.UI.RawUI.ForegroundColor = "White"
    $host.UI.RawUI.BackgroundColor = "Black"
    $dvlp_choice = 'n'
    do {
        $repo_src_owner = 'kindtek'
        $repo_src_name = 'devels-workshop'
        $repo_src_branch = 'main'
        $repo_dir_name = 'dvlw'
        $git_parent_path = "$env:USERPROFILE/repos/$repo_src_owner"
        $git_path = "$git_parent_path/$repo_dir_name"
        $img_name = 'devels-playground'
        $img_name_tag = "$img_name`:$img_tag"
        $confirmation = ''
    
        if (($dvlp_choice -ine 'kw') -And (!(Test-Path -Path "$git_path/.dvlp-installed" -PathType Leaf))) {
            Write-Host "$([char]27)[2J"
            $host.UI.RawUI.ForegroundColor = "Black"
            $host.UI.RawUI.BackgroundColor = "DarkRed"
    
            # $confirmation = Read-Host "`r`nRestarts may be required as new applications are installed. Save your work now.`r`n`r`n`tHit ENTER to continue`r`n`r`n`tpowershell.exe -Command $file $args" 
            $confirmation = Read-Host "`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`nRestarts may be required as new applications are installed. Save your work now.`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`tHit ENTER to continue`r`n"
            Write-Host "$([char]27)[2J"
            Write-Host "`r`n`r`n`r`n`r`n`r`n`r`nRestarts may be required as new applications are installed. Save your work now.`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`t"
    
        }
        if ($confirmation -eq '') {  
            # source of the below self-elevating script: https://blog.expta.com/2017/03/how-to-self-elevate-powershell-script.html#:~:text=If%20User%20Account%20Control%20(UAC,select%20%22Run%20with%20PowerShell%22.
            # Self-elevate the script if required
            if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
                if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
                    $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
                    Start-Process -FilePath PowerShell.exe -Verb Runas -WindowStyle Maximized -ArgumentList $CommandLine
                    Exit
                }
            }
            # args must not empty or dvlp must not installed
            if (!([string]::IsNullOrEmpty($args)) -Or !(Test-Path -Path "$git_path/.dvlp-installed" -PathType Leaf)) {
                Write-Host "`t-- use CTRL + C or close this window to cancel anytime --"
                Start-Sleep 3
                Write-Host ""
                Start-Sleep 1
                Write-Host ""
                Write-Host ""
                Start-Sleep 1
                Write-Host ""
                Start-Sleep 1
                $host.UI.RawUI.BackgroundColor = "Black"
                Write-Host "`r`n`r`nThese programs will be installed or updated:" -ForegroundColor Magenta
                Start-Sleep 1
                Write-Host "`r`n`t- WinGet`r`n`t- Github CLI`r`n`t- devels-workshop repo`r`n`t- devels-playground repo" -ForegroundColor Magenta
                
                # Write-Host "Creating path $env:USERPROFILE\repos\kindtek if it does not exist ... "  
                New-Item -ItemType Directory -Force -Path $git_parent_path | Out-Null
        
                install_winget $git_parent_path
        
                install_git $git_parent_path $git_path $repo_src_ownr $repo_src_name $repo_dir_name $repo_src_branch  
                . $git_path/scripts/devel-tools.ps1
                run_installer
                Start-Process powershell -WindowStyle hidden -LoadUserProfile -ArgumentList "-command &{Set-Location -literalPath $env:USERPROFILE;. $git_path/scripts/devel-tools.ps1;require_docker_online;exit;}" -Wait
                # make sure failsafe kalilinux-kali-rolling-latest distro is installed so changes can be easily reverted
                # $git_path, $img_name_tag, $non_interactive, $default_distro
                try {
                    if (!(Test-Path -Path "$git_path/.dvlp-installed" -PathType Leaf)){
                        run_devels_playground "$git_path" "default"
                    }
                    
                }
                catch {
                    Write-Host "error setting $FAILSAFE_WSL_DISTRO as default wsl distro"
                }
                # install distro requested in arg
                try {
                    $old_wsl_default_distro = get_default_wsl_distro
                    run_devels_playground "$git_path" "$img_name_tag" "kindtek-$img_name_tag" "default"
                    $new_wsl_default_distro = get_default_wsl_distro
                    if ( require_docker_online -eq $false ) {
                        Write-Host "ERROR: docker desktop failed to start with $new_wsl_default_distro distro"
                        Write-Host "reverting to $old_wsl_default_distro as default wsl distro ..."
                        try {
                            wsl -s $old_wsl_default_distro
                            wsl_docker_restart_new_win
                            # wsl_docker_restart
                            require_docker_online
                        }
                        catch {
                            try {
                                revert_default_wsl_distro
                            }
                            catch {
                                Write-Host "error setting failsafe as default wsl distro"
                            }
                        }
                    }
                }
                catch {
                    Write-Host "error setting "kindtek-$img_name_tag" as default wsl distro"
                    try {
                        wsl -s $FAILSAFE_WSL_DISTRO
                        Start-Process powershell -WindowStyle hidden -LoadUserProfile -ArgumentList "-command &{Set-Location -literalPath $env:USERPROFILE;. $git_path/scripts/devel-tools.ps1;require_docker_online;exit;}" -Wait 
                        require_docker_online
                    }
                    catch {
                        try {
                            revert_default_wsl_distro
                            require_docker_online
                        }
                        catch {
                            Write-Host "error setting failsafe as default wsl distro"
                        }
                    }
                }
            }
            else {
                . $git_path/scripts/devel-tools.ps1
                Start-Process powershell -LoadUserProfile -WindowStyle Hidden -ArgumentList "-command &{Set-Location -literalPath $env:USERPROFILE;. $git_path/powerhell/devel-spawn.ps1;. $git_path/scripts/devel-tools.ps1;install_winget $git_parent_path; sync_repo '$git_parent_path' '$git_path' '$repo_src_ownr' '$repo_src_name' '$repo_dir_name' '$repo_src_branch';run_installer;}"
            }
    
            do {
                $wsl_restart_path = "$env:USERPROFILE/wsl-restart.ps1"
                $global:DEFAULT_WSL_DISTRO = get_default_wsl_distro
                if ([string]::IsNullOrEmpty($global:ORIG_DEFAULT_WSL_DISTRO)) {
                    $global:ORIG_DEFAULT_WSL_DISTRO = $FAILSAFE_WSL_DISTRO
                    $wsl_distro_undo_option = "`r`n`t- [u]ndo wsl changes (reset to $global:ORIG_DEFAULT_WSL_DISTRO)"
                }
                elseif ("$global:ORIG_DEFAULT_WSL_DISTRO" -ne "$global:DEFAULT_WSL_DISTRO") {
                    $wsl_distro_undo_option = "`r`n`t- [u]ndo wsl changes (revert to $global:ORIG_DEFAULT_WSL_DISTRO)"
                }
                else {
                    $wsl_distro_undo_option = ''
                }
                # if (get_default_wsl_distro -eq $FAILSAFE_WSL_DISTRO){
                #     $wsl_distro_undo_option = "`r`n`t- set [f]ailsafe distro as default" + $wsl_distro_undo_option
                # }
                $restart_option = "`r`n`t- [r]estart"
                # $dvlp_choice = Read-Host "`r`nHit ENTER to exit or choose from the following:`r`n`t- launch [W]SL`r`n`t- launch [D]evels Playground`r`n`t- launch repo in [V]S Code`r`n`t- build/install a Linux [K]ernel`r`n`r`n`t"
                $dvlp_options = "`r`n`r`n`r`nChoose from the following:`r`n`t- [d]ocker devel$wsl_distro_undo_option`r`n`t- [c]ommand line`r`n`t- [k]indtek setup$restart_option`r`n`r`n`r`n(exit)"
                # $current_process = [System.Diagnostics.Process]::GetCurrentProcess() | Select-Object -ExpandProperty ID
                # $current_process_object = Get-Process -id $current_process
                # Set-ForegroundWindow $current_process_object.MainWindowHandle
                $dvlp_choice = Read-Host $dvlp_options
                if ($dvlp_choice -ieq 'f') {
                    try {
                        wsl -s $FAILSAFE_WSL_DISTRO
                        Start-Process powershell -WindowStyle hidden -LoadUserProfile -ArgumentList "-command &{Set-Location -literalPath $env:USERPROFILE;. $git_path/scripts/devel-tools.ps1;require_docker_online;exit;}" -Wait 
                    }
                    catch {
                        try {
                            run_devels_playground "$git_path" "default"
                        }
                        catch {
                            Write-Host "error setting $FAILSAFE_WSL_DISTRO as default wsl distro"
                        }
                    }
                }
                elseif ($dvlp_choice -like 'c**') {    
                    if ($dvlp_choice -ieq 'c') {
                        Write-Host "`r`n`t[l]inux or [w]indows"
                        $dvlp_cli_options = Read-Host
                    }
                    if ($dvlp_cli_options -ieq 'l' -or $dvlp_cli_options -ieq 'w') {
                        $dvlp_choice = $dvlp_choice + $dvlp_cli_options
                    }
                    if ($dvlp_choice -ieq 'cl' ) {
                        wsl.exe --cd /hal
                    }
                    elseif ($dvlp_choice -ieq 'cdl' ) {
                        wsl.exe --cd /hal --exec cdir
                    }
                    elseif ($dvlp_choice -ieq 'cw' ) {
                        powershell.exe -noexit -command Set-Location -literalPath $env:USERPROFILE
                    }
                    elseif ($dvlp_choice -ieq 'cdw' ) {
                        # one day might get the windows cdir working
                        Start-Process powershell.exe -LoadUserProfile -noexit -command Set-Location -literalPath $env:USERPROFILE
                    }
                }
                elseif ($dvlp_choice -ieq 'd') {
                    Start-Process powershell -WindowStyle hidden -LoadUserProfile -ArgumentList "-command &{Set-Location -literalPath $env:USERPROFILE;. $git_path/scripts/devel-tools.ps1;require_docker_online;exit;}" -Wait 
                    run_devels_playground "$git_path" "$img_name_tag"
                }
                elseif ($dvlp_choice -ieq 'd!') {
                    Start-Process powershell -WindowStyle hidden -LoadUserProfile -ArgumentList "-command &{Set-Location -literalPath $env:USERPROFILE;. $git_path/scripts/devel-tools.ps1;require_docker_online;exit;}" -Wait 
                    run_devels_playground "$git_path" "$img_name_tag" "kindtek-$img_name_tag" "default"
                }
                elseif ($dvlp_choice -like 'k*') {
                    if ($dvlp_choice -ieq 'k') {
                        Write-Host "`r`n`t[l]inux or [w]indows"
                        $dvlp_kindtek_options = Read-Host
                        if ($dvlp_kindtek_options -ieq 'l' -or $dvlp_kindtek_options -ieq 'w') {
                            $dvlp_choice = $dvlp_choice + $dvlp_kindtek_options
                        }
                    }
                    if ($dvlp_choice -ieq 'kl' ) {
                        wsl.exe --cd /hal exec bash setup.sh $env:USERNAME
                    }
                    elseif ($dvlp_choice -ieq 'kw' ) {
                        Write-Host 'checking for new updates ...'
                    }
                }
                elseif ($dvlp_choice -ieq 'u') {
                    if ($global:ORIG_DEFAULT_WSL_DISTRO -ne "") {
                        # wsl.exe --set-default kalilinux-kali-rolling-latest
                        Write-Host "`r`n`r`nsetting $global:ORIG_DEFAULT_WSL_DISTRO as default distro ..."
                        wsl.exe --set-default $global:ORIG_DEFAULT_WSL_DISTRO
                        # wsl_docker_restart
                        wsl_docker_restart_new_win
                        Start-Process powershell -WindowStyle hidden -LoadUserProfile -ArgumentList "-command &{Set-Location -literalPath $env:USERPROFILE;. $git_path/scripts/devel-tools.ps1;require_docker_online;exit;}" -Wait
                    }
                }
                elseif ($dvlp_choice -ceq 'r') {
                    # wsl_docker_restart
                    wsl_docker_restart_new_win
                    Start-Process powershell -WindowStyle hidden -LoadUserProfile -ArgumentList "-command &{Set-Location -literalPath $env:USERPROFILE;. $git_path/scripts/devel-tools.ps1;require_docker_online;exit;}" -Wait
                }
                elseif ($dvlp_choice -ceq 'R') {
                    if (Test-Path $wsl_restart_path -PathType Leaf -ErrorAction SilentlyContinue ) {
                        powershell.exe -ExecutionPolicy RemoteSigned -File $wsl_restart_path
                        Start-Process powershell -WindowStyle hidden -LoadUserProfile -ArgumentList "-command &{Set-Location -literalPath $env:USERPROFILE;. $git_path/scripts/devel-tools.ps1;require_docker_online;exit;}" -Wait
                    }
                }
                elseif ($dvlp_choice -ceq 'R!') {
                    reboot_prompt
                    # elseif ($dvlp_choice -ieq 'v') {
                    #     wsl sh -c "cd /hel;. code"
                }
                else {
                    $dvlp_choice = ''
                }
            } while ($dvlp_choice -ne 'kw' -And $dvlp_choice -ne '')
        }
    } while ($dvlp_choice -ieq 'kw')
    
    
    Write-Host "`r`nGoodbye!`r`n"
}

if ([string]::IsNullOrEmpty($args[0])) {
    if ($PSCommandPath -eq "$env:USERPROFILE\dvlp.ps1"){
        install_everything
    } else {
        # include above functions
    }
}
else {
    # write-host "$args[0] is not empty"
    install_everything $args[0]
}
