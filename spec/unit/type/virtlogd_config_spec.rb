require 'puppet'
require 'puppet/type/virtlogd_config'

describe 'Puppet::Type.type(:virtlogd_config)' do
  before :each do
    @virtlogd_config = Puppet::Type.type(:virtlogd_config).new(:name => 'DEFAULT/foo', :value => 'bar')
  end

  it 'should accept a valid value' do
    @virtlogd_config[:value] = 'bar'
    expect(@virtlogd_config[:value]).to eq('bar')
  end

  it 'should convert a boolean value (true)' do
    @virtlogd_config[:value] = true
    expect(@virtlogd_config[:value]).to eq('1')
  end

  it 'should convert a boolean value (false)' do
    @virtlogd_config[:value] = false
    expect(@virtlogd_config[:value]).to eq('0')
  end

  it 'should autorequire the package that install the file' do
    catalog = Puppet::Resource::Catalog.new
    anchor = Puppet::Type.type(:anchor).new(:name => 'nova::install::end')
    catalog.add_resource anchor, @virtlogd_config
    dependency = @virtlogd_config.autorequire
    expect(dependency.size).to eq(1)
    expect(dependency[0].target).to eq(@virtlogd_config)
    expect(dependency[0].source).to eq(anchor)
  end

end
