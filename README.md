# puppet-runit

Puppet module to create user services linked to init

Currently only works on RedHat-like systems.

## runit

This module installs Runit and sets up for user services.  Configured users can
then set up managed services under their home directory that work similarly to
system services.

The recommended usage is to place the configuration under in a hiera config
file and just include the runit module in your puppet configuration:

    include runit

Example hiera config:

    runit:package_file: runit-2.1.1-6.el6.x86_64.rpm
    runit::users:
      'kburdis':
        group: 'admins'
      'fbloggs':
        group: 'users'
      
This installs the runit package and configures runit.  It then calls
runit::user to configure user services for the kburdis and fbloggs users.

### Parameters

*package_file*: the name of the RPM package file to install - see the Runit
Package section below. Required.

*users*: a list of users to set up user services for - see the User Services
section below. Optional.

## runit::user

Used to set up a service directory for a user - for example:

    runit::user { 'kburdis': group => 'users' }

will create /home/kburdis/service managed by a runsvdir process with any logs
from this process written to /home/kburdis/logs/runsvdir/current.  The user (or
other Puppet modules) can then create services under $HOME/service.

### Parameters

*title*: The title is the user's username - for example 'kburdis' in the example above.

*group*: The group the runit files under the user's home directory will be
owned by.  Defaults to the same as the username.

## runit::service

Example:

    class runit::service { 'tomcat': 
      user  => 'kburdis,
      group => 'users,
    }

Create a service directory under $HOME/runit with:

* Stdout logged to subdirectory under $HOME/logs using svlogd

* A configurable number of restarts within a certain restart interval

The user just needs to supply a run script that:

* Redirects stderr to stdout

* Runs the final command in the forefound prefixed with 'exec'

and link the service directory under $HOME/service - for example:

  $ ln -s $HOME/runit/tomcat $HOME/service/tomcat

### Parameters

*title*: The title is the service name (eg. tomcat in the example above)

*user*: The user running the service (used for file location and ownership)

*group*: The group of the user running the service (used for file ownership)

*restart_interval*: The minimum delay (in seconds) between automatic restarts.
Default: 30

*restart_count*: The maximum number of automatic restarts allowed. Default: 3

*clear_interval*: Reset the restart count if this number of seconds have
elapsed since the last automatic restart.  Default: 300

*log_size*: The size of the log file (in bytes) before it is rotated. Default:
1000000000

*log_max_files*: The maximum number of old log files to keep. Default: 30

*log_min_files*: The minimum number of files to keep (regardless of lack of
disk space). Default: 2

*log_rotate_time*: The age of the log file (in seconds) before it is rotated.
Default: 86400 (1 day)

*home*: The directory under which user home directories are located. Default: '/home'

*down*: True if the service should not be started automatically as soon as the
service directory is created. Defaukt: false

## User services

System services managed by root get automatically started at boot and restarted
if they fail. And, there is a consistent way to manage them: service
`start|stop|restart|status <service name>`.  The idea of user services is to
provide the same for non-root user processes.

Each user has a service directory under their home directory that is managed by
their own runsvdir process.  This runsvdir process is linked to init so will be
started at boot and restarted if it fails.  Similarly any user services
configured under $HOME/service will be started at boot and restarted if they
fail, if configured to do so.  All services are managed in a consistent way:
`sv start|stop|restart|status <service_name>`.

Each runit service has a subdirectory under $HOME/service which is the same of
the service.  Inside this directory is a script called *run* that starts the
process running in the _foreground_, with the final command starting with
*exec*.

Optionally a service can have a *finish* script that is executed when the
service stops running - for example because the process died or the user
requested so.  This can be useful to diagnose failures and configure the number
of restarts in a time period.

If a _down_ file exists in the service directory then the service will not be
automatically restarted if it fails or a boot time.

If the process writes output to stdout or stderr this can be fed through a
managed log process called svlogd which takes care of prefixing timestamps and
rotating logs according to a policy - for example daily.

## Runit Package

Runit is not normally packaged by distributions so you will likely need to
clone Ian Meyer's git repository and build the RPM yourself - for example:

    # yum install git rpm-build rpmdevtools gcc glibc-static make
    # git clone https://github.com/imeyer/runit-rpm.git
    # cd runit-rpm
    # ./build.sh
    # cp /root/rpmbuild/RPMS/x86_64/runit-2.1.1-6.el6.x86_64.rpm \
    /var/lib/puppet/files/

This module expects that the RPM has been placed in the directory specified by
the _files_ section of the Puppet file server.  For example if fileserver.conf
has:

     [files]
     path /var/lib/puppet/files

then place the RPM in /var/lib/puppet/files.  

## Support

License: Apache License, Version 2.0

GitHub URL: https://github.com/erwbgy/puppet-runit
