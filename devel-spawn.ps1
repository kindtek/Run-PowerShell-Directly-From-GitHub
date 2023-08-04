$host.UI.RawUI.ForegroundColor = "White"
$host.UI.RawUI.BackgroundColor = "Black"

$global:devel_spawn = 'sourced'

class dvlp_process {
    [String]$proc_cmd
    [String]$proc_wait
    [String]$proc_noexit
    [String]$proc_exit
    [String]$proc_style
    [String]$proc_nowin

    hidden init ([string]$proc_cmd) {
        $this.init($proc_cmd, '')
    }

    hidden init ([string]$proc_cmd, [string]$proc_wait) {
        $this.init($proc_cmd, $proc_wait, '')
    }

    hidden init ([string]$proc_cmd, [string]$proc_wait, [string]$proc_noexit) {
        $this.re_set()
        if ([string]::IsNullOrEmpty($this.proc_nowin)){
            if (!([String]::IsNullOrEmpty($proc_wait))) {
                $this.proc_wait = "wait"
            }
            else {
                $this.proc_wait = ''
            }
            if (!([String]::IsNullOrEmpty($proc_noexit))) {
                $this.proc_noexit = '-noexit'
            }
            else {
                $this.proc_noexit = ''
            } 
            # write-host "start process powershell -argument list $proc_wait $proc_noexit $proc_cmd"
        } else {
            # write-host "start process powershell -nonewwindow -argument list $proc_cmd"
            $this.proc_wait = ''
            $this.proc_noexit = ''
        }
        if (!([String]::IsNullOrEmpty($proc_cmd))) {
            # echo testing path $env:KINDTEK_DEVEL_TOOLS
            if ((Test-Path -Path "$env:KINDTEK_DEVEL_TOOLS" -PathType Leaf)) {
                # write-host 'dot sourcing devel tools'
                # echo path $env:KINDTEK_DEVEL_TOOLS exists
                $this.proc_cmd = ". $env:KINDTEK_DEVEL_TOOLS;$proc_cmd"
            } else {
                # echo path $env:KINDTEK_DEVEL_TOOLS does not exist
                $this.proc_cmd = $proc_cmd
            }
        }
        else {
            $this.proc_cmd = 'write-host "command string empty"'
            $this.proc_wait = "wait"
            $this.proc_noexit = '-noexit'
        }
        # $this.start()
    }
    dvlp_process (
        [string]$proc_cmd
    ) {
        $this.init($proc_cmd, '')
    }
    dvlp_process (
        [string]$proc_cmd,
        [string]$proc_wait
    ) {
        $this.init($proc_cmd, $proc_wait)
    }
    dvlp_process (
        [string]$proc_cmd,
        [string]$proc_wait,
        [string]$proc_noexit
    ) {
        $this.init($proc_cmd, $proc_wait, $proc_noexit)
    }

    re_set () {
        if (([string]::IsNullOrEmpty($env:KINDTEK_NEW_PROC_NOEXIT))) {
            $this.proc_noexit = ""
        }
        else {
            $this.proc_noexit = "-noexit"
        }
        # write-host "noexit: $($this.proc_noexit)"
        if ([string]::IsNullOrEmpty($env:KINDTEK_NEW_PROC_STYLE)) {
            $this.proc_style = [System.Diagnostics.ProcessWindowStyle]::Normal
        }
        else {
            $this.proc_style = [System.Diagnostics.ProcessWindowStyle]::$env:KINDTEK_NEW_PROC_STYLE
        }
        $this.proc_wait = ''
        # write-host "style: $($this.proc_style)"
    }

    [bool]start() {
        if (([string]::IsNullOrEmpty($this.proc_cmd))) {
            return $false
        } else {
            if (!([string]::IsNullOrEmpty($env:KINDTEK_WIN_DVLW_PATH))){
                $this.proc_cmd = "$($this.proc_cmd)"
            } 
        }
        if (!([string]::IsNullOrEmpty($this.proc_nowin))){
            $proc_show = @{
                NoNewWindow = $null
            }    
        }  elseif ([string]::IsNullOrEmpty($this.proc_style)){
            $proc_show = @{
                WindowStyle = $($this.proc_style)
            }    
        } elseif ([string]::IsNullOrEmpty($this.proc_wait)){
            $proc_show = @{
                WindowStyle = $($this.proc_style)
            }    
        } else {
            $proc_show = @{
                WindowStyle = $($this.proc_style)
                Wait = $null
            }
        }
        
        try {
            if ([string]::IsNullOrEmpty($this.proc_noexit)){
                # write-host  "Start-Process -Filepath powershell.exe @proc_show -ArgumentList `"-Command`", `"$($this.proc_cmd)`""
                Start-Process -Filepath powershell.exe -LoadUserProfile -WorkingDirectory $env:USERPROFILE @proc_show -ArgumentList '-Command', $this.proc_cmd
            } else {
                # Write-host "Start-Process -Filepath powershell.exe @proc_show -ArgumentList $($this.proc_noexit), '-Command', '$($this.proc_cmd)'"
                Start-Process -Filepath powershell.exe -LoadUserProfile -WorkingDirectory $env:USERPROFILE @proc_show -ArgumentList $this.proc_noexit, '-Command', $this.proc_cmd
            }
        }
        catch { 
            return $false 
        }
        return $true
    }
}

class dvlp_process_hide : dvlp_process {
    [String]$proc_exit
    [String]$proc_noexit
    [String]$proc_style

    dvlp_process_hide([string]$proc_cmd) : base($proc_cmd){
        $this.re_set()
        ([dvlp_process] $this).start()
    }
    dvlp_process_hide([string]$proc_cmd, [string]$proc_wait) : base($proc_cmd, $proc_wait){
        $this.re_set()
        ([dvlp_process] $this).start()
    }
    dvlp_process_hide([string]$proc_cmd, [string]$proc_wait, [string]$proc_noexit) : base($proc_cmd, $proc_wait, $proc_noexit){
        $this.re_set()
        ([dvlp_process] $this).start()
    }
    re_set () {
        $this.proc_style = [System.Diagnostics.ProcessWindowStyle]::Hidden
    }
}

class dvlp_process_popmax : dvlp_process {
    [String]$proc_exit
    [String]$proc_noexit
    [String]$proc_style

    dvlp_process_popmax([string]$proc_cmd) : base($proc_cmd){
        $this.re_set()
        ([dvlp_process] $this).start()
    }
    dvlp_process_popmax([string]$proc_cmd, [string]$proc_wait) : base($proc_cmd, $proc_wait){
        $this.re_set()
        ([dvlp_process] $this).start()
    }
    dvlp_process_popmax([string]$proc_cmd, [string]$proc_wait, [string]$proc_noexit) : base($proc_cmd, $proc_wait, $proc_noexit){
        $this.re_set()
        ([dvlp_process] $this).start()
    }
    re_set () {
        $this.proc_style = [System.Diagnostics.ProcessWindowStyle]::Maximized
    }
}

class dvlp_process_embed : dvlp_process {
    [String]$proc_exit
    [String]$proc_noexit
    [String]$proc_style
    [string]$proc_nowin

    # dvlp_process_embed([string]$proc_cmd) : base($proc_cmd){
    dvlp_process_embed([string]$proc_cmd, [string]$proc_wait, [string]$proc_noexit) : base($proc_cmd){
        $this.re_set()
        ([dvlp_process] $this).start()
    }

    dvlp_process_embed([string]$proc_cmd, [string]$proc_wait) : base($proc_cmd){
        $this.re_set()
        ([dvlp_process] $this).start()
    }

    dvlp_process_embed([string]$proc_cmd) : base($proc_cmd){
        $this.re_set()
        ([dvlp_process] $this).start()
    }
    re_set () {
        $this.proc_nowin = 'nowin'
    }
}

class dvlp_process_popmin : dvlp_process {
    [String]$proc_exit
    [String]$proc_noexit
    [String]$proc_style

    dvlp_process_popmin([string]$proc_cmd) : base($proc_cmd){
        $this.re_set()
        ([dvlp_process] $this).start()
    }
    dvlp_process_popmin([string]$proc_cmd, [string]$proc_wait) : base($proc_cmd, $proc_wait){
        $this.re_set()
        ([dvlp_process] $this).start()
    }
    dvlp_process_popmin([string]$proc_cmd, [string]$proc_wait, [string]$proc_noexit) : base($proc_cmd, $proc_wait, $proc_noexit){
        $this.re_set()
        ([dvlp_process] $this).start()
    }
    re_set () {
        $this.proc_style = [System.Diagnostics.ProcessWindowStyle]::Minimized
    }
}

class dvlp_process_pop : dvlp_process {
    [String]$proc_exit
    [String]$proc_noexit
    [String]$proc_style

    dvlp_process_pop([string]$proc_cmd) : base($proc_cmd){
        $this.re_set()
        ([dvlp_process] $this).start()
    }
    dvlp_process_pop([string]$proc_cmd, [string]$proc_wait) : base($proc_cmd, $proc_wait){
        $this.re_set()
        ([dvlp_process] $this).start()
    }
    dvlp_process_pop([string]$proc_cmd, [string]$proc_wait, [string]$proc_noexit) : base($proc_cmd, $proc_wait, $proc_noexit){
        $this.re_set()
        ([dvlp_process] $this).start()
    }
    re_set () {
        $this.proc_style = [System.Diagnostics.ProcessWindowStyle]::Normal
    }
}
# [dvlp_process_popmin]$dvlp_proc = [dvlp_process_popmin]::new('write-host "zzzzzzzzzz";start-sleep 2;', 'zdf')

