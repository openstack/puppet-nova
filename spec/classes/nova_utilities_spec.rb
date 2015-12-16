require 'spec_helper'

describe 'nova::utilities' do

  describe 'on debian platforms' do
    let :pre_condition do
      "class { '::nova': install_utilities => true }"
    end

    let :facts do
      @default_facts.merge({ :osfamily => 'Debian' })
    end

    it 'installs utilities' do
      is_expected.to contain_package('unzip').with_ensure('present')
      is_expected.to contain_package('screen').with_ensure('present')
      is_expected.to contain_package('parted').with_ensure('present')
      is_expected.to contain_package('curl').with_ensure('present')
      is_expected.to contain_package('euca2ools').with_ensure('present')
      is_expected.to contain_package('libguestfs-tools').with_ensure('present')
    end
  end
end
