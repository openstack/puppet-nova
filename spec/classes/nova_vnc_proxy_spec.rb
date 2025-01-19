require 'spec_helper'

describe 'nova::vncproxy' do

  shared_examples 'nova_vnc_proxy' do

    let :pre_condition do
      'include nova'
    end

    let :params do
      { :enabled => true }
    end

    context 'with default parameters' do
      it { is_expected.to contain_nova_config('vnc/novncproxy_host').with_value('0.0.0.0') }
      it { is_expected.to contain_nova_config('vnc/novncproxy_port').with_value(6080) }
      it { is_expected.to contain_nova_config('vnc/auth_schemes').with_value('none') }
      it { is_expected.to contain_nova_config('vnc/vencrypt_client_key').with_ensure('absent')}
      it { is_expected.to contain_nova_config('vnc/vencrypt_client_cert').with_ensure('absent')}
      it { is_expected.to contain_nova_config('vnc/vencrypt_ca_certs').with_ensure('absent')}

      it { is_expected.to contain_package('nova-vncproxy').with(
        :name   => platform_params[:nova_vncproxy_package],
        :ensure => 'present'
      ) }
      it { is_expected.to contain_service('nova-vncproxy').with(
        :name      => platform_params[:nova_vncproxy_service],
        :hasstatus => true,
        :ensure    => 'running'
      ) }

      describe 'with manage_service as false' do
        let :params do
          {
            :manage_service => false
          }
        end

        it { is_expected.to_not contain_service('nova-vncproxy') }
      end

      describe 'with package version' do
        let :params do
          { :ensure_package => '2012.1-2' }
        end

        it { is_expected.to contain_package('nova-vncproxy').with(
            :ensure => '2012.1-2',
            :name   => platform_params[:nova_vncproxy_package],
          )
        }
      end
    end

    context 'with vencrypt' do
      let :params do
        {
          :allow_vencrypt => true,
          :vencrypt_key   => '/foo.key',
          :vencrypt_cert  => '/bar.pem',
          :vencrypt_ca    => '/baz.pem'
        }
      end
      it { is_expected.to contain_nova_config('vnc/auth_schemes').with_value('vencrypt,none') }
      it { is_expected.to contain_nova_config('vnc/vencrypt_client_key').with_value('/foo.key')}
      it { is_expected.to contain_nova_config('vnc/vencrypt_client_cert').with_value('/bar.pem')}
      it { is_expected.to contain_nova_config('vnc/vencrypt_ca_certs').with_value('/baz.pem')}
    end

    context 'with vencrypt without noauth' do
      let :params do
        {
          :allow_vencrypt => true,
          :allow_noauth => false,
          :vencrypt_key   => '/foo.key',
          :vencrypt_cert  => '/bar.pem',
          :vencrypt_ca    => '/baz.pem'
        }
      end
      it { is_expected.to contain_nova_config('vnc/auth_schemes').with_value('vencrypt') }
      it { is_expected.to contain_nova_config('vnc/vencrypt_client_key').with_value('/foo.key')}
      it { is_expected.to contain_nova_config('vnc/vencrypt_client_cert').with_value('/bar.pem')}
      it { is_expected.to contain_nova_config('vnc/vencrypt_ca_certs').with_value('/baz.pem')}
    end

    context 'with no auth method set' do
      let :params do
        {
          :allow_vencrypt => false,
          :allow_noauth   => false,
        }
      end
      it_raises 'a Puppet::Error', /Either allow_noauth or allow_vencrypt must be true/
    end

    context 'with vencrypt missing ca' do
      let :params do
        {
          :allow_vencrypt => true,
          :allow_noauth => false,
          :vencrypt_key   => '/foo.key',
          :vencrypt_cert  => '/bar.pem',
        }
      end
      it_raises 'a Puppet::Error', /vencrypt_ca\/cert\/key params are required when allow_vencrypt is true/
    end

    context 'with vencrypt missing key' do
      let :params do
        {
          :allow_vencrypt => true,
          :allow_noauth => false,
          :vencrypt_cert  => '/bar.pem',
          :vencrypt_ca    => '/baz.pem'
        }
      end
      it_raises 'a Puppet::Error', /vencrypt_ca\/cert\/key params are required when allow_vencrypt is true/
    end

    context 'with vencrypt missing cert' do
      let :params do
        {
          :allow_vencrypt => true,
          :allow_noauth => false,
          :vencrypt_key   => '/foo.key',
          :vencrypt_ca    => '/baz.pem'
        }
      end
      it_raises 'a Puppet::Error', /vencrypt_ca\/cert\/key params are required when allow_vencrypt is true/
    end

  end

  shared_examples 'nova_vnc_proxy debian package' do
    let :pre_condition do
      'include nova'
    end

    it { is_expected.to contain_file_line('/etc/default/nova-consoleproxy:NOVA_CONSOLE_PROXY_TYPE').with(
      :path    => '/etc/default/nova-consoleproxy',
      :match   => '^NOVA_CONSOLE_PROXY_TYPE=(.*)$',
      :line    => 'NOVA_CONSOLE_PROXY_TYPE=novnc',
      :tag     => 'nova-consoleproxy',
      :require => 'Anchor[nova::config::begin]',
      :notify  => 'Anchor[nova::config::end]',
    )}
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      let (:platform_params) do
        case facts[:os]['family']
        when 'Debian'
          if facts[:os]['name'] == 'Debian'
            { :nova_vncproxy_package => 'nova-consoleproxy',
              :nova_vncproxy_service => 'nova-novncproxy' }
          else
            { :nova_vncproxy_package => 'nova-novncproxy',
              :nova_vncproxy_service => 'nova-novncproxy' }
          end
        when 'RedHat'
          { :nova_vncproxy_package => 'openstack-nova-novncproxy',
            :nova_vncproxy_service => 'openstack-nova-novncproxy' }
        end
      end

      it_behaves_like 'nova_vnc_proxy'

      if facts[:os]['name'] == 'Debian'
        it_behaves_like 'nova_vnc_proxy debian package'
      end

    end
  end

end
