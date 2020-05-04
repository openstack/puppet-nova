require 'puppet'
require 'puppet/type/nova_paste_api_ini'

describe 'Puppet::Type.type(:nova_paste_api_ini)' do
  before :each do
    @nova_paste_api_ini = Puppet::Type.type(:nova_paste_api_ini).new(:name => 'DEFAULT/foo', :value => 'bar')
  end

  it 'should accept a valid value' do
    @nova_paste_api_ini[:value] = 'bar'
    expect(@nova_paste_api_ini[:value]).to eq('bar')
  end

  it 'should autorequire the package that install the file' do
    catalog = Puppet::Resource::Catalog.new
    anchor = Puppet::Type.type(:anchor).new(:name => 'nova::install::end')
    catalog.add_resource anchor, @nova_paste_api_ini
    dependency = @nova_paste_api_ini.autorequire
    expect(dependency.size).to eq(1)
    expect(dependency[0].target).to eq(@nova_paste_api_ini)
    expect(dependency[0].source).to eq(anchor)
  end

end
