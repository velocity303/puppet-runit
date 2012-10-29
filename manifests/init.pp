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
    $runit = hiera_hash('runit')
    class { 'runit::install':
      package_file => $runit['package_file'] ? {
        undef   => $package_file,
        default => $runit['package_file'],
      }
    }
  }
  else {
    class { 'runit::install':
      package_file => $package_file,
    }
  }
  include runit::service
  create_resources( 'runit::user', $users )
}
