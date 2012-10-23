class runit::install {
  realize( File['runit-rpm'] )
  realize( Package['runit'] )
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
