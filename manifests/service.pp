class runit::service {
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
}
