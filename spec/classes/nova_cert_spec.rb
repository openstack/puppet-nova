require 'spec_helper'

describe 'nova::cert' do

  let :pre_condition do
    'include nova'
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      let (:platform_params) do
        case facts[:osfamily]
        when 'Debian'
          it_behaves_like 'generic nova service', {
            :name         => 'nova-cert',
            :package_name => 'nova-cert',
            :service_name => 'nova-cert' }
        when 'RedHat'
          it_behaves_like 'generic nova service', {
            :name         => 'nova-cert',
            :package_name => 'openstack-nova-cert',
            :service_name => 'openstack-nova-cert' }
        end
      end
    end
  end

end