function start_dvlp_process {
    param (
        $proc_cmd, $proc_wait, $proc_noexit
    )
    [dvlp_process]$dvlp_proc = [dvlp_process]::new($proc_cmd, $proc_wait, $proc_noexit)
}

function start_dvlp_process_pop {
    param (
        $proc_cmd, $proc_wait, $proc_noexit
    )
    [dvlp_process_pop]$dvlp_proc = [dvlp_process_pop]::new($proc_cmd, $proc_wait, $proc_noexit)
}

function start_dvlp_process_popmin {
    param (
        $proc_cmd, $proc_wait, $proc_noexit
    )
    [dvlp_process_popmin]$dvlp_proc = [dvlp_process_popmin]::new($proc_cmd, $proc_wait, $proc_noexit)
}

function start_dvlp_process_popmax {
    param (
        $proc_cmd, $proc_wait, $proc_noexit
    )
    [dvlp_process_popmax]$dvlp_proc = [dvlp_process_popmax]::new($proc_cmd, $proc_wait, $proc_noexit)
}

function start_dvlp_process_hide {
    param (
        $proc_cmd, $proc_wait, $proc_noexit
    )
    [dvlp_process_hide]$dvlp_proc = [dvlp_process_hide]::new($proc_cmd, $proc_wait, $proc_noexit)
}

function start_dvlp_process_embed {
    param (
        $proc_cmd, $proc_wait, $proc_noexit
    )
    [dvlp_process_embed]$dvlp_proc = [dvlp_process_embed]::new($proc_cmd, $proc_wait, $proc_noexit)
}
function get_dvlp_env {
    param (
        $dvlp_env_var, $set_machine_env_flag
    )
    
    try {
        if (([string]::IsNullOrEmpty($set_machine_env_flag)) ){
            # write-host "getting local $dvlp_env_var"
            return [System.Environment]::GetEnvironmentVariable("$dvlp_env_var")
        } else {    
            # write-host "getting machine $dvlp_env_var"
            return [System.Environment]::GetEnvironmentVariable("$dvlp_env_var", [System.EnvironmentVariableTarget]::Machine)
        }
        return $null
    }
    catch {
        if (!([string]::IsNullOrEmpty($DEBUG_MODE))) {
            Write-Host "error setting $dvlp_env_var"
            Write-Host "$cmd_str"
        }
        return $null
    }

}
function set_dvlp_env {
    param (
        $dvlp_env_var, $dvlp_env_val, $set_machine_env_flag, $set_both_env_flag
    )
    
    try {
        if (!([string]::IsNullOrEmpty($dvlp_env_var))) {
            # Write-Host "setting $dvlp_env_var to $dvlp_env_val"
            if (([string]::IsNullOrEmpty($set_machine_env_flag)) -and ([string]::IsNullOrEmpty($set_both_env_flag))){
                # write-host "setting local env $dvlp_env_var to $dvlp_env_val"
                [System.Environment]::SetEnvironmentVariable("$dvlp_env_var", "$dvlp_env_val")
            } elseif (!([string]::IsNullOrEmpty($set_machine_env_flag)) -and ($(get_dvlp_env "$dvlp_env_var" "machine") -ne $dvlp_env_val)){
                # write-host "setting machine env $dvlp_env_var to $dvlp_env_val"
                [System.Environment]::SetEnvironmentVariable("$dvlp_env_var", "$dvlp_env_val", [System.EnvironmentVariableTarget]::Machine)                  
            } elseif ((!([string]::IsNullOrEmpty($set_both_env_flag))) -and (($(get_dvlp_env "$dvlp_env_var" "machine") -ne $dvlp_env_val) -or ($(get_dvlp_env "$dvlp_env_var") -ne $dvlp_env_val))){
                # write-host "setting local and machine env $dvlp_env_var to $dvlp_env_val"
                [System.Environment]::SetEnvironmentVariable("$dvlp_env_var", "$dvlp_env_val")
                [System.Environment]::SetEnvironmentVariable("$dvlp_env_var", "$dvlp_env_val", [System.EnvironmentVariableTarget]::Machine)                  
            } else {
                # write-host "not setting $dvlp_env_var to $dvlp_env_val with $($set_machine_env_flag) $($set_both_env_flag) ( currently: $(get_dvlp_env "$dvlp_env_var"), $(get_dvlp_env "$dvlp_env_var" 'machine')) "
            }
        }
    }
    catch {
        if (!([string]::IsNullOrEmpty($DEBUG_MODE))) {
            Write-Host "error setting $dvlp_env_var"
            Write-Host "$cmd_str"
        }
    }
    return $null
}

function set_dvlp_envs_new_win {
    if ([string]::IsNullOrEmpty($env:KINDTEK_NEW_PROC_STYLE)) {
        $this_proc_style = [System.Diagnostics.ProcessWindowStyle]::Minimized
        $this_proc_style = "-WindowStyle $this_proc_style"
    }
    else {
        $this_proc_style = $env:KINDTEK_NEW_PROC_STYLE
    }
    start_dvlp_process "set_dvlp_envs;exit;"
}


function unset_dvlp_envs {
    param (
        $unset_machine_envs
    )
    if ([string]::IsNullOrEmpty([System.Environment]::GetEnvironmentVariable('KINDTEK_WIN_GIT_OWNER', [System.EnvironmentVariableTarget]::Machine))) {
        $dvlp_owner = 'kindtek'
    }    else {
        $dvlp_owner = [System.Environment]::GetEnvironmentVariable('KINDTEK_WIN_GIT_OWNER', [System.EnvironmentVariableTarget]::Machine)
    }
    get-childitem env: | where-object name -match "^$([regex]::escape($dvlp_owner)).*$" | foreach-object {
        # write-host "$($_.name)"
    }
    
    get-childitem env: | where-object name -match "^$([regex]::escape($dvlp_owner)).*$" | foreach-object {
        # echo "deleting local env $($_.name)"
        set_dvlp_env "$($_.name)" "$null"
        try {
            env_refresh
        } catch {}
    }
    if (!([string]::IsNullOrEmpty($unset_machine_envs))) {
        [Environment]::GetEnvironmentVariables('machine').GetEnumerator() | where-object name -match "^$([regex]::escape($dvlp_owner)).*$" | foreach-object {
            # echo "deleting machine env $($_.name)"
            set_dvlp_env "$($_.name)" "$null" 'machine'
            try {
                env_refresh
            } catch {} 
        }
    }
    get-childitem env: | where-object name -match "^$([regex]::escape($dvlp_owner)).*$" | foreach-object {
        # write-host "$($_.name)"
    }
}

function pull_dvlp_envs {
    if ([string]::IsNullOrEmpty([System.Environment]::GetEnvironmentVariable('KINDTEK_WIN_GIT_OWNER', [System.EnvironmentVariableTarget]::Machine))) {
        $dvlp_owner = 'kindtek'
    }    else {
        $dvlp_owner = [System.Environment]::GetEnvironmentVariable('KINDTEK_WIN_GIT_OWNER', [System.EnvironmentVariableTarget]::Machine)
    }
    [Environment]::GetEnvironmentVariables('machine').GetEnumerator() | where-object name -match "^$([regex]::escape($dvlp_owner)).*$" | foreach-object {
        # write-host " $($_.name):  $($_.value)"
    }
    [Environment]::GetEnvironmentVariables('machine').GetEnumerator() | where-object name -match "^$([regex]::escape($dvlp_owner)).*$" | foreach-object {
        set_dvlp_env "$($_.name)" "$($_.value)"
    }
    get-childitem env: | where-object name -match "^$([regex]::escape($dvlp_owner)).*$" | foreach-object {
        # write-host " $($_.name):  $($_.value)"
    }
}

