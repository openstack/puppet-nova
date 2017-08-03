require 'spec_helper'

describe 'nova::client' do

  shared_examples_for 'nova client' do

    it { is_expected.to contain_class('nova::deps') }

    it 'installs nova client package' do
      is_expected.to contain_package('python-novaclient').with(
        :ensure => 'present',
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

      it_behaves_like 'nova client'
    end
  end

end
