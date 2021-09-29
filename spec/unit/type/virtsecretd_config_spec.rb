require 'puppet'
require 'puppet/type/virtsecretd_config'

describe 'Puppet::Type.type(:virtsecretd_config)' do
  before :each do
    @virtsecretd_config = Puppet::Type.type(:virtsecretd_config).new(:name => 'DEFAULT/foo', :value => 'bar')
  end

  it 'should accept a valid value' do
    @virtsecretd_config[:value] = 'bar'
    expect(@virtsecretd_config[:value]).to eq('bar')
  end

  it 'should autorequire the package that install the file' do
    catalog = Puppet::Resource::Catalog.new
    anchor = Puppet::Type.type(:anchor).new(:name => 'nova::install::end')
    catalog.add_resource anchor, @virtsecretd_config
    dependency = @virtsecretd_config.autorequire
    expect(dependency.size).to eq(1)
    expect(dependency[0].target).to eq(@virtsecretd_config)
    expect(dependency[0].source).to eq(anchor)
  end

end
