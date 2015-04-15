require 'spec_helper'

describe 'nova::api' do

  let :pre_condition do
    'include nova'
  end

  let :params do
    { :admin_password => 'passw0rd' }
  end

  let :facts do
    { :processorcount => 5 }
  end

  shared_examples 'nova-api' do

    context 'with default parameters' do

      it 'installs nova-api package and service' do
        should contain_service('nova-api').with(
          :name      => platform_params[:nova_api_service],
          :ensure    => 'stopped',
          :hasstatus => true,
          :enable    => false
        )
        should contain_package('nova-api').with(
          :name   => platform_params[:nova_api_package],
          :ensure => 'present',
          :notify => 'Service[nova-api]',
          :tag    => ['openstack', 'nova']
        )
        should_not contain_exec('validate_nova_api')
      end

      it 'configures keystone_authtoken middleware' do
        should contain_nova_config(
         'keystone_authtoken/auth_host').with_value('127.0.0.1')
        should contain_nova_config(
          'keystone_authtoken/auth_port').with_value('35357')
        should contain_nova_config(
          'keystone_authtoken/auth_protocol').with_value('http')
        should contain_nova_config(
          'keystone_authtoken/auth_uri').with_value('http://127.0.0.1:5000/')
        should contain_nova_config(
          'keystone_authtoken/auth_admin_prefix').with_ensure('absent')
        should contain_nova_config(
          'keystone_authtoken/auth_version').with_ensure('absent')
        should contain_nova_config(
          'keystone_authtoken/admin_tenant_name').with_value('services')
        should contain_nova_config(
          'keystone_authtoken/admin_user').with_value('nova')
        should contain_nova_config(
          'keystone_authtoken/admin_password').with_value('passw0rd').with_secret(true)
      end

      it 'configures various stuff' do
        should contain_nova_config('DEFAULT/ec2_listen').with('value' => '0.0.0.0')
        should contain_nova_config('DEFAULT/osapi_compute_listen').with('value' => '0.0.0.0')
        should contain_nova_config('DEFAULT/metadata_listen').with('value' => '0.0.0.0')
        should contain_nova_config('DEFAULT/osapi_volume_listen').with('value' => '0.0.0.0')
        should contain_nova_config('DEFAULT/osapi_compute_workers').with('value' => '5')
        should contain_nova_config('DEFAULT/ec2_workers').with('value' => '5')
        should contain_nova_config('DEFAULT/metadata_workers').with('value' => '5')
      end

      it 'do not configure v3 api' do
        should contain_nova_config('osapi_v3/enabled').with('value' => false)
      end

      it 'unconfigures neutron_metadata proxy' do
        should contain_nova_config('neutron/service_metadata_proxy').with(:value => false)
        should contain_nova_config('neutron/metadata_proxy_shared_secret').with(:ensure => 'absent')
      end
    end

    context 'with deprecated parameters' do
      before do
        params.merge!({
          :workers           => 1,
        })
      end
      it 'configures various stuff' do
        should contain_nova_config('DEFAULT/osapi_compute_workers').with('value' => '1')
      end
    end

    context 'with overridden parameters' do
      before do
        params.merge!({
          :enabled                              => true,
          :ensure_package                       => '2012.1-2',
          :auth_host                            => '10.0.0.1',
          :auth_port                            => 1234,
          :auth_protocol                        => 'https',
          :auth_admin_prefix                    => '/keystone/admin',
          :auth_uri                             => 'https://10.0.0.1:9999/',
          :auth_version                         => 'v3.0',
          :admin_tenant_name                    => 'service2',
          :admin_user                           => 'nova2',
          :admin_password                       => 'passw0rd2',
          :api_bind_address                     => '192.168.56.210',
          :metadata_listen                      => '127.0.0.1',
          :volume_api_class                     => 'nova.volume.cinder.API',
          :use_forwarded_for                    => false,
          :ratelimits                           => '(GET, "*", .*, 100, MINUTE);(POST, "*", .*, 200, MINUTE)',
          :neutron_metadata_proxy_shared_secret => 'secrete',
          :osapi_compute_workers                => 1,
          :metadata_workers                     => 2,
          :osapi_v3                             => true,
          :keystone_ec2_url                     => 'https://example.com:5000/v2.0/ec2tokens',
          :pci_alias                            => "[{\"vendor_id\":\"8086\",\"product_id\":\"0126\",\"name\":\"graphic_card\"},{\"vendor_id\":\"9096\",\"product_id\":\"1520\",\"name\":\"network_card\"}]"
        })
      end

      it 'installs nova-api package and service' do
        should contain_package('nova-api').with(
          :name   => platform_params[:nova_api_package],
          :ensure => '2012.1-2',
          :tag    => ['openstack', 'nova']
        )
        should contain_service('nova-api').with(
          :name      => platform_params[:nova_api_service],
          :ensure    => 'running',
          :hasstatus => true,
          :enable    => true
        )
      end

      it 'configures keystone_authtoken middleware' do
        should contain_nova_config(
          'keystone_authtoken/auth_host').with_value('10.0.0.1')
        should contain_nova_config(
          'keystone_authtoken/auth_port').with_value('1234')
        should contain_nova_config(
          'keystone_authtoken/auth_protocol').with_value('https')
        should contain_nova_config(
          'keystone_authtoken/auth_admin_prefix').with_value('/keystone/admin')
        should contain_nova_config(
          'keystone_authtoken/auth_uri').with_value('https://10.0.0.1:9999/')
        should contain_nova_config(
          'keystone_authtoken/auth_version').with_value('v3.0')
        should contain_nova_config(
          'keystone_authtoken/admin_tenant_name').with_value('service2')
        should contain_nova_config(
          'keystone_authtoken/admin_user').with_value('nova2')
        should contain_nova_config(
          'keystone_authtoken/admin_password').with_value('passw0rd2').with_secret(true)
        should contain_nova_paste_api_ini(
          'filter:ratelimit/limits').with_value('(GET, "*", .*, 100, MINUTE);(POST, "*", .*, 200, MINUTE)')
      end

      it 'configures various stuff' do
        should contain_nova_config('DEFAULT/ec2_listen').with('value' => '192.168.56.210')
        should contain_nova_config('DEFAULT/osapi_compute_listen').with('value' => '192.168.56.210')
        should contain_nova_config('DEFAULT/metadata_listen').with('value' => '127.0.0.1')
        should contain_nova_config('DEFAULT/osapi_volume_listen').with('value' => '192.168.56.210')
        should contain_nova_config('DEFAULT/use_forwarded_for').with('value' => false)
        should contain_nova_config('DEFAULT/osapi_compute_workers').with('value' => '1')
        should contain_nova_config('DEFAULT/metadata_workers').with('value' => '2')
        should contain_nova_config('neutron/service_metadata_proxy').with('value' => true)
        should contain_nova_config('neutron/metadata_proxy_shared_secret').with('value' => 'secrete')
        should contain_nova_config('DEFAULT/keystone_ec2_url').with('value' => 'https://example.com:5000/v2.0/ec2tokens')
      end

      it 'configure nova api v3' do
        should contain_nova_config('osapi_v3/enabled').with('value' => true)
      end

      it 'configures nova pci_alias entries' do
        should contain_nova_config('DEFAULT/pci_alias').with(
          'value' => "[{\"vendor_id\":\"8086\",\"product_id\":\"0126\",\"name\":\"graphic_card\"},{\"vendor_id\":\"9096\",\"product_id\":\"1520\",\"name\":\"network_card\"}]"
        )
      end
    end

    [
      '/keystone/',
      'keystone/',
      'keystone',
      '/keystone/admin/',
      'keystone/admin/',
      'keystone/admin'
    ].each do |auth_admin_prefix|
      context "with auth_admin_prefix_containing incorrect value #{auth_admin_prefix}" do
        before do
          params.merge!({ :auth_admin_prefix => auth_admin_prefix })
        end
        it { expect { should contain_nova_config('keystone_authtoken/auth_admin_prefix') }.to \
          raise_error(Puppet::Error, /validate_re\(\): "#{auth_admin_prefix}" does not match/) }
      end
    end

    context 'while validating the service with default command' do
      before do
        params.merge!({
          :validate => true,
        })
      end
      it { should contain_exec('execute nova-api validation').with(
        :path        => '/usr/bin:/bin:/usr/sbin:/sbin',
        :provider    => 'shell',
        :tries       => '10',
        :try_sleep   => '2',
        :command     => 'nova --os-auth-url http://127.0.0.1:5000/ --os-tenant-name services --os-username nova --os-password passw0rd flavor-list',
      )}

      it { should contain_anchor('create nova-api anchor').with(
        :require => 'Exec[execute nova-api validation]',
      )}
    end

    context 'while validating the service with custom command' do
      before do
        params.merge!({
          :validate            => true,
          :validation_options  => { 'nova-api' => { 'command' => 'my-script' } }
        })
      end
      it { should contain_exec('execute nova-api validation').with(
        :path        => '/usr/bin:/bin:/usr/sbin:/sbin',
        :provider    => 'shell',
        :tries       => '10',
        :try_sleep   => '2',
        :command     => 'my-script',
      )}

      it { should contain_anchor('create nova-api anchor').with(
        :require => 'Exec[execute nova-api validation]',
      )}
    end

    context 'while not managing service state' do
      before do
        params.merge!({
          :enabled           => false,
          :manage_service    => false,
        })
      end

      it { should contain_service('nova-api').without_ensure }
    end

    context 'with default database parameters' do
      let :pre_condition do
        "include nova"
      end

      it { should_not contain_nova_config('database/connection') }
      it { should_not contain_nova_config('database/slave_connection') }
      it { should_not contain_nova_config('database/idle_timeout').with_value('3600') }
    end

    context 'with overridden database parameters' do
      let :pre_condition do
        "class { 'nova':
           database_connection   => 'mysql://user:pass@db/db',
           slave_connection      => 'mysql://user:pass@slave/db',
           database_idle_timeout => '30',
         }
        "
      end

      it { should contain_nova_config('database/connection').with_value('mysql://user:pass@db/db').with_secret(true) }
      it { should contain_nova_config('database/slave_connection').with_value('mysql://user:pass@slave/db').with_secret(true) }
      it { should contain_nova_config('database/idle_timeout').with_value('30') }
    end

  end

  context 'on Debian platforms' do
    before do
      facts.merge!( :osfamily => 'Debian' )
    end

    let :platform_params do
      { :nova_api_package => 'nova-api',
        :nova_api_service => 'nova-api' }
    end

    it_behaves_like 'nova-api'
  end

  context 'on RedHat platforms' do
    before do
      facts.merge!( :osfamily => 'RedHat' )
    end

    let :platform_params do
      { :nova_api_package => 'openstack-nova-api',
        :nova_api_service => 'openstack-nova-api' }
    end

    it_behaves_like 'nova-api'
  end

end
