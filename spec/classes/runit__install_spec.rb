require 'spec_helper'

describe 'runit::install', :type => 'class' do
  let(:facts) { {
    :ipaddress => '10.0.0.1',
    :osfamily  => 'RedHat'
  } }
  context 'no parameters' do
    let(:params) { {} }
    it {
      should contain_file('runit-rpm').with( {
        'ensure'  => 'file',
        'path'    => '/root/runit-2.1.1-6.el6.x86_64.rpm',
      } )
      should contain_package('runit').with( {
        'ensure'   => 'installed',
        'provider' => 'rpm',
        'source'   => '/root/runit-2.1.1-6.el6.x86_64.rpm',
      } )
    }
  end
  context 'package name specified' do
    let(:params) { {
      :package_file => 'runit-1.8.0-1.el6.x86_64.rpm',
    } }
    it {
      should contain_file('runit-rpm').with( {
        'ensure'  => 'file',
        'path'    => '/root/runit-1.8.0-1.el6.x86_64.rpm',
      } )
      should contain_package('runit').with( {
        'ensure'   => 'installed',
        'provider' => 'rpm',
        'source'   => '/root/runit-1.8.0-1.el6.x86_64.rpm',
      } )
    }
  end
end
