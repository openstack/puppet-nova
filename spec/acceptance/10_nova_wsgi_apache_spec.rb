require 'spec_helper_acceptance'

describe 'basic nova' do

  context 'default parameters' do

    it 'should work with no errors' do
      pp= <<-EOS
      include openstack_integration
      include openstack_integration::repos
      include openstack_integration::apache
      include openstack_integration::rabbitmq
      include openstack_integration::mysql
      include openstack_integration::memcached
      include openstack_integration::keystone
      include openstack_integration::neutron
      include openstack_integration::placement
      include openstack_integration::nova

      nova_aggregate { 'test_aggregate':
        ensure            => present,
        availability_zone => 'zone1',
        metadata          => 'test=property',
        require           => Class['nova::api'],
      }

      nova_flavor { 'public_flavor':
        ensure => present,
        name   => 'public_flavor',
        id     => '42',
        ram    => '512',
        disk   => '1',
        vcpus  => '1',
      }
      nova_flavor { 'private_flavor':
        ensure       => present,
        name         => 'private_flavor',
        id           => '43',
        ram          => '512',
        disk         => '1',
        vcpus        => '1',
        is_public    => 'False',
        project_name => 'services'
      }
      EOS


      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe port(8774) do
      it { is_expected.to be_listening }
    end

    describe port(8775) do
      it { is_expected.to be_listening }
    end

    describe port(6080) do
      it { is_expected.to be_listening }
    end

    describe cron do
      it { is_expected.to have_entry('1 0 * * * nova-manage db archive_deleted_rows --max_rows 100 >>/var/log/nova/nova-rowsflush.log 2>&1').with_user('nova') }
    end

    describe 'nova aggregate' do
      it 'should create new aggregate' do
        command('openstack --os-identity-api-version 3 --os-username nova --os-password a_big_secret --os-project-name services --os-user-domain-name Default --os-project-domain-name Default --os-auth-url http://127.0.0.1:5000/v3 aggregate list') do |r|
          expect(r.stdout).to match(/test_aggregate/)
        end
      end
    end
    describe 'nova flavor' do
      it 'should create new flavor' do
        command('openstack --os-identity-api-version 3 --os-username nova --os-password a_big_secret --os-project-name services --os-user-domain-name Default --os-project-domain-name Default --os-auth-url http://127.0.0.1:5000/v3 flavor list') do |r|
          expect(r.stdout).to match(/public_flavor/)
          expect(r.stdout).to match(/private_flavor/)
        end
      end
    end
  end
end