# push local envs to machine
function push_dvlp_envs {
    if ([string]::IsNullOrEmpty([System.Environment]::GetEnvironmentVariable('KINDTEK_WIN_GIT_OWNER'))) {
        $dvlp_owner = 'kindtek'
    }    else {
        $dvlp_owner = [System.Environment]::GetEnvironmentVariable('KINDTEK_WIN_GIT_OWNER')
    }
    # echo 'local env'
    # get-childitem env: | where-object name -match "^$([regex]::escape($dvlp_owner)).*$" | foreach-object {
    #     write-host " $($_.name):  $($_.value)"
    # }
    get-childitem env: | where-object name -match "^$([regex]::escape($dvlp_owner)).*$" | foreach-object {
        # "setting machine $($_.name) to $($_.value)" 
        set_dvlp_env "$($_.name)" "$($_.value)" 'machine'
        try {
            env_refresh
        } catch {}    }
    # echo 'machine env'
    # [Environment]::GetEnvironmentVariables('machine').GetEnumerator() | where-object name -match "^$([regex]::escape($dvlp_owner)).*$" | foreach-object {
    #     write-host " $($_.name):  $($_.value)"
    # }
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
    set_dvlp_env '_AGL' 'agl'
    set_dvlp_env '_AGL' 'agl' 'machine'
    if ($env:KINDTEK_WIN_GIT_OWNER -ne "$repo_src_owner" -or $env:KINDTEK_WIN_GIT_OWNER -ne "$repo_src_owner") {
        write-host "setting global environment variables ..."
        start-sleep 1
    }
    try {
        if ([string]::IsNullOrEmpty($DEBUG_MODE) -or $DEBUG_MODE -eq '0' -or $DEBUG_MODE -eq 0) {
            # Set-PSDebug -Trace 0;
            set_dvlp_env 'KINDTEK_DEBUG_MODE' '0' 'machine' 'both'
            $this_proc_style = [System.Diagnostics.ProcessWindowStyle]::Hidden;
            set_dvlp_env 'KINDTEK_NEW_PROC_STYLE' "$this_proc_style" 'machine' 'both'
            set_dvlp_env 'KINDTEK_NEW_PROC_NOEXIT' " " 'machine' 'both'
        }
        elseif (!([string]::IsNullOrEmpty($DEBUG_MODE)) -or $DEBUG_MODE -ne '0' -or $DEBUG_MODE -eq 0) {
            Set-PSDebug -Trace 2;
            set_dvlp_env 'KINDTEK_DEBUG_MODE' '1' 'machine' 'both'
            $this_proc_style = [System.Diagnostics.ProcessWindowStyle]::Normal;
            set_dvlp_env 'KINDTEK_NEW_PROC_STYLE' "$this_proc_style" 'machine' 'both'
            set_dvlp_env 'KINDTEK_NEW_PROC_NOEXIT' "-noexit" 'machine' 'both'
            write-host "debug = true"
        }
        if ($DEBUG_MODE -ne '0' -and $DEBUG_MODE -ne 0 -and !([string]::IsNullOrEmpty($DEBUG_MODE))) {        
            Write-Host "debug mode $(get_dvlp_env 'KINDTEK_DEBUG_MODE', 'machine')"
            # Write-Host "$cmd_str_dbg"
        }
        else {
            # Write-Host "debug mode not set"
        }
    }
    catch {
        Write-Host 'error setting debug mode.'
        Write-Host "$cmd_str_dbg"
    }
    # }
    set_dvlp_env 'KINDTEK_FAILSAFE_WSL_DISTRO' "kalilinux-kali-rolling-latest"
    set_dvlp_env 'KINDTEK_DEFAULT_WSL_DISTRO' "kalilinux-kali-rolling-latest"
    set_dvlp_env 'KINDTEK_DEVEL_TOOLS' "$git_path/scripts/devel-tools.ps1"
    set_dvlp_env 'KINDTEK_DEVEL_SPAWN' "$git_path/powerhell/devel-spawn.ps1"
    set_dvlp_env 'KINDTEK_WIN_GIT_OWNER' "$repo_src_owner"
    set_dvlp_env 'KINDTEK_WIN_GIT_PATH' "$git_parent_path"
    set_dvlp_env 'KINDTEK_WIN_DVLW_PATH' "$git_path"
    set_dvlp_env 'KINDTEK_WIN_DVLW_FULLNAME' "$repo_src_name"
    set_dvlp_env 'KINDTEK_WIN_DVLW_NAME' "$repo_dir_name"
    set_dvlp_env 'KINDTEK_WIN_DVLW_BRANCH' "$repo_src_branch"
    set_dvlp_env 'KINDTEK_WIN_DVLP_PATH' "$git_path/$repo_dir_name2"
    set_dvlp_env 'KINDTEK_WIN_DVLP_FULLNAME' "$repo_src_name2"
    set_dvlp_env 'KINDTEK_WIN_DVLP_NAME' "$repo_dir_name2"
    set_dvlp_env 'KINDTEK_WIN_POWERHELL_FULLNAME' "$repo_dir_name3"
    set_dvlp_env 'KINDTEK_WIN_POWERHELL_NAME' "$repo_dir_name3"
    set_dvlp_env 'KINDTEK_WIN_POWERHELL_PATH' "$git_path/$repo_dir_name3"
    set_dvlp_env 'KINDTEK_WIN_DVLADV_FULLNAME' "$repo_dir_name4"
    set_dvlp_env 'KINDTEK_WIN_DVLADV_NAME' "$repo_dir_name4"
    set_dvlp_env 'KINDTEK_WIN_DVLADV_PATH' "$git_path/$repo_dir_name4"
    set_dvlp_env 'KINDTEK_WIN_KERNELS_FULLNAME' "$repo_dir_name5"
    set_dvlp_env 'KINDTEK_WIN_KERNELS_NAME' "$repo_dir_name5"
    set_dvlp_env 'KINDTEK_WIN_KERNELS_PATH' "$repo_dir_name5"
    set_dvlp_env 'KINDTEK_WIN_MNT_FULLNAME' "$repo_dir_name6"
    set_dvlp_env 'KINDTEK_WIN_MNT_NAME' "$repo_dir_name6"
    set_dvlp_env 'KINDTEK_WIN_MNT_PATH' "$git_path/$repo_dir_name6"
    set_dvlp_env 'WSL_UTF8' '1'
    push_dvlp_envs

    try {
        $local_paths = get_dvlp_env 'path'
        $machine_paths = get_dvlp_env 'path' 'machine'
        $local_ext = get_dvlp_env 'pathext'
        $machine_ext = get_dvlp_env 'pathext' 'machine'
        
        # $local_paths = [string][System.Environment]::GetEnvironmentVariable('path')
        # $machine_paths = [string][System.Environment]::GetEnvironmentVariable('path', [System.EnvironmentVariableTarget]::Machine)
        # $local_ext = [System.Environment]::GetEnvironmentVariable('pathext')
        # $machine_ext = [string][System.Environment]::GetEnvironmentVariable('pathext', [System.EnvironmentVariableTarget]::Machine)
        
        if ($local_ext -split ";" -notcontains ".ps1") {
            # $local_ext += ";.ps1"
            set_dvlp_env "pathext" "$(get_dvlp_env 'pathext');.ps1"
            # $cmd_str_local = "[System.Environment]::SetEnvironmentVariable('pathext', '$local_ext')"
            # [dvlp_process_embed]$dvlp_proc = [dvlp_process_embed]::new("$cmd_str_local", 'wait')
        }
        if ($machine_ext -split ";" -notcontains ".ps1") {
            # $machine_ext += ";.ps1"
            # $cmd_str_machine = "[System.Environment]::SetEnvironmentVariable('pathext', '$machine_ext', '$([System.EnvironmentVariableTarget]::Machine)')"
            set_dvlp_env "pathext" "$(get_dvlp_env 'pathext' 'machine');.ps1" "machine" 
            # [dvlp_process_embed]$dvlp_proc = [dvlp_process_embed]::new("$cmd_str_machine")
        }
        if ($local_paths -split ";" -notcontains "$envKINDTEK_DEVEL_SPAWN" -or $local_paths -split ";" -notcontains "$env:KINDTEK_DEVEL_TOOLS" -or $local_paths -split ";" -notcontains "$env:KINDTEK_WIN_DVLW_PATH/scripts/" -or $local_paths -split ";" -notcontains "$env:KINDTEK_WIN_DVLP_PATH/scripts/") {
            # $local_paths += ";$env:KINDTEK_DEVEL_TOOLS;$env:KINDTEK_DEVEL_SPAWN;$env:KINDTEK_WIN_DVLW_PATH/scripts/;$env:KINDTEK_WIN_DVLP_PATH/scripts/;$env:USERPROFILE\dvlp.ps1"
            # $cmd_str_local = "[System.Environment]::SetEnvironmentVariable('path', '$local_paths')"
            set_dvlp_env "path" "$(get_dvlp_env 'path');$env:KINDTEK_DEVEL_TOOLS;$env:KINDTEK_DEVEL_SPAWN;$env:KINDTEK_WIN_DVLW_PATH/scripts/;$env:KINDTEK_WIN_DVLP_PATH/scripts/;$env:USERPROFILE\dvlp.ps1"
        }
        if ($machine_paths -split ";" -notcontains "$env:KINDTEK_DEVEL_SPAWN" -or $machine_paths -split ";" -notcontains "$env:KINDTEK_DEVEL_TOOLS" -or $machine_paths -split ";" -notcontains "$env:KINDTEK_WIN_DVLW_PATH/scripts/" -or $machine_paths -split ";" -notcontains "$env:KINDTEK_WIN_DVLP_PATH/scripts/") {
            # $machine_paths += ";$env:KINDTEK_DEVEL_TOOLS;$env:KINDTEK_DEVEL_SPAWN;$env:KINDTEK_WIN_DVLW_PATH/scripts/;$env:KINDTEK_WIN_DVLP_PATH/scripts/;$env:USERPROFILE\dvlp.ps1"
            # $cmd_str_machine = "[System.Environment]::SetEnvironmentVariable('path', '$machine_paths', '$([System.EnvironmentVariableTarget]::Machine)')"
            set_dvlp_env "path" "$(get_dvlp_env 'path' 'machine');$env:KINDTEK_DEVEL_TOOLS;$env:KINDTEK_DEVEL_SPAWN;$env:KINDTEK_WIN_DVLW_PATH/scripts/;$env:KINDTEK_WIN_DVLP_PATH/scripts/;$env:USERPROFILE\dvlp.ps1" "machine"
        }
        # Invoke-Expression("$cmd_str_local")
        # Invoke-Expression("$cmd_str_machine")

        # write-host "cmd_str_machine: $cmd_str_machine"
        # write-host "cmd_str_local: $cmd_str_local"

    } catch {}

    # $local_paths = [string][System.Environment]::GetEnvironmentVariable('path')
    # if ($local_paths -split ";" -notcontains "devel-tools.ps1" ) {
    #     if ($local_paths -split ";" -notcontains "$env:KINDTEK_WIN_DVLW_PATH/scripts/"){
    #         $local_paths += ";$env:KINDTEK_WIN_DVLW_PATH/scripts/"
    #     }
    #     if ($local_paths -split ";" -notcontains "$env:KINDTEK_WIN_DVLW_PATH/powerhell/devel-spawn.ps1"){
    #         $local_paths += ";$env:KINDTEK_WIN_DVLW_PATH/powerhell/devel-spawn.ps1"
    #     }
    #     $local_paths += ";$env:KINDTEK_DEVEL_TOOLS"
        
    #     if ($local_paths -split ";" -notcontains "$env:KINDTEK_WIN_DVLP_PATH/scripts/") {
    #         $local_paths += ";$env:KINDTEK_WIN_DVLP_PATH/scripts/"
    #     }
    #     $cmd_str_local = "[System.Environment]::SetEnvironmentVariable('path', '$local_paths')"
    #     [dvlp_process_embed]$dvlp_proc_local_paths = [dvlp_process_embed]::new("$cmd_str_local", 'wait')
    # }
    # $machine_paths = [string][System.Environment]::GetEnvironmentVariable('path', [System.EnvironmentVariableTarget]::Machine)
    # if ($machine_paths -split ";" -notcontains "devel-tools.ps1") {
    #     if ($machine_paths -split ";" -notcontains "$env:KINDTEK_WIN_DVLW_PATH/scripts/"){
    #         $machine_paths += ";$env:KINDTEK_WIN_DVLW_PATH/scripts/"
    #     }
    #     if ($machine_paths -split ";" -notcontains "$env:KINDTEK_WIN_DVLW_PATH/powerhell/devel-spawn.ps1"){
    #         $machine_paths += ";$env:KINDTEK_WIN_DVLW_PATH/powerhell/devel-spawn.ps1"
    #     }
    #     $machine_paths += ";$env:KINDTEK_DEVEL_TOOLS"
        
    #     if ($machine_paths -split ";" -notcontains "$env:KINDTEK_WIN_DVLP_PATH/scripts/") {
    #         $machine_paths += ";$env:KINDTEK_WIN_DVLP_PATH/scripts/"
    #     }
    #     $cmd_str_local = "[System.Environment]::SetEnvironmentVariable('path', '$machine_paths')"
    #     [dvlp_process_embed]$dvlp_proc_machine_envs = [dvlp_process_embed]::new("$cmd_str_machine", 'wait')
    # }
    # while ([string]::IsNullOrEmpty($env:KINDTEK_WIN_GIT_OWNER) `
    #         -or [string]::IsNullOrEmpty($env:KINDTEK_DEBUG_MODE) `
    #         -or [string]::IsNullOrEmpty($env:KINDTEK_DEVEL_TOOLS) `
    #         -or [string]::IsNullOrEmpty($env:KINDTEK_FAILSAFE_WSL_DISTRO) `
    #         -or [string]::IsNullOrEmpty($env:KINDTEK_WIN_GIT_PATH) `
    #         -or [string]::IsNullOrEmpty($env:KINDTEK_WIN_GIT_OWNER) `
    #         -or [string]::IsNullOrEmpty($env:KINDTEK_WIN_GIT_PATH) `
    #         -or [string]::IsNullOrEmpty($env:KINDTEK_WIN_DVLW_NAME) `
    #         -or [string]::IsNullOrEmpty($env:KINDTEK_WIN_DVLW_FULLNAME) `
    #         -or [string]::IsNullOrEmpty($env:KINDTEK_WIN_DVLW_BRANCH) `
    #         -or [string]::IsNullOrEmpty($env:KINDTEK_WIN_DVLW_PATH) `
    #         -or [string]::IsNullOrEmpty($env:KINDTEK_WIN_DVLP_NAME) `
    #         -or [string]::IsNullOrEmpty($env:KINDTEK_WIN_DVLP_FULLNAME) `
    #         -or [string]::IsNullOrEmpty($env:KINDTEK_WIN_DVLP_PATH) `
    #         -or [string]::IsNullOrEmpty($env:KINDTEK_WIN_POWERHELL_NAME) `
    #         -or [string]::IsNullOrEmpty($env:KINDTEK_WIN_POWERHELL_FULLNAME) `
    #         -or [string]::IsNullOrEmpty($env:KINDTEK_WIN_POWERHELL_PATH) `
    #         -or [string]::IsNullOrEmpty($env:KINDTEK_WIN_DVLADV_NAME) `
    #         -or [string]::IsNullOrEmpty($env:KINDTEK_WIN_DVLADV_FULLNAME) `
    #         -or [string]::IsNullOrEmpty($env:KINDTEK_WIN_DVLADV_PATH) `
    #         -or [string]::IsNullOrEmpty($env:KINDTEK_WIN_KERNELS_NAME) `
    #         -or [string]::IsNullOrEmpty($env:KINDTEK_WIN_KERNELS_FULLNAME) `
    #         -or [string]::IsNullOrEmpty($env:KINDTEK_WIN_KERNELS_PATH) `
    #         -or [string]::IsNullOrEmpty($env:KINDTEK_WIN_MNT_NAME) `
    #         -or [string]::IsNullOrEmpty($env:KINDTEK_WIN_MNT_FULLNAME) `
    #         -or [string]::IsNullOrEmpty($env:KINDTEK_WIN_MNT_PATH) ) {
    #     echo 'waiting for environment variables to update'
    #     start-sleep 5

    # }
    # try {
    #     write-host "dot sourcing devel-tools"
    #     if ((Test-Path -Path "$env:KINDTEK_DEVEL_TOOLS" -PathType Leaf)) {
    #         write-host 'dot sourcing devel tools'
    #         . $env:KINDTEK_DEVEL_TOOLS
    #     }
    # }catch{}

}

