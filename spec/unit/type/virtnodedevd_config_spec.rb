require 'puppet'
require 'puppet/type/virtnodedevd_config'

describe 'Puppet::Type.type(:virtnodedevd_config)' do
  before :each do
    @virtnodedevd_config = Puppet::Type.type(:virtnodedevd_config).new(:name => 'DEFAULT/foo', :value => 'bar')
  end

  it 'should accept a valid value' do
    @virtnodedevd_config[:value] = 'bar'
    expect(@virtnodedevd_config[:value]).to eq('bar')
  end

  it 'should autorequire the package that install the file' do
    catalog = Puppet::Resource::Catalog.new
    anchor = Puppet::Type.type(:anchor).new(:name => 'nova::install::end')
    catalog.add_resource anchor, @virtnodedevd_config
    dependency = @virtnodedevd_config.autorequire
    expect(dependency.size).to eq(1)
    expect(dependency[0].target).to eq(@virtnodedevd_config)
    expect(dependency[0].source).to eq(anchor)
  end

end
