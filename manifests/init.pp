class runit (
  $package_file = undef,
  $users        = [],
  $use_hiera    = true
) {
  # Only run on RedHat derived systems.
  case $::osfamily {
    RedHat: { }
    default: {
      fail('This module currently only supports RedHat-based systems')
    }
  }
  if $use_hiera {
    $runit = hiera_hash('runit', undef)
    if $runit {
      class { 'runit::install':
        package_file => $runit['package_file'] ? {
          undef   => $package_file,
          default => $runit['package_file'],
        }
      }
      include runit::service
      if $runit['users'] {
        create_resources( 'runit::user', $runit['users'] )
      }
    }
  }
  else {
    class { 'runit::install':
      package_file => $package_file,
    }
    include runit::service
    create_resources( 'runit::user', $users )
  }
}
