require 'spec_helper'

describe 'nova::client' do

  shared_examples_for 'nova client' do

    it { is_expected.to contain_class('nova::deps') }
    it { is_expected.to contain_class('nova::params') }

    it 'installs nova client package' do
      is_expected.to contain_package('python-novaclient').with(
        :ensure => 'present',
        :name   => platform_params[:client_package_name],
        :tag    => ['openstack', 'nova-support-package']
      )
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      let(:platform_params) do
        case facts[:osfamily]
        when 'Debian'
          { :client_package_name => 'python3-novaclient' }
        when 'RedHat'
          if facts[:operatingsystemmajrelease] > '7'
            { :client_package_name => 'python3-novaclient' }
          else
            { :client_package_name => 'python-novaclient' }
          end
        end
      end

      it_behaves_like 'nova client'
    end
  end

end
