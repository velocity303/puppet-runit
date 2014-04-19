class runit (
  $basedir      = undef,
  $logdir       = undef,
  $home         = '/home',
  $filestore    = 'puppet:///files/runit',
  $package_file = undef,
  $users        = {},
  $workspace    = '/root/runit',
) {
  # Only run on RedHat derived systems.
  case $::osfamily {
    RedHat: { }
    default: {
      warn('This module may not work on non-RedHat-based systems')
    }
  }
  class { 'runit::install':
    filestore => $filestore,
    workspace => $workspace,
  }
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
  $defaults = {
    basedir => $basedir,
    home    => $home,
  }
  $config = hiera_hash('runit::users', $users)
  create_resources('runit::user', $config, $defaults)
}
