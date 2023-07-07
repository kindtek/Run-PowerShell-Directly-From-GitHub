function set_dvlp_envs_new_win {
    Start-Process powershell -LoadUserProfile -WindowStyle $env:KINDTEK_NEW_PROC_STYLE -ArgumentList [string]$env:KINDTEK_NEW_PROC_NOEXIT, "-Command &{. $env:KINDTEK_WIN_GIT_PATH/dvlp.ps1 source;set_dvlp_envs;exit;}" -Wait
}
function set_dvlp_envs {
    param (
        $DEBUG_MODE
    )
    $repo_src_owner = 'kindtek'
    $repo_src_name = 'devels-workshop'
    $repo_dir_name = 'dvlw'
    $repo_src_branch = 'main'
    $repo_src_name2 = 'devels-playground'
    $repo_dir_name2 = 'dvlp'
    $repo_src_name3 = 'powerhell'
    $repo_dir_name3 = 'powerhell'
    $repo_src_name4 = 'dvl-adv'
    $repo_dir_name4 = 'dvl-adv'
    $repo_src_name5 = 'kernels'
    $repo_dir_name5 = 'kernels'
    $repo_src_name6 = 'mnt'
    $repo_dir_name6 = 'mnt'

    $git_parent_path = "$env:USERPROFILE/repos/$repo_src_owner"
    $git_path = "$git_parent_path/$repo_dir_name"
    start-sleep 3
    if ($env:KINDTEK_WIN_GIT_OWNER -ne "$repo_src_owner" -or $env:KINDTEK_WIN_GIT_OWNER -ne "$repo_src_owner") {
        write-host "setting global environment variables ..."
    }
    if ([string]::IsNullOrEmpty($env:KINDTEK_DEBUG_MODE) -or $env:KINDTEK_DEBUG_MODE -ne $DEBUG_MODE) {
        try {
            if ([string]::IsNullOrEmpty($DEBUG_MODE)) {
                Set-PSDebug -Trace 0;
                $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_DEBUG_MODE', '0')
                Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
                $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_DEBUG_MODE', '0', [System.EnvironmentVariableTarget]::Machine)
                Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
                # Set-Item -Path env:KINDTEK_DEBUG_MODE -Value 0 -Force
                $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_NEW_PROC_STYLE', 'hidden')
                Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
                $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_NEW_PROC_STYLE', 'hidden', [System.EnvironmentVariableTarget]::Machine)
                Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
                $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_NEW_PROC_NOEXIT', ' ')
                Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
                $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_NEW_PROC_NOEXIT', ' ', [System.EnvironmentVariableTarget]::Machine)
                Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
                # Set-Item -Path env:KINDTEK_NEW_PROC_STYLE -Value hidden -Force
            }
            elseif (!([string]::IsNullOrEmpty($DEBUG_MODE)) -or !([string]::IsNullOrEmpty($env:KINDTEK_DEBUG_MODE))) {
                Set-PSDebug -Trace 2;
                $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_DEBUG_MODE', '1')
                Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
                $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_DEBUG_MODE', '1', [System.EnvironmentVariableTarget]::Machine)
                Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
                $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_NEW_PROC_STYLE', 'minimized')
                Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
                $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_NEW_PROC_STYLE', 'minimized', [System.EnvironmentVariableTarget]::Machine)
                Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
                $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_NEW_PROC_NOEXIT', '-noexit')
                Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
                $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_NEW_PROC_NOEXIT', '-noexit', [System.EnvironmentVariableTarget]::Machine)
                Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
                Write-Output "debug = true"
            }
        }
        catch {}
    }
    try {
        $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_FAILSAFE_WSL_DISTRO', 'kalilinux-kali-rolling-latest')
        Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
          
        $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_FAILSAFE_WSL_DISTRO', 'kalilinux-kali-rolling-latest', [System.EnvironmentVariableTarget]::Machine)       
        Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
        # Set-Item -Path env:$env:KINDTEK_FAILSAFE_WSL_DISTRO -Value 'kalilinux-kali-rolling-latest' -Force
    }
    catch {}
    try {
        Start-Process -FilePath powershell.exe -ArgumentList "-Command [string][System.Environment]::SetEnvironmentVariable('KINDTEK_DEVEL_TOOLS', '$git_parent_path/scripts/devel-tools.ps1 source')"            
        Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"

        $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_DEVEL_TOOLS', '$git_parent_path/scripts/devel-tools.ps1 source', [System.EnvironmentVariableTarget]::Machine)            
        Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
        # Set-Item -Path env:$env:KINDTEK_FAILSAFE_WSL_DISTRO -Value 'kalilinux-kali-rolling-latest' -Force
    }
    catch {}
    try {
        $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_WIN_GIT_OWNER', "$repo_src_owner")
        Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
        $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_WIN_GIT_OWNER', "$repo_src_owner", [System.EnvironmentVariableTarget]::Machine)
        Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
        # Set-Item -Path env:KINDTEK_WIN_GIT_OWNER -Value  $repo_src_owner -Force
    }
    catch {}
    try { 
        $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_WIN_GIT_PATH', "$git_parent_path")
        Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
        $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_WIN_GIT_PATH', "$git_parent_path", [System.EnvironmentVariableTarget]::Machine)
        Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
        # Set-Item -Path env:KINDTEK_WIN_GIT_PATH -Value $git_parent_path -Force
    }
    catch {}
    try {
        $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_WIN_DVLW_PATH', "$git_path")
        Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
        $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_WIN_DVLW_PATH', "$git_path", [System.EnvironmentVariableTarget]::Machine)
        Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
        # Set-Item -Path env:KINDTEK_WIN_DVLW_PATH -Value $git_path -Force
    }
    catch {}
    try {
        $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_WIN_DVLW_FULLNAME', "$repo_src_name")
        Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
        $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_WIN_DVLW_FULLNAME', "$repo_src_name", [System.EnvironmentVariableTarget]::Machine)
        Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
        # Set-Item -Path env:KINDTEK_WIN_DVLW_FULLNAME -Value $repo_src_name -Force
    }
    catch {}
    try {
        $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_WIN_DVLW_NAME', "$repo_dir_name")
        Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
        $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_WIN_DVLW_NAME', "$repo_dir_name", [System.EnvironmentVariableTarget]::Machine)
        Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
        # Set-Item -Path env:KINDTEK_WIN_DVLW_NAME -Value $repo_dir_name -Force
    }
    catch {}
    try {            
        $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_WIN_DVLW_BRANCH', "$repo_src_branch")
        Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
        $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_WIN_DVLW_BRANCH', "$repo_src_branch", [System.EnvironmentVariableTarget]::Machine)
        Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
        # Set-Item -Path env:KINDTEK_WIN_DVLW_BRANCH -Value $repo_src_branch -Force
    }
    catch {}
    try {
        $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_WIN_DVLP_PATH', "$git_path/$repo_dir_nam2")
        Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
        $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_WIN_DVLP_PATH', "$git_path/$repo_dir_nam2", [System.EnvironmentVariableTarget]::Machine)
        Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
        # Set-Item -Path env:KINDTEK_WIN_DVLP_PATH -Value "$git_path/$repo_dir_name2" -Force
    }
    catch {}
    try {            
        $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_WIN_DVLP_FULLNAME', "$repo_src_name2")
        Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
        $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_WIN_DVLP_FULLNAME', "$repo_src_name2", [System.EnvironmentVariableTarget]::Machine)
        Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
        # Set-Item -Path env:KINDTEK_WIN_DVLP_FULLNAME -Value $repo_src_name2 -Force
    }
    catch {}
    try {
        $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_WIN_DVLP_NAME', "$repo_dir_name2")
        Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
        $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_WIN_DVLP_NAME', "$repo_dir_name2", [System.EnvironmentVariableTarget]::Machine)
        Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
        # Set-Item -Path env:KINDTEK_WIN_DVLP_NAME -Value $repo_dir_name2 -Force
    }
    catch {}
    try {
        $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_WIN_POWERHELL_FULLNAME', "$repo_src_name3")
        Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
        $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_WIN_POWERHELL_FULLNAME', "$repo_src_name3", [System.EnvironmentVariableTarget]::Machine)
        Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
        # Set-Item -Path env:KINDTEK_WIN_POWERHELL_PATH -Value "$git_path/$repo_dir_name3" -Force
    }
    catch {}
    try {
        $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_WIN_POWERHELL_NAME', "$repo_dir_name3")
        Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
        $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_WIN_POWERHELL_NAME', "$repo_dir_name3", [System.EnvironmentVariableTarget]::Machine)
        Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
        # Set-Item -Path env:KINDTEK_WIN_POWERHELL_PATH -Value "$git_path/$repo_dir_name3" -Force
    }
    catch {}
    try {
        $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_WIN_POWERHELL_PATH', "$git_path/$repo_dir_name3")
        Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
        $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_WIN_POWERHELL_PATH', "$git_path/$repo_dir_name3", [System.EnvironmentVariableTarget]::Machine)
        Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
        # Set-Item -Path env:KINDTEK_WIN_POWERHELL_PATH -Value "$git_path/$repo_dir_name3" -Force
    }
    catch {}
    try {
        $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_WIN_DVLADV_FULLNAME', "$repo_src_name4")
        Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
        $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_WIN_DVLADV_FULLNAME', "$repo_src_name4", [System.EnvironmentVariableTarget]::Machine)
        Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
        # Set-Item -Path env:KINDTEK_WIN_DVLADV_PATH -Value "$repo_dir_name2" -Force
    }
    catch {}
    try {
        $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_WIN_DVLADV_NAME', "$repo_dir_name4")
        Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
        $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_WIN_DVLADV_NAME', "$repo_dir_name4", [System.EnvironmentVariableTarget]::Machine)
        Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
        # Set-Item -Path env:KINDTEK_WIN_DVLADV_PATH -Value "$repo_dir_name2" -Force
    }
    catch {}
    try {
        $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_WIN_DVLADV_PATH', "$git_path/$repo_dir_name4")
        Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
        $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_WIN_DVLADV_PATH', "$git_path/$repo_dir_name4", [System.EnvironmentVariableTarget]::Machine)
        Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
        # Set-Item -Path env:KINDTEK_WIN_DVLADV_PATH -Value "$repo_dir_name2" -Force
    }
    catch {}
    try {
        $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_WIN_KERNELS_FULLNAME', "$repo_src_name5")
        Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
        $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_WIN_KERNELS_FULLNAME', "$repo_src_name5", [System.EnvironmentVariableTarget]::Machine)
        Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
        # Set-Item -Path env:KINDTEK_WIN_DVLADV_PATH -Value "$repo_dir_name2" -Force
    }
    catch {}
    try {
        $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_WIN_KERNELS_NAME', "$repo_dir_name5")
        Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
        $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_WIN_KERNELS_NAME', "$repo_dir_name5", [System.EnvironmentVariableTarget]::Machine)
        Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
        # Set-Item -Path env:KINDTEK_WIN_DVLADV_PATH -Value "$repo_dir_name2" -Force
    }
    catch {}
    try {
        $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_WIN_KERNELS_PATH', "$git_path/$repo_dir_name5")
        Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
        $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_WIN_KERNELS_PATH', "$git_path/$repo_dir_name5", [System.EnvironmentVariableTarget]::Machine)
        Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
        # Set-Item -Path env:KINDTEK_WIN_DVLADV_PATH -Value "$repo_dir_name2" -Force
    }
    catch {}
    try {
        $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_WIN_MNT_FULLNAME', "$repo_src_name6")
        Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
        $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_WIN_MNT_FULLNAME', "$repo_src_name6", [System.EnvironmentVariableTarget]::Machine)
        Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
        # Set-Item -Path env:KINDTEK_WIN_DVLADV_PATH -Value "$repo_dir_name2" -Force
    }
    catch {}
    try {
        $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_WIN_MNT_NAME', "$repo_dir_name6")
        Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
        $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_WIN_MNT_NAME', "$repo_dir_name6", [System.EnvironmentVariableTarget]::Machine)
        Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
        # Set-Item -Path env:KINDTEK_WIN_DVLADV_PATH -Value "$repo_dir_name2" -Force
    }
    catch {}
    try {
        $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_WIN_MNT_PATH', "$git_path/$repo_dir_name6")
        Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
        $cmd_str = [string][System.Environment]::SetEnvironmentVariable('KINDTEK_WIN_MNT_PATH', "$git_path/$repo_dir_name6", [System.EnvironmentVariableTarget]::Machine)
        Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
        # Set-Item -Path env:KINDTEK_WIN_DVLADV_PATH -Value "$repo_dir_name2" -Force
    }
    catch {}
    try {
        $cmd_str = [string][System.Environment]::SetEnvironmentVariable('WSL_UTF8', "1")
        Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
        $cmd_str = [string][System.Environment]::SetEnvironmentVariable('WSL_UTF8', "1", [System.EnvironmentVariableTarget]::Machine)
        Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str"
    }
    catch {}
    while ([string]::IsNullOrEmpty($env:KINDTEK_WIN_GIT_OWNER) `
            -or [string]::IsNullOrEmpty($env:KINDTEK_DEBUG_MODE) `
            -or [string]::IsNullOrEmpty($env:KINDTEK_DEVEL_TOOLS) `
            -or [string]::IsNullOrEmpty($env:KINDTEK_FAILSAFE_WSL_DISTRO) `
            -or [string]::IsNullOrEmpty($env:KINDTEK_WIN_GIT_PATH) `
            -or [string]::IsNullOrEmpty($env:KINDTEK_WIN_GIT_OWNER) `
            -or [string]::IsNullOrEmpty($env:KINDTEK_WIN_GIT_PATH) `
            -or [string]::IsNullOrEmpty($env:KINDTEK_WIN_DVLW_NAME) `
            -or [string]::IsNullOrEmpty($env:KINDTEK_WIN_DVLW_FULLNAME) `
            -or [string]::IsNullOrEmpty($env:KINDTEK_WIN_DVLW_BRANCH) `
            -or [string]::IsNullOrEmpty($env:KINDTEK_WIN_DVLW_PATH) `
            -or [string]::IsNullOrEmpty($env:KINDTEK_WIN_DVLP_NAME) `
            -or [string]::IsNullOrEmpty($env:KINDTEK_WIN_DVLP_FULLNAME) `
            -or [string]::IsNullOrEmpty($env:KINDTEK_WIN_DVLP_PATH) `
            -or [string]::IsNullOrEmpty($env:KINDTEK_WIN_POWERHELL_NAME) `
            -or [string]::IsNullOrEmpty($env:KINDTEK_WIN_POWERHELL_FULLNAME) `
            -or [string]::IsNullOrEmpty($env:KINDTEK_WIN_POWERHELL_PATH) `
            -or [string]::IsNullOrEmpty($env:KINDTEK_WIN_DVLADV_NAME) `
            -or [string]::IsNullOrEmpty($env:KINDTEK_WIN_DVLADV_FULLNAME) `
            -or [string]::IsNullOrEmpty($env:KINDTEK_WIN_DVLADV_PATH) `
            -or [string]::IsNullOrEmpty($env:KINDTEK_WIN_KERNELS_NAME) `
            -or [string]::IsNullOrEmpty($env:KINDTEK_WIN_KERNELS_FULLNAME) `
            -or [string]::IsNullOrEmpty($env:KINDTEK_WIN_KERNELS_PATH) `
            -or [string]::IsNullOrEmpty($env:KINDTEK_WIN_MNT_NAME) `
            -or [string]::IsNullOrEmpty($env:KINDTEK_WIN_MNT_FULLNAME) `
            -or [string]::IsNullOrEmpty($env:KINDTEK_WIN_MNT_PATH) ) {
            echo 'waiting for environment variables to update'
            start-sleep 5

    }

}

function test_dvlp_spawn {
    return $true
}
function unset_dvlp_envs {
    if ( [string]::IsNullOrEmpty($env:KINDTEK_WIN_GIT_OWNER)) {
        $dvlp_owner = 'kindtek'
    }
    get-childitem env: | where-object name -match ("^" + [regex]::escape($dvlp_owner) + ".*$") | foreach-object {
        $unset_command = [string][System.Environment]::SetEnvironmentVariable([string]$_.name, $null, [System.EnvironmentVariableTarget]::Machine)
        Start-Process -FilePath powershell.exe -LoadUserProfile -WindowStyle $env:KINDTEK_NEW_PROC_STYLE -ArgumentList "-noexit", "-Command $unset_command"
        echo Start-Process -FilePath powershell.exe -LoadUserProfile -WindowStyle $env:KINDTEK_NEW_PROC_STYLE -ArgumentList "-noexit", "-Command $unset_command"
    }
}


function get_default_wsl_distro {
    $default_wsl_distro = wsl --list | Where-Object { $_ -and $_ -ne '' -and $_ -match '(.*)\(' }
    $default_wsl_distro = $default_wsl_distro -replace '^(.*)\s.*$', '$1'
    return $default_wsl_distro
}

function revert_default_wsl_distro {
    $env:KINDTEK_FAILSAFE_WSL_DISTRO = 'kalilinux-kali-rolling-latest'
    try {
        wsl -s $env:KINDTEK_FAILSAFE_WSL_DISTRO
    }
    catch {
        try {
            run_devels_playground "$env:KINDTEK_WIN_DVLW_PATH" "default"
        }
        catch {
            Write-Host "error reverting to $env:KINDTEK_FAILSAFE_WSL_DISTRO as default wsl distro"
            return $false
        }
    }
    if ( (get_default_wsl_distro) -eq $env:KINDTEK_FAILSAFE_WSL_DISTRO ) {
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
        $old_wsl_default_distro = get_default_wsl_distro
        try {
            wsl -s $new_wsl_default_distro
        }
        catch {
            try {
                run_devels_playground "$env:KINDTEK_WIN_DVLW_PATH" "default"
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
                    run_devels_playground "$env:KINDTEK_WIN_DVLW_PATH" "default"
                }
                catch {
                    Write-Host "error setting $old_wsl_default_distro as default wsl distro"
                }
            }
            # wsl_docker_restart
            wsl_docker_restart_new_win
            require_docker_online_new_win
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
    $software_name = "WinGet"
    Write-Host "`r`n"
    if (!(Test-Path -Path "$env:KINDTEK_WIN_GIT_PATH/.winget-installed" -PathType Leaf)) {
        $file = "$env:KINDTEK_WIN_GIT_PATH/get-latest-winget.ps1"
        Write-Host "Installing $software_name ..." -ForegroundColor DarkCyan
        Invoke-WebRequest "https://raw.githubusercontent.com/kindtek/dvl-adv/dvl-works/get-latest-winget.ps1" -OutFile $file;
        Start-Process powershell -WindowStyle $env:KINDTEK_NEW_PROC_STYLE -LoadUserProfile -ArgumentList [string]$env:KINDTEK_NEW_PROC_NOEXIT, "-Command &{powershell.exe -executionpolicy remotesigned -File $file}" -Wait
        # install winget and use winget to install everything else
        # $p = Get-Process -Name "PackageManagement"
        # Stop-Process -InputObject $p
        # Get-Process | Where-Object { $_.HasExited }
        Write-Host "$software_name installed" -ForegroundColor DarkCyan | Out-File -FilePath "$env:KINDTEK_WIN_GIT_PATH/.winget-installed"
    }
    else {
        Write-Host "$software_name already installed" -ForegroundColor DarkCyan
    }
}

function install_git {
    $software_name = "Github CLI"
    $refresh_envs = "$env:KINDTEK_WIN_GIT_PATH/RefreshEnv.cmd"
    $global:progress_flag = 'silentlyContinue'
    $orig_progress_flag = $progress_flag 
    $progress_flag = 'SilentlyContinue'
    Invoke-WebRequest "https://raw.githubusercontent.com/kindtek/choco/ac806ee5ce03dea28f01c81f88c30c17726cb3e9/src/chocolatey.resources/redirects/RefreshEnv.cmd" | Out-Null
    $progress_flag = $orig_progress_flag
    if (!(Test-Path -Path "$env:KINDTEK_WIN_GIT_PATH/.github-installed" -PathType Leaf)) {
        Write-Host "Installing $software_name ..." -ForegroundColor DarkCyan
        Start-Process powershell -WindowStyle $env:KINDTEK_NEW_PROC_STYLE -LoadUserProfile -ArgumentList [string]$env:KINDTEK_NEW_PROC_NOEXIT, "-Command &{winget install --exact --id GitHub.cli --silent --locale en-US --accept-package-agreements --accept-source-agreements;winget upgrade --exact --id GitHub.cli --silent --locale en-US --accept-package-agreements --accept-source-agreements;winget install --id Git.Git --source winget --silent --locale en-US --accept-package-agreements --accept-source-agreements;winget upgrade --id Git.Git --source winget --silent --locale en-US --accept-package-agreements --accept-source-agreements;}" -Wait
        Write-Host "$software_name installed" -ForegroundColor DarkCyan | Out-File -FilePath "$env:KINDTEK_WIN_GIT_PATH/.github-installed"; `
    
    }
    else {
        Write-Host "$software_name already installed" -ForegroundColor DarkCyan
    }
    # allow git to be used in same window immediately after installation
    powershell.exe -Command $refresh_envs | Out-Null
    ([void]( New-Item -path alias:git -Value 'C:\Program Files\Git\bin\git.exe' -ErrorAction SilentlyContinue | Out-Null ))
    Start-Process powershell -LoadUserProfile -WindowStyle $env:KINDTEK_NEW_PROC_STYLE -ArgumentList [string]$env:KINDTEK_NEW_PROC_NOEXIT, "-Command &{;sync_repo;exit;}" -Wait
    return $new_install
}

