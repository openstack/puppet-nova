
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
require 'spec_helper'
provider_class = Puppet::Type.type(:virtnodedevd_config).provider(:ini_setting)
describe provider_class do
  it 'should allow setting to be set explicitly' do
    resource = Puppet::Type::Virtnodedevd_config.new(
      {:name => 'foo', :value => 'bar'}
    )
    provider = provider_class.new(resource)
    expect(provider.section).to eq('')
    expect(provider.setting).to eq('foo')
  end
  it 'should quote the value when quote is true' do
    resource = Puppet::Type::Virtnodedevd_config.new(
      {:name => 'foo', :value => 'baa', :quote => true }
    )
    provider = provider_class.new(resource)
    provider.exists?
    expect(provider.section).to eq('')
    expect(provider.setting).to eq('foo')
    expect(resource[:value]).to eq('"baa"')
  end
  it 'should not quote the value when quote is true but the value is quoted' do
    resource = Puppet::Type::Virtnodedevd_config.new(
      {:name => 'foo', :value => '"baa"', :quote => true }
    )
    provider = provider_class.new(resource)
    provider.exists?
    expect(provider.section).to eq('')
    expect(provider.setting).to eq('foo')
    expect(resource[:value]).to eq('"baa"')
  end
  it 'should ensure absent when <SERVICE DEFAULT> is specified as a value' do
    resource = Puppet::Type::Virtnodedevd_config.new(
      {:name => 'foo', :value => '<SERVICE DEFAULT>'}
    )
    provider = provider_class.new(resource)
    provider.exists?
    expect(resource[:ensure]).to eq :absent
  end
  it 'should ensure absent when <SERVICE DEFAULT> is specified as a value and quote is true' do
    resource = Puppet::Type::Virtnodedevd_config.new(
      {:name => 'foo', :value => '<SERVICE DEFAULT>', :quote => true}
    )
    provider = provider_class.new(resource)
    provider.exists?
    expect(resource[:ensure]).to eq :absent
  end
end

