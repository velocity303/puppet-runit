class runit {
  include runit::install, runit::service
}

define runit::user (
  $group = ''
) {
  $user = $name
  User {
    owner   => root,
    group   => root,
  }
  file { "/etc/runit/${user}":
    ensure  => directory,
    mode    => '0755',
    require => File['/etc/runit'],
  }
  file { "/etc/runit/${user}/down":
    ensure  => absent,
    require => File["/etc/runit/${user}"],
  }
  file { "/etc/runit/${user}/run":
    ensure  => file,
    content => template('runit/user_run.erb'),
    mode    => '0555',
    require => [
      File["/etc/runit/${user}", "/etc/runit/${user}/down"],
      Class['runit::install']
    ],
  }

  file { "/home/${user}/service":
    ensure  => directory,
    mode    => '0755',
    owner   => $user,
    group   => $group,
    require => User["${user}"],
  }
  file { "/home/${user}/logs":
    ensure  => directory,
    mode    => '0755',
    owner   => $user,
    group   => $group,
    require => User["${user}"],
  }
  file { "/home/${user}/logs/runsvdir":
    ensure  => directory,
    mode    => '0755',
    require => File["/home/${user}/logs"],
    owner   => $user,
    group   => $group,
  }
  file { "/etc/runit/${user}/log":
    ensure  => directory,
    mode    => '0755',
    require => File["/etc/runit/${user}"],
  }
  file { "/etc/runit/${user}/log/down":
    ensure  => absent,
    require => File["/etc/runit/${user}/log"],
  }
  file { "/etc/runit/${user}/log/run":
    ensure  => file,
    content => template('runit/user_log_run.erb'),
    mode    => '0555',
    require => File[
      "/etc/runit/${user}/log",
      "/etc/runit/${user}/log/down",
      "/home/${user}/logs/runsvdir"
    ],
  }

  service { "runit-${user}":
    name     => $user,
    ensure   => 'running',
    provider => 'runit',
    path     => '/etc/runit',
    require  => File["/etc/runit/${user}/run", '/usr/bin/sv'],
  }
}