function sync_repo {
    Write-Host "testing git command ..." -ForegroundColor DarkCyan
    ([void]( New-Item -path alias:git -Value 'C:\Program Files\Git\bin\git.exe' -ErrorAction SilentlyContinue | Out-Null ))
    Write-Host "synchronizing kindtek github repos ..." -ForegroundColor DarkCyan
    Push-Location $env:KINDTEK_WIN_GIT_PATH
    Write-Host "synchronizing $env:KINDTEK_WIN_GIT_PATH/$env:KINDTEK_WIN_DVLW_NAME with https://github.com/$env:KINDTEK_WIN_GIT_OWNER/$env:KINDTEK_WIN_DVLW_FULLNAME repo ..." -ForegroundColor DarkCyan
    try {
        git -C $env:KINDTEK_WIN_DVLW_NAME pull --progress
        write-host "$env:KINDTEK_WIN_DVLW_NAME pulled"
    }
    catch {
        try {
            git clone "https://github.com/$env:KINDTEK_WIN_GIT_OWNER/$env:KINDTEK_WIN_DVLW_FULLNAME" --branch $env:KINDTEK_WIN_DVLW_BRANCH --progress -- $env:KINDTEK_WIN_DVLW_NAME
            write-host "$env:KINDTEK_WIN_DVLW_NAME cloned"
        }
        catch {}
    }
    Push-Location $env:KINDTEK_WIN_DVLW_NAME
    try {
        git submodule update --remote --progress -- $env:KINDTEK_WIN_DVLP_NAME
        write-host "$env:KINDTEK_WIN_DVLP_NAME pulled"
        git submodule update --remote --progress -- $env:KINDTEK_WIN_DVLADV_NAME
        write-host "$env:KINDTEK_WIN_DVLADV_NAME pulled"
        git submodule update --remote --progress -- $env:KINDTEK_WIN_POWERHELL_NAME
        write-host "$env:KINDTEK_WIN_POWERHELL_NAME pulled"
    }
    catch {
        try {
            git submodule update --init --init --remote --progress -- $env:KINDTEK_WIN_DVLP_NAME
            write-host "$env:KINDTEK_WIN_DVLP_NAME pulled"
            git submodule update --init --remote --progress -- $env:KINDTEK_WIN_DVLADV_NAME
            write-host "$env:KINDTEK_WIN_DVLADV_NAME pulled"
            git submodule update --init --remote --progress -- $env:KINDTEK_WIN_POWERHELL_NAME
            write-host "$env:KINDTEK_WIN_POWERHELL_NAME pulled"
        }
        catch {}
    }
    Push-Location $env:KINDTEK_WIN_DVLP_NAME
    try {
        git submodule update --remote --progress -- $env:KINDTEK_WIN_MNT_NAME
        write-host "$env:KINDTEK_WIN_MNT_NAME pulled"
        git submodule update --remote --progress -- $env:KINDTEK_WIN_KERNELS_NAME
        write-host "$env:KINDTEK_WIN_KERNELS_NAME pulled"
    }
    catch {
        try {
            git submodule update --init --remote --progress -- $env:KINDTEK_WIN_MNT_NAME
            write-host "$env:KINDTEK_WIN_MNT_NAME pulled"
            git submodule update --init --remote --progress -- $env:KINDTEK_WIN_KERNELS_NAME
            write-host "$env:KINDTEK_WIN_KERNELS_NAME pulled"
        }
        catch {}
    }
    Pop-Location
    Pop-Location
    Pop-Location
}

