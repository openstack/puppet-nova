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
      'auth_uri'     => 'https://192.168.56.210:35357/v2.0/',
      'project_name' => 'admin_tenant',
      'username'     => 'admin',
      'password'     => 'password',
      'region_name'  => 'Region1',
    }
  end

  let :auth_endpoint do
    'https://192.168.56.210:35357/v2.0/'
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

  describe 'when invoking the nova cli' do

    it 'should set auth credentials in the environment' do
      authenv = {
        :OS_AUTH_URL     => auth_endpoint,
        :OS_USERNAME     => credential_hash['username'],
        :OS_PROJECT_NAME => credential_hash['project_name'],
        :OS_PASSWORD     => credential_hash['password'],
        :OS_REGION_NAME => credential_hash['region_name'],
      }
      klass.expects(:get_nova_credentials).with().returns(credential_hash)
      klass.expects(:withenv).with(authenv)
      klass.auth_nova('test_retries')
    end

    ['[Errno 111] Connection refused',
     '(HTTP 400)'].reverse.each do |valid_message|
      it "should retry when nova cli returns with error #{valid_message}" do
        klass.expects(:get_nova_credentials).with().returns({})
        klass.expects(:sleep).with(10).returns(nil)
        klass.expects(:nova).twice.with(['test_retries']).raises(
          Exception, valid_message).then.returns('')
        klass.auth_nova('test_retries')
      end
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

    it 'should return the same string' do
      res = klass.str2list("zone1")
      expect(res).to eq("zone1")
    end

    it 'should return a list of strings' do
      res = klass.str2list("zone1, zone2")
      expect(res).to eq(["zone1", "zone2"])
    end


    it 'should return a list of strings' do
      res = klass.str2list("zo n e1,    zone2    ")
      expect(res).to eq(["zo n e1", "zone2"])
    end

    it 'should return a hash with multiple keys' do
      res = klass.str2list("a=b, c=d")
      expect(res).to eq({"a"=>"b", "c"=>"d"})
    end

    it 'should return a single hash' do
      res = klass.str2list("a=b")
      expect(res).to eq({"a"=>"b"})
    end
  end
end
