require 'puppet'
require 'puppet/type/virtproxyd_config'

describe 'Puppet::Type.type(:virtproxyd_config)' do
  before :each do
    @virtproxyd_config = Puppet::Type.type(:virtproxyd_config).new(:name => 'DEFAULT/foo', :value => 'bar')
  end

  it 'should accept a valid value' do
    @virtproxyd_config[:value] = 'bar'
    expect(@virtproxyd_config[:value]).to eq('bar')
  end

  it 'should autorequire the package that install the file' do
    catalog = Puppet::Resource::Catalog.new
    anchor = Puppet::Type.type(:anchor).new(:name => 'nova::install::end')
    catalog.add_resource anchor, @virtproxyd_config
    dependency = @virtproxyd_config.autorequire
    expect(dependency.size).to eq(1)
    expect(dependency[0].target).to eq(@virtproxyd_config)
    expect(dependency[0].source).to eq(anchor)
  end

end
