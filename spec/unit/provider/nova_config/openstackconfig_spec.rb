#
# these tests are a little concerning b/c they are hacking around the
# modulepath, so these tests will not catch issues that may eventually arise
# related to loading these plugins.
# I could not, for the life of me, figure out how to programatcally set the modulepath
$LOAD_PATH.push(
  File.join(
    File.dirname(__FILE__),
    '..',
    '..',
    '..',
    'fixtures',
    'modules',
    'inifile',
    'lib')
)
$LOAD_PATH.push(
  File.join(
    File.dirname(__FILE__),
    '..',
    '..',
    '..',
    'fixtures',
    'modules',
    'openstacklib',
    'lib')
)
require 'spec_helper'
provider_class = Puppet::Type.type(:nova_config).provider(:openstackconfig)
describe provider_class do

  it 'should default to the default setting when no other one is specified' do
    resource = Puppet::Type::Nova_config.new(
      {:name => 'DEFAULT/foo', :value => 'bar'}
    )
    provider = provider_class.new(resource)
    expect(provider.section).to eq('DEFAULT')
    expect(provider.setting).to eq('foo')
  end

  it 'should allow setting to be set explicitly' do
    resource = Puppet::Type::Nova_config.new(
      {:name => 'dude/foo', :value => 'bar'}
    )
    provider = provider_class.new(resource)
    expect(provider.section).to eq('dude')
    expect(provider.setting).to eq('foo')
  end

  it 'should ensure absent when <SERVICE DEFAULT> is specified as a value' do
    resource = Puppet::Type::Nova_config.new(
      {:name => 'dude/foo', :value => '<SERVICE DEFAULT>'}
    )
    provider = provider_class.new(resource)
    provider.exists?
    expect(resource[:ensure]).to eq :absent
  end

  it 'should ensure absent when value matches ensure_absent_val' do
    resource = Puppet::Type::Nova_config.new(
      {:name => 'dude/foo', :value => 'foo', :ensure_absent_val => 'foo' }
    )
    provider = provider_class.new(resource)
    provider.exists?
    expect(resource[:ensure]).to eq :absent
  end

end
