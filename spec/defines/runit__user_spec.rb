require 'spec_helper'

describe 'runit::install', :type => 'define' do
  let(:facts) { {
    :ipaddress => '10.0.0.1',
    :osfamily  => 'RedHat',
    :id        => 'keith',
  } }
  context 'no additional parameters' do
    let(:params) { {
      :title => 'keith',
    } }
    it {
      should contain_file('/etc/runit/keith').with( {
        'ensure'  => 'directory',
        'mode'    => '0755',
      } )
      should contain_file('/etc/runit/keith/down').with( {
        'ensure'  => 'absent',
      } )
      should contain_file('/etc/runit/user/run').with( {
        'ensure'  => 'file',
        'mode'    => '0555',
        'content' => '',
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
      should contain_file('/home/keith/logs/runsvdir').with( {
        'ensure'  => 'directory',
        'mode'    => '0755',
        'owner'   => 'keith',
        'group'   => 'keith',
      } )
      should contain_file('/etc/runit/user/log').with( {
        'ensure'  => 'directory',
        'mode'    => '0755',
      } )
      should contain_file('/etc/runit/user/log/down').with( {
        'ensure'  => 'absent',
      } )
      should contain_file('/etc/runit/user/log/run').with( {
        'ensure'  => 'file',
        'mode'    => '0555',
        'content' => '',
      } )
    }
  end
  context 'group name specified' do
    let(:params) { {
      :title => 'keith',
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
        'group'   => 'keith',
      } )
    }
  end
end