function test_wsl_distro {
    param (
        $distro_name
    )
    if ([string]::IsNullOrEmpty($distro_name)){
        return $false
    }
    Write-Host "testing wsl distro $distro_name"
    $test_string = 'helloworld'
    $test = wsl.exe -d $distro_name --exec echo $test_string
    if ($test -eq $test_string){
        # Write-Host "$distro_name is valid distro"
        return $true
    } else {
        # Write-Host "$distro_name is INVALID distro"
        return $false
    }
}

function test_default_wsl_distro {
    param (
        $distro_name
    )
    Write-Host "preparing to test wsl default distro $distro_name"

    if ( test_wsl_distro $distro_name){
        Write-Host "testing wsl default distro $distro_name"
        if (get_default_wsl_distro -eq $distro_name -and require_docker_online){
            # Write-Host "$distro_name is valid default distro"
            return $true
        } else {
            # Write-Host "$distro_name is INVALID default distro"
        }
    }

    return $false
}

function get_default_wsl_distro {
    $default_wsl_distro = wsl.exe --list | Where-Object { $_ -and $_ -ne '' -and $_ -match '(.*)\(' }
    $default_wsl_distro = $default_wsl_distro -replace '^(.*)\s.*$', '$1'
    return $default_wsl_distro
}

function revert_default_wsl_distro {
    try {
        wsl.exe -s $env:KINDTEK_FAILSAFE_WSL_DISTRO
    }
    catch {
        try {
            run_devels_playground "default"
        }
        catch {
            Write-Host "error reverting to $env:KINDTEK_FAILSAFE_WSL_DISTRO as default wsl distro"
            return $false
        }
    }
    if ( test_default_wsl_distro $env:KINDTEK_FAILSAFE_WSL_DISTRO ) {
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
    if ([string]::IsNullOrEmpty($new_wsl_default_distro)){
        if (!([string]::IsNullOrEmpty($env:KINDTEK_FAILSAFE_WSL_DISTRO))){
            $new_wsl_default_distro = $env:KINDTEK_FAILSAFE_WSL_DISTRO
        } else {
            return $false
        }
    }
    try {
        $old_wsl_default_distro = get_default_wsl_distro
        try {
            wsl.exe -s $new_wsl_default_distro
            $new_wsl_default_distro = get_default_wsl_distro
        }
        catch {
            Write-Host "error changing wsl default distro from $old_wsl_default_distro to $new_wsl_default_distro"
            $new_wsl_default_distro = $env:KINDTEK_FAILSAFE_WSL_DISTRO
            Write-Host "restoring default distro as $old_wsl_default_distro"
            wsl.exe -s $old_wsl_default_distro
            cmd.exe /c net stop LxssManager
            cmd.exe /c net start LxssManager
            $new_wsl_default_distro = $old_wsl_default_distro
        }
        set_dvlp_env 'KINDTEK_DEFAULT_WSL_DISTRO' $new_wsl_default_distro
        set_dvlp_env 'KINDTEK_OLD_DEFAULT_WSL_DISTRO' $old_wsl_default_distro
        push_dvlp_envs
        # handle failed installations
        if ( test_default_wsl_distro $new_wsl_default_distro -eq $false ) {
            # Write-Host "ERROR: docker desktop failed to start with $new_wsl_default_distro as default"
            # Start-Sleep 3
            # Write-Host "reverting to $env:KINDTEK_FAILSAFE_WSL_DISTRO as default wsl distro ..."
            # try {
            #     wsl.exe -s $env:KINDTEK_FAILSAFE_WSL_DISTRO
            # }
            # catch {
            #     try {
            #         run_devels_playground "default"
            #     }
            #     catch {
            #         Write-Host "error setting $env:KINDTEK_FAILSAFE_WSL_DISTRO as default wsl distro"
            #     }
            # }
            # # wsl_docker_restart
            # wsl_docker_restart_new_win
            # require_docker_online_new_win
            # $env:KINDTEK_OLD_DEFAULT_WSL_DISTRO = $old_wsl_default_distro
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
        start_dvlp_process_popmax "powershell.exe -executionpolicy remotesigned -File $file" 'wait'
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
    Invoke-WebRequest "https://raw.githubusercontent.com/kindtek/choco/ac806ee5ce03dea28f01c81f88c30c17726cb3e9/src/chocolatey.resources/redirects/RefreshEnv.cmd" -OutFile $refresh_envs | Out-Null
    $progress_flag = $orig_progress_flag
    if (!(Test-Path -Path "$env:KINDTEK_WIN_GIT_PATH/.github-installed" -PathType Leaf)) {
        Write-Host "Installing $software_name ..." -ForegroundColor DarkCyan
        start_dvlp_process_popmax "winget install --exact --id GitHub.cli --silent --locale en-US --accept-package-agreements --accept-source-agreements;winget upgrade --exact --id GitHub.cli --silent --locale en-US --accept-package-agreements --accept-source-agreements;winget install --id Git.Git --source winget --silent --locale en-US --accept-package-agreements --accept-source-agreements;winget upgrade --id Git.Git --source winget --silent --locale en-US --accept-package-agreements --accept-source-agreements;exit;" 'wait'
        Write-Host "$software_name installed" -ForegroundColor DarkCyan | Out-File -FilePath "$env:KINDTEK_WIN_GIT_PATH/.github-installed"; `
    }
    else {
        Write-Host "$software_name already installed" -ForegroundColor DarkCyan
    }
    # allow git to be used in same window immediately after installation
    powershell.exe -Command $refresh_envs | Out-Null
    ([void]( New-Item -path alias:git -Value 'C:\Program Files\Git\bin\git.exe' -ErrorAction SilentlyContinue | Out-Null ))
    start_dvlp_process_pop 'sync_repo' 'wait'
    # assuming the repos are now synced now is a good time to dot source devel-tools
    if ((Test-Path -Path "$env:KINDTEK_DEVEL_TOOLS" -PathType Leaf)) {
        # write-host 'dot sourcing devel tools'
        . $env:KINDTEK_DEVEL_TOOLS
    }
    # Start-Process powershell -LoadUserProfile $env:KINDTEK_NEW_PROC_STYLE -ArgumentList [string]$env:KINDTEK_NEW_PROC_NOEXIT "-Command &{sync_repo;exit;}" -Wait
    return
}

function clone_repo {
    Push-Location $env:KINDTEK_WIN_GIT_PATH
    write-host "cloning $env:KINDTEK_WIN_DVLW_NAME ..." -ForegroundColor DarkCyan
    $clone_result = git clone "https://github.com/$env:KINDTEK_WIN_GIT_OWNER/$env:KINDTEK_WIN_DVLW_FULLNAME" --branch $env:KINDTEK_WIN_DVLW_BRANCH --progress -- $env:KINDTEK_WIN_DVLW_NAME
    write-host "$env:KINDTEK_WIN_DVLW_NAME cloned" -ForegroundColor DarkCyan
    Pop-Location
    return $clone_result
}

function pull_repo {
    Push-Location $env:KINDTEK_WIN_GIT_PATH
    write-host "pulling $env:KINDTEK_WIN_DVLW_NAME ..." -ForegroundColor DarkCyan
    $clone_result = git -C $env:KINDTEK_WIN_DVLW_NAME pull --progress
    write-host "$env:KINDTEK_WIN_DVLW_NAME pulled" -ForegroundColor DarkCyan
    Pop-Location
    return $clone_result
}
function sync_repo {
    Write-Host "testing git command ..." -ForegroundColor DarkCyan
    ([void]( New-Item -path alias:git -Value 'C:\Program Files\Git\bin\git.exe' -ErrorAction SilentlyContinue | Out-Null ))
    Write-Host "synchronizing kindtek github repos ..." -ForegroundColor DarkCyan
    New-Item -ItemType Directory -Force -Path $env:KINDTEK_WIN_GIT_PATH | Out-Null
    echo "entering path $($env:KINDTEK_WIN_GIT_PATH)"
    Push-Location $env:KINDTEK_WIN_GIT_PATH
    Write-Host "synchronizing $env:KINDTEK_WIN_GIT_PATH/$env:KINDTEK_WIN_DVLW_NAME with https://github.com/$env:KINDTEK_WIN_GIT_OWNER/$env:KINDTEK_WIN_DVLW_FULLNAME repo ..." -ForegroundColor DarkCyan
    write-host "testing path $($env:KINDTEK_WIN_DVLW_PATH)/.git" 
    if ((Test-Path -Path "$($env:KINDTEK_WIN_DVLW_PATH)/.git")) {
        write-host "path $($env:KINDTEK_WIN_DVLW_PATH)/.git found" 
        pull_repo
    } else {
        write-host "path $($env:KINDTEK_WIN_DVLW_PATH)/.git NOT found" 
        clone_repo
    }
    try {
        write-host "entering path $($env:KINDTEK_WIN_DVLW_PATH)"
        Push-Location $env:KINDTEK_WIN_DVLW_PATH
    } catch {
        clone_repo
        Push-Location $env:KINDTEK_WIN_DVLW_PATH
    }
    if ((Test-Path -Path "$($env:KINDTEK_WIN_DVLP_PATH)/.git")) {
        write-host "pulling $env:KINDTEK_WIN_DVLP_NAME ..." -ForegroundColor DarkCyan
        git submodule update --remote --progress -- $env:KINDTEK_WIN_DVLP_NAME
        write-host "$env:KINDTEK_WIN_DVLP_NAME pulled" -ForegroundColor DarkCyan
    }
    else {
        write-host "pulling $env:KINDTEK_WIN_DVLP_NAME ..." -ForegroundColor DarkCyan
        git submodule update --init --init --remote --progress -- $env:KINDTEK_WIN_DVLP_NAME
        write-host "$env:KINDTEK_WIN_DVLP_NAME pulled" -ForegroundColor DarkCyan
    }
    if ((Test-Path -Path "$($env:KINDTEK_WIN_DVLADV_PATH)/.git")) {
        write-host "pulling $env:KINDTEK_WIN_DVLADV_NAME ..." -ForegroundColor DarkCyan
        git submodule update --remote --progress -- $env:KINDTEK_WIN_DVLADV_NAME
        write-host "$env:KINDTEK_WIN_DVLADV_NAME pulled" -ForegroundColor DarkCyan
    }
    else {
        write-host "pulling $env:KINDTEK_WIN_DVLADV_NAME ..." -ForegroundColor DarkCyan
        git submodule update --init --remote --progress -- $env:KINDTEK_WIN_DVLADV_NAME
        write-host "$env:KINDTEK_WIN_DVLADV_NAME pulled" -ForegroundColor DarkCyan
    }
    if ((Test-Path -Path "$($env:KINDTEK_WIN_POWERHELL_PATH)/.git")) {
        write-host "pulling $env:KINDTEK_WIN_POWERHELL_NAME ..." -ForegroundColor DarkCyan
        git submodule update --remote --progress -- $env:KINDTEK_WIN_POWERHELL_NAME
        write-host "$env:KINDTEK_WIN_POWERHELL_NAME pulled" -ForegroundColor DarkCyan
    }
    else {
        write-host "pulling $env:KINDTEK_WIN_POWERHELL_NAME ..." -ForegroundColor DarkCyan
        git submodule update --init --remote --progress -- $env:KINDTEK_WIN_POWERHELL_NAME
        write-host "$env:KINDTEK_WIN_POWERHELL_NAME pulled" -ForegroundColor DarkCyan
    }
    Push-Location $env:KINDTEK_WIN_DVLP_NAME
    if ((Test-Path -Path "$($env:KINDTEK_WIN_KERNELS_PATH)/.git")) {
        write-host "pulling $env:KINDTEK_WIN_KERNELS_NAME ..." -ForegroundColor DarkCyan
        git submodule update --remote --progress -- $env:KINDTEK_WIN_KERNELS_NAME
        write-host "$env:KINDTEK_WIN_KERNELS_NAME pulled" -ForegroundColor DarkCyan
    }
    else {
        write-host "pulling $env:KINDTEK_WIN_KERNELS_NAME ..." -ForegroundColor DarkCyan
        git submodule update --init --remote --progress -- $env:KINDTEK_WIN_KERNELS_NAME
        write-host "$env:KINDTEK_WIN_KERNELS_NAME pulled" -ForegroundColor DarkCyan
    }
    if ((Test-Path -Path "$($env:KINDTEK_WIN_MNT_PATH)/.git")) {
        write-host "pulling $env:KINDTEK_WIN_MNT_NAME" -ForegroundColor DarkCyan
        git submodule update --remote --progress -- $env:KINDTEK_WIN_MNT_NAME
        write-host "$env:KINDTEK_WIN_MNT_NAME pulled" -ForegroundColor DarkCyan
    }
    else {
        write-host "pulling $env:KINDTEK_WIN_MNT_NAME ..." -ForegroundColor DarkCyan
        git submodule update --init --remote --progress -- $env:KINDTEK_WIN_MNT_NAME
        write-host "$env:KINDTEK_WIN_MNT_NAME pulled" -ForegroundColor DarkCyan
    }
    
    Pop-Location
    Pop-Location
    Pop-Location
    Copy-Item $env:KINDTEK_WIN_POWERHELL_PATH/devel-spawn.ps1 $env:USERPROFILE/dvlp.ps1 -Verbose
}

function run_devels_playground {
    param (
        $img_name_tag, $non_interactive, $default_distro
    )
    try {
        $software_name = "docker devel"
        # if (!(Test-Path -Path "$env:KINDTEK_WIN_GIT_PATH/.dvlp-installed" -PathType Leaf)) {
        Write-Host "`r`nIMPORTANT: keep docker desktop running or the import will fail`r`n" 
        require_docker_online | Out-Null
        if (is_docker_desktop_online -eq $true) {
            # Write-Host "now connected to docker desktop ...`r`n"
            # Write-Host "&$devs_playground $env:img_name_tag"
            # Write-Host "$([char]27)[2J"
            # Write-Host "`r`npowershell.exe -Command `"$env:"$env:KINDTEK_WIN_DVLP_PATH/scripts/wsl-docker-import.cmd`" $img_name_tag`r`n"
            # write-host `$img_name_tag $img_name_tag
            # write-host `$non_interactive $non_interactive
            # write-host `$default_distro $default_distro
            # $current_process = [System.Diagnostics.Process]::GetCurrentProcess() | Select-Object -ExpandProperty ID
            # $current_process_object = Get-Process -id $current_process
            # Set-ForegroundWindow $current_process_object.MainWindowHandle
            # Set-ForegroundWindow ($current_process_object).MainWindowHandle
            if ([string]::IsNullOrEmpty($img_name_tag)){
                powershell.exe -Command "$env:KINDTEK_WIN_DVLP_PATH/scripts/wsl-docker-import.cmd"
            } else {
                powershell.exe -Command "$env:KINDTEK_WIN_DVLP_PATH/scripts/wsl-docker-import.cmd '$img_name_tag' '$non_interactive' '$default_distro'" 
            }

            # powershell.exe -Command "$env:KINDTEK_WIN_DVLP_PATH/scripts/wsl-docker-import.cmd" "$img_name_tag" "$non_interactive" "$default_distro"
            # &$devs_playground = "$env:KINDTEK_WIN_GIT_PATH/dvlp/scripts/wsl-docker-import.cmd $env:img_tag"
        }
        else {
            Write-Host "`r`nmake sure docker desktop is running"
            Write-Host "still not working? try: `r`n`t- restart WSL`r`n`t- change your default distro (ie: wsl.exe -s kalilinux-kali-rolling-latest )"
        }
        
        # }
    }
    catch {}
}

function run_dvlp_latest_kernel_installer {
    param (
        $distro
    )
    push-location $env:KINDTEK_WIN_DVLP_PATH/kernels/linux/kache
    require_docker_online_new_win
    if (is_docker_desktop_online -eq $true){
        ./wsl-kernel-install.ps1 latest
    }    
    pop-location
}

function install_everything {  
    param (
        $img_name_tag
    )
    $dvlp_choice = 'refresh'
    do {
        if ((Test-Path -Path "$env:KINDTEK_DEVEL_TOOLS" -PathType Leaf)) {
            # write-host 'dot sourcing devel tools'
            . $env:KINDTEK_DEVEL_TOOLS
        }
        $host.UI.RawUI.ForegroundColor = "White"
        $host.UI.RawUI.BackgroundColor = "Black"
        $confirmation = ''    
        if (($dvlp_choice -ine 'kw') -And (!(Test-Path -Path "$env:KINDTEK_WIN_DVLW_PATH/.dvlp-installed" -PathType Leaf))) {
            $host.UI.RawUI.ForegroundColor = "Black"
            $host.UI.RawUI.BackgroundColor = "DarkRed"
            Write-Host "$([char]27)[2J"
            # $confirmation = Read-Host "`r`nRestarts may be required as new applications are installed. Save your work now.`r`n`r`n`tHit ENTER to continue`r`n`r`n`tpowershell.exe -Command $file $args" 
            Write-Host "`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n"
            $confirmation = Read-Host "Restarts may be required as new applications are installed. Save your work now.`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`tHit ENTER to continue`r`n"
            Write-Host "$([char]27)[2J"
            Write-Host "`r`n`r`n`r`n`r`n`r`n`r`nRestarts may be required as new applications are installed. Save your work now.`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`t"
    
        } else {
            Write-Host "`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n"
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
            # if confirmation is kw or (img_tag must not empty ... OR dvlp must not installed)
            # if (($confirmation -eq 'kw') -or (!(Test-Path -Path "$env:KINDTEK_WIN_DVLW_PATH/.dvlp-installed" -PathType Leaf) -or (!([string]::IsNullOrEmpty($img_name_tag))))) {
            if (($dvlp_choice -eq 'kw') -or (!(Test-Path -Path "$env:KINDTEK_WIN_DVLW_PATH/.dvlp-installed" -PathType Leaf))) {
                # write-host "confirmation: $confirmation"
                # write-host "test path $($env:KINDTEK_WIN_DVLW_PATH)/.dvlp-installed $((Test-Path -Path "$env:KINDTEK_WIN_DVLW_PATH/.dvlp-installed" -PathType Leaf))"
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
                install_git
                if ((Test-Path -Path "$($env:KINDTEK_DEVEL_TOOLS)" -PathType Leaf)) {
                    # write-host 'dot sourcing devel tools'
                    . $env:KINDTEK_DEVEL_TOOLS
                } 
                run_installer
                # $host.UI.RawUI.ForegroundColor = "DarkGray"
                # $host.UI.RawUI.ForegroundColor = "White"
                require_docker_online_new_win
                # make sure failsafe kalilinux-kali-rolling-latest distro is installed so changes can be easily reverted
                # $env:KINDTEK_WIN_DVLW_PATH, $img_name_tag, $non_interactive, $default_distro
                try {
                    if (!(Test-Path -Path "$($env:KINDTEK_WIN_DVLW_PATH)/.dvlp-installed" -PathType Leaf)) {
                        run_devels_playground "default"
                        cmd.exe /c net stop LxssManager
                        cmd.exe /c net start LxssManager
                        # write-host "testing wsl distro $env:KINDTEK_FAILSAFE_WSL_DISTRO"
                        if ((test_default_wsl_distro $env:KINDTEK_FAILSAFE_WSL_DISTRO) -eq $true){
                            # write-host "$env:KINDTEK_FAILSAFE_WSL_DISTRO test passed"
                            Write-Host "docker devel installed`r`n" | Out-File -FilePath "$env:KINDTEK_WIN_DVLW_PATH/.dvlp-installed"
                        } else {
                            # write-host "$env:KINDTEK_FAILSAFE_WSL_DISTRO test FAILED"
                        }
                        # install hypervm on next open
                        try {
                            if (!(Test-Path "$env:KINDTEK_WIN_DVLW_PATH/.hypervm-installed" -PathType Leaf)) {
                                $profilePath = Join-Path $env:USERPROFILE 'Documents\PowerShell\Microsoft.PowerShell_profile.ps1'
                                $vmpPath = Join-Path $env:USERPROFILE 'Documents\PowerShell\kindtek.Set-VMP.ps1'
                                New-Item -Path $profilePath -ItemType File -Force
                                New-Item -Path $vmpPath -ItemType File -Force
                                Add-Content $profilePath "./kindtek.Set-VMP.ps1;Clear-Content 'kindtek.Set-VMP.ps1';./$env:USERPROFILE/dvlp"
                                Add-Content $vmpPath "`nWrite-Host 'Preparing to set up HyperV VM Processor as kali-linux ...';Start-Sleep 10;Set-VMProcessor -VMName kali-linux -ExposeVirtualizationExtensions `$true -ErrorAction SilentlyContinue"        
                                Write-Host "$software_name installed`r`n" | Out-File -FilePath "$env:KINDTEK_WIN_DVLW_PATH/.hypervm-installed"
                            }
                        }
                        catch {}
                    }
                    
                }
                catch {
                    Write-Host "error setting $env:KINDTEK_FAILSAFE_WSL_DISTRO as default wsl distro"
                }
                # install distro requested in arg
                try {
                    if (!([string]::IsNullOrEmpty($img_name_tag))) {
                        $host.UI.RawUI.ForegroundColor = "White"
                        $host.UI.RawUI.BackgroundColor = "Black"

                        $old_wsl_default_distro = get_default_wsl_distro
                        if ($dvlp_choice -ieq 'kw' -and (Test-Path -Path "$env:KINDTEK_WIN_DVLW_PATH/.dvlp-installed" -PathType Leaf)) {
                            # start_dvlp_process_pop "$(run_devels_playground "$env:KINDTEK_WIN_DVLP_FULLNAME:$img_name_tag" '' 'default')" 'wait'
                            run_devels_playground "$env:KINDTEK_WIN_DVLP_FULLNAME:$img_name_tag" '' 'default'
                            run_dvlp_latest_kernel_installer
                            require_docker_online_new_win
                        } else {
                            run_devels_playground "$env:KINDTEK_WIN_DVLP_FULLNAME:$img_name_tag" "kindtek-$env:KINDTEK_WIN_DVLP_FULLNAME-$img_name_tag" "default"
                            run_dvlp_latest_kernel_installer
                            require_docker_online | Out-Null
                        }
                        $new_wsl_default_distro = get_default_wsl_distro
                        
                        if (($new_wsl_default_distro -ne $old_wsl_default_distro) -and (is_docker_desktop_online -eq $false)) {
                            Write-Host "ERROR: docker desktop failed to start with $new_wsl_default_distro distro"
                            # Write-Host "reverting to $old_wsl_default_distro as default wsl distro ..."
                            # try {
                            #     wsl.exe -s $old_wsl_default_distro
                            #     wsl_docker_restart_new_win
                            #     # wsl_docker_restart
                            #     require_docker_online_new_win
                            # }
                            # catch {
                            #     try {
                            #         revert_default_wsl_distro
                            #         require_docker_online_new_win
                            #     }
                            #     catch {
                            #         Write-Host "error setting failsafe as default wsl distro"
                            #     }
                            # }
                        }
                    }
                }
                catch {
                    Write-Host "error setting "kindtek-$env:KINDTEK_WIN_DVLP_FULLNAME-$img_name_tag" as default wsl distro"
                    try {
                        wsl.exe -s $env:KINDTEK_FAILSAFE_WSL_DISTRO
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
            } else {
                if ((Test-Path -Path "$env:KINDTEK_DEVEL_TOOLS" -PathType Leaf)) {
                    # write-host 'dot sourcing devel tools'
                    . $env:KINDTEK_DEVEL_TOOLS
                }
                if (($dvlp_choice -ceq 'refresh') -And ((Test-Path -Path "$env:KINDTEK_WIN_DVLW_PATH/.dvlp-installed" -PathType Leaf))) {
                    start_dvlp_process_hide 'sync_repo'
                } else {
                    sync_repo
                }
            } 
            do {
                $wsl_restart_path = "$env:USERPROFILE/wsl-restart.ps1"
                $env:KINDTEK_DEFAULT_WSL_DISTRO = get_default_wsl_distro
                if ((Test-Path -Path "$env:KINDTEK_WIN_DVLW_PATH/.dvlp-installed" -PathType Leaf) -and (!([string]::IsNullOrEmpty($img_name_tag)))){
                    $run_devels_playground_noninteractive = "`r`n`t- [d!] (import $env:KINDTEK_WIN_DVLP_FULLNAME:$img_name_tag)"
                }
                if ("$env:KINDTEK_OLD_DEFAULT_WSL_DISTRO" -ne "$env:KINDTEK_DEFAULT_WSL_DISTRO" -and !([string]::IsNullOrEmpty($env:KINDTEK_OLD_DEFAULT_WSL_DISTRO)) -and "$env:KINDTEK_OLD_DEFAULT_WSL_DISTRO" -ne "$env:KINDTEK_FAILSAFE_WSL_DISTRO") {
                    $wsl_distro_undo_option = "`r`n`t- [u]ndo wsl changes (revert to $env:KINDTEK_OLD_DEFAULT_WSL_DISTRO)"
                }
                else {
                    $wsl_distro_undo_option = ''
                }
                # if (get_default_wsl_distro -eq $env:KINDTEK_FAILSAFE_WSL_DISTRO){
                #     $wsl_distro_undo_option = "`r`n`t- set [f]ailsafe distro as default" + $wsl_distro_undo_option
                # }
                write-host "`r`n`r`n`r`n --------------------------------------------------------------------------"
                write-host "  WSL Distros"
                write-host " --------------------------------------------------------------------------"
                $wsl_distro_list = get_wsl_distro_list
                wsl_distro_list_display $wsl_distro_list
                # $dvlp_choice = Read-Host "`r`nHit ENTER to exit or choose from the following:`r`n`t- launch [W]SL`r`n`t- launch [D]evels Playground`r`n`t- launch repo in [V]S Code`r`n`t- build/install a Linux [K]ernel`r`n`r`n`t"
                $dvlp_options = "`r`n`r`n`r`nEnter a wsl distro number or choose from the following:`r`n`t- [d]ocker devel${run_devels_playground_noninteractive}${wsl_distro_undo_option}`r`n`t- [c]ommand line`r`n`t- [k]indtek setup`r`n`t- [refresh]`r`n`t- [restart] wsl`r`n`t- [reboot] computer`r`n`t- [revert] to $env:KINDTEK_FAILSAFE_WSL_DISTRO`r`n`r`n`r`n(exit)"
                # $current_process = [System.Diagnostics.Process]::GetCurrentProcess() | Select-Object -ExpandProperty ID
                # $current_process_object = Get-Process -id $current_process
                # Set-ForegroundWindow $current_process_object.MainWindowHandle
                $dvlp_choice = Read-Host $dvlp_options
                if ($dvlp_choice -ieq 'refresh') {
                    # require_docker_online
                    # sync_repo
                }
                elseif ($dvlp_choice -ieq 'd') {
                    # require_docker_online
                    if ([string]::IsNullOrEmpty($img_name_tag)){
                        run_devels_playground
                    } else {
                        require_docker_online;
                        run_devels_playground '$env:KINDTEK_WIN_DVLP_FULLNAME:$img_name_tag' '' ''
                    }
                    $dvlp_choice = 'refresh'
                }
                elseif ($dvlp_choice -ieq 'd!') {
                    require_docker_online
                    run_devels_playground '$env:KINDTEK_WIN_DVLP_FULLNAME:$img_name_tag' 'kindtek-$env:KINDTEK_WIN_DVLP_FULLNAME-$img_name_tag' 'default'
                }
                elseif ($dvlp_choice -imatch "d\d"){
                    [int]$wsl_choice = [string]$dvlp_choice.Substring(1)
                    echo "wsl_choice: $wsl_choice"
                    $wsl_distro_choice = wsl_distro_list_select $wsl_distro_list $wsl_choice
                    if ($wsl_distro_choice){
                        write-output "`r`n`tpress ENTER to set $wsl_distro_choice as default distro`r`n`t`t.. or enter any other key to skip "
                        $wsl_distro_choice_confirm = read-host "
(set $wsl_distro_choice as default distro)"
                        if ([string]::isnullorempty($wsl_distro_choice_confirm)){
                            set_default_wsl_distro $wsl_distro_choice
                        }
                    } else {
                        write-host "no distro for ${wsl_choice} found"
                    }
                    $dvlp_choice = 'refresh'
                }
                elseif ($dvlp_choice -imatch "x\d"){
                    [int]$wsl_choice = [string]$dvlp_choice.Substring(1)
                    echo "wsl_choice: $wsl_choice"
                    $wsl_distro_choice = wsl_distro_list_select $wsl_distro_list $wsl_choice
                    if ($wsl_distro_choice){
                        write-output "`r`n`tpress ENTER to delete $wsl_distro_choice `r`n`t`t.. or enter any other key to skip "
                        $wsl_distro_choice_confirm = read-host "
(DELETE $wsl_distro_choice)"
                        if ([string]::isnullorempty($wsl_distro_choice_confirm)){
                            if ($wsl_distro_choice -eq $(get_default_wsl_distro)){
                                write-host "replacing $wsl_distro_choice with $env:KINDTEK_FAILSAFE_WSL_DISTRO as default distro ..."
                                revert_default_wsl_distro
                            }
                            wsl --unregister $wsl_distro_choice
                        }
                    } else {
                        write-host "no distro for ${wsl_choice} found"
                    }
                    $dvlp_choice = 'refresh'
                }
                elseif ($dvlp_choice -imatch "o\d"){
                    [int]$wsl_choice = [string]$dvlp_choice.Substring(1)
                    echo "wsl_choice: $wsl_choice"
                    $wsl_distro_choice = wsl_distro_list_select $wsl_distro_list $wsl_choice
                    if ($wsl_distro_choice){
                        write-output "`r`n`tpress ENTER to open $wsl_distro_choice `r`n`t`t.. or enter any other key to skip "
                        $wsl_distro_choice_confirm = read-host "
(OPEN $wsl_distro_choice)"
                        if ([string]::isnullorempty($wsl_distro_choice_confirm)){
                            wsl --cd /hal --user agl -d $wsl_distro_choice -- bash source .bashrc
                        }
                    } else {
                        write-host "no distro for ${wsl_choice} found"
                    }
                    $dvlp_choice = 'refresh'
                } 
                elseif ($dvlp_choice -match "\d"){
                    $wsl_distro_selected = wsl_distro_list_select $wsl_distro_list $dvlp_choice
                    if ([string]::IsNullOrEmpty($wsl_distro_selected)){
                        write-host "no distro found for $dvlp_choice`r`n`r`nEnter 'DELETE' for option to delete multiple distros"
                        $wsl_action_choice = read-host 
                        if ($wsl_action_choice -ceq 'DELETE') {
                            write-host $(get_dvlp_env 'KINDTEK_WIN_DVLP_PATH')
                            write-host $("$(get_dvlp_env 'KINDTEK_WIN_DVLP_PATH')/scripts/wsl-remove-distros.ps1")
                            powershell -File $("$(get_dvlp_env 'KINDTEK_WIN_DVLP_PATH')/scripts/wsl-remove-distros.ps1")
                        }
                    }
                    else {
                        write-host "$wsl_distro_selected selected.`r`n`r`nEnter OPEN, DEFAULT, SETUP, KERNEL, DELETE`r`n`t ... or press ENTER to open"
                        $wsl_action_choice = read-host "
(open $wsl_distro_selected)"
                        if ($wsl_action_choice -ceq 'DELETE') {
                            if ($wsl_distro_selected -eq $(get_default_wsl_distro)){
                                write-host "replacing $wsl_distro_selected with $env:KINDTEK_FAILSAFE_WSL_DISTRO as default distro ..."
                                revert_default_wsl_distro
                            }
                            write-host "deleting $wsl_distro_selected distro ..."
                            wsl --unregister $wsl_distro_selected
                        } elseif ($wsl_action_choice -ceq 'DEFAULT') {
                            write-host "setting $wsl_distro_selected as default distro ..."
                            wsl --set-default $wsl_distro_selected
                        } elseif ($wsl_action_choice -ceq 'KERNEL') {
                            $kernel_choices = @()
                            $wsl_kernel_make_path = "$($env:USERPROFILE)/kache/wsl-kernel-make.ps1"
                            $wsl_kernel_rollback_path = "$($env:USERPROFILE)/kache/wsl-kernel-rollback.ps1"
                            $wsl_kernel_install_path = "$($env:USERPROFILE)/kache/wsl-kernel-install.ps1"
                            if ($(get_default_wsl_distro $wsl_distro_selected)){
                                if (Test-Path $wsl_kernel_install_path -PathType Leaf -ErrorAction SilentlyContinue ){
                                    $kernel_choices += 'install'
                                }
                                if (Test-Path $wsl_kernel_make_path -PathType Leaf -ErrorAction SilentlyContinue ){
                                    $kernel_choices += 'make'
                                }
                            }
                            if (Test-Path $wsl_kernel_rollback_path -PathType Leaf -ErrorAction SilentlyContinue ){
                                $kernel_choices += 'rollback'
                            }
                            write-host 'enter one of the following:'
                            for ($i = 0; $i -le $kernel_choices.length - 1; $i++) {
                                write-host $kernel_choices[$i]
                            }
                            $kernel_choice = read-host "
(exit)"
                            if ($kernel_choice  = 'install'){
                                powershell -File $wsl_kernel_install_path                               
                            }
                            if ($kernel_choice  = 'make'){
                                powershell -File $wsl_kernel_make_path                                
                            }
                            if ($kernel_choice  = 'rollback'){
                                powershell -File $wsl_kernel_rollback_path                                
                            }
                            if ($kernel_choice = ''){
                                $dvlp_choice = 'refresh'
                            }
                            $kernel_choice = ''

                        } elseif ($wsl_action_choice -ceq 'SETUP') {
                            write-host "setting up $wsl_distro_selected ..."
                            wsl -d $wsl_distro_selected --user $(get_dvlp_env '_AGL') --cd /hal --exec bash ./setup.sh $env:USERNAME
                        }  elseif ([string]::IsNullOrEmpty($wsl_action_choice) -or $wsl_action_choice -ieq 'open' ){
                            write-host "type 'exit' to return to main menu"
                            wsl -d $wsl_distro_selected --user $(get_dvlp_env '_AGL') --cd /hal
                        }
                    }
                    $dvlp_choice = 'refresh'
                }
                elseif ($dvlp_choice -ieq 'revert') {
                    try {
                        set_default_wsl_distro
                        require_docker_online_new_win
                    }
                    catch {
                        try {
                            revert_default_wsl_distro
                        }
                        catch {
                            Write-Host "error setting $env:KINDTEK_FAILSAFE_WSL_DISTRO as default wsl distro"
                        }
                    }
                    $dvlp_choice = 'refresh'
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
                        start_dvlp_process_pop "wsl --cd /hal -- " 'wait' 'noexit'
                    }
                    elseif ($dvlp_choice -ieq 'cdl' ) {
                        start_dvlp_process_pop "wsl --cd /hal -- `$(cdir)" 'wait' 'noexit'
                    }
                    elseif ($dvlp_choice -ieq 'cw' ) {
                        start_dvlp_process_pop "Set-Location -literalPath $env:USERPROFILE" 'wait' 'noexit'
                    }
                    elseif ($dvlp_choice -ieq 'cdw' ) {
                        # one day might get the windows cdir working
                        start_dvlp_process_pop "Set-Location -literalPath $env:USERPROFILE" 'wait' 'noexit'
                    }
                    # $dvlp_choice = 'refresh'

                }
                elseif ($dvlp_choice -like 'k*') {
                    if ($dvlp_choice -ieq 'k') {
                        Write-Host "`r`n`t[l]inux or [w]indows"
                        $dvlp_kindtek_options = Read-Host
                        if ($dvlp_kindtek_options -ieq 'l' -or $dvlp_kindtek_options -ieq 'w') {
                            $dvlp_choice = $dvlp_choice + $dvlp_kindtek_options
                            if ($dvlp_kindtek_options -ieq 'w') {
                                Write-Host "`t-`t[d]ocker settings reset`r`n`t-`t[D]ocker re-install`r`n`t-`t[w]indows re-install`r`n"
                                $dvlp_kindtek_options_win = Read-Host
                                if ($dvlp_kindtek_options_win -ceq 'd') {
                                    reset_docker_settings_hard
                                    require_docker_online_new_win
                                }
                                if ($dvlp_kindtek_options_win -ceq 'D') {
                                    powershell -File $("$(get_dvlp_env 'KINDTEK_WIN_DVLADV_PATH')/reinstall-docker.ps1")
                                    require_docker_online_new_win
                                }
                                if ($dvlp_kindtek_options_win -ieq 'w') {
                                    powershell -File $("$(get_dvlp_env 'KINDTEK_WIN_DVLADV_PATH')/add-windows-features.ps1")
                                    powershell -File $("$(get_dvlp_env 'KINDTEK_WIN_DVLADV_PATH')/del-windows-features.ps1")
                                    require_docker_online_new_win
                                }
                            } elseif ($dvlp_kindtek_options_win -ieq 'l') {
                                $dvlp_kindtek_options_win = Read-Host
                            }
                        }
                        $dvlp_choice = 'refresh'
                    }
                    if ($dvlp_choice -ieq 'kl' ) {
                        wsl.exe --cd /hal exec bash setup.sh $env:USERNAME
                        $dvlp_choice = 'refresh'

                    }
                    elseif ($dvlp_choice -ieq 'kw' ) {
                        Write-Host 'checking for updates ...'
                    }
                }
                elseif ($dvlp_choice -ieq 'u') {
                    if ($env:KINDTEK_OLD_DEFAULT_WSL_DISTRO -ne "") {
                        # wsl.exe --set-default kalilinux-kali-rolling-latest
                        Write-Host "`r`n`r`nsetting $env:KINDTEK_OLD_DEFAULT_WSL_DISTRO as default distro ..."
                        wsl.exe --set-default $env:KINDTEK_OLD_DEFAULT_WSL_DISTRO
                        # wsl_docker_restart
                        wsl_docker_restart_new_win
                        $dvlp_choice = 'refresh'
                    }
                }
                elseif ($dvlp_choice -ceq 'restart') {
                    # wsl_docker_restart
                    wsl_docker_restart_new_win
                    $dvlp_choice = 'refresh'
                }
                elseif ($dvlp_choice -ceq 'restart!') {
                    # wsl_docker_restart
                    wsl_docker_full_restart_new_win
                    $dvlp_choice = 'refresh'
                }
                elseif ($dvlp_choice -ceq 'RESTART') {
                    if (Test-Path $wsl_restart_path -PathType Leaf -ErrorAction SilentlyContinue ) {
                        powershell.exe -ExecutionPolicy RemoteSigned -File $wsl_restart_path
                        require_docker_online_new_win
                    }
                    $dvlp_choice = 'refresh'
                }
                elseif ($dvlp_choice -ceq 'rk'){
                    $wsl_kernel_rollback_path = "$($env:USERPROFILE)/kache/wsl-kernel-rollback.ps1"
                    if (Test-Path $wsl_kernel_rollback_path -PathType Leaf -ErrorAction SilentlyContinue ){
                        powershell.exe -ExecutionPolicy RemoteSigned -File $wsl_restart_path
                        require_docker_online_new_win
                    }
                    $dvlp_choice = 'refresh'
                }
                elseif ($dvlp_choice -ceq 'reboot') {
                    reboot_prompt
                    # elseif ($dvlp_choice -ieq 'v') {
                    #     wsl sh -c "cd /hel;. code"
                    $dvlp_choice = 'refresh'
                }
                else {
                    # exit
                    $dvlp_choice = ''
                }
            } while ($dvlp_choice -ne 'kw' -And $dvlp_choice -ne ''-And $dvlp_choice -ne 'refresh')
        }
    } while ($dvlp_choice -ieq 'kw' -or $dvlp_choice -ieq 'refresh')
    
    
    Write-Host "`r`nGoodbye!`r`n"
}

pull_dvlp_envs
if (!([string]::IsNullOrEmpty($args[0])) -or $PSCommandPath -eq "$env:USERPROFILE\dvlp.ps1") {
    # echo 'installing everything and setting envs ..'
    set_dvlp_envs
    install_everything $args[0]
} elseif ($global:devel_tools -ne "sourced"){
    # echo 'devel_tools not yet sourced'
    if ((Test-Path -Path "$env:KINDTEK_WIN_GIT_PATH/.github-installed" -PathType Leaf)) {
        # echo 'now sourcing devel_tools ...'
        . $env:KINDTEK_DEVEL_TOOLS
    }
}
else {
    # echo 'not installing anything ...'
    # echo 'devel_tools already sourced'
}
