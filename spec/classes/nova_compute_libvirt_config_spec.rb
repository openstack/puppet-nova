require 'spec_helper'

describe 'nova::compute::libvirt::config' do
  shared_examples 'nova::compute::libvirt::config' do
    let :params do
      {
        :libvirtd_config => {
          'foo' => { 'value'  => 'fooValue' },
          'bar' => { 'value'  => 'barValue' },
          'baz' => { 'ensure' => 'absent' }
        },
        :virtlogd_config => {
          'foo2' => { 'value'  => 'fooValue' },
          'bar2' => { 'value'  => 'barValue' },
          'baz2' => { 'ensure' => 'absent' }
        }
      }
    end

    context 'with specified configs' do
      it { should contain_class('nova::deps') }

      it {
        should contain_libvirtd_config('foo').with_value('fooValue')
        should contain_libvirtd_config('bar').with_value('barValue')
        should contain_libvirtd_config('baz').with_ensure('absent')
      }

      it {
        should contain_virtlogd_config('foo2').with_value('fooValue')
        should contain_virtlogd_config('bar2').with_value('barValue')
        should contain_virtlogd_config('baz2').with_ensure('absent')
      }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'nova::compute::libvirt::config'
    end
  end
end
