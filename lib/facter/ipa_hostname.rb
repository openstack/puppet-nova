Facter.add(:ipa_hostname) do
  confine kernel: 'Linux'
  setcode do
    if File.exist?('/etc/ipa/default.conf')
      Facter::Util::Resolution.exec('grep xmlrpc_uri /etc/ipa/default.conf | cut -d/ -f3')
    end
  end
end
