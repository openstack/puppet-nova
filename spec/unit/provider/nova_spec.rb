require 'puppet'
require 'spec_helper'
require 'puppet/provider/nova'
require 'rspec/mocks'

describe Puppet::Provider::Nova do

  def klass
    described_class
  end

  let :credential_hash do
    {
      'www_authenticate_uri' => 'https://192.168.56.210:5000/v2.0/',
      'project_name'         => 'admin_tenant',
      'username'             => 'admin',
      'password'             => 'password',
      'region_name'          => 'Region1',
    }
  end

  let :auth_endpoint do
    'https://192.168.56.210:5000/v2.0/'
  end

  let :credential_error do
    /Nova types will not work/
  end

  after :each do
    klass.reset
  end

  describe 'when determining credentials' do

    it 'should fail if config is empty' do
      conf = {}
      klass.expects(:nova_conf).returns(conf)
      expect do
        klass.nova_credentials
      end.to raise_error(Puppet::Error, credential_error)
    end

    it 'should fail if config does not have keystone_authtoken section.' do
      conf = {'foo' => 'bar'}
      klass.expects(:nova_conf).returns(conf)
      expect do
        klass.nova_credentials
      end.to raise_error(Puppet::Error, credential_error)
    end

    it 'should fail if config does not contain all auth params' do
      conf = {'keystone_authtoken' => {'invalid_value' => 'foo'}}
      klass.expects(:nova_conf).returns(conf)
      expect do
       klass.nova_credentials
      end.to raise_error(Puppet::Error, credential_error)
    end

    it 'should use specified uri in the auth endpoint' do
      conf = {'keystone_authtoken' => credential_hash}
      klass.expects(:nova_conf).returns(conf)
      expect(klass.get_auth_endpoint).to eq(auth_endpoint)
    end

  end

  describe 'when parse a string line' do
    it 'should return the same string' do
      res = klass.str2hash("zone1")
      expect(res).to eq("zone1")
    end

    it 'should return the string without quotes' do
      res = klass.str2hash("'zone1'")
      expect(res).to eq("zone1")
    end

    it 'should return the same string' do
      res = klass.str2hash("z o n e1")
      expect(res).to eq("z o n e1")
    end

    it 'should return a hash' do
      res = klass.str2hash("a=b")
      expect(res).to eq({"a"=>"b"})
    end

    it 'should return a hash with containing spaces' do
      res = klass.str2hash("a b = c d")
      expect(res).to eq({"a b "=>" c d"})
    end
  end
end
