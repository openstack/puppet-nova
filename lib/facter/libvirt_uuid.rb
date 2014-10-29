require 'facter'
Facter.add(:libvirt_uuid) do
  setcode do
    uuid_file_path = '/etc/libvirt/libvirt_uuid'
    if File.file? uuid_file_path
      File.read uuid_file_path
    else
      nil
    end
  end
end
