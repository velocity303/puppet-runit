class runit::install {
  $package_file = $::runit::package_file
  file { 'runit-rpm':
    ensure  => file,
    path    => "/root/${package_file}",
    source  => "puppet:///files/${package_file}",
  }
  package { 'runit':
    ensure   => installed,
    provider => 'rpm',
    source   => "/root/${package_file}",
    require  => File['runit-rpm'],
  }
  file { '/usr/bin/sv':
    ensure => link,
    target => '/sbin/sv',
  }
  file { '/etc/runit':
    ensure  => directory,
    mode    => '0755',
  }
  file { '/etc/profile.d/runit.sh':
    ensure  => present,
    content => "export SVDIR=\$HOME/service\n",
  }
  file { '/etc/profile.d/runit.csh':
    ensure  => present,
    content => "setenv SVDIR \$HOME/service\n",
  }
}
