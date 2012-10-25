require 'spec_helper'

describe 'runit::user', :type => 'define' do
  let(:facts) { {
    :ipaddress => '10.0.0.1',
    :osfamily  => 'RedHat',
    :id        => 'keith',
  } }
  context 'no additional parameters' do
    let(:title) { 'keith' }
    let(:params) { {} }
    it {
      should contain_file('/etc/runit/keith').with( {
        'ensure'  => 'directory',
        'mode'    => '0755',
      } )
      should contain_file('/etc/runit/keith/down').with( {
        'ensure'  => 'absent',
      } )
      should contain_file('/etc/runit/keith/run').with( {
        'ensure'  => 'file',
        'mode'    => '0555',
        'content' => "#!/bin/bash\nexec 2>&1\nexec su -c 'chpst -l /home/keith/service/.lock runsvdir -P -H /home/keith/service' keith\n",
      } )
      should contain_file('/home/keith/logs/runsvdir').with( {
        'ensure'  => 'directory',
        'mode'    => '0755',
        'owner'   => 'keith',
        'group'   => 'keith',
      } )
      should contain_file('/etc/runit/keith/log').with( {
        'ensure'  => 'directory',
        'mode'    => '0755',
      } )
      should contain_file('/etc/runit/keith/log/down').with( {
        'ensure'  => 'absent',
      } )
      should contain_file('/etc/runit/keith/log/run').with( {
        'ensure'  => 'file',
        'mode'    => '0555',
        'content' => "#!/bin/bash\nexec 2>&1\nexec su -c 'svlogd -tt /home/keith/logs/runsvdir' keith\n",
      } )
      should contain_file('/home/keith/service').with( {
        'ensure'  => 'directory',
        'mode'    => '0755',
        'owner'   => 'keith',
        'group'   => 'keith',
      } )
      should contain_file('/home/keith/logs').with( {
        'ensure'  => 'directory',
        'mode'    => '0755',
        'owner'   => 'keith',
        'group'   => 'keith',
      } )
    }
  end
  context 'group name specified' do
    let(:title) { 'keith' }
    let(:params) { {
      :group => 'users',
    } }
    it {
      should contain_file('/home/keith/service').with( {
        'ensure'  => 'directory',
        'mode'    => '0755',
        'owner'   => 'keith',
        'group'   => 'users',
      } )
      should contain_file('/home/keith/logs').with( {
        'ensure'  => 'directory',
        'mode'    => '0755',
        'owner'   => 'keith',
        'group'   => 'users',
      } )
      should contain_file('/home/keith/logs/runsvdir').with( {
        'ensure'  => 'directory',
        'mode'    => '0755',
        'owner'   => 'keith',
        'group'   => 'users',
      } )
    }
  end
end
