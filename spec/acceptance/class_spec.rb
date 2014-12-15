require 'spec_helper_acceptance'

describe 'nova class' do

  context 'default parameters' do

    it 'should work with no errors' do
      pp= <<-EOS
      include epel # Get our epel on
      class { 'nova':
        database_connection => 'mysql://nova:a_big_secret@127.0.0.1/nova?charset=utf8',
        rabbit_userid       => 'nova',
        rabbit_password     => 'an_even_bigger_secret',
        image_service       => 'nova.image.glance.GlanceImageService',
        glance_api_servers  => 'localhost:9292',
        verbose             => false,
        rabbit_host         => '127.0.0.1',
        mysql_module        => '2.2',
      }

      class { 'nova::compute':
        enabled                       => true,
        vnc_enabled                   => true,
      }

      class { 'nova::compute::libvirt':
        migration_support => true,
        vncserver_listen  => '0.0.0.0',
      }
      EOS


      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

  end
end
