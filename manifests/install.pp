class runit::install (
  $basedir,
  $filestore,
  $workspace,
) {
  if ! defined(File[$workspace]) {
    file { $workspace: 
      ensure => directory,
      mode   => '0755',
    }
  }
  $package_file = $::runit::package_file
  file { 'runit-rpm':
    ensure  => file,
    path    => "${worksspace}/${package_file}",
    source  => "${filestore}/${package_file}",
  }
  package { 'runit':
    ensure   => installed,
    provider => 'rpm',
    source   => "${workspace}/${package_file}",
    require  => File['runit-rpm'],
  }
  file { '/usr/bin/sv':
    ensure  => link,
    target  => '/sbin/sv',
    replace => false,
  }
  file { '/etc/runit':
    ensure  => directory,
    mode    => '0755',
  }
}
