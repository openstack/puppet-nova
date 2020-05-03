require 'puppet'
require 'puppet/type/libvirtd_config'

describe 'Puppet::Type.type(:libvirtd_config)' do
  before :each do
    @libvirtd_config = Puppet::Type.type(:libvirtd_config).new(:name => 'DEFAULT/foo', :value => 'bar')
  end

  it 'should accept a valid value' do
    @libvirtd_config[:value] = 'bar'
    expect(@libvirtd_config[:value]).to eq('bar')
  end

  it 'should autorequire the package that install the file' do
    catalog = Puppet::Resource::Catalog.new
    anchor = Puppet::Type.type(:anchor).new(:name => 'nova::install::end')
    catalog.add_resource anchor, @libvirtd_config
    dependency = @libvirtd_config.autorequire
    expect(dependency.size).to eq(1)
    expect(dependency[0].target).to eq(@libvirtd_config)
    expect(dependency[0].source).to eq(anchor)
  end

end
