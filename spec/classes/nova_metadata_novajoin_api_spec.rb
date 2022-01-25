require 'spec_helper'

describe 'nova::metadata::novajoin::api' do
  let :default_params do
    {
      :bind_address              => '127.0.0.1',
      :api_paste_config          => '/etc/novajoin/join-api-paste.ini',
      :auth_strategy             => '<SERVICE DEFAULT>',
      :auth_type                 => 'password',
      :cacert                    => '/etc/ipa/ca.crt',
      :connect_retries           => '<SERVICE DEFAULT>',
      :debug                     => '<SERVICE DEFAULT>',
      :enabled                   => true,
      :enable_ipa_client_install => true,
      :ensure_package            => 'present',
      :join_listen_port          => '<SERVICE DEFAULT>',
      :keytab                    => '/etc/novajoin/krb5.keytab',
      :log_dir                   => '/var/log/novajoin',
      :manage_service            => true,
      :username                  => 'novajoin',
      :project_domain_name       => 'Default',
      :project_name              => 'services',
      :user_domain_name          => 'Default',
      :ipa_domain                => 'EXAMPLE.COM',
      :keystone_auth_url         => 'https://keystone.example.com:5000',
      :password                  => 'my_secret_password',
      :transport_url             => 'rabbit:rabbit_pass@rabbit_host',
    }
  end

  let :pre_condition do
    "class { 'ipaclient': password => 'join_otp', }
     class { 'nova::metadata::novajoin::authtoken':
       password => 'passw0rd',
     }"
  end

  shared_examples 'nova::metadata::novajoin::api' do
    [{},
     {
       :bind_address              => '0.0.0.0',
       :api_paste_config          => '/etc/novajoin/join-api-paste.ini',
       :auth_strategy             => 'noauth2',
       :auth_type                 => 'password',
       :cacert                    => '/etc/ipa/ca.crt',
       :connect_retries           => 2,
       :debug                     => true,
       :enabled                   => false,
       :enable_ipa_client_install => false,
       :ensure_package            => 'present',
       :join_listen_port          => '9921',
       :keytab                    => '/etc/krb5.conf',
       :log_dir                   => '/var/log/novajoin',
       :manage_service            => true,
       :username                  => 'novajoin1',
       :project_domain_name       => 'Default',
       :project_name              => 'services',
       :user_domain_name          => 'Default',
       :ipa_domain                => 'EXAMPLE2.COM',
       :keystone_auth_url         => 'https://keystone2.example.com:5000',
       :password                  => 'my_secret_password2',
       :transport_url             => 'rabbit:rabbit_pass2@rabbit_host',
     }
    ].each do |param_set|
      context "when #{param_set == {} ? "using default" : "specifying"} class parameters" do
        let :param_hash do
          default_params.merge(param_set)
        end

        let :params do
          param_hash
        end

        it { should contain_class('nova::metadata::novajoin::authtoken') }

        it { should contain_service('novajoin-server').with(
          'ensure'     => (param_hash[:manage_service] && param_hash[:enabled]) ? 'running': 'stopped',
          'enable'     => param_hash[:enabled],
          'hasstatus'  => true,
          'hasrestart' => true,
          'tag'        => 'openstack',
        )}

        it { should contain_service('novajoin-notify').with(
          'ensure'     => (param_hash[:manage_service] && param_hash[:enabled]) ? 'running': 'stopped',
          'enable'     => param_hash[:enabled],
          'hasstatus'  => true,
          'hasrestart' => true,
          'tag'        => 'openstack',
        )}

        it {
          should contain_novajoin_config('DEFAULT/join_listen').with_value(param_hash[:bind_address])
          should contain_novajoin_config('DEFAULT/api_paste_config').with_value(param_hash[:api_paste_config])
          should contain_novajoin_config('DEFAULT/auth_strategy').with_value(param_hash[:auth_strategy])
          should contain_novajoin_config('DEFAULT/cacert').with_value(param_hash[:cacert])
          should contain_novajoin_config('DEFAULT/connect_retries').with_value(param_hash[:connect_retries])
          should contain_novajoin_config('DEFAULT/debug').with_value(param_hash[:debug])
          should contain_novajoin_config('DEFAULT/join_listen_port').with_value(param_hash[:join_listen_port])
          should contain_novajoin_config('DEFAULT/keytab').with_value(param_hash[:keytab])
          should contain_novajoin_config('DEFAULT/log_dir').with_value(param_hash[:log_dir])
          should contain_novajoin_config('DEFAULT/domain').with_value(param_hash[:ipa_domain])
          should contain_novajoin_config('DEFAULT/transport_url').with_value(param_hash[:transport_url])
        }

        it {
          should contain_novajoin_config('service_credentials/auth_type').with_value(param_hash[:auth_type])
          should contain_novajoin_config('service_credentials/auth_url').with_value(param_hash[:keystone_auth_url])
          should contain_novajoin_config('service_credentials/password').with_value(param_hash[:password])
          should contain_novajoin_config('service_credentials/project_name').with_value(param_hash[:project_name])
          should_not contain_novajoin_config('service_credentials/user_domain_id')
          should contain_novajoin_config('service_credentials/user_domain_name').with_value(param_hash[:user_domain_name])
          should contain_novajoin_config('service_credentials/project_domain_name').with_value(param_hash[:project_domain_name])
          should contain_novajoin_config('service_credentials/username').with_value(param_hash[:username])
        }

        it {
          if param_hash[:enable_ipa_client_install]
            should contain_exec('get-service-user-keytab').with(
              'command' => "/usr/bin/kinit -kt /etc/krb5.keytab && ipa-getkeytab -s `grep xmlrpc_uri /etc/ipa/default.conf | cut -d/ -f3` \
-p nova/undercloud.example.com -k #{param_hash[:keytab]}",
            )
          else
            should contain_exec('get-service-user-keytab').with(
              'command' => "/usr/bin/kinit -kt /etc/krb5.keytab && ipa-getkeytab -s ipa.ipadomain \
-p nova/undercloud.example.com -k #{param_hash[:keytab]}",
            )
          end
        }

        it { should contain_file("/var/log/novajoin").with(
          'ensure'  => 'directory',
          'owner'   => "#{param_hash[:username]}",
          'group'   => "#{param_hash[:username]}",
          'recurse' => true
        )}

        it { should contain_file("#{param_hash[:keytab]}").with(
          'owner'   => "#{param_hash[:username]}",
          'require' => 'Exec[get-service-user-keytab]',
        )}
      end
    end

    context 'with disabled service managing' do
      let :params do
        {
          :manage_service => false,
          :enabled        => false,
          :ipa_domain     => 'EXAMPLE.COM',
          :password       => 'my_secret_password',
          :transport_url  => 'rabbit:rabbit_pass@rabbit_host',
        }
      end

      it { should contain_service('novajoin-server').with(
        'ensure'     => nil,
        'enable'     => false,
        'hasstatus'  => true,
        'hasrestart' => true,
        'tag'        => 'openstack',
      )}

      it { should contain_service('novajoin-notify').with(
        'ensure'     => nil,
        'enable'     => false,
        'hasstatus'  => true,
        'hasrestart' => true,
        'tag'        => 'openstack',
      )}
    end
  end

  shared_examples 'nova::metadata::novajoin::api on RedHat' do
    let :params do
      default_params
    end

    it { should contain_package('python-novajoin').with(
        :name => platform_params[:novajoin_package_name],
        :tag  => ['openstack', 'novajoin-package'],
    )}
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({ :ipa_hostname => 'ipa.ipadomain',
                                            :fqdn         => "undercloud.example.com" }))
      end

      if facts[:osfamily] == 'RedHat'
        it_behaves_like 'nova::metadata::novajoin::api'
        it_behaves_like 'nova::metadata::novajoin::api on RedHat'
        let (:platform_params) do
          { :novajoin_package_name => 'python3-novajoin' }
        end
      end
    end
  end
end
