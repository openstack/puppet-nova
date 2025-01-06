require 'spec_helper'

describe 'nova::wsgi::apache_metadata' do
  shared_examples_for 'apache serving nova-metadata with mod_wsgi' do
    context 'with default parameters' do

      let :pre_condition do
        "include nova
         class { 'nova::keystone::authtoken':
           password => 'secrete',
         }
         class { 'nova::metadata': }"
      end
      it { is_expected.to contain_class('nova::params') }
      it { is_expected.to contain_openstacklib__wsgi__apache('nova_metadata_wsgi').with(
        :bind_port                   => 8775,
        :group                       => 'nova',
        :path                        => '/',
        :priority                    => 10,
        :servername                  => 'foo.example.com',
        :ssl                         => false,
        :threads                     => 1,
        :user                        => 'nova',
        :workers                     => facts[:os_workers],
        :wsgi_daemon_process         => 'nova-metadata',
        :wsgi_process_group          => 'nova-metadata',
        :wsgi_script_dir             => platform_params[:wsgi_script_path],
        :wsgi_script_file            => 'nova-metadata-api',
        :wsgi_script_source          => platform_params[:metadata_wsgi_script_source],
        :headers                     => nil,
        :request_headers             => nil,
        :custom_wsgi_process_options => {},
        :access_log_file             => nil,
        :access_log_pipe             => nil,
        :access_log_syslog           => nil,
        :access_log_format           => nil,
        :access_log_env_var          => nil,
        :error_log_file              => nil,
        :error_log_pipe              => nil,
        :error_log_syslog            => nil,
      )}
    end

    context 'when overriding parameters' do
      let :pre_condition do
        "include nova
         class { 'nova::keystone::authtoken':
           password => 'secrete',
         }
         class { 'nova::metadata': }"
      end

      let :params do
        {
          :servername                  => 'dummy.host',
          :bind_host                   => '10.42.51.1',
          :port                        => 12345,
          :ssl                         => true,
          :vhost_custom_fragment       => 'Timeout 99',
          :wsgi_process_display_name   => 'nova-metadata',
          :workers                     => 37,
          :custom_wsgi_process_options => {
            'python_path' => '/my/python/path',
          },
          :headers                     => ['set X-XSS-Protection "1; mode=block"'],
          :request_headers             => ['set Content-Type "application/json"'],
        }
      end

      it { is_expected.to contain_class('nova::params') }
      it { is_expected.to contain_openstacklib__wsgi__apache('nova_metadata_wsgi').with(
        :bind_host                   => '10.42.51.1',
        :bind_port                   => 12345,
        :group                       => 'nova',
        :path                        => '/',
        :servername                  => 'dummy.host',
        :ssl                         => true,
        :threads                     => 1,
        :user                        => 'nova',
        :vhost_custom_fragment       => 'Timeout 99',
        :workers                     => 37,
        :wsgi_daemon_process         => 'nova-metadata',
        :wsgi_process_display_name   => 'nova-metadata',
        :wsgi_process_group          => 'nova-metadata',
        :wsgi_script_dir             => platform_params[:wsgi_script_path],
        :wsgi_script_file            => 'nova-metadata-api',
        :wsgi_script_source          => platform_params[:metadata_wsgi_script_source],
        :headers                     => ['set X-XSS-Protection "1; mode=block"'],
        :request_headers             => ['set Content-Type "application/json"'],
        :custom_wsgi_process_options => {
          'python_path' => '/my/python/path',
        },
      )}
    end

    context 'when nova::metadata is missing in the composition layer' do

      let :pre_condition do
        "include nova"
      end

      it { should raise_error(Puppet::Error, /nova::metadata class must be declared in composition layer./) }
    end

    context 'with custom access logging' do
      let :pre_condition do
        "include nova
         class { 'nova::keystone::authtoken':
           password => 'secrete',
         }
         class { 'nova::metadata': }"
      end

      let :params do
        {
          :access_log_format  => 'foo',
          :access_log_syslog  => 'syslog:local0',
          :error_log_syslog   => 'syslog:local1',
          :access_log_env_var => '!dontlog',
        }
      end

      it { should contain_openstacklib__wsgi__apache('nova_metadata_wsgi').with(
        :access_log_format  => params[:access_log_format],
        :access_log_syslog  => params[:access_log_syslog],
        :error_log_syslog   => params[:error_log_syslog],
        :access_log_env_var => params[:access_log_env_var],
      )}
    end

    context 'with access_log_file' do
      let :pre_condition do
        "include nova
         class { 'nova::keystone::authtoken':
           password => 'secrete',
         }
         class { 'nova::metadata': }"
      end

      let :params do
        {
          :access_log_file => '/path/to/file',
        }
      end

      it { should contain_openstacklib__wsgi__apache('nova_metadata_wsgi').with(
        :access_log_file => params[:access_log_file],
      )}
    end

    context 'with access_log_pipe' do
      let :pre_condition do
        "include nova
         class { 'nova::keystone::authtoken':
           password => 'secrete',
         }
         class { 'nova::metadata': }"
      end

      let :params do
        {
          :access_log_pipe => 'pipe',
        }
      end

      it { should contain_openstacklib__wsgi__apache('nova_metadata_wsgi').with(
        :access_log_pipe => params[:access_log_pipe],
      )}
    end

    context 'with error_log_file' do
      let :pre_condition do
        "include nova
         class { 'nova::keystone::authtoken':
           password => 'secrete',
         }
         class { 'nova::metadata': }"
      end

      let :params do
        {
          :error_log_file => '/path/to/file',
        }
      end

      it { should contain_openstacklib__wsgi__apache('nova_metadata_wsgi').with(
        :error_log_file => params[:error_log_file],
      )}
    end

    context 'with error_log_pipe' do
      let :pre_condition do
        "include nova
         class { 'nova::keystone::authtoken':
           password => 'secrete',
         }
         class { 'nova::metadata': }"
      end

      let :params do
        {
          :error_log_pipe => 'pipe',
        }
      end

      it { should contain_openstacklib__wsgi__apache('nova_metadata_wsgi').with(
        :error_log_pipe => params[:error_log_pipe],
      )}
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({
          :os_workers => 42,
        }))
      end

      let(:platform_params) do
        case facts[:os]['family']
        when 'Debian'
          {
            :wsgi_script_path            => '/usr/lib/cgi-bin/nova',
            :metadata_wsgi_script_source => '/usr/bin/nova-metadata-wsgi',
          }
        when 'RedHat'
          {
            :wsgi_script_path            => '/var/www/cgi-bin/nova',
            :metadata_wsgi_script_source => '/usr/bin/nova-metadata-wsgi',
          }
        end
      end

      it_behaves_like 'apache serving nova-metadata with mod_wsgi'
    end
  end
end
