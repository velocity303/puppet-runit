class runit (
  $package_file = undef,
  $users        = {}
) {
  # Only run on RedHat derived systems.
  case $::osfamily {
    RedHat: { }
    default: {
      fail('This module currently only supports RedHat-based systems')
    }
  }
  include runit::install
  service { 'runsvdir':
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    enable     => false,
    restart    => '/sbin/initctl restart runsvdir',
    start      => '/sbin/initctl start runsvdir',
    stop       => '/sbin/initctl stop runsvdir',
    status     => '/sbin/initctl status runsvdir | grep "/running" 1>/dev/null 2>&1',
    require    => Class['runit::install'],
  }
  $config = hiera_hash('runit::users', $users)
  create_resources('runit::user', $config)
}
