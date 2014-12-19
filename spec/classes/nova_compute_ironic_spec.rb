require 'spec_helper'
describe 'nova::compute::ironic' do

  it 'configures ironic in nova.conf' do
    should contain_nova_config('ironic/admin_username').with_value('admin')
    should contain_nova_config('ironic/admin_password').with_value('ironic')
    should contain_nova_config('ironic/admin_url').with_value('http://127.0.0.1:35357/v2.0')
    should contain_nova_config('ironic/admin_tenant_name').with_value('services')
    should contain_nova_config('ironic/api_endpoint').with_value('http://127.0.0.1:6385/v1')
    should contain_nova_config('DEFAULT/compute_driver').with_value('nova.virt.ironic.IronicDriver')
  end

end