function run_devels_playground {
    param (
        $git_path, $img_name_tag, $non_interactive, $default_distro
    )
    try {
        
        $software_name = "docker devel"
        # if (!(Test-Path -Path "$env:KINDTEK_WIN_GIT_PATH/.dvlp-installed" -PathType Leaf)) {
        Write-Host "establishing a connection with docker desktop ...`r`n" 
        Write-Host "`r`nIMPORTANT: keep docker desktop running or the import will fail`r`n" 
        require_docker_online_new_win
        if (is_docker_desktop_online -eq $true) {
            Write-Host "now connected to docker desktop ...`r`n"
            # Write-Host "&$devs_playground $env:img_name_tag"
            # Write-Host "$([char]27)[2J"
            # Write-Host "`r`npowershell.exe -Command `"$env:"$env:KINDTEK_WIN_DVLP_PATH/scripts/wsl-docker-import.cmd`" $img_name_tag`r`n"
            $img_name_tag = $img_name_tag.replace("\s+", '')
            # write-host `$img_name_tag $img_name_tag
            # write-host `$non_interactive $non_interactive
            # write-host `$default_distro $default_distro
            # $current_process = [System.Diagnostics.Process]::GetCurrentProcess() | Select-Object -ExpandProperty ID
            # $current_process_object = Get-Process -id $current_process
            # Set-ForegroundWindow $current_process_object.MainWindowHandle
            # Set-ForegroundWindow ($current_process_object).MainWindowHandle
            powershell.exe -Command "$env:KINDTEK_WIN_DVLP_PATH/scripts/wsl-docker-import.cmd" "$img_name_tag" "$non_interactive" "$default_distro"
            # &$devs_playground = "$env:KINDTEK_WIN_GIT_PATH/dvlp/scripts/wsl-docker-import.cmd $env:img_tag"
            if (!(Test-Path -Path "$env:KINDTEK_WIN_DVLP_PATH/.dvlp-installed" -PathType Leaf)) {
                Write-Host "$software_name installed`r`n" | Out-File -FilePath "$env:KINDTEK_WIN_DVLP_PATH/.dvlp-installed"
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
        $img_name = $env:KINDTEK_WIN_DVLP_NAME
        $img_name_tag = "$img_name`:$img_tag"
        $confirmation = ''
    
        if (($dvlp_choice -ine 'kw') -And (!(Test-Path -Path "$env:KINDTEK_WIN_DVLW_PATH/.dvlp-installed" -PathType Leaf))) {
            Write-Host "$([char]27)[2J"
            $host.UI.RawUI.ForegroundColor = "Black"
            $host.UI.RawUI.BackgroundColor = "DarkRed"
    
            # $confirmation = Read-Host "`r`nRestarts may be required as new applications are installed. Save your work now.`r`n`r`n`tHit ENTER to continue`r`n`r`n`tpowershell.exe -Command $file $args" 
            Write-Host "`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n"
            $confirmation = Read-Host "Restarts may be required as new applications are installed. Save your work now.`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`tHit ENTER to continue`r`n"
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
            # args must not empty and if they are must not equal 'source' ... OR dvlp must not installed
            if ((!([string]::IsNullOrEmpty($args[0])) -and ($args[0] -ne 'source')) -Or !(Test-Path -Path "$env:KINDTEK_WIN_DVLW_PATH/.dvlp-installed" -PathType Leaf)) {
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
                New-Item -ItemType Directory -Force -Path $env:KINDTEK_WIN_GIT_PATH | Out-Null
        
                install_winget $env:KINDTEK_WIN_GIT_PATH
                $host.UI.RawUI.ForegroundColor = "DarkGray"
                install_git
                . $env:KINDTEK_WIN_DVLW_PATH/scripts/devel-tools.ps1 source
                run_installer

                $host.UI.RawUI.ForegroundColor = "White"
                require_docker_online_new_win
                # make sure failsafe kalilinux-kali-rolling-latest distro is installed so changes can be easily reverted
                # $env:KINDTEK_WIN_DVLW_PATH, $img_name_tag, $non_interactive, $default_distro
                try {
                    if (!(Test-Path -Path "$env:KINDTEK_WIN_DVLW_PATH/.dvlp-installed" -PathType Leaf)) {
                        run_devels_playground "$env:KINDTEK_WIN_DVLW_PATH" "default"
                    }
                    
                }
                catch {
                    Write-Host "error setting $env:KINDTEK_FAILSAFE_WSL_DISTRO as default wsl distro"
                }

                # install hypervm on next open
                try {
                    if (!(Test-Path "env:KINDTEK_WIN_DVLW_PATH/.hypervm-installed" -PathType Leaf)) {
                        $profilePath = Join-Path $env:USERPROFILE 'Documents\PowerShell\Microsoft.PowerShell_profile.ps1'
                        $vmpPath = Join-Path $env:USERPROFILE 'Documents\PowerShell\kindtek.Set-VMP.ps1'
                        New-Item -Path $profilePath -ItemType File -Force
                        New-Item -Path $vmpPath -ItemType File -Force
                        Add-Content $profilePath "./kindtek.Set-VMP.ps1;Clear-Content 'kindtek.Set-VMP.ps1';./$env:USERPROFILE/dvlp"
                        Add-Content $vmpPath "`nWrite-Host 'Preparing to set up HyperV VM Processor as kali-linux ...';Start-Sleep 10;Set-VMProcessor -VMName kali-linux -ExposeVirtualizationExtensions `$true -ErrorAction SilentlyContinue"        
                        Write-Host "$software_name installed`r`n" | Out-File -FilePath "$env:KINDTEK_WIN_GIT_PATH/.dvlp-installed"
                    }
                }
                catch {}
                # install distro requested in arg
                try {
                    $old_wsl_default_distro = get_default_wsl_distro
                    run_devels_playground "$env:KINDTEK_WIN_DVLW_PATH" "$img_name_tag" "kindtek-$img_name_tag" "default"
                    $new_wsl_default_distro = get_default_wsl_distro
                    require_docker_online_new_win
                    if ( is_docker_desktop_online -eq $false ) {
                        Write-Host "ERROR: docker desktop failed to start with $new_wsl_default_distro distro"
                        Write-Host "reverting to $old_wsl_default_distro as default wsl distro ..."
                        try {
                            wsl -s $old_wsl_default_distro
                            wsl_docker_restart_new_win
                            # wsl_docker_restart
                            require_docker_online_new_win
                        }
                        catch {
                            try {
                                revert_default_wsl_distro
                                require_docker_online_new_win
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
                        wsl -s $env:KINDTEK_FAILSAFE_WSL_DISTRO
                        require_docker_online_new_win
                    }
                    catch {
                        try {
                            revert_default_wsl_distro
                            require_docker_online_new_win
                        }
                        catch {
                            Write-Host "error setting failsafe as default wsl distro"
                        }
                    }
                }
            }
            else {
                
                Start-Process powershell -LoadUserProfile -WindowStyle $env:KINDTEK_NEW_PROC_STYLE -ArgumentList [string]$env:KINDTEK_NEW_PROC_NOEXIT, "-Command &{. $env:KINDTEK_WIN_DVLW_PATH/powerhell/devel-spawn.ps1;;install_winget $env:KINDTEK_WIN_GIT_PATH; sync_repo;run_installer;}"
            }
    
            do {
                $wsl_restart_path = "$env:USERPROFILE/wsl-restart.ps1"
                $env:DEFAULT_WSL_DISTRO = get_default_wsl_distro
                if ([string]::IsNullOrEmpty($env:ORIG_DEFAULT_WSL_DISTRO)) {
                    $env:ORIG_DEFAULT_WSL_DISTRO = $env:KINDTEK_FAILSAFE_WSL_DISTRO
                    $wsl_distro_undo_option = "`r`n`t- [u]ndo wsl changes (reset to $env:ORIG_DEFAULT_WSL_DISTRO)"
                }
                elseif ("$env:ORIG_DEFAULT_WSL_DISTRO" -ne "$env:DEFAULT_WSL_DISTRO") {
                    $wsl_distro_undo_option = "`r`n`t- [u]ndo wsl changes (revert to $env:ORIG_DEFAULT_WSL_DISTRO)"
                }
                else {
                    $wsl_distro_undo_option = ''
                }
                # if (get_default_wsl_distro -eq $env:KINDTEK_FAILSAFE_WSL_DISTRO){
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
                        wsl -s $env:KINDTEK_FAILSAFE_WSL_DISTRO
                        require_docker_online_new_win
                    }
                    catch {
                        try {
                            run_devels_playground "$env:KINDTEK_WIN_DVLW_PATH" "default"
                        }
                        catch {
                            Write-Host "error setting $env:KINDTEK_FAILSAFE_WSL_DISTRO as default wsl distro"
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
                        powershell.exe $env:KINDTEK_NEW_PROC_NOEXIT -command Set-Location -literalPath $env:USERPROFILE
                    }
                    elseif ($dvlp_choice -ieq 'cdw' ) {
                        # one day might get the windows cdir working
                        Start-Process powershell.exe -LoadUserProfile $env:KINDTEK_NEW_PROC_NOEXIT -command Set-Location -literalPath $env:USERPROFILE
                    }
                }
                elseif ($dvlp_choice -ieq 'd') {
                    require_docker_online_new_win
                    run_devels_playground "$env:KINDTEK_WIN_DVLW_PATH" "$img_name_tag"
                }
                elseif ($dvlp_choice -ieq 'd!') {
                    require_docker_online_new_win
                    run_devels_playground "$env:KINDTEK_WIN_DVLW_PATH" "$img_name_tag" "kindtek-$img_name_tag" "default"
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
                    if ($env:ORIG_DEFAULT_WSL_DISTRO -ne "") {
                        # wsl.exe --set-default kalilinux-kali-rolling-latest
                        Write-Host "`r`n`r`nsetting $env:ORIG_DEFAULT_WSL_DISTRO as default distro ..."
                        wsl.exe --set-default $env:ORIG_DEFAULT_WSL_DISTRO
                        # wsl_docker_restart
                        wsl_docker_restart_new_win
                        require_docker_online_new_win
                    }
                }
                elseif ($dvlp_choice -ceq 'r') {
                    # wsl_docker_restart
                    wsl_docker_restart_new_win
                    require_docker_online_new_win
                }
                elseif ($dvlp_choice -ceq 'R') {
                    if (Test-Path $wsl_restart_path -PathType Leaf -ErrorAction SilentlyContinue ) {
                        powershell.exe -ExecutionPolicy RemoteSigned -File $wsl_restart_path
                        require_docker_online_new_win
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

function dvlp_spawn {
    try {
        set_dvlp_envs_new_win 1 
        echo 'test_dvlp_tools'
        # test_dvlp_spawn
        test_dvlp_tools
        
    
    }
    catch {
        set_dvlp_envs_new_win 1 
        echo 'test_dvlp_tools2'
        $local_paths = [string][System.Environment]::GetEnvironmentVariable('path')
        $local_paths += ";$env:KINDTEK_WIN_DVLW_PATH/scripts/devel-tools.ps1"
        $machine_paths = [string][System.Environment]::GetEnvironmentVariable('path', [System.EnvironmentVariableTarget]::Machine)
        $machine_paths += ";$env:KINDTEK_WIN_DVLW_PATH/scripts/devel-tools.ps1"
        $cmd_str_local = [string][System.Environment]::SetEnvironmentVariable('path', "$local_paths")
        $cmd_str_machine = [string][System.Environment]::SetEnvironmentVariable('path', "$machine_paths", [System.EnvironmentVariableTarget]::Machine)
        Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str_local" -wait
        Start-Process -FilePath powershell.exe -ArgumentList "-Command $cmd_str_machine" -wait
        
    }
}

dvlp_spawn

if ([string]::IsNullOrEmpty($args[0])) {
    if ($PSCommandPath -eq "$env:USERPROFILE\dvlp.ps1") {
        install_everything
    }
    else {
        # include above functions and devel-tools
        # set_dvlp_envs_new_win 1 
        # start-sleep 3
        # . $env:KINDTEK_WIN_DVLW_PATH/scripts/devel-tools.ps1 source
    }
}
else {
    if ($args[0] -eq "source") {
        # include above functions and devel-tools
        # set_dvlp_envs_new_win 1 
        # . $env:KINDTEK_WIN_DVLW_PATH/scripts/devel-tools.ps1 source
    }
    else {
        # write-host "$args[0] is not empty"
        install_everything $args[0]
    }
}
