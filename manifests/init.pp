class runit (
  $package_name = undef
) {
  # Only run on RedHat derived systems.
  case $::osfamily {
    RedHat: { }
    default: {
      fail('This module only supports RedHat-based systems')
    }
  }
  class { 'runit::install':
    package_name => $package_name,
  }
  include runit::service
}
