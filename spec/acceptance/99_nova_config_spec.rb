require 'spec_helper_acceptance'

describe 'basic nova_config resource' do

  context 'default parameters' do

    it 'should work with no errors' do
      pp= <<-EOS
      Exec { logoutput => 'on_failure' }

      File <||> -> Nova_config <||>
      File <||> -> Nova_api_paste_ini <||>
      File <||> -> Nova_rootwrap_config <||>

      file { '/etc/nova' :
        ensure => directory,
      }
      file { '/etc/nova/nova.conf' :
        ensure => file,
      }
      file { '/etc/nova/api-paste.ini' :
        ensure => file,
      }
      file { '/etc/nova/rootwrap.conf' :
        ensure => file,
      }

      nova_config { 'DEFAULT/thisshouldexist' :
        value => 'foo',
      }

      nova_config { 'DEFAULT/thisshouldnotexist' :
        value => '<SERVICE DEFAULT>',
      }

      nova_config { 'DEFAULT/thisshouldexist2' :
        value             => '<SERVICE DEFAULT>',
        ensure_absent_val => 'toto',
      }

      nova_config { 'DEFAULT/thisshouldnotexist2' :
        value             => 'toto',
        ensure_absent_val => 'toto',
      }

      nova_config { 'DEFAULT/thisshouldexist3' :
        value => ['foo', 'bar'],
      }

      nova_api_paste_ini { 'DEFAULT/thisshouldexist' :
        value => 'foo',
      }

      nova_api_paste_ini { 'DEFAULT/thisshouldnotexist' :
        value => '<SERVICE DEFAULT>',
      }

      nova_api_paste_ini { 'DEFAULT/thisshouldexist2' :
        value             => '<SERVICE DEFAULT>',
        ensure_absent_val => 'toto',
      }

      nova_api_paste_ini { 'DEFAULT/thisshouldnotexist2' :
        value             => 'toto',
        ensure_absent_val => 'toto',
      }

      nova_api_paste_ini { 'DEFAULT/thisshouldexist3' :
        value             => 'foo',
        key_val_separator => ':'
      }

      nova_rootwrap_config { 'DEFAULT/thisshouldexist' :
        value => 'foo',
      }

      nova_rootwrap_config { 'DEFAULT/thisshouldnotexist' :
        value => '<SERVICE DEFAULT>',
      }

      nova_rootwrap_config { 'DEFAULT/thisshouldexist2' :
        value             => '<SERVICE DEFAULT>',
        ensure_absent_val => 'toto',
      }

      nova_rootwrap_config { 'DEFAULT/thisshouldnotexist2' :
        value             => 'toto',
        ensure_absent_val => 'toto',
      }
      EOS


      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe file('/etc/nova/nova.conf') do
      it { is_expected.to exist }
      it { is_expected.to contain('thisshouldexist=foo') }
      it { is_expected.to contain('thisshouldexist2=<SERVICE DEFAULT>') }
      it { is_expected.to contain('thisshouldexist3=foo') }
      it { is_expected.to contain('thisshouldexist3=bar') }

      describe '#content' do
        subject { super().content }
        it { is_expected.to_not match /thisshouldnotexist/ }
      end
    end

    describe file('/etc/nova/api-paste.ini') do
      it { is_expected.to exist }
      it { is_expected.to contain('thisshouldexist=foo') }
      it { is_expected.to contain('thisshouldexist2=<SERVICE DEFAULT>') }
      it { is_expected.to contain('thisshouldexist3:foo') }

      describe '#content' do
        subject { super().content }
        it { is_expected.to_not match /thisshouldnotexist/ }
      end
    end

    describe file('/etc/nova/rootwrap.conf') do
      it { is_expected.to exist }
      it { is_expected.to contain('thisshouldexist=foo') }
      it { is_expected.to contain('thisshouldexist2=<SERVICE DEFAULT>') }

      describe '#content' do
        subject { super().content }
        it { is_expected.to_not match /thisshouldnotexist/ }
      end
    end
  end
end
