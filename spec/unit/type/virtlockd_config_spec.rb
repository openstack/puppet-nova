require 'puppet'
require 'puppet/type/virtlockd_config'

describe 'Puppet::Type.type(:virtlockd_config)' do
  before :each do
    @virtlockd_config = Puppet::Type.type(:virtlockd_config).new(:name => 'DEFAULT/foo', :value => 'bar')
  end

  it 'should accept a valid value' do
    @virtlockd_config[:value] = 'bar'
    expect(@virtlockd_config[:value]).to eq('bar')
  end

  it 'should autorequire the package that install the file' do
    catalog = Puppet::Resource::Catalog.new
    anchor = Puppet::Type.type(:anchor).new(:name => 'nova::install::end')
    catalog.add_resource anchor, @virtlockd_config
    dependency = @virtlockd_config.autorequire
    expect(dependency.size).to eq(1)
    expect(dependency[0].target).to eq(@virtlockd_config)
    expect(dependency[0].source).to eq(anchor)
  end

end
