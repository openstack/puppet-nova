require 'spec_helper'

describe 'nova::consoleauth' do

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
            :name         => 'nova-consoleauth',
            :package_name => 'nova-consoleauth',
            :service_name => 'nova-consoleauth' }
        when 'RedHat'
          it_behaves_like 'generic nova service', {
            :name         => 'nova-consoleauth',
            :package_name => 'openstack-nova-console',
            :service_name => 'openstack-nova-consoleauth' }
        end
      end
    end
  end

end
