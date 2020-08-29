Puppet::Type.type(:nova_floating).provide(:nova_manage) do

  desc "Manage nova floating (DEPRECATED!)"

  optional_commands :nova_manage => 'nova-manage'

  def exists?
    warning('nova_floating type is deprecated and has no effect')
  end

  def create
    warning('nova_floating type is deprecated and has no effect')
  end

  def destroy
    warning('nova_floating type is deprecated and has no effect')
  end
end
