class runit (
  $package_file = undef,
  $users        = [],
) {
  # Only run on RedHat derived systems.
  case $::osfamily {
    RedHat: { }
    default: {
      fail('This module currently only supports RedHat-based systems')
    }
  }
  include runit::install
  include runit::service
  $users = hiera_array('runit::users', $users)
  create_resources('runit::user', $users)
}
