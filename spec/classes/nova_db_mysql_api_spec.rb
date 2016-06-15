require 'spec_helper'

describe 'nova::db::mysql_api' do

  shared_examples_for 'nova::db::mysql_api' do

    let :pre_condition do
      'include mysql::server'
    end

    let :required_params do
      { :password => "qwerty" }
    end

    context 'with only required params' do
      let :params do
        required_params
      end
      it { is_expected.to contain_openstacklib__db__mysql('nova_api').with(
        :user          => 'nova_api',
        :password_hash => '*AA1420F182E88B9E5F874F6FBE7459291E8F4601',
        :charset       => 'utf8',
        :collate       => 'utf8_general_ci',
      )}
    end

    context 'overriding allowed_hosts param to array' do
      let :params do
        { :password       => 'novapass',
          :allowed_hosts  => ['127.0.0.1','%'],
        }.merge(required_params)
      end

      it { is_expected.to contain_openstacklib__db__mysql('nova_api').with(
        :user          => 'nova_api',
        :password_hash => '*AA1420F182E88B9E5F874F6FBE7459291E8F4601',
        :charset       => 'utf8',
        :collate       => 'utf8_general_ci',
        :allowed_hosts => ['127.0.0.1','%'],
      )}
    end

    context 'overriding allowed_hosts param to string' do
      let :params do
        { :password       => 'novapass2',
          :allowed_hosts  => '192.168.1.1',
        }.merge(required_params)
      end

      it { is_expected.to contain_openstacklib__db__mysql('nova_api').with(
        :user          => 'nova_api',
        :password_hash => '*AA1420F182E88B9E5F874F6FBE7459291E8F4601',
        :charset       => 'utf8',
        :collate       => 'utf8_general_ci',
        :allowed_hosts => '192.168.1.1',
      )}
    end

    context 'when overriding charset' do
      let :params do
        { :password => 'novapass',
          :charset => 'latin1',
        }.merge(required_params)
      end

      it { is_expected.to contain_openstacklib__db__mysql('nova_api').with(
        :charset => 'latin1',
      )}
    end

  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_configures 'nova::db::mysql_api'
    end
  end

end
