require 'puppet'
require 'puppet/type/virtqemud_config'

describe 'Puppet::Type.type(:virtqemud_config)' do
  before :each do
    @virtqemud_config = Puppet::Type.type(:virtqemud_config).new(:name => 'DEFAULT/foo', :value => 'bar')
  end

  it 'should accept a valid value' do
    @virtqemud_config[:value] = 'bar'
    expect(@virtqemud_config[:value]).to eq('bar')
  end

  it 'should autorequire the package that install the file' do
    catalog = Puppet::Resource::Catalog.new
    anchor = Puppet::Type.type(:anchor).new(:name => 'nova::install::end')
    catalog.add_resource anchor, @virtqemud_config
    dependency = @virtqemud_config.autorequire
    expect(dependency.size).to eq(1)
    expect(dependency[0].target).to eq(@virtqemud_config)
    expect(dependency[0].source).to eq(anchor)
  end

end
