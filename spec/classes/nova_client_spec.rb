require 'spec_helper'

describe 'nova::client' do

  shared_examples_for 'nova client' do

    it { is_expected.to contain_class('nova::deps') }
    it { is_expected.to contain_class('nova::params') }

    it 'installs nova client package' do
      is_expected.to contain_package('python-novaclient').with(
        :ensure => 'present',
        :name   => platform_params[:client_package_name],
        :tag    => 'openstack',
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
        case facts[:os]['family']
        when 'Debian'
          { :client_package_name => 'python3-novaclient' }
        when 'RedHat'
          { :client_package_name => 'python3-novaclient' }
        end
      end

      it_behaves_like 'nova client'
    end
  end

end
