class runit (
  $basedir      = undef,
  $logdie       = undef,
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
  if $basedir == undef {
    $_basedir = "${home}/${user}"
  }
  else {
    $_basedir = $basedir
  }
  class { 'runit::install':
    basedir   => $_basedir,
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
    basedir => $_basedir,
    home    => $home,
  }
  $config = hiera_hash('runit::users', $users)
  create_resources('runit::user', $config, $defaults)
}
