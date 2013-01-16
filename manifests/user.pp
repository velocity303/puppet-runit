define runit::user (
  $basedir = undef,
  $group   = undef,
  $home    = '/home',
) {
  $user = $title
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
  User {
    owner   => root,
    group   => root,
  }
  file { "/etc/runit/${user}":
    ensure  => directory,
    mode    => '0755',
  }
  file { "/etc/runit/${user}/down":
    ensure  => absent,
  }
  file { "/etc/runit/${user}/run":
    ensure  => file,
    mode    => '0555',
    content => template('runit/user/run.erb'),
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
    content => template('runit/user/log_run.erb'),
    require => File[
      "/etc/runit/${user}/log",
      "/etc/runit/${user}/log/down",
      "${_basedir}/logs/runsvdir"
    ],
  }

  file { "${_basedir}/service":
    ensure  => directory,
    mode    => '0755',
    owner   => $user,
    group   => $_group,
  }
  file { "${_basedir}/logs":
    ensure  => directory,
    mode    => '0755',
    owner   => $user,
    group   => $_group,
  }
  file { "${_basedir}/logs/runsvdir":
    ensure  => directory,
    mode    => '0755',
    owner   => $user,
    group   => $_group,
    require => File["${_basedir}/logs"],
  }

  file { "/etc/service":
    ensure   => directory,
  }
  file { "/etc/service/${user}":
    ensure   => link,
    target   => "/etc/runit/${user}",
    require  => File["/etc/service", "/etc/runit/${user}/run"],
  }
  $var = "export SVDIR='${_basedir}/service'"
  exec { "runit-update-${user}-bash-profile":
    command => "/bin/echo ${var} >> ~${user}/.bash_profile",
    user    => $user,
    group   => $_group,
    unless  => "/bin/grep -w ${var} ~${user}/.bash_profile",
  }
}
