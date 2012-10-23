class runit::install {
  file { 'runit-rpm':
    ensure  => file,
    path    => '/root/runit-2.1.1-6.el6.x86_64.rpm',
    source  => 'puppet:///files/runit-2.1.1-6.el6.x86_64.rpm',
  }
  package { 'runit':
    ensure   => installed,
    provider => 'rpm',
    source   => '/root/runit-2.1.1-6.el6.x86_64.rpm',
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
    content => 'export SVDIR=\$HOME/service\n',
  }
  file { '/etc/profile.d/runit.csh':
    ensure  => present,
    content => 'setenv SVDIR \$HOME/service\n',
  }
}
