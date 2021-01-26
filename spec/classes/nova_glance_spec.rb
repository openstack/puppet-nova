require 'spec_helper'

describe 'nova::glance' do

  shared_examples_for 'nova::glance' do
    context 'with default params' do
      let :params do
        {}
      end

      it 'configure default params' do
        is_expected.to contain_nova_config('glance/endpoint_override').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('glance/num_retries').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('glance/enable_rbd_download').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('glance/rbd_user').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('glance/rbd_connect_timeout').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('glance/rbd_pool').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('glance/rbd_ceph_conf').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with specific parameters' do
      let :params do
        {
          :endpoint_override   => 'http://localhost:9292',
          :num_retries         => 3,
          :enable_rbd_download => true,
          :rbd_user            => 'nova',
          :rbd_connect_timeout => 5,
          :rbd_pool            => 'images',
          :rbd_ceph_conf       => '/etc/ceph/ceph.conf',
        }
      end

      it 'configure glance params' do
        is_expected.to contain_nova_config('glance/endpoint_override').with_value('http://localhost:9292')
        is_expected.to contain_nova_config('glance/num_retries').with_value(3)
        is_expected.to contain_nova_config('glance/enable_rbd_download').with_value(true)
        is_expected.to contain_nova_config('glance/rbd_user').with_value('nova')
        is_expected.to contain_nova_config('glance/rbd_connect_timeout').with_value(5)
        is_expected.to contain_nova_config('glance/rbd_pool').with_value('images')
        is_expected.to contain_nova_config('glance/rbd_ceph_conf').with_value('/etc/ceph/ceph.conf')
      end
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'nova::glance'
    end
  end

end
