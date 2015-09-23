require 'spec_helper'

describe 'nova::rabbitmq' do

  let :facts do
    {
      :puppetversion => '2.7',
      :osfamily => 'Debian'
    }
  end

  describe 'with defaults' do

    it 'should contain all of the default resources' do

      is_expected.to contain_rabbitmq_vhost('/').with(
        :provider => 'rabbitmqctl'
      )
    end

  end

  describe 'when a rabbitmq user is specified' do

    let :params do
      {
        :userid   => 'dan',
        :password => 'pass'
      }
    end

    it 'should contain user and permissions' do

      is_expected.to contain_rabbitmq_user('dan').with(
        :admin    => true,
        :password => 'pass',
        :provider => 'rabbitmqctl'
      )

      is_expected.to contain_rabbitmq_user_permissions('dan@/').with(
        :configure_permission => '.*',
        :write_permission     => '.*',
        :read_permission      => '.*',
        :provider             => 'rabbitmqctl'
      )

    end

  end

  describe 'when disabled' do
    let :params do
      {
        :userid   => 'dan',
        :password => 'pass',
        :enabled  => false
      }
    end

    it 'should be disabled' do

      is_expected.to_not contain_rabbitmq_user('dan')
      is_expected.to_not contain_rabbitmq_user_permissions('dan@/')
      is_expected.to_not contain_rabbitmq_vhost('/')

    end
  end

end
