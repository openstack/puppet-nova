require 'spec_helper'

describe 'nova::compute::libvirt::qemu' do

  shared_examples_for 'nova compute libvirt with qemu' do

    context 'when not configuring qemu' do
      it 'should remove all configuations' do
        is_expected.to contain_qemu_config('max_files').with_ensure('absent')
        is_expected.to contain_qemu_config('max_processes').with_ensure('absent')
        is_expected.to contain_qemu_config('vnc_tls').with_ensure('absent')
        is_expected.to contain_qemu_config('vnc_tls_x509_verify').with_ensure('absent')
        is_expected.to contain_qemu_config('default_tls_x509_verify').with_ensure('absent')
        is_expected.to contain_qemu_config('user').with_ensure('absent')
        is_expected.to contain_qemu_config('group').with_ensure('absent')
        is_expected.to contain_qemu_config('memory_backing_dir').with_ensure('absent')
        is_expected.to contain_qemu_config('nbd_tls').with_ensure('absent')
      end
    end

    context 'when configuring qemu with defaults' do
      let :params do
        {
          :configure_qemu => true,
        }
      end
      it 'should configure the default values' do
        is_expected.to contain_qemu_config('max_files').with_value(1024)
        is_expected.to contain_qemu_config('max_processes').with_value(4096)
        is_expected.to contain_qemu_config('vnc_tls').with_value(false)
        is_expected.to contain_qemu_config('vnc_tls_x509_verify').with_value(false)
        is_expected.to contain_qemu_config('default_tls_x509_verify').with_value(true)
        is_expected.to contain_qemu_config('user').with_ensure('absent')
        is_expected.to contain_qemu_config('group').with_ensure('absent')
        is_expected.to contain_qemu_config('memory_backing_dir').with_ensure('absent')
        is_expected.to contain_qemu_config('nbd_tls').with_value(false)
      end
    end

    context 'when configuring qemu with overridden parameters' do
      let :params do
        {
          :configure_qemu     => true,
          :max_files          => 32768,
          :max_processes      => 131072,
          :user               => 'qemu-user',
          :group              => 'qemu-group',
          :memory_backing_dir => '/tmp',
        }
      end
      it 'should configure the given values' do
        is_expected.to contain_qemu_config('max_files').with_value(32768)
        is_expected.to contain_qemu_config('max_processes').with_value(131072)
        is_expected.to contain_qemu_config('user').with_value('qemu-user').with_quote(true)
        is_expected.to contain_qemu_config('group').with_value('qemu-group').with_quote(true)
        is_expected.to contain_qemu_config('memory_backing_dir').with_value('/tmp').with_quote(true)
      end
    end

    context 'when configuring qemu with vnc_tls' do
      let :params do
        {
          :configure_qemu => true,
          :vnc_tls        => true,
        }
      end
      it 'should configure vnc tls' do
        is_expected.to contain_qemu_config('vnc_tls').with_value(true)
        is_expected.to contain_qemu_config('vnc_tls_x509_verify').with_value(true)
      end
    end

    context 'when configuring qemu with default_tls_verify enabled' do
      let :params do
        {
          :configure_qemu     => true,
          :default_tls_verify => true,
        }
      end
      it 'should enable default_tls_x509_verify' do
        is_expected.to contain_qemu_config('default_tls_x509_verify').with_value(true)
      end
    end

    context 'when configuring qemu with vnc_tls_verify disabled' do
      let :params do
        {
          :configure_qemu => true,
          :vnc_tls        => true,
          :vnc_tls_verify => false,
        }
      end
      it 'should disable vnc_tls_x509_veridy' do
        is_expected.to contain_qemu_config('vnc_tls').with_value(true)
        is_expected.to contain_qemu_config('vnc_tls_x509_verify').with_value(false)
      end
    end

    context 'when configuring qemu with default_tls_verify disabled' do
      let :params do
        {
          :configure_qemu     => true,
          :default_tls_verify => false,
        }
      end
      it 'should disable default_tls_x509_verify' do
        is_expected.to contain_qemu_config('default_tls_x509_verify').with_value(false)
      end
    end

    context 'when configuring qemu with nbd_tls' do
      let :params do
        {
          :configure_qemu => true,
          :nbd_tls        => true,
        }
      end
      it 'should enable nbd_tls' do
        is_expected.to contain_qemu_config('nbd_tls').with_value(true)
      end
    end

  end

  on_supported_os({
     :supported_os => OSDefaults.get_supported_os
   }).each do |os,facts|
     context "on #{os}" do
       let (:facts) do
         facts.merge!(OSDefaults.get_facts())
       end

      it_configures 'nova compute libvirt with qemu'
     end
  end
end
