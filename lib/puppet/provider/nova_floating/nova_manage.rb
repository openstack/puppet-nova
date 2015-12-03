Puppet::Type.type(:nova_floating).provide(:nova_manage) do

  desc "Manage nova floating"

  optional_commands :nova_manage => 'nova-manage'

  def exists?
    if resource[:network] =~ /^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\/[0-9]{1,2}$/
      # Calculate num quads to grab for prefix$$
      mask=resource[:network].sub(/.*\/([0-9][0-9]?)/, '\1').to_i
      num_quads = 4 - mask / 8
      prefix=resource[:network].sub(/(\.[0-9]{1,3}){#{num_quads}}(\/[0-9]{1,2})?$/, '') + "."
      return nova_manage("floating", "list").match(/#{prefix}/)

    elsif resource[:network].to_s =~ /^.{0,2}\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}-\d{1,3}\.\d{1,3}.\d{1,3}.\d{1,3}.{0,2}/
      if resource[:ensure] == :absent
        operate_range.any?
      else
        operate_range.empty?
      end
    end
  end

  def create
    if resource[:network] =~ /^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\/[0-9]{1,2}$/
      nova_manage("floating", "create", '--pool', resource[:pool], resource[:network])

    elsif resource[:network].to_s =~ /^.{0,2}\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}-\d{1,3}\.\d{1,3}.\d{1,3}.\d{1,3}.{0,2}/
      mixed_range.each do |ip|
        nova_manage("floating", "create", ip)
      end
    end
  end

  def destroy
    if resource[:network] =~ /^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\/[0-9]{1,2}$/
      nova_manage("floating", "delete", resource[:network])

    elsif resource[:network].to_s =~ /^.{0,2}\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}-\d{1,3}\.\d{1,3}.\d{1,3}.\d{1,3}.{0,2}/
      mixed_range.each do |ip|
        nova_manage("floating", "delete", ip )
      end
    end
  end

  # Create range in cidr, including first and last ip
  # Nova will create this range, excluding network and broadcast IPs
  def mixed_range
    require 'netaddr'
    range = []
    NetAddr.merge(operate_range).each do |cidr|
      tmp_range = NetAddr::CIDR.create(cidr).enumerate
      range << tmp_range.first.to_s
      range << tmp_range.last.to_s
    end
    range.uniq!
    range += NetAddr.merge(operate_range).delete_if{ |part| part =~ /\/3[12]/}
  end

  # Calculate existed IPs and provided ip ranges
  def operate_range
    exist_range = []
    output = nova_manage("floating", "list")
    range_list = output.scan(/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/)
    range_list.each do |element|
      exist_range << element
    end
    if @resource[:ensure] == :absent
       ip_range & exist_range
    else
       ip_range - exist_range
    end
  end

  def ip_range
    require 'netaddr'
    ip_range = []
    Array(@resource[:network]).each do |rng|
      ip = rng.split('-')
      generated_range = NetAddr.range(NetAddr::CIDR.create(ip.first), NetAddr::CIDR.create(ip.last))
      ip_range += generated_range.unshift(ip.first).push(ip.last)
    end
    return ip_range
  end
end
