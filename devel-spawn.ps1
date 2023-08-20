# set regular console colors
[console]::backgroundcolor = "Black"
[console]::foregroundcolor = "White"

# set special colors

$p = $host.privatedata

$p.ErrorForegroundColor    = "DarkGray"
$p.ErrorBackgroundColor    = "Black"
$p.WarningForegroundColor  = "White"
$p.WarningBackgroundColor  = "Black"
$p.DebugForegroundColor    = "DarkGray"
$p.DebugBackgroundColor    = "Black"
$p.VerboseForegroundColor  = "Gray"
$p.VerboseBackgroundColor  = "Black"
$p.ProgressForegroundColor = "Red"
$p.ProgressBackgroundColor = "White"

# clear screen
if ($global:screen_cleared -ne $true){
  clear-host
}
$global:screen_cleared = $true


$global:devel_spawn = 'sourced'


# # # # # # # # # # # # # # functions # # # # # # # # # # # # # # # # # # 

function include_devel_tools {
    if (($global:devel_tools -ne 'sourced')) {
      # write-host "dot sourcing $env:KINDTEK_DEVEL_TOOLS"
      . $env:KINDTEK_DEVEL_TOOLS
    } 
}
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
    if ([string]::IsNullOrEmpty($this.proc_nowin)) {
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
    }
    else {
      # write-host "start process powershell -nonewwindow -argument list $proc_cmd"
      $this.proc_wait = ''
      $this.proc_noexit = ''
    }
    if (!([String]::IsNullOrEmpty($proc_cmd))) {
      # echo testing path $env:KINDTEK_DEVEL_TOOLS
      if (Test-Path -Path "$env:KINDTEK_DEVEL_TOOLS" -PathType Leaf) {
        # write-host "dvl-tools: $proc_cmd"
        if ($(get_dvlp_debug_mode) -eq $true) {
          $this.proc_cmd = ". $env:KINDTEK_DEVEL_TOOLS;write-host '$proc_cmd';Set-PSDebug -Trace 2;$proc_cmd;"
        }
        else {
          $this.proc_cmd = ". $env:KINDTEK_DEVEL_TOOLS;$proc_cmd"
        }
        # write-host 'dot sourcing devel tools'
        # echo path $env:KINDTEK_DEVEL_TOOLS exists
      }
      elseif ((Test-Path -Path "$env:KINDTEK_DEVEL_SPAWN" -PathType Leaf) -and ($PSCommandPath -ne "$env:USERPROFILE/dvlp.ps1") -and ($PSCommandPath -ne "$env:KINDTEK_DEVEL_SPAWN")) {
        # echo path $env:KINDTEK_DEVEL_TOOLS does not exist
        # write-host "dvl-spawn: $proc_cmd"
        if ($(get_dvlp_debug_mode) -eq $true) {
          $this.proc_cmd = "write-host '$proc_cmd';Set-PSDebug -Trace 2;$proc_cmd;"
        }
        else {
          $this.proc_cmd = "$proc_cmd"
        }
      }
      elseif ((Test-Path -Path "$env:USERPROFILE/dvlp.ps1" -PathType Leaf) -and ($PSCommandPath -ne "$env:USERPROFILE/dvlp.ps1") -and ($PSCommandPath -ne "$env:KINDTEK_DEVEL_SPAWN")) {
        # write-host "dvlp: $proc_cmd"
        if ($(get_dvlp_debug_mode) -eq $true) {
          $this.proc_cmd = "write-host '$proc_cmd';Set-PSDebug -Trace 2;$proc_cmd;"
        }
        else {
          $this.proc_cmd = "$proc_cmd"
        }
      }
      else {
        $this.proc_cmd = "write-host 'could not source files but still continuing ...';Set-PSDebug -Trace 2;$proc_cmd;"
        $this.proc_wait = "wait"
        $this.proc_noexit = '-noexit'
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
    }
    else {
      if (!([string]::IsNullOrEmpty($env:KINDTEK_WIN_DVLW_PATH))) {
        $this.proc_cmd = "$($this.proc_cmd)"
      } 
    }
    if (!([string]::IsNullOrEmpty($this.proc_nowin))) {
      $proc_show = @{
        NoNewWindow = $null
      }    
    }
    elseif ([string]::IsNullOrEmpty($this.proc_style)) {
      $proc_show = @{
        WindowStyle = $($this.proc_style)
      }    
    }
    elseif ([string]::IsNullOrEmpty($this.proc_wait)) {
      $proc_show = @{
        WindowStyle = $($this.proc_style)
      }    
    }
    else {
      $proc_show = @{
        WindowStyle = $($this.proc_style)
        Wait        = $null
      }
    }
        
    try {
      if ([string]::IsNullOrEmpty($this.proc_noexit)) {
        # write-host  "Start-Process -Filepath powershell.exe $proc_show -ArgumentList `"-Command`", `"$($this.proc_cmd)`""
        Start-Process -Filepath powershell.exe -LoadUserProfile -WorkingDirectory $env:USERPROFILE @proc_show -ArgumentList '-Command', $this.proc_cmd
      }
      else {
        # Write-host "Start-Process -Filepath powershell.exe $proc_show -ArgumentList $($this.proc_noexit), '-Command', '$($this.proc_cmd)'"
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

  dvlp_process_hide([string]$proc_cmd) : base($proc_cmd) {
    $this.re_set()
        ([dvlp_process] $this).start()
  }
  dvlp_process_hide([string]$proc_cmd, [string]$proc_wait) : base($proc_cmd, $proc_wait) {
    $this.re_set()
        ([dvlp_process] $this).start()
  }
  dvlp_process_hide([string]$proc_cmd, [string]$proc_wait, [string]$proc_noexit) : base($proc_cmd, $proc_wait, $proc_noexit) {
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

  dvlp_process_popmax([string]$proc_cmd) : base($proc_cmd) {
    $this.re_set()
        ([dvlp_process] $this).start()
  }
  dvlp_process_popmax([string]$proc_cmd, [string]$proc_wait) : base($proc_cmd, $proc_wait) {
    $this.re_set()
        ([dvlp_process] $this).start()
  }
  dvlp_process_popmax([string]$proc_cmd, [string]$proc_wait, [string]$proc_noexit) : base($proc_cmd, $proc_wait, $proc_noexit) {
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
  dvlp_process_embed([string]$proc_cmd, [string]$proc_wait, [string]$proc_noexit) : base($proc_cmd) {
    $this.re_set()
        ([dvlp_process] $this).start()
  }

  dvlp_process_embed([string]$proc_cmd, [string]$proc_wait) : base($proc_cmd) {
    $this.re_set()
        ([dvlp_process] $this).start()
  }

  dvlp_process_embed([string]$proc_cmd) : base($proc_cmd) {
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

  dvlp_process_popmin([string]$proc_cmd) : base($proc_cmd) {
    $this.re_set()
        ([dvlp_process] $this).start()
  }
  dvlp_process_popmin([string]$proc_cmd, [string]$proc_wait) : base($proc_cmd, $proc_wait) {
    $this.re_set()
        ([dvlp_process] $this).start()
  }
  dvlp_process_popmin([string]$proc_cmd, [string]$proc_wait, [string]$proc_noexit) : base($proc_cmd, $proc_wait, $proc_noexit) {
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

  dvlp_process_pop([string]$proc_cmd) : base($proc_cmd) {
    $this.re_set()
        ([dvlp_process] $this).start()
  }
  dvlp_process_pop([string]$proc_cmd, [string]$proc_wait) : base($proc_cmd, $proc_wait) {
    $this.re_set()
        ([dvlp_process] $this).start()
  }
  dvlp_process_pop([string]$proc_cmd, [string]$proc_wait, [string]$proc_noexit) : base($proc_cmd, $proc_wait, $proc_noexit) {
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
    if (([string]::IsNullOrEmpty($set_machine_env_flag)) ) {
      # write-host "getting local $dvlp_env_var"
      return [System.Environment]::GetEnvironmentVariable("$dvlp_env_var")
    }
    else {    
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
      if (([string]::IsNullOrEmpty($set_machine_env_flag)) -And ([string]::IsNullOrEmpty($set_both_env_flag))) {
        # write-host "setting local env $dvlp_env_var to $dvlp_env_val"
        [System.Environment]::SetEnvironmentVariable("$dvlp_env_var", "$dvlp_env_val")
      }
      elseif (!([string]::IsNullOrEmpty($set_machine_env_flag)) -And ($(get_dvlp_env "$dvlp_env_var" "machine") -ne $dvlp_env_val)) {
        # write-host "setting machine env $dvlp_env_var to $dvlp_env_val"
        [System.Environment]::SetEnvironmentVariable("$dvlp_env_var", "$dvlp_env_val", [System.EnvironmentVariableTarget]::Machine)                  
      }
      elseif ((!([string]::IsNullOrEmpty($set_both_env_flag))) -And (($(get_dvlp_env "$dvlp_env_var" "machine") -ne $dvlp_env_val) -Or ($(get_dvlp_env "$dvlp_env_var") -ne $dvlp_env_val))) {
        # write-host "setting local and machine env $dvlp_env_var to $dvlp_env_val"
        [System.Environment]::SetEnvironmentVariable("$dvlp_env_var", "$dvlp_env_val")
        [System.Environment]::SetEnvironmentVariable("$dvlp_env_var", "$dvlp_env_val", [System.EnvironmentVariableTarget]::Machine)                  
      }
      else {
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
  start_dvlp_process "set_dvlp_envs $env:KINDTEK_DEBUG_MODE;exit;"
}


function unset_dvlp_envs {
  param (
    $unset_machine_envs
  )
  if ([string]::IsNullOrEmpty([System.Environment]::GetEnvironmentVariable('KINDTEK_WIN_GIT_OWNER', [System.EnvironmentVariableTarget]::Machine))) {
    $dvlp_owner = 'kindtek'
  }
  else {
    $dvlp_owner = [System.Environment]::GetEnvironmentVariable('KINDTEK_WIN_GIT_OWNER', [System.EnvironmentVariableTarget]::Machine)
  }
  get-childitem env: | where-object name -match "^$([regex]::escape($dvlp_owner)).*$" | foreach-object {
    # write-host "$($_.name)"
  }
  # try {
  #     reload_envs
  # }
  # catch {}
  get-childitem env: | where-object name -match "^$([regex]::escape($dvlp_owner)).*$" | foreach-object {
    echo "deleting local env $($_.name)"
    set_dvlp_env "$($_.name)" "$null"
  }
  if (!([string]::IsNullOrEmpty($unset_machine_envs))) {
    [Environment]::GetEnvironmentVariables('machine').GetEnumerator() | where-object name -match "^$([regex]::escape($dvlp_owner)).*$" | foreach-object {
      echo "deleting machine env $($_.name)"
      set_dvlp_env "$($_.name)" "$null" 'machine'
    }
  }
  get-childitem env: | where-object name -match "^$([regex]::escape($dvlp_owner)).*$" | foreach-object {
    # write-host "$($_.name)"
  }
  # try {
  #     reload_envs
  # }
  # catch {}
}

function pull_dvlp_envs {
  if ([string]::IsNullOrEmpty([System.Environment]::GetEnvironmentVariable('KINDTEK_WIN_GIT_OWNER', [System.EnvironmentVariableTarget]::Machine))) {
    $dvlp_owner = 'kindtek'
  }
  else {
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
  }
  else {
    $dvlp_owner = [System.Environment]::GetEnvironmentVariable('KINDTEK_WIN_GIT_OWNER')
  }
  # echo 'local env'
  # get-childitem env: | where-object name -match "^$([regex]::escape($dvlp_owner)).*$" | foreach-object {
  #     write-host " $($_.name):  $($_.value)"
  # }
  # try {
  #     reload_envs
  # } catch {}
  get-childitem env: | where-object name -match "^$([regex]::escape($dvlp_owner)).*$" | foreach-object {
    # "setting machine $($_.name) to $($_.value)" 
    set_dvlp_env "$($_.name)" "$($_.value)" 'machine'
  }
  # try {
  #         reload_envs
  # } catch {}
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
  if ($env:KINDTEK_WIN_GIT_OWNER -ne "$repo_src_owner" -Or $env:KINDTEK_WIN_GIT_OWNER -ne "$repo_src_owner") {
    write-host "setting global environment variables ..."
    start-sleep 1
  }
  try {
    if ([string]::IsNullOrEmpty($DEBUG_MODE) -Or $DEBUG_MODE -eq '0' -Or $DEBUG_MODE -eq 0) {
      Set-PSDebug -Trace 0;
      set_dvlp_env 'KINDTEK_DEBUG_MODE' '0' 'machine' 'both'
      $this_proc_style = [System.Diagnostics.ProcessWindowStyle]::Hidden;
      set_dvlp_env 'KINDTEK_NEW_PROC_STYLE' "$this_proc_style" 'machine' 'both'
      set_dvlp_env 'KINDTEK_NEW_PROC_NOEXIT' " " 'machine' 'both'
    }
    elseif (!([string]::IsNullOrEmpty($DEBUG_MODE)) -Or $DEBUG_MODE -ne '0' -Or $DEBUG_MODE -eq 0) {
      Set-PSDebug -Trace 2;
      set_dvlp_env 'KINDTEK_DEBUG_MODE' '1' 'machine' 'both'
      $this_proc_style = [System.Diagnostics.ProcessWindowStyle]::Normal;
      set_dvlp_env 'KINDTEK_NEW_PROC_STYLE' "$this_proc_style" 'machine' 'both'
      set_dvlp_env 'KINDTEK_NEW_PROC_NOEXIT' "-noexit" 'machine' 'both'
      write-host "debug = true"
    }
    if ($DEBUG_MODE -ne '0' -And $DEBUG_MODE -ne 0 -And !([string]::IsNullOrEmpty($DEBUG_MODE))) {        
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
  set_dvlp_env 'WSL_UTF8' '1' 'machine'


  try {
    $local_paths = get_dvlp_env 'path'
    $machine_paths = get_dvlp_env 'path' 'machine'
    $local_ext = get_dvlp_env 'pathext'
    $machine_ext = get_dvlp_env 'pathext' 'machine'
              
    if ($local_ext -split ";" -notcontains ".ps1") {
      set_dvlp_env "pathext" "$(get_dvlp_env 'pathext');.ps1"
    }
    if ($machine_ext -split ";" -notcontains ".ps1") {
      set_dvlp_env "pathext" "$(get_dvlp_env 'pathext' 'machine');.ps1" "machine" 
    }
    if ($local_paths -split ";" -notcontains "$env:KINDTEK_DEVEL_SPAWN" -Or $local_paths -split ";" -notcontains "$env:KINDTEK_DEVEL_TOOLS" -Or $local_paths -split ";" -notcontains "$env:KINDTEK_WIN_DVLW_PATH/scripts/" -Or $local_paths -split ";" -notcontains "$env:KINDTEK_WIN_DVLP_PATH/scripts/") {
      set_dvlp_env "path" "$(get_dvlp_env 'path');$env:KINDTEK_DEVEL_TOOLS;$env:KINDTEK_DEVEL_SPAWN;$env:KINDTEK_WIN_DVLW_PATH/scripts/;$env:KINDTEK_WIN_DVLP_PATH/scripts/;$env:USERPROFILE\dvlp.ps1"
    }
    if ($machine_paths -split ";" -notcontains "$env:KINDTEK_DEVEL_SPAWN" -Or $machine_paths -split ";" -notcontains "$env:KINDTEK_DEVEL_TOOLS" -Or $machine_paths -split ";" -notcontains "$env:KINDTEK_WIN_DVLW_PATH/scripts/" -Or $machine_paths -split ";" -notcontains "$env:KINDTEK_WIN_DVLP_PATH/scripts/") {
      set_dvlp_env "path" "$(get_dvlp_env 'path' 'machine');$env:KINDTEK_DEVEL_TOOLS;$env:KINDTEK_DEVEL_SPAWN;$env:KINDTEK_WIN_DVLW_PATH/scripts/;$env:KINDTEK_WIN_DVLP_PATH/scripts/;$env:USERPROFILE\dvlp.ps1" "machine"
    }

  }
  catch {}

}

function test_wsl_distro {
  param (
    $distro_name
  )
  if ([string]::IsNullOrEmpty($distro_name)) {
    return $false
  }
  wsl.exe --distribution "$distro_name".trim() --exec echo $test_string | out-null
  if ($?) {
    # Write-Host "testing wsl distro $distro_name"
    $test_string = 'helloworld'
    $test = wsl.exe --distribution "$distro_name".trim() --exec echo $test_string
    if ($test -eq $test_string) {
      # Write-Host "$distro_name is valid distro"
      return $true
    }
    else {
      # Write-Host "$distro_name is INVALID distro"
      return $false
    }
  }
  else {
    return $false
  }
}

function test_default_wsl_distro {
  param (
    $distro_name
  )
  Write-Host "preparing to test wsl default distro $distro_name"
  . include_devel_tools
  if ( $(test_wsl_distro $distro_name)) {
    Write-Host "testing wsl default distro $distro_name"
    if ($(get_default_wsl_distro) -eq $distro_name -And $(require_docker_desktop_online)) {
      # Write-Host "$distro_name is valid default distro"
      return $true
    }
    else {
      # Write-Host "$distro_name is INVALID default distro"
    }
  }

  return $false
}

function get_default_wsl_distro {
  $default_wsl_distro = wsl.exe --list | where-object { 
        ($_ -ne 'Windows Subsystem for Linux Distributions:') -and ($_ -ne "docker-desktop") -and ($_ -ne "docker-desktop-data") -and ($_ -ne "$env:KINDTEK_FAILSAFE_WSL_DISTRO") -and ($_ -ne '') -And $_ -match '(.*)\(' 
  }
  $default_wsl_distro = $default_wsl_distro -replace '^(.*)\s.*$', '$1'
  $default_wsl_distro = $default_wsl_distro -replace "[^a-zA-Z0-9_-]", ''
  return $("$default_wsl_distro".trim())
}

function revert_default_wsl_distro {
  try {
    wsl.exe --set-default "$env:KINDTEK_FAILSAFE_WSL_DISTRO".trim()
  }
  catch {
    try {
      docker_devel_spawn "default"
    }
    catch {
      Write-Host "error reverting to $env:KINDTEK_FAILSAFE_WSL_DISTRO as default wsl distro"
      return $false
    }
  }
  if ( $(test_default_wsl_distro $env:KINDTEK_FAILSAFE_WSL_DISTRO) ) {
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
  if ([string]::IsNullOrEmpty($new_wsl_default_distro)) {
    if (!([string]::IsNullOrEmpty($env:KINDTEK_FAILSAFE_WSL_DISTRO))) {
      $new_wsl_default_distro = $env:KINDTEK_FAILSAFE_WSL_DISTRO
    }
    else {
      return $false
    }
  }
  try {
    $old_wsl_default_distro = get_default_wsl_distro
    try {
      wsl.exe --set-default "$($new_wsl_default_distro)".trim()
      write-host $wsl_output
      $new_wsl_default_distro = get_default_wsl_distro
    }
    catch {
      Write-Host "error changing wsl default distro from $old_wsl_default_distro to $new_wsl_default_distro"
      $new_wsl_default_distro = $env:KINDTEK_FAILSAFE_WSL_DISTRO
      Write-Host "restoring default distro as $old_wsl_default_distro"
      wsl.exe --set-default "$old_wsl_default_distro".trim()
      cmd.exe /c net stop LxssManager
      cmd.exe /c net start LxssManager
      $new_wsl_default_distro = $old_wsl_default_distro
    }
    set_dvlp_env 'KINDTEK_DEFAULT_WSL_DISTRO' $new_wsl_default_distro
    set_dvlp_env 'KINDTEK_OLD_DEFAULT_WSL_DISTRO' $old_wsl_default_distro
    push_dvlp_envs
    # handle failed installations
    if ( $(test_default_wsl_distro $new_wsl_default_distro) -eq $false ) {
      # Write-Host "ERROR: docker desktop failed to start with $new_wsl_default_distro as default"
      # start-sleep -Milliseconds 600
      # Write-Host "reverting to $env:KINDTEK_FAILSAFE_WSL_DISTRO as default wsl distro ..."
      # try {
      #     wsl.exe --set-default "$env:KINDTEK_FAILSAFE_WSL_DISTRO".trim()
      # }
      # catch {
      #     try {
      #         docker_devel_spawn "default"
      #     }
      #     catch {
      #         Write-Host "error setting $env:KINDTEK_FAILSAFE_WSL_DISTRO as default wsl distro"
      #     }
      # }
      # # restart_wsl_docker
      # restart_wsl_docker_new_win
      # require_docker_desktop_online_new_win
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
  try {
    if (!(Test-Path -Path "$env:KINDTEK_WIN_GIT_PATH/.winget-installed" -PathType Leaf)) {
      $file = "$env:KINDTEK_WIN_GIT_PATH/get-latest-winget.ps1"
      Write-Host "Installing $software_name ..." -ForegroundColor DarkCyan
      $network_connected = $false
      $network_err_msg = "`r`ncannot connect to github. retrying .."
      while ($network_connected -eq $false) {
        try {
          if (!(Test-Path $file)) {
            # use cache
            Invoke-RestMethod "https://raw.githubusercontent.com/kindtek/dvl-adv/dvl-works/get-latest-winget.ps1" -OutFile $file;
          }
          # not necessarily connected but if cache is used its good enough
          $network_connected = $true
        }
        catch {
          write-host -NoNewline "$network_err_msg"
          $network_err_msg = "."
        }
      }
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
  catch { write-host 'error installing winget'; exit }
}

function install_git {
  try {
    $software_name = "Github CLI"
    if (!(Test-Path -Path "$env:KINDTEK_WIN_GIT_PATH/.github-installed" -PathType Leaf)) {
      Write-Host "Installing $software_name ..." -ForegroundColor DarkCyan
      start_dvlp_process_popmax "winget install --exact --id GitHub.cli --silent --locale en-US --accept-package-agreements --accept-source-agreements;winget upgrade --exact --id GitHub.cli --silent --locale en-US --accept-package-agreements --accept-source-agreements;winget install --id Git.Git --source winget --silent --locale en-US --accept-package-agreements --accept-source-agreements;winget upgrade --id Git.Git --source winget --silent --locale en-US --accept-package-agreements --accept-source-agreements;exit;" 'wait'
      Write-Host "$software_name installed" -ForegroundColor DarkCyan | Out-File -FilePath "$env:KINDTEK_WIN_GIT_PATH/.github-installed"; `
        
    }
    else {
      Write-Host "$software_name already installed" -ForegroundColor DarkCyan
    }
    # allow git to be used in same window immediately after installation
        ([void]( New-Item -path alias:git -Value 'C:\Program Files\Git\bin\git.exe' -ErrorAction SilentlyContinue | Out-Null ))
    reload_envs
    # Start-Process powershell -LoadUserProfile $env:KINDTEK_NEW_PROC_STYLE -ArgumentList [string]$env:KINDTEK_NEW_PROC_NOEXIT "-Command &{sync_repos;exit;}" -Wait
    git config --global core.autocrlf input
    return
  }
  catch { write-host 'error installing github and repos'; exit }
}

function uninstall_git {
  Write-Host "please wait while git is uninstalled"
  start-sleep -Milliseconds 600
  # docker builder prune -af 
  # docker system prune -af --volumes 
  Start-Process powershell.exe -Wait -Argumentlist '-Command', 'write-host "uninstalling git... ";winget uninstall --id=Git.Git;winget uninstall --id=Git.Git;' | Out-Null 
  Remove-Item "$env:USERPROFILE/repos/kindtek/.git-installed" -Confirm:$false -Force -ErrorAction SilentlyContinue
}

# TODO: refactor/modularize git functions
function clone_repos {
  param (
    [bool]$quiet
  )

  Push-Location $env:KINDTEK_WIN_GIT_PATH
  if ($quiet -eq $false) {
    write-host "cloning $env:KINDTEK_WIN_DVLW_NAME ..." -ForegroundColor DarkCyan
  }
  $clone_result = git clone "https://github.com/$env:KINDTEK_WIN_GIT_OWNER/$env:KINDTEK_WIN_DVLW_FULLNAME" --branch $env:KINDTEK_WIN_DVLW_BRANCH --progress -- $env:KINDTEK_WIN_DVLW_NAME
  if ($quiet -eq $false) {
    write-host "$env:KINDTEK_WIN_DVLW_NAME cloned" -ForegroundColor DarkCyan
  }
  Pop-Location
  return $clone_result
}

function pull_repos {
  param (
    [bool]$quiet
  )
  Push-Location $env:KINDTEK_WIN_GIT_PATH
  if ($quiet -eq $false) {
    write-host "pulling $env:KINDTEK_WIN_DVLW_NAME ..." -ForegroundColor DarkCyan
  }
  $clone_result = git -C $env:KINDTEK_WIN_DVLW_NAME pull --progress
  if ($quiet -eq $false) {
    write-host "$env:KINDTEK_WIN_DVLW_NAME pulled" -ForegroundColor DarkCyan
  }
  Pop-Location
  return $clone_result
}

function quick_sync_repos_new_win {
  param (
    [bool]$wait
  )
  if ($wait -eq $true){
    $wait = 'wait'
  }
  start_dvlp_process_popmin "quick_sync_repos;exit" "$wait" ''
}

function quick_sync_repo {
  param (
    [bool]$quiet
  )
  if ((Test-Path -Path "$($env:KINDTEK_WIN_DVLW_PATH)/.git")) {
    if ($quiet -eq $false) {
      write-host "path $($env:KINDTEK_WIN_DVLW_PATH)/.git found" 
    }
    Push-Location $env:KINDTEK_WIN_DVLW_PATH
    Pop-Location
    return pull_repos
  }
  else {
    if ($quiet -eq $false) {
      write-host "path $($env:KINDTEK_WIN_DVLW_PATH)/.git NOT found" 
    }
    return clone_repos
  }
}

function sync_repos_new_win {
  param (
    [bool]$wait
  )
  if ($wait -eq $true){
    $wait = 'wait'
  }
  start_dvlp_process_popmin "sync_repos;exit" "$wait" ''
}

function sync_repos {
  Write-Host "testing git command ..." -ForegroundColor DarkCyan
    ([void]( New-Item -path alias:git -Value 'C:\Program Files\Git\bin\git.exe' -ErrorAction SilentlyContinue | Out-Null ))
  try {
    git --version | out-null
    if (!($?)) {
      install_winget
      install_git
    }
    Write-Host "synchronizing kindtek github repos ..." -ForegroundColor DarkCyan
    New-Item -ItemType Directory -Force -Path $env:KINDTEK_WIN_GIT_PATH | Out-Null
    echo "entering path $($env:KINDTEK_WIN_GIT_PATH)"
    Push-Location $env:KINDTEK_WIN_GIT_PATH
    Write-Host "synchronizing $env:KINDTEK_WIN_GIT_PATH/$env:KINDTEK_WIN_DVLW_NAME with https://github.com/$env:KINDTEK_WIN_GIT_OWNER/$env:KINDTEK_WIN_DVLW_FULLNAME repo ..." -ForegroundColor DarkCyan
    write-host "testing path $($env:KINDTEK_WIN_DVLW_PATH)/.git" 
    quick_sync_repos
    try {
      write-host "entering path $($env:KINDTEK_WIN_DVLW_PATH)"
      Push-Location $env:KINDTEK_WIN_DVLW_PATH
    }
    catch {
      clone_repos
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
    Copy-Item $env:KINDTEK_WIN_POWERHELL_PATH/devel-spawn.ps1 $env:USERPROFILE/dvlp.ps1
    
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
  }
  catch {
    install_winget
    install_git
    sync_repos
  }
    
  Pop-Location
  Pop-Location
  Pop-Location
  Copy-Item $env:KINDTEK_WIN_POWERHELL_PATH/devel-spawn.ps1 $env:USERPROFILE/dvlp.ps1
}

function get_local_commit {
  $git_commit = 0
  try {
    if (Test-Path $env:KINDTEK_WIN_DVLW_PATH) {
      Push-Location $env:KINDTEK_WIN_DVLW_PATH
      $git_commit = $(git rev-parse HEAD)
      Pop-Location
    } 
  }
  catch {}

  return $git_commit
}

function get_remote_commit {
  $remote_commit_raw = $(git ls-remote https://github.com/kindtek/devels-workshop HEAD)
  $remote_commit = $remote_commit_raw -creplace "[^a-z0-9]" , ''
  return $remote_commit
}

function get_latest_commit {
  if ($(update_found_local)){
    # we have an update  
    if($(get_local_commit) -ne $(get_remote_commit)){
      # try sync to get latest commit available since local head might be ahead of remote head
      quick_sync_repos $true
  } else{
      # local head is current with remote - no need to sync
    } 
  } elseif ($(update_found_remote)) {
    # sync to get latest commit from local
    quick_sync_repos $true

  } 
    
  return $(get_local_commit)
  
  
}
function update_found_local {
  $local_commit = $(get_local_commit)
  if ($global:dvlw_commit -ne $local_commit) {
    return $true
  } else {
    return $false
  }
}

function update_found_remote {
  $remote_commit = $(get_remote_commit)
  if ($global:dvlw_commit -ne $remote_commit) {
    return $true
  } else {
    return $false
  }
}

function update_found {
  if($(get_latest_commit) -ne $global:dvlw_commit){
    return $true
  } else {
    return $false
  }
}

function reload_dvlp {
  write-host "reloading $($env:USERPROFILE)\dvlp.ps1`r`n"
  # powershell.exe -Command "$($env:USERPROFILE)\dvlp.ps1 '$($global:dvlp_arg0)' 'skip'"
  $global:devel_spawn = $false
  . include_devel_tools
  # start-process -filepath powershell.exe -Verb RunAs -ArgumentList '-Command', "$($env:USERPROFILE)\dvlp.ps1 '$($global:dvlp_arg0)' 'skip'"           
}

function update_dvlp {
  if (($(update_found) -eq $true)) {
    $global:dvlw_commit = $(get_latest_commit)
    $global:update_dvlw = $true
    sync_repos_new_win $true
    reload_dvlp           
  }
}
function require_devel_online {
  do {
    try {
      $docker_online = require_docker_desktop_online
    }
    catch {
      . include_devel_tools
      safe_boot_devel
      $docker_online = require_docker_desktop_online
    }
  } while ($docker_online -eq $false)
}
function docker_devel_spawn {
  param (
    $img_name_tag, $non_interactive, $default_distro
  )
  Write-Host "`r`nIMPORTANT: keep docker desktop running or the import will fail`r`n" 
  . include_devel_tools
  start_docker_desktop | out-null

  if ($(is_docker_desktop_online) -eq $true) {
    if ([string]::IsNullOrEmpty($img_name_tag)) {
      powershell.exe -Command "$env:KINDTEK_WIN_DVLP_PATH/scripts/wsl-docker-import.cmd"
    }
    elseif ($img_name_tag -eq "skip") {
      powershell.exe -Command "$env:KINDTEK_WIN_DVLP_PATH/scripts/wsl-docker-import.cmd"
    }
    else {
      powershell.exe -Command "$env:KINDTEK_WIN_DVLP_PATH/scripts/wsl-docker-import.cmd '$img_name_tag' '$non_interactive' '$default_distro'" 
    }
  }
  else {
    Write-Host "`r`docker desktop is not starting automatically"
    $start_docker = Read-Host "press ENTER to keep trying normally
    ... or enter 'force' to force docker to start"
    if ($start_docker -eq "force") {
      if ([string]::IsNullOrEmpty($img_name_tag)) {
        powershell.exe -Command "$env:KINDTEK_WIN_DVLP_PATH/scripts/wsl-docker-import.cmd"
      }
      elseif ($img_name_tag -eq "skip") {
        powershell.exe -Command "$env:KINDTEK_WIN_DVLP_PATH/scripts/wsl-docker-import.cmd"
      }
      else {
        powershell.exe -Command "$env:KINDTEK_WIN_DVLP_PATH/scripts/wsl-docker-import.cmd '$img_name_tag' '$non_interactive' '$default_distro'" 
      }
    }
  }
}

function run_dvlp_latest_kernel_installer {
  param (
    $distro
  )
  push-location $env:KINDTEK_WIN_DVLP_PATH/kernels/linux/kache
  require_docker_desktop_online_new_win
  if ($(is_docker_desktop_online) -eq $true) {
    ./wsl-kernel-install.ps1 latest latest $distro
    restart_wsl_docker | Out-Null
  }    
  pop-location
}

function get_dvlp_auto_boot {
  if ($(get_dvlp_env 'KINDTEK_AUTO_BOOT') -eq '1') {
    return $true
  }
  else {
    return $false
  }
}
function set_dvlp_auto_boot {
  param (
    [bool]$auto_boot
  )
  if ($auto_boot) {
    set_dvlp_env 'KINDTEK_AUTO_BOOT' '1' 'machine'
    set_dvlp_env 'KINDTEK_AUTO_BOOT' '1' 
    New-Item -Path "$env:AppData\Microsoft\Windows\Start Menu\Programs\Startup\dvlp-spawn.cmd" -Value "
        # PowerShell -Command `"Set-ExecutionPolicy Unrestricted`" >> `"$env:TEMP\spawnlogs.txt`" 2>&1
        start wt -p windows cmd.exe /c echo 'please confirm administrator access to launch wsl devel' & powershell.exe start-process -filepath powershell.exe -Verb RunAs -WindowStyle Maximized -ArgumentList '-Command', '$($env:USERPROFILE)\dvlp.ps1 `"$($global:dvlp_arg0)`" `"skip`"' >> `"$env:TEMP\spawnlogs.txt`" 2>&1
        # PowerShell -Command `"Set-ExecutionPolicy RemoteSigned`" >> `"$env:TEMP\spawnlogs.txt`" 2>&1
        # cmd /k
        " -Force | Out-Null
  }
  else {
    set_dvlp_env 'KINDTEK_AUTO_BOOT' '0' 'machine'
    set_dvlp_env 'KINDTEK_AUTO_BOOT' '0'
    Remove-Item -Path "$env:AppData\Microsoft\Windows\Start Menu\Programs\Startup\dvlp-spawn.cmd" -Confirm:$false -Force -ErrorAction SilentlyContinue | Out-Null   
  }
}

function safe_boot_devel {
  try {
    Set-PSDebug -Trace 2;
    install_winget $true
    install_git $true    
    sync_repos
    . include_devel_tools
    install_dependencies $true
    start_docker_desktop_new_win

        
    Set-PSDebug -Trace "$env:KINDTEK_DEBUG_MODE"
    return $true
  }
  catch { return $false }
}

function boot_devel {
  $new_windowsfeatures_installed = $false
  try {
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    $host.UI.RawUI.BackgroundColor = "Black"
    $host.UI.RawUI.ForegroundColor = "DarkGray"
    Write-Host "`r`n`r`nThese programs will be installed or updated:" -ForegroundColor Magenta
    Start-Sleep 1
    Write-Host "`r`n`t- WinGet`r`n`t- Github CLI`r`n`t- devels-workshop repo`r`n`t- devels-playground repo" -ForegroundColor Magenta
        
    # Write-Host "Creating path $env:USERPROFILE\repos\kindtek if it does not exist ... "  
    New-Item -ItemType Directory -Force -Path $env:KINDTEK_WIN_GIT_PATH | Out-Null
    install_winget
    install_git
    update_dvlp
    if ($global:update_dvlw){
      return $true
    }
    # log default distro
    $env:KINDTEK_OLD_DEFAULT_WSL_DISTRO = get_default_wsl_distro
    # jump to bottom line without clearing scrollback
    # Write-Host "$([char]27)[2J" 
    if (Test-Path -Path "$env:KINDTEK_WIN_GIT_PATH/.windowsfeatures-installed" -PathType Leaf) {
      $windowsfeatures_installed = $true
    }
    else {
      $windowsfeatures_installed = $false
    }
    try {
      . include_devel_tools
      install_windows_features 'skip reboot prompt'
      Write-Host "Windows features are installed" -ForegroundColor DarkCyan | Out-File -FilePath "$env:KINDTEK_WIN_GIT_PATH/.windowsfeatures-installed"
      if ($windowsfeatures_installed -eq $false) {
        $new_windowsfeatures_installed = $true
        wsl.exe --distribution kali-linux --status | Out-Null
        if (!($?)) {
          reboot_prompt 'reboot continue'
          exit
        }
      }
    }
    catch { throw "problems with installing windows features" }
    install_recommends
    $new_dependencies_installed = $(install_dependencies) 
    if ($($new_windowsfeatures_installed) -eq $true -or $($new_dependencies_installed) -eq $true) {
      Write-Host -NoNewline "`r`n`r`n" -ForegroundColor White -BackgroundColor Black
      if (!([string]::isnullorempty($global:dvlp_arg0))) {
        Write-Host "please wait for installation process(es) to complete "
        while ($(dependencies_installed) -eq $false) {
          Write-Host ""
          for ($i = 0; $i -le 15; $i++) {
            Write-Host -NoNewline "." -ForegroundColor White -BackgroundColor Black
            Start-Sleep 1
          }                
        }

        start_dvlp_process_popmin "start_docker_desktop | Out-Null;exit;"
        $docker_tries = 0
        wsl.exe --distribution docker-desktop --version | out-null
        if (!$($?)) {
          Write-Host "confirm the license agreements and other prompts in the docker desktop app" -ForegroundColor Yellow
        }
        else {
          Write-Host "waiting for docker desktop to come online"
        }
        while (($docker_tries -lt 5) -and !$($?)) {
          start_dvlp_process_popmin "start_docker_desktop;exit;" 'wait'
          start-sleep 15
          $docker_tries += 1
          wsl.exe --distribution docker-desktop --version | out-null
        }
        start_docker_desktop | out-null
        if (!($(is_docker_desktop_online))) {    
          if ($new_windowsfeatures_installed -or $new_dependencies_installed ) {
            if ($new_windowsfeatures_installed) {
              Write-Host "
                            
                windows features and software installations complete! 
                restart(s) may be needed to start docker devel`r`n`r`n" -ForegroundColor Magenta -BackgroundColor Yellow
            }
            elseif ($new_dependencies_installed ) {
              Write-Host "
                software installations complete! 
                restart(s) may be needed to start docker devel`r`n`r`n" -ForegroundColor Magenta -BackgroundColor Yellow
            }
            elseif ($new_dependencies_installed ) {
              Write-Host "
                software installations complete! 
                restart(s) may be needed to start docker devel`r`n`r`n" -ForegroundColor Magenta -BackgroundColor Yellow
            }
            reboot_prompt
          }
        }
      }
      else {
        $continue_install = ''
        if (($(dependencies_installed) -eq $false)) {
          $continue_install = Read-Host "press ENTER to continue to wait for installations to complete
                    ...or enter 'skip' (not recommended)"
        }
        else {
          $continue_install = "continue"
        }
        Write-Host "please wait for installation process(es) to complete "
        while (($docker_tries -lt 5) -and !$($?)) {
          for ($i = 0; $i -le 15; $i++) {
            Write-Host ""
            Write-Host -NoNewline "." -ForegroundColor White -BackgroundColor Black
            Start-Sleep 1
          }                
        }
        start_dvlp_process_popmin "start_docker_desktop | Out-Null;exit;"
        $docker_tries = 0
        wsl.exe --distribution docker-desktop --version | out-null
        if (!$($?)) {
          Write-Host "confirm the license agreements and other prompts in the docker desktop app" -ForegroundColor Yellow
        }
        else {
          Write-Host "waiting for docker desktop to come online"
        }
        while (!$($?) -and $docker_tries -lt 5) {
          start_dvlp_process_popmin "start_docker_desktop;exit;" 'wait'
          start-sleep 15
          $docker_tries += 1
          wsl.exe --distribution docker-desktop --version | out-null
        }
        start_docker_desktop | out-null
        if ($continue_install -ieq '' -or $(dependencies_installed) -eq $false -or (!(is_docker_desktop_online))) {
          if ($new_windowsfeatures_installed -or $new_dependencies_installed ) {
            if ($new_windowsfeatures_installed) {
              Write-Host "
                                
                    windows features and software installations complete! 
                    restart(s) may be needed to start docker devel`r`n`r`n" -ForegroundColor Magenta -BackgroundColor Yellow
            }
            elseif ($new_dependencies_installed ) {
              Write-Host "
                    software installations complete! 
                    restart(s) may be needed to start docker devel`r`n`r`n" -ForegroundColor Magenta -BackgroundColor Yellow
            }
            elseif ($new_dependencies_installed ) {
              Write-Host "
                    software installations complete! 
                    restart(s) may be needed to start docker devel`r`n`r`n" -ForegroundColor Magenta -BackgroundColor Yellow
            }
            reboot_prompt
          }
        }
                
      }
            
    }
    else {
      Write-Host "
            success!
            windows features and software are installed
            " -ForegroundColor Magenta -BackgroundColor Yellow
      write-host `r`n`r`n
    }
        
    return $true
  }
  catch { return $false }
}

function devel_daemon {
  param (
    $keep_running
  )
  [int]$boot_devel_loop_count = 0
  [int]$boot_devel_loop_max = 10
  do {
    $boot_devel_loop_count += 1 
    try {  
      return boot_devel
    }
    catch { 
      try {
        # try pulling envs first
        pull_dvlp_envs
        return boot_devel
      }
      catch { 
        # try setting envs first then do bare minimum
        set_dvlp_envs $env:KINDTEK_DEBUG_MODE
        return safe_boot_devel
      }
      reboot_prompt
            
      return $false 
    }

    return $true

  } while ($boot_devel_loop_count -lt $boot_devel_loop_max -And $(boot_devel) -eq $false)

  if ($keep_running) {
    # daemon initialized ... now check periodically for problems
    start_dvlp_process_popmin "
      while (`$true){
        if (`$(dependencies_installed) -eq `$false){
            # try setting envs first then do bare minimum
            pull_dvlp_envs $env:KINDTEK_DEBUG_MODE;
            safe_boot_devel;
        }
        if (updates_found_local){
          update_dvlp;
          start-sleep 60;
        } elseif (updates_found){
          update_dvlp
        }
        sync_repos;
        require_docker_desktop_online;
      start-sleep 60;
    }
    " '' 'noexit'
  }
    
  return $true
    
}

function wsl_devel_spawn {  
  param (
    $img_name_tag
  )
  $dvlp_input = 'screen'
  do {
    $host.UI.RawUI.ForegroundColor = "White"
    $host.UI.RawUI.BackgroundColor = "Black"

    $confirmation = ''    
    if (($dvlp_input -ine 'daemon') -And (!(Test-Path -Path "$env:KINDTEK_WIN_GIT_PATH/.dvlp-installed" -PathType Leaf)) -And ([string]::IsNullOrEmpty($global:dvlp_arg1))) {  
      try {
        if (!($(dependencies_installed))) {
          $host.UI.RawUI.ForegroundColor = "Red"
          $host.UI.RawUI.BackgroundColor = "White"
        }
      }
      catch {
        $host.UI.RawUI.ForegroundColor = "Red"
        $host.UI.RawUI.BackgroundColor = "White"
      }

      Write-Host "$([char]27)[2J"
      # $confirmation = Read-Host "`r`nRestarts may be required as new applications are installed. Save your work now.`r`n`r`n`tHit ENTER to continue`r`n`r`n`tpowershell.exe -Command $file $args" 
      Write-Host "`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n"
      $confirmation = Read-Host "Restarts may be required as new applications are installed. Save your work now.`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`tHit ENTER to continue`r`n"
      Write-Host "$([char]27)[2J"
      Write-Host "`r`n`r`n`r`n`r`n`r`n`r`nRestarts may be required as new applications are installed. Save your work now.`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`t"
    
    }
    else {
      if (($dvlp_input -eq 'screen') -and ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
        Write-Host "`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n"
        write-host "`r`n`r`n`r`n --------------------------------------------------------------------------"
        write-host -nonewline "
            \________
                W    \\ O C K E R" -ForegroundColor DarkRed
      }
      if (![string]::isnullorempty($global:dvlp_arg1) -and ($confirmation -ne "skip") -and ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
        write-host -nonewline "
         <------S----+++=======================|======|
             ___L____// E V E L
            /  " -ForegroundColor DarkRed
        write-host "`r`n`r`n --------------------------------------------------------------------------`r`n`r`n"
        # no need for this variable anymore - leaving will only make display look weird
      }
    }
    if ($confirmation -eq '' -or $confirmation -eq 'skip') {
      # source of the below self-elevating script: https://blog.expta.com/2017/03/how-to-self-elevate-powershell-script.html#:~:text=If%20User%20Account%20Control%20(UAC,select%20%22Run%20with%20PowerShell%22.
      # Self-elevate the script if required
      if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
        if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
          $command_line = "-NoExit -File `"$($PSCommandPath)`" `"" + $global:dvlp_arg0 + "`" `"skip`" " 
          Write-Host "please confirm admin access in prompt that appears" -ForegroundColor Magenta -BackgroundColor Yellow
          Write-Host "..try using [WIN + x] then [a] to run this program with native admin privileges if you experience loss of copy/paste functionality or display errors" -ForegroundColor Yellow
          Start-Sleep 6
          Start-Process -FilePath PowerShell.exe -Verb Runas -WindowStyle Maximized -ArgumentList "$command_line"
          # Write-Host "
          # Start-Process -FilePath PowerShell.exe -Verb Runas -WindowStyle Maximized -ArgumentList '$command_line'
          # "
          Exit
        }
      }
      # if confirmation is daemon or (img_tag must not empty ... OR dvlp must not installed)
      # if (($confirmation -eq 'daemon') -Or (!(Test-Path -Path "$env:KINDTEK_WIN_GIT_PATH/.dvlp-installed" -PathType Leaf) -Or (!([string]::IsNullOrEmpty($img_name_tag))))) {
      if (($dvlp_input -eq 'daemon') -Or (!(Test-Path -Path "$env:KINDTEK_WIN_GIT_PATH/.dvlp-installed" -PathType Leaf)) -and ($confirmation -ne 'skip')) {
        # write-host "confirmation: $confirmation"
        # write-host "test path $($env:KINDTEK_WIN_GIT_PATH)/.dvlp-installed $((Test-Path -Path "$env:KINDTEK_WIN_DVLW_PATH/.dvlp-installed" -PathType Leaf))"
        if (([string]::IsNullOrEmpty($global:dvlp_arg1))) {
          Write-Host "`t-- use CTRL + C or close this window to cancel anytime --"
          start_countdown "starting " "in 3" "in 2" "in 1" "now"
        }
        # make sure failsafe kalilinux-kali-rolling-latest distro is installed so changes can be easily reverted
        try {
          if ($global:dvlp_safe_mode -eq $true){
            $devel_booted = $(safe_boot_devel)
          } else {
            $devel_booted = $(boot_devel)
          }
          
          if ($devel_booted -eq $false) {
            throw
          }

          if (!(Test-Path -Path "$($env:KINDTEK_WIN_GIT_PATH)/.dvlp-installed" -PathType Leaf)) {
            docker_devel_spawn 'default'
            $dvlp_input = 'screen'
            # cmd.exe /c net stop LxssManager
            # cmd.exe /c net start LxssManager
            # write-host "testing wsl distro $env:KINDTEK_FAILSAFE_WSL_DISTRO"
            if ($(test_default_wsl_distro $env:KINDTEK_FAILSAFE_WSL_DISTRO) -eq $true) {
              # write-host "$env:KINDTEK_FAILSAFE_WSL_DISTRO test passed"
              Write-Host "docker devel installed`r`n" | Out-File -FilePath "$env:KINDTEK_WIN_GIT_PATH/.dvlp-installed"
            }
            else {
              # write-host "$env:KINDTEK_FAILSAFE_WSL_DISTRO test FAILED"
            }
            # install hypervm on next open
            try {
              if (!(Test-Path "$env:KINDTEK_WIN_GIT_PATH/.hypervm-installed" -PathType Leaf)) {
                $profilePath = Join-Path $env:USERPROFILE 'Documents\PowerShell\Microsoft.PowerShell_profile.ps1'
                $vmpPath = Join-Path $env:USERPROFILE 'Documents\PowerShell\kindtek.Set-VMP.ps1'
                New-Item -Path $profilePath -ItemType File -Force | Out-Null
                New-Item -Path $vmpPath -ItemType File -Force | Out-Null
                Add-Content $profilePath ". $vmpPath;Clear-Content $vmpPath;cd $env:USERPROFILE;./dvlp.ps1"
                Add-Content $vmpPath "`nWrite-Host 'Preparing to set up HyperV VM Processor as kali-linux ...';Start-Sleep 10;Set-VMProcessor -VMName kali-linux -ExposeVirtualizationExtensions `$true -ErrorAction SilentlyContinue"        
                Write-Host "hypervm processor installed`r`n" | Out-File -FilePath "$env:KINDTEK_WIN_GIT_PATH/.hypervm-installed"
              }
            }
            catch {
              Write-Host "failed setting up hypervm in user profile"
            }
          }
          if (!([string]::IsNullOrEmpty($img_name_tag)) -and $img_name_tag -ne "skip") {
            $host.UI.RawUI.ForegroundColor = "White"
            $host.UI.RawUI.BackgroundColor = "Black"

            $old_wsl_default_distro = get_default_wsl_distro
            if ($dvlp_input -ieq 'daemon' -And (Test-Path -Path "$env:KINDTEK_WIN_GIT_PATH/.dvlp-installed" -PathType Leaf)) {
              # start_dvlp_process_pop "
              # `$old_wsl_default_distro = '$old_wsl_default_distro';
              # `$(docker_devel_spawn 'kindtek/$($env:KINDTEK_WIN_DVLP_FULLNAME):$img_name_tag' '' 'default');
              # `$new_wsl_default_distro = get_default_wsl_distro;
              # if ((`$new_wsl_default_distro -ne `$old_wsl_default_distro) -And (`$(is_docker_desktop_online) -eq $false)) {
              #     Write-Host 'ERROR: docker desktop failed to start with `$new_wsl_default_distro distro';
              # }
              # if ('$img_name_tag' -like '*kernel' ){
              #     run_dvlp_latest_kernel_installer
              # }
              # " 'wait'
              $dvlp_input = 'screen'
              $old_wsl_default_distro = $old_wsl_default_distro;
              $(docker_devel_spawn "kindtek/$($env:KINDTEK_WIN_DVLP_FULLNAME):$img_name_tag" '' 'default');
              $new_wsl_default_distro = get_default_wsl_distro;
              if (($new_wsl_default_distro -ne $old_wsl_default_distro) -And ($(is_docker_desktop_online) -eq $false)) {
                  Write-Host "ERROR: docker desktop failed to start with `$new_wsl_default_distro distro";
              }              
            }
            else {
              $dvlp_input = 'screen'
              $old_wsl_default_distro = $old_wsl_default_distro;
              $(docker_devel_spawn "kindtek/$($env:KINDTEK_WIN_DVLP_FULLNAME):$img_name_tag" "kindtek-$env:KINDTEK_WIN_DVLP_FULLNAME-$img_name_tag" 'default');
              $new_wsl_default_distro = get_default_wsl_distro;
              if (($new_wsl_default_distro -ne $old_wsl_default_distro) -And ($(is_docker_desktop_online) -eq $false)) {
                  Write-Host "ERROR: docker desktop failed to start with $new_wsl_default_distro distro";
              }
              # start_dvlp_process_pop "
              #               `$old_wsl_default_distro = $old_wsl_default_distro;
              #               `$(docker_devel_spawn 'kindtek/$($env:KINDTEK_WIN_DVLP_FULLNAME):$img_name_tag' 'kindtek-$env:KINDTEK_WIN_DVLP_FULLNAME-$img_name_tag' 'default');
              #               `$new_wsl_default_distro = get_default_wsl_distro;
              #               if ((`$new_wsl_default_distro -ne `$old_wsl_default_distro) -And (`$(is_docker_desktop_online) -eq $false)) {
              #                   Write-Host 'ERROR: docker desktop failed to start with `$new_wsl_default_distro distro';
              #               }
              #               if ('$img_name_tag' -like '*kernel' ){
              #                   run_dvlp_latest_kernel_installer
              #               }
              #               " 'wait'
            }
            if ($img_name_tag -like '*kernel' ){
              run_dvlp_latest_kernel_installer
            }
            if ($img_name_tag -like '*gui*' ){
              $start_gui = Read-Host "start gui?

continue or skip

(continue)
" 
              if ($start_gui -eq "" -or $start_gui -ieq "continue"){
                start_gui $new_default_distro
              }  
            }
          }
          # try {
          #     wsl.exe --set-default "$env:KINDTEK_FAILSAFE_WSL_DISTRO".trim()
          #     require_docker_desktop_online_new_win
          # }
          # catch {
          #     try {
          #         revert_default_wsl_distro
          #         require_docker_desktop_online_new_win
          #     }
          #     catch {
          #         Write-Host "error setting failsafe as default wsl distro"
          #     }
          # }
                    
          if ((Test-Path "$env:USERPROFILE/DockerDesktopInstaller.exe") -or (Test-Path "$env:USERPROFILE/kali-linux.AppxBundle")) {
            Write-Host 'optional: cleaning up downloaded installation files'
            try {
              if (Test-Path "$env:USERPROFILE/DockerDesktopInstaller.exe") {
                # install complete .. try to remove install files
                Remove-Item -Path "$env:USERPROFILE/DockerDesktopInstaller.exe" -Confirm
              }

            }
            catch {}
            try {
              if (Test-Path "$env:USERPROFILE/kali-linux.AppxBundle") {
                # install complete .. try to remove install files
                Remove-Item -Path "$env:USERPROFILE/kali-linux.AppxBundle" -Confirm
              }
            }
            catch {}
          }
        }
        catch {
          Write-Host "initial boot error occurred" -ForegroundColor Magenta -BackgroundColor Yellow
          Write-Host "hit ENTER to reload `r`n`t..or enter any other character to continue"
          if ($(read-host) -eq "") {
            reload_dvlp
          }
        }
        # install distro requested in arg
                
      }
      else {
        if ($dvlp_input -eq 'screen' -and [string]::IsNullOrEmpty(($global:dvlp_arg1)) -and (($confirmation -ne "skip"))) {
          write-host -nonewline "
          <-----S----+++=======================|======|" -ForegroundColor DarkRed
        }
        . include_devel_tools
        if (($dvlp_input -ceq 'noscreen' -or $dvlp_input -ceq 'screen') -And ((Test-Path -Path "$env:KINDTEK_WIN_GIT_PATH/.dvlp-installed" -PathType Leaf))) {
          start_dvlp_process_hide 'sync_repos'
        }
        else {
          update_dvlp
          if ($global:update_dvlw){
            return
          }
        }
      }
      # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # ## # # 
      $wsl_restart_path = "$env:USERPROFILE/wsl-restart.ps1"
      $env:KINDTEK_DEFAULT_WSL_DISTRO = get_default_wsl_distro
      if ($(get_dvlp_env 'KINDTEK_AUTO_BOOT') -eq '1') {
        $auto_boot_status = 'ON'
      }
      else {
        $auto_boot_status = 'OFF'
      }
      do {
        if ((Test-Path -Path "$env:KINDTEK_WIN_GIT_PATH/.dvlp-installed" -PathType Leaf) -And (!([string]::IsNullOrEmpty($img_name_tag))) -And ($img_name_tag -ne 'skip')) {
          $docker_devel_spawn_noninteractive = "`r`n`t- [i!] import $env:KINDTEK_WIN_DVLP_FULLNAME:$img_name_tag as default"
        }
        if ("$env:KINDTEK_OLD_DEFAULT_WSL_DISTRO" -ne "$env:KINDTEK_DEFAULT_WSL_DISTRO" -And !([string]::IsNullOrEmpty($env:KINDTEK_OLD_DEFAULT_WSL_DISTRO)) -And "$env:KINDTEK_OLD_DEFAULT_WSL_DISTRO" -ne "$env:KINDTEK_FAILSAFE_WSL_DISTRO" -And "$(test_wsl_distro $env:KINDTEK_OLD_DEFAULT_WSL_DISTRO)" -eq $true) {
          $wsl_distro_revert_options = "- [r]evert wsl to $env:KINDTEK_OLD_DEFAULT_WSL_DISTRO`r`n`t"
        }
        else {
          $wsl_distro_revert_options = ''
        }
        if ($(get_default_wsl_distro) -ne "$env:KINDTEK_FAILSAFE_WSL_DISTRO") {
          $wsl_distro_revert_options = $wsl_distro_revert_options + "- [revert] wsl to $env:KINDTEK_FAILSAFE_WSL_DISTRO`r`n`t"
        }
        if ($(update_found) -eq $true) {
          $update_found = ' (available)'
        }
        try {
          $wsl_distro_list = get_wsl_distro_list
          if ($dvlp_input -eq 'screen' -and [string]::IsNullOrEmpty(($global:dvlp_arg1))) {
            write-host -nonewline "
             ___L____// E V E L
            /  " -ForegroundColor DarkRed
            write-host "`r`n`r`n --------------------------------------------------------------------------`r`n`r`n"
          }
          display_wsl_distro_list $wsl_distro_list
          $dvlp_options = "`r`n`r`n`r`nEnter a wsl distro number/name, powershell command, docker image (repo/image:tag), or one of the following:`r`n`r`n`t- [i]mport docker image into wsl${docker_devel_spawn_noninteractive}`r`n`t- [t]erminal`r`n`t- [c]ustomize`r`n`t- [update]$update_found`r`n`t- [screen]`r`n`t- [restart] wsl/docker`r`n`t${wsl_distro_revert_options}- [reboot] computer`r`n`t- [auto] boot is $auto_boot_status`r`n`r`n`r`n"
        }
        catch {
          try {
            . include_devel_tools
            $wsl_distro_list = get_wsl_distro_list
            if ($global:dvlp_safe_mode -eq $true) {
              write-host -nonewline "
             ___L____// E V E L (safe mode)
            /  " -ForegroundColor DarkRed
              write-host "`r`n`r`n --------------------------------------------------------------------------`r`n`r`n"
            }
            elseif ($dvlp_input -eq 'screen' -and [string]::IsNullOrEmpty(($global:dvlp_arg1))) {
              write-host -nonewline "
             ___L____// E V E L
            /  "
              write-host "`r`n`r`n --------------------------------------------------------------------------`r`n`r`n"
            }
            display_wsl_distro_list $wsl_distro_list
            $dvlp_options = "`r`n`r`n`r`nEnter a wsl distro number/name, powershell command, docker image (repo/image:tag), or one of the following:`r`n`r`n`t- [i]mport docker image into wsl${docker_devel_spawn_noninteractive}`r`n`t- [t]erminal`r`n`t- [c]ustomize`r`n`t- [update]$update_found`r`n`t- [screen]`r`n`t- [restart] wsl/docker`r`n`t${wsl_distro_revert_options}- [reboot] computer`r`n`t- [auto] boot is $auto_boot_status`r`n`r`n`r`n"
          }
          catch {
            if ($dvlp_input -eq 'screen' -and [string]::IsNullOrEmpty(($global:dvlp_arg1))) {
              write-host "
             ___L____// E V E L
            /  "
# write-host 
# '
#          \________
#              W    \\ O C K E R
#       <------S----+++=======================|======|
#           ___L____// E V E L
#          /
#      ' 
#  write-host
# '  
#          </=+====\\
#             W     \\ O_C_K_E_R
#         <-= S --`=|+|===============================|#######|
#             L     // E V E L
#          <\=+====//  
# '
              #     
              write-host "`r`n`r`n --------------------------------------------------------------------------`r`n`r`n"
            }
            $dvlp_options = "`r`noops ..wsl devel install failed :( `r`nChoose from the one of the following:`r`n`r`n`t- [t]erminal`r`n`t- [c]ustomize`r`n`t- [update]$update_found`r`n`t- [restart] wsl/docker`r`n`t${wsl_distro_revert_options}- [reboot] computer`r`n`t- [auto] boot is $auto_boot_status`r`n`r`n`r`n"
          }
        }
        # $dvlp_input = Read-Host "`r`nHit ENTER to exit or choose from the following:`r`n`t- launch [W]SL`r`n`t- launch [D]evels Playground`r`n`t- launch repo in [V]S Code`r`n`t- build/install a Linux [K]ernel`r`n`r`n`t"
        # $current_process = [System.Diagnostics.Process]::GetCurrentProcess() | Select-Object -ExpandProperty ID
        # $current_process_object = Get-Process -id $current_process
        # Set-ForegroundWindow $current_process_object.MainWindowHandle
        $global:dvlp_arg1 = ''
        $dvlp_prompt_cursor1 = "(exit) > "
        $dvlp_prompt_cursor2 = "> "
        $dvlp_prompt_prefix = ""
        if ($dvlp_prompt_cursor -eq $dvlp_prompt_cursor2) {
          # once activated, keep command line mode active 
          $dvlp_prompt_cursor = $dvlp_prompt_cursor2
          $dvlp_prompt_location = "$("$(get-location)".tolower())"
          $dvlp_prompt_prefix = 'DVL'
        }
        else {
          $dvlp_prompt_cursor = $dvlp_prompt_cursor1
          $dvlp_prompt_location = ''
          $dvlp_prompt_prefix = ''
        }
        do {
          if ($dvlp_prompt_cursor -eq $dvlp_prompt_cursor2) {
            # once activated, keep command line mode active 
            $dvlp_prompt_location = "$("$(get-location)".tolower())"
          }
          Write-Host -nonewline "${dvlp_options}" -ForegroundColor Gray
          Write-Host -nonewline "DVL${dvlp_prompt_prefix}" -ForegroundColor DarkRed
          write-host -nonewline " ${dvlp_prompt_location}" -ForegroundColor White
          write-host -nonewline "${dvlp_prompt_cursor}" -ForegroundColor DarkYellow
          $dvlp_input = $Host.UI.ReadLine()
          $dvlp_options = ''
          
          if (($dvlp_input -ieq 'x') -Or ($dvlp_input -ieq 'exit') -Or (($dvlp_input -ieq '') -and ($dvlp_prompt_cursor -eq $dvlp_prompt_cursor1))) {
            # entering space the first time will exit - after that need x or exit to exit
            $dvlp_input = 'exit'
          }
          try {    
            if ($wsl_distro_list.contains($dvlp_input)) {
              for ($i = 0; $i -le $wsl_distro_list.length - 1; $i++) {
                if ($dvlp_input -eq $wsl_distro_list[$i]) {
                  $dvlp_input = "$($i + 1)"
                }
              }
            }
          }
          catch {}
          if (($dvlp_input -ieq '') -and ($dvlp_prompt_cursor -eq $dvlp_prompt_cursor2)) {
            $dvlp_input = 'noscreen'
          }
          elseif ($dvlp_input -ieq 'update') {
            update_dvlp
            if (($dependencies_installed -eq $false) -or (!(Test-Path -Path "$env:KINDTEK_WIN_GIT_PATH/.dvlp-installed" -PathType Leaf))) {
              reload_dvlp
            }
            else {
              $dvlp_input = 'noscreen'
            }
          }
          elseif ($dvlp_input -ieq 'i') {
            # require_docker_desktop_online
            require_docker_desktop_online_new_win
            if ([string]::IsNullOrEmpty($img_name_tag) -or ($img_name_tag -eq 'skip')) {
              docker_devel_spawn
            }
            else {
              docker_devel_spawn "kindtek/$($env:KINDTEK_WIN_DVLP_FULLNAME):$img_name_tag" '' ''
            }
            $dvlp_input = 'screen'
          }
          elseif ($dvlp_input -ieq 'i!') {
            require_docker_desktop_online_new_win
            if ([string]::IsNullOrEmpty($img_name_tag) -or ($img_name_tag -eq 'skip')) {
              docker_devel_spawn 'wait'
            }
            else {
              docker_devel_spawn "kindtek/$($env:KINDTEK_WIN_DVLP_FULLNAME):$img_name_tag" "kindtek-$($env:KINDTEK_WIN_DVLP_FULLNAME)-$img_name_tag" 'default' 'wait'
            }
            $dvlp_input = 'screen'
          }
          elseif (($dvlp_input.length -lt 4) -and ($dvlp_input -imatch "d\d")) {
            [int]$wsl_choice = $("$dvlp_input".Substring(1))
            $dvlp_input = 'screen'
            $wsl_distro_selected_name = select_wsl_distro_list_num $wsl_distro_list $wsl_choice
            if ($wsl_distro_selected_name) {
              set_default_wsl_distro $wsl_distro_selected_name
            }
            else {
              write-host "no distro for ${wsl_choice} found"
              $dvlp_input = 'noscreen'
            }
          }
          elseif (($dvlp_input.length -lt 4) -and ($dvlp_input -imatch "x\d")) {
            [int]$wsl_choice = $("$dvlp_input".Substring(1))
            $wsl_distro_selected_name = select_wsl_distro_list_num $wsl_distro_list $wsl_choice
            if ($wsl_distro_selected_name) {
              $dvlp_input = 'screen'
              if ($wsl_distro_selected_name -eq $(get_default_wsl_distro)) {
                write-host "replacing $wsl_distro_selected_name with $env:KINDTEK_FAILSAFE_WSL_DISTRO as default distro ..."
                revert_default_wsl_distro
              }
              write-host "executing: wsl.exe --unregister $wsl_distro_selected_name"
              wsl.exe --unregister $wsl_distro_selected_name
            }
            else {
              $dvlp_input = 'noscreen'
              write-host "no distro for ${wsl_choice} found"
            }
          }
          elseif (($dvlp_input.length -lt 4) -and ($dvlp_input -imatch "t\d")) {
            [int]$wsl_choice = $("$dvlp_input".Substring(1))
            $dvlp_input = 'screen'
            $wsl_distro_selected_name = select_wsl_distro_list_num $wsl_distro_list $wsl_choice
            if ($wsl_distro_selected_name) {
              write-host "use 'exit' to exit $wsl_distro_selected_name terminal"
              wsl.exe --distribution "$($wsl_distro_selected_name)".trim() -- bash
            }
            else {
              $dvlp_input = 'noscreen'
              write-host "no distro for ${wsl_choice} found"
            }
                    
          }
          elseif (($dvlp_input.length -lt 4) -and ($dvlp_input -imatch "g\d")) {
            [int]$wsl_choice = $("$dvlp_input".Substring(1))
            $dvlp_input = 'screen'
            $wsl_distro_selected_name = select_wsl_distro_list_num $wsl_distro_list $wsl_choice
            if ($wsl_distro_selected_name) {
              gui_launch $wsl_distro_selected_name
            }
            else {
              $dvlp_input = 'noscreen'
              write-host "no distro for ${wsl_choice} found"
            }
          } 
          elseif (($dvlp_input.length -lt 4) -and ($dvlp_input -match "\d")) {
            $wsl_distro_selected_name = select_wsl_distro_list_num $wsl_distro_list $dvlp_input
            if ([string]::IsNullOrEmpty($wsl_distro_selected_name)) {
              write-host "no distro found for $dvlp_input`r`n`r`n"
              $dvlp_input = 'noscreen'
            }
            else {
              write-host "`r`n`r`n$wsl_distro_selected_name selected.`r`n`r`nEnter terminal, gui, DEFAULT, DELETE, setup, kernel, backup, rename, restore`r`n`t ... or press ENTER to open"
              $wsl_action_choice = read-host "
    (open $wsl_distro_selected_name)"
              if ($wsl_action_choice -ceq 'DELETE') {
                if ($wsl_distro_selected_name -eq $(get_default_wsl_distro)) {
                  write-host "`r`nreplacing $wsl_distro_selected_name with $env:KINDTEK_FAILSAFE_WSL_DISTRO as default distro ..."
                  revert_default_wsl_distro
                }
                write-host "`r`ndeleting $wsl_distro_selected_name distro ..."
                wsl.exe --unregister $wsl_distro_selected_name
                $wsl_distro_selected_num = $(select_wsl_distro_list_name $wsl_distro_list $wsl_distro_selected_name)
                write-host "`r`npro tip: next time you can use x$wsl_distro_selected_num to delete a distro"
                start-sleep -Milliseconds 600
                $dvlp_input = 'screen'
              }
              elseif ($wsl_action_choice -ceq 'DEFAULT') {
                write-host "`r`nsetting $wsl_distro_selected_name as default distro ..."
                wsl.exe --set-default "$wsl_distro_selected_name".trim()
                $wsl_distro_selected_num = $(select_wsl_distro_list_name $wsl_distro_list $wsl_distro_selected_name)
                write-host "`r`npro tip: next time use d$wsl_distro_selected_num to set $wsl_distro_selected_name as default"
                start-sleep -Milliseconds 600
                $dvlp_input = 'screen'

              }
              elseif ($wsl_action_choice -ieq 'kernel') {
                $kernel_choices = @()
                $wsl_kernel_make_path = "$($env:USERPROFILE)/kache/wsl-kernel-make.ps1"
                $wsl_kernel_rollback_path = "$($env:USERPROFILE)/kache/wsl-kernel-rollback.ps1"
                $wsl_kernel_install_path = "$($env:USERPROFILE)/kache/wsl-kernel-install.ps1"
                if ($(get_default_wsl_distro $wsl_distro_selected_name)) {
                  if (Test-Path "$wsl_kernel_install_path" -PathType Leaf -ErrorAction SilentlyContinue ) {
                    $kernel_choices += 'install'
                  }
                  if (Test-Path "$wsl_kernel_make_path" -PathType Leaf -ErrorAction SilentlyContinue ) {
                    $kernel_choices += 'make'
                  }
                }
                if (Test-Path "$wsl_kernel_rollback_path" -PathType Leaf -ErrorAction SilentlyContinue ) {
                  $kernel_choices += 'rollback'
                }
                write-host 'enter one of the following:'
                for ($i = 0; $i -le $kernel_choices.length - 1; $i++) {
                  write-host $kernel_choices[$i]
                }
                $kernel_choice = read-host "
    (main menu)"
                if ($kernel_choice = 'install') {
                  push-location "$env:USERPROFILE/kache"
                  write-host "powershell.exe -File $wsl_kernel_install_path `"''`" `"''`" $wsl_distro_selected_name"
                  write-host "powershell.exe -File $wsl_kernel_install_path `"''`" `"''`" $wsl_distro_selected_name"
                  powershell.exe -File $wsl_kernel_install_path "''" "''" $wsl_distro_selected_name
                  pop-location                              
                }
                if ($kernel_choice = 'make') {
                  powershell -File $wsl_kernel_make_path                                
                }
                if ($kernel_choice = 'rollback') {
                  powershell -File $wsl_kernel_rollback_path                                
                }
                if ($kernel_choice = '') {
                  $dvlp_input = 'screen'
                }
                $kernel_choice = ''
                if ([string]::IsNullOrEmpty($kernel_choice)) {
                  $dvlp_input = 'screen'
                }

              }
              elseif ($wsl_action_choice -ieq 'setup') {
                write-host "`r`nsetting up $wsl_distro_selected_name ..."
                wsl.exe --distribution $wsl_distro_selected_name -- cd `$HOME `&`& bash setup.sh "$env:USERNAME"
              }
              elseif ([string]::IsNullOrEmpty($wsl_action_choice) -Or $wsl_action_choice -ieq 'TERMINAL' ) {
                write-host "use 'exit' to exit $wsl_distro_selected_name terminal"
                wsl.exe --distribution $wsl_distro_selected_name -- cd `$HOME `&`& bash
                $wsl_distro_selected_num = $(select_wsl_distro_list_name $wsl_distro_list $wsl_distro_selected_name)
                write-host "`r`npro tip: next time use t$wsl_distro_selected_num to open the terminal for $wsl_distro_selected_name"
                start-sleep -Milliseconds 600
              }
              elseif ([string]::IsNullOrEmpty($wsl_action_choice) -Or $wsl_action_choice -ieq 'GUI' ) {
                gui_launch $wsl_distro_selected_name
                $wsl_distro_selected_num = $(select_wsl_distro_list_name $wsl_distro_list $wsl_distro_selected_name)
                write-host "`r`npro tip: use g$wsl_distro_selected_num to open the gui for $wsl_distro_selected_name"
                start-sleep -Milliseconds 600
              }
              elseif ($wsl_action_choice -Ieq 'VERSION1') {
                write-host "`r`nsetting $wsl_distro_selected_name to wsl version 1..."
                wsl.exe --distribution $wsl_distro_selected_name --set-version 1
              }
              elseif ($wsl_action_choice -ieq 'VERSION2') {
                write-host "`r`nsetting $wsl_distro_selected_name to wsl version 2..."
                wsl.exe --distribution $wsl_distro_selected_name --set-version 2
              }
              elseif ($wsl_action_choice -ieq 'BACKUP') {
                $base_distro = $wsl_distro_selected_name.Substring(0, $wsl_distro_selected_name.lastIndexOf('-'))
                $base_distro_id = $wsl_distro_selected_name.Substring($wsl_distro_selected_name.lastIndexOf('-') + 1)
                $base_distro_backup_root_path = "$($env:USERPROFILE)\kache\docker2wsl\$($base_distro)\$($base_distro_id)\backups"
                $base_distro_backup_file_path = "$($base_distro_backup_root_path)\$($base_distro)-$($base_distro_id)-$((Get-Date).ToFileTime()).tar"
                New-Item -ItemType Directory -Force -Path "$base_distro_backup_root_path" | Out-Null
                write-host "`r`nbacking up $wsl_distro_selected_name to $base_distro_backup_file_path ..."
                wsl.exe --export $wsl_distro_selected_name "$base_distro_backup_file_path"
              }
              elseif ($wsl_action_choice -ieq 'RENAME') {
                $filetime = "$((Get-Date).ToFileTime())"
                $base_distro = $wsl_distro_selected_name.Substring(0, $wsl_distro_selected_name.lastIndexOf('-'))
                $base_distro_id = $wsl_distro_selected_name.Substring($wsl_distro_selected_name.lastIndexOf('-') + 1)
                $new_distro_name = read-host "
    enter new name for $base_distro
    (main menu)"

                if ([string]::IsNullOrEmpty($base_distro_id)) {
                  $new_distro_root_path = "$($env:USERPROFILE)\kache\docker2wsl\$($new_distro_name)"
                  $new_distro_file_path = "$($new_distro_root_path)\$($new_distro_name)-$filetime.tar"
                }
                else {
                  $new_distro_root_path = "$($env:USERPROFILE)\kache\docker2wsl\$($new_distro_name)\$($base_distro_id)"
                  $new_distro_file_path = "$($new_distro_root_path)\backups\$($new_distro_name)-$($base_distro_id)-$filetime.tar"
                }

                New-Item -ItemType Directory -Force -Path "$new_distro_root_path\backups" | Out-Null
                write-host "`r`nbacking up $wsl_distro_selected_name to $new_distro_file_path ..."
                if (!([string]::IsNullOrEmpty($new_distro_name)) -And $(wsl.exe --export "$wsl_distro_selected_name" "$new_distro_file_path")) {
                  write-host "importing $new_distro_file_path as $new_distro_name ..."
                  if (wsl.exe --import "$new_distro_name-$base_distro_id" "$new_distro_root_path" "$new_distro_file_path") {
                    wsl.exe --unregister $wsl_distro_selected_name
                    $new_distro_diskman = "$($new_distro_root_path)\diskman.ps1"
                    $new_distro_diskshrink = "$($new_distro_root_path)\diskshrink.ps1"
                    New-Item -Path $new_distro_diskman -ItemType File -Force -Value "select vdisk file=$new_distro_diskman\ext4.vhdx 
                                        attach vdisk readonly 
                                        compact vdisk 
                                        detach vdisk " | Out-Null
                    New-Item -Path $new_distro_diskshrink -ItemType File -Force -Value "try { 
                                            # Self-elevate the privileges 
                                            if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) { 
                                                if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) { 
                                                    `$CommandLine = -File `$MyInvocation.MyCommand.Path + ' ' + `$MyInvocation.UnboundArguments 
                                                    Start-Process -FilePath PowerShell.exe -Verb Runas -WindowStyle 'Maximized' -ArgumentList `$CommandLine 
                                                    Exit 
                                                } 
                                            } 
                                        }  catch {} 
                                        docker system df 
                                        docker builder prune -af --volumes 
                                        docker system prune -af --volumes 
                                        stop-service -name docker* -force;  
                                        # wsl.exe -- sudo shutdown -h now; 
                                        # wsl.exe -- sudo shutdown -r 0; 
                                        wsl.exe --shutdown; 
                                        stop-service -name wsl* -force -ErrorAction SilentlyContinue; 
                                        stop-process -name docker* -force -ErrorAction SilentlyContinue; 
                                        stop-process -name wsl* -force -ErrorAction SilentlyContinue; 
                                        Invoke-Command -ScriptBlock { diskpart /s $new_distro_diskman } -ArgumentList '-Wait -Verbose'; 
                                        start-service wsl*; 
                                        start-service docker*; 
                                        write-host 'done.'; 
                                        read-host " | Out-Null
                    $base_distro_root_path = "$($env:USERPROFILE)\kache\docker2wsl\$($base_distro_name)\$($base_distro_id)"
                    Remove-Item  "$base_distro_root_path\.diskshrink.ps1" -Force -ErrorAction SilentlyContinue | Out-Null
                    Remove-Item  "$base_distro_root_path\.diskman.ps1" -Force -ErrorAction SilentlyContinue | Out-Null
                    Move-Item  "$base_distro_root_path\.container_id" "$base_distro_root_path\.container_id" -Force -ErrorAction SilentlyContinue | Out-Null
                    Move-Item  "$base_distro_root_path\.image_id" "$base_distro_root_path\.image_id" -Force -ErrorAction SilentlyContinue | Out-Null
                    Move-Item  "$base_distro_root_path\backups" "$base_distro_root_path\backups" -Force -ErrorAction SilentlyContinue | Out-Null

                  }
                }
                else {
                  $dvlp_input = 'noscreen'
                }
              }
              elseif ($wsl_action_choice -ieq 'RESTORE') {
                $filetime = "$((Get-Date).ToFileTime())"
                $base_distro = $wsl_distro_selected_name.Substring(0, $wsl_distro_selected_name.lastIndexOf('-'))
                $base_distro_id = $wsl_distro_selected_name.Substring($($wsl_distro_selected_name.lastIndexOf('-') + 1))
                $new_distro_base_root_path = "$($env:USERPROFILE)\kache\docker2wsl\$($base_distro)"
                if ([string]::IsNullOrEmpty($base_distro_id)) {
                  $old_distro_backup_path = "$($new_distro_base_root_path)\backups"
                  $old_distro_backup_file_path = "$($old_distro_backup_path)\$($base_distro).tar"
                  $new_distro_root_path = "$new_distro_base_root_path\$filetime"
                  $new_distro_file_name = "$($base_distro)-$filetime"
                  # $base_distro_root_path = "$($env:USERPROFILE)\kache\docker2wsl\$($base_distro)"
                }
                else {
                  $old_distro_backup_path = "$($new_distro_base_root_path)\$($base_distro_id)\backups"
                  $old_distro_backup_file_path = "$($old_distro_backup_path)\$($base_distro)-$($base_distro_id).tar"
                  $new_distro_root_path = "$new_distro_base_root_path\$($base_distro_id)\$filetime"
                  $new_distro_file_name = "$($base_distro)-$($base_distro_id)-$filetime"
                  # $base_distro_root_path = "$($env:USERPROFILE)\kache\docker2wsl\$($base_distro)\$($base_distro_id)"
                }                                                                   
                try {
                  if (!(Test-Path -Path "$old_distro_backup_path" -PathType Leaf)) {
                    $backup_distro_files = Get-ChildItem -Path "$old_distro_backup_path" -File | Where-Object { $_ -And $_ -ne '' -And $_ -match '^(.*)\.tar$' } | Sort-Object
                    $backup_distro_num = 0
                    write-host "`r`n"
                    foreach ($backup_distro_file in $backup_distro_files) {
                      $backup_distro_num += 1
                      write-host "`t$backup_distro_num)`t$($backup_distro_file.name)"
                    }
                    [string]$restore_backup_choice_string = read-host "`r`n`tenter number of a distro backup to restore
    `t(main menu)"
                    if (!([string]::IsNullOrEmpty($restore_backup_choice_string))) {
                      [int]$restore_backup_choice_int = [string]$restore_backup_choice_string
                      $restore_backup_choice_int = $restore_backup_choice_int -= 1
                      foreach ($backup_distro_file in $backup_distro_files) {
                        # write-host "restore choice: $([int]$restore_backup_choice_int + 1)"
                        write-host "backup chosen for recovery: $($backup_distro_files[$restore_backup_choice_int])"
                        # write-host "$($backup_distro_files[$restore_backup_choice_int]) -eq $backup_distro_file"
                        if ("$($backup_distro_files[$restore_backup_choice_int])" -eq "${backup_distro_file}") {
                          $new_distro_file_path = "$($new_distro_root_path)\backups\$($backup_distro_file.name)"
                          write-host "restoring '$($backup_distro_file.name)' to $new_distro_file_path"
                          write-host "wsl.exe --import '$new_distro_file_name' '$new_distro_root_path' '$new_distro_file_path'"
                          New-Item -ItemType Directory -Force -Path "$($new_distro_root_path)\backups" | Out-Null
                          Copy-Item "$old_distro_backup_path\$($backup_distro_file.name)" "$new_distro_file_path" -Verbose
                          wsl.exe --import "$new_distro_file_name" "$new_distro_root_path" "$new_distro_file_path"
                        }
                      }
                    }
                    else {
                      $dvlp_input = 'noscreen'
                    }
                  }
                  else {
                    write-host "`r`nno backups found for $wsl_distro_selected_name"
                    read-host "(main menu)"
                  }
                }
                catch {
                  write-host "`r`nthere was a problem retrieving backups found for $wsl_distro_selected_name"
                  read-host "(main menu)"

                }
              }
              else {
                $dvlp_input = 'noscreen'
              }
            }
            # $dvlp_input = 'screen'
          }
          elseif ($dvlp_input -ieq 'revert' -or $dvlp_input -ieq 'failsafe') {
            try {
              set_default_wsl_distro
              require_docker_desktop_online_new_win
            }
            catch {
              try {
                revert_default_wsl_distro
              }
              catch {
                Write-Host "error setting $env:KINDTEK_FAILSAFE_WSL_DISTRO as default wsl distro"
              }
            }
            $dvlp_input = 'noscreen'
          }
          elseif (($dvlp_input.length -lt 3) -and ($dvlp_input -like 't**') -and ($dvlp_input -NotLike '*:*') -and ($dvlp_input -NotLike '*/*')) {    
            if ($dvlp_input -ieq 't') {
              Write-Host "`r`n`t[l]inux or [w]indows"
              $dvlp_cli_options = Read-Host
            }
            if ($dvlp_cli_options -ieq 'l' -Or $dvlp_cli_options -ieq 'w') {
              $dvlp_input = $dvlp_input + $dvlp_cli_options
            }
            if ($dvlp_input -ieq 'tl' ) {
              wsl.exe -- cd `$HOME `&`& bash
            }
            elseif ($dvlp_input -ieq 'tdl' ) {
              # wsl.exe --distribution "devels-playground-kali-git".trim() -- cd `$HOME/.local/bin; alias cdir`=`'source cdir.sh; alias grep=`'grep --color=auto`'; ls -al; cdir_cli
              # start_dvlp_process_pop "wsl.exe --cd /hal --exec bash `$(cdir)" 'wait' 'noexit'
            }
            elseif ($dvlp_input -ieq 'tw' ) {
              start_dvlp_process_pop "Set-Location -literalPath $env:USERPROFILE" 'wait' 'noexit'
            }
            elseif ($dvlp_input -ieq 'tdw' ) {
              # one day might get the windows cdir working
              # start_dvlp_process_pop "Set-Location -literalPath $env:USERPROFILE" 'wait' 'noexit'
            }
            $dvlp_input = 'screen'

          }
          elseif (($dvlp_input.length -lt 3) -and ($dvlp_input -Like 'k*') -and ($dvlp_input -NotLike '*:*') -and ($dvlp_input -NotLike '*/*')) {
            if ($dvlp_input -ieq 'k') {
              $dvlp_input = 'screen'
              Write-Host "`r`n`t[l]inux or [w]indows"
              $dvlp_kindtek_options = Read-Host
              if ($dvlp_kindtek_options -ieq 'l' -Or $dvlp_kindtek_options -ieq 'w') {
                $dvlp_input = $dvlp_input + $dvlp_kindtek_options
                if ($dvlp_kindtek_options -ieq 'w') {
                  $dvlp_input = 'noscreen'
                  Write-Host "`r`n`t`t- [r]eset docker settings`r`n`t`t- [R]eset wsl settings`r`n`t`t- [d]ocker re-install`r`n`t`t- [D]ocker uninstall`r`n`t`t- [w]indows re-install`r`n`t`t- [W]indows uninstall"
                  $dvlp_kindtek_options_win = Read-Host
                  if ($dvlp_kindtek_options_win -ceq 'r') {
                    reset_docker_settings_hard
                    require_docker_desktop_online_new_win
                  }
                  if ($dvlp_kindtek_options_win -ceq 'R') {
                    Remove-Item "$env:USERPROFILE/.wslconfig" -Confirm:$false -Force -ErrorAction SilentlyContinue
                    restart_wsl_docker
                    $revert_failsafe = Read-Host "revert to $env:KINDTEK_FAILSAFE_WSL_DISTRO ? (Y/n)"
                    if (($revert_failsafe -eq '') -or ($revert_failsafe -ieq 'y') -or ($revert_failsafe -eq 'yes')) {
                      revert_default_wsl_distro
                    }
                    require_docker_desktop_online_new_win
                  }
                  if ($dvlp_kindtek_options_win -ceq 'd') {
                    reinstall_docker
                    require_docker_desktop_online_new_win
                  }
                  if ($dvlp_kindtek_options_win -ceq 'D') {
                    uninstall_docker
                  }
                  if ($dvlp_kindtek_options_win -ceq 'w') {
                    remove_installation
                    reboot_prompt 'reboot continue'
                  }
                  if ($dvlp_kindtek_options_win -ceq 'W') {
                    remove_installation
                    reboot_prompt
                  }
                }
                elseif ($dvlp_kindtek_options_win -ieq 'l') {
                  $dvlp_kindtek_options_win = Read-Host
                }
              }
            }
            if ($dvlp_input -ieq 'kl' ) {
              wsl.exe -- cd `$HOME `&`& bash setup.sh "$env:USERNAME"
            }
            elseif ($dvlp_input -ieq 'daemon' ) {
              Write-Host "spawning daemon with $(get_default_wsl_distro)"
              return devel_daemon
            }
            elseif ($dvlp_input -ieq 'devel' ){
              $debug_mode = get_dvlp_debug_mode
              if ($debug_mode -eq $true){
                set_dvlp_debug_mode $false
              } else {
                set_dvlp_debug_mode $true
              }
            }
                        

          }
          elseif ($dvlp_input -ieq 'r') {
            if ($env:KINDTEK_OLD_DEFAULT_WSL_DISTRO -ne "") {
              # wsl.exe --set-default kalilinux-kali-rolling-latest
              Write-Host "`r`n`r`nsetting $env:KINDTEK_OLD_DEFAULT_WSL_DISTRO as default distro ..."
              wsl.exe --set-default "$env:KINDTEK_OLD_DEFAULT_WSL_DISTRO".trim()
              # restart_wsl_docker
              restart_wsl_docker_new_win
              $dvlp_input = 'noscreen'
            }
          }
          elseif ($dvlp_input -ceq 'restart') {
            # restart_wsl_docker
            restart_wsl_docker_new_win
            $dvlp_input = 'noscreen'
          }
          elseif ($dvlp_input -ceq 'restart!') {
            # restart_wsl_docker
            hard_restart_wsl_docker_new_win
            $dvlp_input = 'noscreen'
          }
          elseif ($dvlp_input -ceq 'RESTART') {
            if (Test-Path "$wsl_restart_path" -PathType Leaf -ErrorAction SilentlyContinue ) {
              powershell.exe -ExecutionPolicy RemoteSigned -File $wsl_restart_path
              require_docker_desktop_online_new_win
            }
            $dvlp_input = 'noscreen'
          }
          elseif ($dvlp_input -ieq 'rollback') {
            $wsl_kernel_rollback_path = "$($env:USERPROFILE)/kache/wsl-kernel-rollback.ps1"
            if (Test-Path "$wsl_kernel_rollback_path" -PathType Leaf -ErrorAction SilentlyContinue ) {
              powershell.exe -ExecutionPolicy RemoteSigned -File $wsl_restart_path
              require_docker_desktop_online_new_win
            }
            $dvlp_input = 'noscreen'
          }
          elseif ($dvlp_input -ceq 'reboot' -or $dvlp_input -ceq 'reboot now' -or $dvlp_input -ceq 'reboot continue') {
            reboot_prompt "$dvlp_input"
            $dvlp_input = 'noscreen'
            # elseif ($dvlp_input -ieq 'v') {
            #     wsl.exe sh -c "cd /hel;. code"
          }
          elseif ($dvlp_input -ieq 'auto') {
            if ($(get_dvlp_auto_boot)) {
              set_dvlp_auto_boot $false
              write-host 'auto boot turned OFF'
              start-sleep 1
            }
            else {
              set_dvlp_auto_boot $true
              write-host 'auto boot turned ON'
              start-sleep 1
            }
            $dvlp_input = 'noscreen'
          }
          elseif (!([string]::isnullorempty($dvlp_input)) -And $dvlp_input -ine 'exit' -And $dvlp_input -ine 'screen' -And $dvlp_input -ine 'noscreen' -And $dvlp_input -ine 'update' -And $dvlp_input -ine 'daemon') {
            try {
              # disguise unavoidable error message
              $orig_foreground = [System.Console]::ForegroundColor
              $temp_foreground = [System.Console]::BackgroundColor
              $host.UI.RawUI.ForegroundColor = $temp_foreground
              $is_docker_image = $(docker manifest inspect $dvlp_input) 
              $host.UI.RawUI.ForegroundColor = $orig_foreground

            }
            catch {}
            if ($is_docker_image.count -ne 0) {
              Write-Host "`r`n$dvlp_input is a valid docker hub official image"
              docker_devel_spawn "$dvlp_input"
              $dvlp_input = 'screen'
            }
            else {
              try {
                $dvlp_input_orig = $dvlp_input
                $dvlp_input = 'noscreen'
                $dvlp_output = Invoke-Expression $dvlp_input_orig | Out-String
                Write-Host $dvlp_output
              }
              catch {
                write-host "invalid command`r`n$dvlp_input_orig`r`n$confirmation"
              }
            }
          } 
          if ($dvlp_input -eq 'noscreen') {
            if ($dvlp_prompt_cursor -eq $dvlp_prompt_cursor1) {
              write-host "`r`ncommand line mode activated`r`n`tenter 'x' to exit`r`n"
            }
            $dvlp_prompt_cursor = $dvlp_prompt_cursor2
          }
        } while ($dvlp_input -ne '' -And $dvlp_input -ine 'daemon' -And $dvlp_input -ine 'exit' -And $dvlp_input -ine 'update' -And $dvlp_input -ine 'rollback' -And $dvlp_input -ine 'failsafe' -and $dvlp_input -ine 'revert' -And $dvlp_input -ine 'screen' -or $dvlp_input -eq 'noscreen')
      } while ($dvlp_input -ne '' -And $dvlp_input -ine 'daemon' -And $dvlp_input -ine 'exit' -And $dvlp_input -ine 'update' -And $dvlp_input -ine 'rollback' -And $dvlp_input -ine 'failsafe'  -and $dvlp_input -ine 'revert' -And $dvlp_input -ine 'screen')
    }
    elseif (!([string]::isNullOrEmpty($confirmation)) -and ($confirmation.length -gt 1)) {
      try {
        Invoke-Expression $confirmation | Out-Null
      }
      catch {
        $dvlp_input = $confirmation
      }
    }
    else {
      $dvlp_input = 'exit'
    }
  } while ($dvlp_input -ieq 'daemon' -Or $dvlp_input -ieq 'update' -Or $dvlp_input -ieq 'screen' -Or "$confirmation" -ieq "" -And $dvlp_input -ine 'exit')
    
  if ($dvlp_input_orig -eq 'update_dvlp') {
    Write-Host "`r`ndocker devel was updated and is now running in a new window"
    Write-Host "`r`nyou can close this one`r`n"
  }
  else {
    Write-Host "`r`nGoodbye!`r`n"
  }
}

function get_dvlp_debug_mode {
  $debug_mode = get_dvlp_env 'KINDTEK_DEBUG_MODE'
  if ($debug_mode -eq '1' -Or $debug_mode -eq 1) {
    return $true
  }
  else {
    return $false
  }
}

function set_dvlp_debug_mode {
  param (
    [bool]$debug_mode_on
  )
  if ($debug_mode_on) {
    Set-PSDebug -Trace 2
    set_dvlp_env 'KINDTEK_DEBUG_MODE' '1'
    set_dvlp_env 'KINDTEK_DEBUG_MODE' '1' 'machine'
  }
  else {
    Set-PSDebug -Trace 0
    set_dvlp_env 'KINDTEK_DEBUG_MODE' '0'
    set_dvlp_env 'KINDTEK_DEBUG_MODE' '0' 'machine'
  }
}

function gui_launch {
  param (
    $distro_name
  )
    # wsl.exe --distribution "$wsl_distro_selected_name".trim() -- cd `$HOME `&`& bash --login -c "nohup yes '' | bash start-kex.sh $env:USERNAME"
    wsl.exe --distribution "$distro_name".trim() -- cd `$HOME `&`& bash start-kex.sh $env:USERNAME
    Start-Process "$env:windir\system32\mstsc.exe" -ArgumentList "$env:userprofile\KEX-gui.rdp"  

}
function reload_envs {

  $orig_progress_flag = $global:progress_flag 
  $reload_envs = "$env:USERPROFILE/repos/$($env:KINDTEK_WIN_GIT_OWNER)/RefreshEnv.cmd"
  $global:progress_flag = 'silentlyContinue'
  $progress_flag = 'SilentlyContinue'
  $global:progress_flag = $orig_progress_flag
  $network_connected = $false
  $network_err_msg = "`r`ncannot connect to the internet. retrying .."
  # write-host 'checking network'
  while ($network_connected -eq $false) {
    # write-host 'checking network'
    try {
      if (!(Test-Path $reload_envs)) {
        Invoke-RestMethod "https://raw.githubusercontent.com/kindtek/choco/ac806ee5ce03dea28f01c81f88c30c17726cb3e9/src/chocolatey.resources/redirects/RefreshEnv.cmd" -OutFile $reload_envs | Out-Null
      }
      # network not necessarily connected but found cached file
      $network_connected = $true
    }
    catch {
      start-sleep 1
      write-host -NoNewline "$network_err_msg"
      $network_err_msg = "."
    }
  }
  .$reload_envs | Out-Null

}

function reload_envs_new_win {
  start_dvlp_process_popmin "hard_restart_wsl_docker" 
  # reload_envs
}

function start_countdown {
  param (
    $countdown_msg,
    $countdown_msg3,
    $countdown_msg2,
    $countdown_msg1,
    $countdown_msg0
  )
  if ([string]::IsNullOrEmpty(($countdown_msg3))){
    $countdown_msg3 = '3'
  }
  if ([string]::IsNullOrEmpty(($countdown_msg2))){
    $countdown_msg2 = '2'
  }
  if ([string]::IsNullOrEmpty(($countdown_msg1))){
    $countdown_msg1 = '1'
  }
  if ([string]::IsNullOrEmpty(($countdown_msg1))){
    $countdown_msg0 = '0'
  }
  write-host ""
  Write-Host -NoNewline "`r`t`t`t${countdown_msg}${countdown_msg3}" -foregroundcolor yellow
  Start-Sleep -Milliseconds 250
  Write-Host -NoNewline "." -foregroundcolor yellow
  Start-Sleep -Milliseconds 250
  Write-Host -NoNewline "." -foregroundcolor yellow
  Start-Sleep -Milliseconds 250
  Write-Host -NoNewline "." -foregroundcolor yellow
  Start-Sleep -Milliseconds 250
  Write-Host -NoNewline "`r                                                                      "
  Write-Host -NoNewline "`r`t`t`t${countdown_msg}${countdown_msg2}" -foregroundcolor darkyellow
  Start-Sleep -Milliseconds 250
  Write-Host -NoNewline "." -foregroundcolor darkyellow
  Start-Sleep -Milliseconds 250
  Write-Host -NoNewline "." -foregroundcolor darkyellow
  Start-Sleep -Milliseconds 250
  Write-Host -NoNewline "." -foregroundcolor darkyellow
  Start-Sleep -Milliseconds 250
  Write-Host -NoNewline "`r                                                                      "
  Write-Host -NoNewline "`r`t`t`t${countdown_msg}${countdown_msg1}" -foregroundcolor red
  Start-Sleep -Milliseconds 250
  Write-Host -NoNewline "." -foregroundcolor red
  Start-Sleep -Milliseconds 250
  Write-Host -NoNewline "." -foregroundcolor red
  Start-Sleep -Milliseconds 250
  Write-Host -NoNewline "." -foregroundcolor red
  Start-Sleep -Milliseconds 250
  Write-Host -NoNewline "`r                                                                      "
  Write-Host -NoNewline "`r`t`t`t${countdown_msg}${countdown_msg0}" -foregroundcolor darkred
  Start-Sleep -Milliseconds 100
}


# # # # # # # # # # # # # driver # # # # # # # # # # # # # # # # # 

New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\repos\kindtek" | Out-Null
pull_dvlp_envs
# remove auto install script (optionally added when using restart prompt)
if ($(get_dvlp_auto_boot) -ne $true) {
  Remove-Item -Path "$env:AppData\Microsoft\Windows\Start Menu\Programs\Startup\dvlp-spawn.cmd" -Force -ErrorAction SilentlyContinue
}
if ((!([string]::IsNullOrEmpty($args[0]))) -Or (!([string]::IsNullOrEmpty($args[1]))) -Or ($($PSCommandPath) -eq "$env:USERPROFILE\dvlp.ps1")) {
  # echo 'installing everything and setting envs ..'
  if ($(get_dvlp_debug_mode) -eq $true) {
    Write-Host "`$PSCommandPath: $($PSCommandPath)"
    Write-Host "`$args[0]: $($args[0])"
    Set-PSDebug -Trace 2
  }

  if (($($args[0]) -eq 'safe') -or ($($args[1]) -eq 'safe') -or ($confirmation -eq 'safe') -or ($dvlp_input -eq 'safe')){
    $global:dvlp_safe_mode = $true
  }
  $global:dvlp_arg0 = "$($args[0])"
  $global:dvlp_arg1 = "$($args[1])"
  set_dvlp_envs $env:KINDTEK_DEBUG_MODE
  . include_devel_tools
  $global:dvlw_commit = $(get_local_commit)
  set-location $env:USERPROFILE
  $global:update_dvlw = $true
  do {
    $global:update_dvlw = $false
    wsl_devel_spawn $args[0]
  } while ($global:update_dvlw -eq $true)
}
elseif ($($PSCommandPath) -eq "$env:KINDTEK_WIN_POWERHELL_PATH\devel-spawn.ps1") {
  # echo 'setting the envs ..'
  set_dvlp_envs $env:KINDTEK_DEBUG_MODE
  # wsl_devel_spawn $args[0]
}
if ($global:devel_tools -ne "sourced") {
  # echo 'devel_tools not yet sourced'
  if (Test-Path -Path "$env:KINDTEK_DEVEL_TOOLS") {
    # echo 'now sourcing devel_tools ...'
    . include_devel_tools
  }
}

