define runit::service  (
  $service,
  $user,
  $group            = undef,
  $restart_interval = 30,
  $restart_count    = 3,
  $clear_interval   = 300,
  $log_size         = 1000000000,
  $log_max_files    = 30,
  $log_min_files    = 2,
  $log_rotate_time  = 86400,
  $basedir          = $runit::basedir,
  $logdir           = $runit::logdir,
  $home             = '/home',
  $down             = false,
  $command          = 'sleep 60',
  $timestamp        = true,
) {
  if $basedir == undef {
    $_basedir = "${home}/${user}"
  }
  else {
    $_basedir = $basedir
  }
  if $group == undef {
    $_group = $user
  }
  else {
    $_group = $group
  }
  if $logdir == undef {
    $service_logdir = "${_basedir}/logs/${service}"
  }
  else {
    $service_logdir = "${logdir}/${service}"
  }

  file { "${_basedir}/runit/${service}":
    ensure  => directory,
    mode    => '0750',
    owner   => $user,
    group   => $_group,
    require => File["${_basedir}/runit"],
  }
  if $down {
    file { "${_basedir}/runit/${service}/down":
      ensure  => present,
      mode    => '0440',
      owner   => $user,
      group   => $_group,
      require => File["${_basedir}/runit/${service}"],
    }
  }
  file { "${_basedir}/runit/${service}/finish":
    ensure  => present,
    mode    => '0550',
    owner   => $user,
    group   => $_group,
    content => template('runit/service/finish.erb'),
    replace => false,
    require => File["${_basedir}/runit/${service}"],
  }
  file { "${_basedir}/runit/${service}/log":
    ensure  => directory,
    mode    => '0750',
    owner   => $user,
    group   => $_group,
    require => File["${_basedir}/runit/${service}"],
  }
  file { "${_basedir}/runit/${service}/log/run":
    ensure  => present,
    mode    => '0550',
    owner   => $user,
    group   => $_group,
    content => template('runit/service/log_run.erb'),
    replace => false,
    require => File["${_basedir}/runit/${service}/log"],
  }
  file { "${_basedir}/runit/${service}/log/config":
    ensure  => present,
    mode    => '0440',
    owner   => $user,
    group   => $_group,
    content => template('runit/service/log_config.erb'),
    replace => false,
    require => File["${_basedir}/runit/${service}/log"],
  }
}
