require 'spec_helper'

describe 'nova::objectstore' do

  let :pre_condition do
    'include nova'
  end

  context 'on Debian platforms' do
    let :facts do
      { :osfamily => 'Debian' }
    end

    it_behaves_like 'generic nova service', {
      :name         => 'nova-objectstore',
      :package_name => 'nova-objectstore',
      :service_name => 'nova-objectstore' }
  end

  context 'on RedHat platforms' do
    let :facts do
      { :osfamily => 'RedHat' }
    end

    it_behaves_like 'generic nova service', {
      :name         => 'nova-objectstore',
      :package_name => 'openstack-nova-objectstore',
      :service_name => 'openstack-nova-objectstore' }
  end
end
