require 'spec_helper'

describe 'runit', :type => 'class' do
  let(:facts) { {
    :ipaddress => '10.0.0.1',
    :osfamily  => 'RedHat'
  } }
  context 'no parameters' do
    let(:params) { { }  }
    it {
      should create_class('runit::install').with( {
        'package_file' => 'runit-2.1.1-6.el6.x86_64.rpm',
      } )
      should create_class('runit::service')
    }
  end
  context 'package_file specified' do
    let(:params) { {
      :package_file => 'runit-1.8.0-1.el6.x86_64.rpm',
    }  }
    it {
      should create_class('runit::install').with( {
        'package_file' => 'runit-1.8.0-1.el6.x86_64.rpm',
      } )
      should create_class('runit::service')
    }
  end
end
