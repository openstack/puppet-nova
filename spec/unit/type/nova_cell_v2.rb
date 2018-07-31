require 'spec_helper'
require 'puppet'
require 'puppet/type/nova_cell_v2'

describe 'Puppet::Type.type(:nova_cell_v2)' do

  before :each do
    Puppet::Type.rmtype(:nova_cell_v2)
  end

  it 'should sanitize transport_url in logs' do
    nova_cell_v2 = Puppet::Type.type(:nova_cell_v2).new(:title => 'foo')
    expect(
      nova_cell_v2.property('transport_url').change_to_s('default', 'foo://bar:secret@example.com')
    ).to_not include('secret')
    expect(
      nova_cell_v2.property('transport_url').change_to_s('foo://bar:secret@example.com', 'default')
    ).to_not include('secret')
  end

  it 'should sanitize database_connection in logs' do
    nova_cell_v2 = Puppet::Type.type(:nova_cell_v2).new(:title => 'foo')
    expect(
      nova_cell_v2.property('database_connection').change_to_s('default', 'foo://bar:secret@example.com')
    ).to_not include('secret')
    expect(
      nova_cell_v2.property('database_connection').change_to_s('foo://bar:secret@example.com', 'default')
    ).to_not include('secret')
  end

  it 'should not alter transport_url \'default\' in is_to_s/should_to_s' do
    nova_cell_v2 = Puppet::Type.type(:nova_cell_v2).new(:title => 'foo')
    expect(
      nova_cell_v2.property('transport_url').is_to_s('default')
    ).to eq('default')
    expect(
      nova_cell_v2.property('transport_url').should_to_s('default')
    ).to eq('default')
  end

  it 'should not alter database_connection \'default\' in is_to_s/should_to_s' do
    nova_cell_v2 = Puppet::Type.type(:nova_cell_v2).new(:title => 'foo')
    expect(
      nova_cell_v2.property('database_connection').is_to_s('default')
    ).to eq('default')
    expect(
      nova_cell_v2.property('database_connection').should_to_s('default')
    ).to eq('default')
  end

  it 'should not alter transport_url with no password in is_to_s/should_to_s' do
    nova_cell_v2 = Puppet::Type.type(:nova_cell_v2).new(:title => 'foo')
    expect(
      nova_cell_v2.property('transport_url').is_to_s('foo://bar@example.com')
    ).to eq('foo://bar@example.com')
    expect(
      nova_cell_v2.property('transport_url').should_to_s('foo://bar@example.com')
    ).to eq('foo://bar@example.com')
  end

  it 'should not alter database_connection with no password in is_to_s/should_to_s' do
    nova_cell_v2 = Puppet::Type.type(:nova_cell_v2).new(:title => 'foo')
    expect(
      nova_cell_v2.property('database_connection').is_to_s('foo://bar@example.com')
    ).to eq('foo://bar@example.com')
    expect(
      nova_cell_v2.property('database_connection').should_to_s('foo://bar@example.com')
    ).to eq('foo://bar@example.com')
  end

  it 'should not alter transport_url with no creds in is_to_s/should_to_s' do
    nova_cell_v2 = Puppet::Type.type(:nova_cell_v2).new(:title => 'foo')
    expect(
      nova_cell_v2.property('transport_url').is_to_s('foo://example.com')
    ).to eq('foo://example.com')
    expect(
      nova_cell_v2.property('transport_url').should_to_s('foo://example.com')
    ).to eq('foo://example.com')
  end

  it 'should not alter database_connection with no creds in is_to_s/should_to_s' do
    nova_cell_v2 = Puppet::Type.type(:nova_cell_v2).new(:title => 'foo')
    expect(
      nova_cell_v2.property('database_connection').is_to_s('foo://example.com')
    ).to eq('foo://example.com')
    expect(
      nova_cell_v2.property('database_connection').should_to_s('foo://example.com')
    ).to eq('foo://example.com')
  end

  it 'should mask transport_url password in is_to_s/should_to_s' do
    nova_cell_v2 = Puppet::Type.type(:nova_cell_v2).new(:title => 'foo')
    expect(
      nova_cell_v2.property('transport_url').is_to_s('foo://bar:secret@example.com')
    ).to eq('foo://bar:****@example.com')
    expect(
      nova_cell_v2.property('transport_url').should_to_s('foo://bar:secret@example.com')
    ).to eq('foo://bar:****@example.com')
  end

  it 'should mask database_connection password in is_to_s/should_to_s' do
    nova_cell_v2 = Puppet::Type.type(:nova_cell_v2).new(:title => 'foo')
    expect(
      nova_cell_v2.property('database_connection').is_to_s('foo://bar:secret@example.com')
    ).to eq('foo://bar:****@example.com')
    expect(
      nova_cell_v2.property('database_connection').should_to_s('foo://bar:secret@example.com')
    ).to eq('foo://bar:****@example.com')
  end

end
