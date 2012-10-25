## puppet-runit

Puppet module to create user services linked to init

### User services

System services managed by root get automatically started at boot and restarted
if they fail. And, there is a consistent way to manage them: service
`start|stop|restart|status <service name>`.  The idea of user services is to 
provide the same for user processes.

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

## Runit package

Runit is not normally packaged by distributions so you will need to clone the
git repository and build the RPM yourself - for example:

    # yum install git rpm-build rpmdevtools gcc glibc-static make
    # git clone https://github.com/imeyer/runit-rpm.git
    # cd runit-rpm
    # ./build.sh
    # cp /root/rpmbuild/RPMS/x86_64/runit-2.1.1-6.el6.x86_64.rpm \
    /var/lib/puppet/files/

This module expects that the RPM has been placed in the directory specified by
the files section of the Puppet file server.  For example if fileserver.conf
has:

     [files]
     path /var/lib/puppet/files

then place the RPM in /var/lib/puppet/files.  

## runit

This module installs Runit and sets things up for user services so must be
called before runit::user is.

Normally this modules is just included:

    include runit

which is the same as:

    class { 'runit': package_file => 'runit-2.1.1-6.el6.x86_64.rpm' }

To use a different package file set the package_file parameter:

    class { 'runit': package_file => 'runit-1.8.0-1.el6.x86_64.rpm' }

## runit::user

Used to set up a service directory for a user - for example:

    runit::user { 'kburdis': group => 'kburdis' }

will create /home/kburdis/service managed by a runsvdir process with any logs
from this process written to /home/kburdis/logs/runsvdir/current.

The user (or other Puppet modules) can then create services under
$HOME/service.

