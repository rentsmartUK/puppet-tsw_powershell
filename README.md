# tsw_powershell

## Description

Module that upgrades Powershell MSF to 5.1 and optionally configures the
execution policy.

## Usage

The following block of code would upgrade Powershell to 5.1 and set the
execution policy to RemoteSigned.

```ruby
class { 'tsw_powershell':
  $powershell_execution_policy  = 'RemoteSigned',
}
```

This could be used as simple as the below to only upgrade Powershell

```ruby
include tsw_powershell
```

## Limitations

This module has been developed for upgrading and configuring Powershell with a
very tailored use.

Only tested on Windows 2012 R2 Datacenter.
