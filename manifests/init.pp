class tsw_powershell (
  # Variables Declaration
  $powershell_execution_policy  = undef, # As per PS, i.e. Unrestricted, RemoteSigned
  $powershell_PSRemoting        = true,
  $powershell_patch_name        = 'KB3191564', # MSF 5.1, has to be defined in the files/ directory
  # $manage_reboot                = true,
  $temp_path                    = 'c:/temp',
){
  # Compose the binary path
  $powershell_patch_path = "${temp_path}/${powershell_patch_name}.msu"

  # Ensure the resource is created. This will avoid conflict with any previous
  # definitions
  ensure_resource('file', $temp_path, { 'ensure'  => 'directory' })

  if $powershell_execution_policy {
    exec { "Set PowerShell execution policy ${powershell_execution_policy}":
      command   => "Set-ExecutionPolicy ${powershell_execution_policy} -force",
      unless    => "if ((Get-ExecutionPolicy -Scope LocalMachine).ToString() -eq '${powershell_execution_policy}') { exit 0 } else { exit 1 }",
      provider  => 'powershell',
      logoutput => true
    }
  }

  if $powershell_PSRemoting {
    exec { "Set PowerShell Remoting ${powershell_execution_policy}":
      command   => "Enable-PSremoting -force",
      unless    => "Invoke-Command -ComputerName localhost {echo true}",
      provider  => 'powershell',
      logoutput => true
    }
  }

  ensure_resource('windowsfeature', 'net-framework-45-aspnet', {'ensure' => 'present'})
  ensure_resource('windowsfeature', 'net-framework-45-core', {'ensure' => 'present'})
  ensure_resource('windowsfeature', 'net-framework-45-features', {'ensure' => 'present'})

  file { $powershell_patch_path:
    ensure  => file,
    source  => "puppet:///modules/tsw_powershell/${powershell_patch_name}.msu"
  }

  package { $powershell_patch_name:
    ensure    => present,
    source    => $powershell_patch_path,
    provider  => msu,
    require   => File[$powershell_patch_path],
    notify    => Reboot['after_run'],
  }

  reboot { 'after_run':
    apply     => immediately,
  }

}
