class runit (
  $package_file = undef
) {
  # Only run on RedHat derived systems.
  case $::osfamily {
    RedHat: { }
    default: {
      fail('This module only supports RedHat-based systems')
    }
  }
  class { 'runit::install':
    package_file => $package_file,
  }
  include runit::service
}
