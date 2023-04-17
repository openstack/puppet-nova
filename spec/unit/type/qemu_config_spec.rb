require 'puppet'
require 'puppet/type/qemu_config'

describe 'Puppet::Type.type(:qemu_config)' do
  before :each do
    @qemu_config = Puppet::Type.type(:qemu_config).new(:name => 'DEFAULT/foo', :value => 'bar')
  end

  it 'should accept a valid value' do
    @qemu_config[:value] = 'bar'
    expect(@qemu_config[:value]).to eq('bar')
  end

  it 'should accept a valid value' do
    @qemu_config[:value] = 'bar'
    expect(@qemu_config[:value]).to eq('bar')
  end

  it 'should convert a boolean value (true)' do
    @qemu_config[:value] = true
    expect(@qemu_config[:value]).to eq('1')
  end

  it 'should autorequire the package that install the file' do
    catalog = Puppet::Resource::Catalog.new
    anchor = Puppet::Type.type(:anchor).new(:name => 'nova::install::end')
    catalog.add_resource anchor, @qemu_config
    dependency = @qemu_config.autorequire
    expect(dependency.size).to eq(1)
    expect(dependency[0].target).to eq(@qemu_config)
    expect(dependency[0].source).to eq(anchor)
  end

end
