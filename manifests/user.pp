define runit::user (
  $group = ''
) {
  include runit
  $user = $title
  if $group == undef {
    $_group = $user
  }
  else {
    $_group = $group
  }
  User {
    owner   => root,
    group   => root,
  }
  file { "/etc/runit/${user}":
    ensure  => directory,
    mode    => '0755',
    require => Class['runit::install'],
  }
  file { "/etc/runit/${user}/down":
    ensure  => absent,
    require => Class['runit::install'],
  }
  file { "/etc/runit/${user}/run":
    ensure  => file,
    mode    => '0555',
    content => template('runit/user_run.erb'),
    require => Class['runit::install'],
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
    mode    => '0555',
    content => template('runit/user_log_run.erb'),
    require => File[
      "/etc/runit/${user}/log",
      "/etc/runit/${user}/log/down",
      "/home/${user}/logs/runsvdir"
    ],
  }

  file { "/home/${user}/service":
    ensure  => directory,
    mode    => '0755',
    owner   => $user,
    group   => $_group,
    require => User[$user],
  }
  file { "/home/${user}/logs":
    ensure  => directory,
    mode    => '0755',
    owner   => $user,
    group   => $_group,
    require => User[$user],
  }
  file { "/home/${user}/logs/runsvdir":
    ensure  => directory,
    mode    => '0755',
    owner   => $user,
    group   => $_group,
    require => File["/home/${user}/logs"],
  }

  service { "runit-${user}":
    ensure   => 'running',
    name     => $user,
    provider => 'runit',
    path     => '/etc/runit',
    require  => File["/etc/runit/${user}/run", '/usr/bin/sv'],
  }
}

