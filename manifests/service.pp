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
  exec { "${user}-runit-${service}":
    command => "/bin/mkdir -p ${home}/${user}/runit",
    creates => "${home}/${user}/runit",
    user    => $user,
    group   => $group,
  }
  file { "${home}/${user}/runit/${service}":
    ensure  => directory,
    mode    => '0750',
    owner   => $user,
    group   => $group,
    require => Exec["${user}-runit-${service}"],
  }
  file { "${home}/${user}/runit/${service}/finish":
    ensure  => present,
    mode    => '0550',
    owner   => $user,
    group   => $group,
    content => template('runit/service/finish.erb'),
    replace => false,
    require => File["${home}/${user}/runit/${service}"],
  }
  file { "${home}/${user}/runit/${service}/log":
    ensure  => directory,
    mode    => '0750',
    owner   => $user,
    group   => $group,
    require => File["${home}/${user}/runit/${service}"],
  }
  file { "${home}/${user}/runit/${service}/log/run":
    ensure  => present,
    mode    => '0550',
    owner   => $user,
    group   => $group,
    content => template('runit/service/log_run.erb'),
    replace => false,
    require => File["${home}/${user}/runit/${service}/log"],
  }
  file { "${home}/${user}/runit/${service}/log/config":
    ensure  => present,
    mode    => '0440',
    owner   => $user,
    group   => $group,
    content => template('runit/service/log_config.erb'),
    replace => false,
    require => File["${home}/${user}/runit/${service}/log"],
  }
}
