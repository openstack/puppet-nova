require 'spec_helper_acceptance'

describe 'basic libvirtd_config resource' do

  context 'default parameters' do

    it 'should work with no errors' do
      pp= <<-EOS
      Exec { logoutput => 'on_failure' }

      File <||> -> Libvirtd_config <||>
      File <||> -> Virtlogd_config <||>
      File <||> -> Virtlockd_config <||>
      File <||> -> Virtnodedevd_config <||>
      File <||> -> Virtproxyd_config <||>
      File <||> -> Virtqemud_config <||>
      File <||> -> Virtsecretd_config <||>
      File <||> -> Virtstoraged_config <||>
      File <||> -> Qemu_config <||>

      file { '/etc/libvirt' :
        ensure => directory,
      }

      [
        'libvirtd', 'virtlogd', 'virtlockd', 'virtnodedevd', 'virtproxyd',
        'virtqemud', 'virtsecretd', 'virtstoraged', 'qemu'
      ].each | String $daemon | {

        file { "/etc/libvirt/${daemon}.conf" :
          ensure => file,
        }

        create_resources("${daemon}_config", {
          'thisshouldexist'     => {
            'value' => 1,
          },
          'thisshouldnotexist'  => {
            'value' => '<SERVICE DEFAULT>'
          },
          'thisshouldexist2'    => {
            'value'             => '<SERVICE DEFAULT>',
            'ensure_absent_val' => 'toto',
            'quote'             => true
          },
          'thisshouldnotexist2' => {
            'value'             => 'toto',
            'ensure_absent_val' => 'toto'
          },
          'thisshouldexist3'    => {
            'value' => 'foo',
            'quote' => true
          },
          'thisshouldnotexist3' => {
            'value' => '<SERVICE DEFAULT>',
            'quote' => true
          },
        })
      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    [
      'libvirtd', 'virtlogd', 'virtlockd', 'virtnodedevd', 'virtproxyd',
      'virtqemud', 'virtsecretd', 'virtstoraged', 'qemu'
    ].each do | daemon |
      describe file("/etc/libvirt/#{daemon}.conf") do
        it { is_expected.to exist }
        it { is_expected.to contain('thisshouldexist=1') }
        it { is_expected.to contain('thisshouldexist2="<SERVICE DEFAULT>"') }
        it { is_expected.to contain('thisshouldexist3="foo"') }

        describe '#content' do
          subject { super().content }
          it { is_expected.to_not match /thisshouldnotexist/ }
        end
      end
    end
  end
end
