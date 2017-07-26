class custom_powershell (
  # Variables Declaration
  $powershell_execution_policy  = undef, # As per PS, i.e. Unrestricted, RemoteSigned
  $powershell_patch_name        = 'Win8.1AndW2K12R2-KB3191564-x64.msu', # MSF 5.1, has to be defined in the files/ directory
  $powershell_patch_temp_path   = 'c:/temp',
  $manage_reboot                = false,
){

  $powershell_patch_path = "${powershell_patch_temp_path}/${powershell_patch_name}"

  if $powershell_execution_policy {
    exec { "Set PowerShell execution policy ${powershell_execution_policy}":
      command   => "Set-ExecutionPolicy ${powershell_execution_policy} -force",
      unless    => "if ((Get-ExecutionPolicy -Scope LocalMachine).ToString() -eq '${powershell_execution_policy}') { exit 0 } else { exit 1 }",
      provider  => 'powershell',
      logoutput => true
    }
  }

  file { $powershell_patch_temp_path:
    ensure  => directory,
  }

  file { $powershell_patch_path:
    ensure  => file,
    source  => "puppet:///modules/custom_powershell/${powershell_patch_name}"
  }

  package { $powershell_patch_name:
    ensure    => present,
    require   => File[$powershell_patch_path],
    source    => $powershell_patch_path,
    provider  => msu,
  }

  if $manage_reboot == true {
    reboot { 'after_run':
      apply     => finished,
      subscribe => Package[$powershell_patch_name], # This should be subscriptipon based
    }
  }

}
