define runit::service  (
  $user             = undef,
  $group            = undef,
  $restart_interval = 30,
  $restart_count    = 3,
  $clear_interval   = 300,
  $log_size         = 1000000000,
  $log_max_files    = 30,
  $log_min_files    = 2,
  $log_rotate_time  = 86400,
  $home             = '/home'
) {
  $service = $title
  file { "${home}/${user}/service/${service}":
    ensure  => directory,
    mode    => '0750',
    owner   => $user,
    group   => $group,
  }
  file { "${home}/${user}/service/${service}/run":
    ensure  => present,
    mode    => '0550',
    owner   => $user,
    group   => $group,
    content => template('runit/service/run.erb'),
    replace => false,
    require => File["${home}/${user}/service/${service}"],
    notify  => Exec["do-not-start-${user}-${service}"],
  }
  exec { "do-not-start-${user}-${service}":
    command     => "/bin/touch ${home}/${user}/service/${service}/down",
    creates     => "${home}/${user}/service/${service}/down",
    refreshonly => true,
  }
  file { "${home}/${user}/service/${service}/finish":
    ensure  => present,
    mode    => '0550',
    owner   => $user,
    group   => $group,
    content => template('runit/service/finish.erb'),
    replace => false,
    require => File["${home}/${user}/service/${service}"],
  }
  file { "${home}/${user}/service/${service}/log":
    ensure  => directory,
    mode    => '0750',
    owner   => $user,
    group   => $group,
    require => File["${home}/${user}/service/${service}"],
  }
  file { "${home}/${user}/service/${service}/log/run":
    ensure  => present,
    mode    => '0550',
    owner   => $user,
    group   => $group,
    content => template('runit/service/log_run.erb'),
    replace => false,
    require => File["${home}/${user}/service/${service}/log"],
  }
  file { "${home}/${user}/service/${service}/log/config":
    ensure  => present,
    mode    => '0440',
    owner   => $user,
    group   => $group,
    content => template('runit/service/log_config.erb'),
    replace => false,
    require => File["${home}/${user}/service/${service}/log"],
  }
}
