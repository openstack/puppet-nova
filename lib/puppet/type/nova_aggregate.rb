# -*- coding: utf-8 -*-
#
# Copyright (C) 2014 Deutsche Telekom AG
#
# Author: Thomas Bechtold <t.bechtold@telekom.de>
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
#
# nova_aggregate type
#
# == Parameters
#  [*name*]
#    Name for the new aggregate
#    Required
#
#  [*filter_hosts*]
#    A boolean-y value to toggle whether only hosts known to be active by
#    openstack should be aggregated. i.e. "true" or "false"
#    Optional, defaults to "false"
#
#  [*availability_zone*]
#    The availability zone. ie "zone1"
#    Optional
#
#  [*metadata*]
#    String with key/value pairs. ie "key=value,key=value"
#    Optional
#
#  [*hosts*]
#    A comma separated list with hosts or a single host. ie "host1,host2"
#    Optional
#

require 'puppet'

Puppet::Type.newtype(:nova_aggregate) do

  @doc = "Manage creation of nova aggregations."

  ensurable

  # Require the nova-api service to be running
  autorequire(:anchor) do
    ['nova::service::end']
  end

  newparam(:name, :namevar => true) do
    desc 'Name for the new aggregate'
    validate do |value|
      if not value.is_a? String
        raise ArgumentError, "name parameter must be a String"
      end
      unless value =~ /[a-z0-9]+/
        raise ArgumentError, "#{value} is not a valid name"
      end
    end
  end

  newparam(:filter_hosts) do
    desc 'Toggle to filter given hosts so that only known nova-compute service hosts are added to the aggregate'
    defaultto :false
    newvalues(:true, :false)
  end

  newproperty(:id) do
    desc 'The unique Id of the aggregate'
    validate do |v|
      raise ArgumentError, 'This is a read only property'
    end
  end

  newproperty(:availability_zone) do
    desc 'The availability zone of the aggregate'
    validate do |value|
      if not value.is_a? String
        raise ArgumentError, "availability zone must be a String"
      end
    end
  end

  newproperty(:metadata) do
    desc 'The metadata of the aggregate'
    #convert DSL/string form to internal form which is a single hash
    munge do |value|
      if value.is_a?(Hash)
        return value
      end
      internal = Hash.new
      value.split(",").map{|el| el.strip()}.each do |pair|
        key, value = pair.split("=", 2)
        internal[key.strip()] = value.strip()
      end
      return internal
    end

    validate do |value|
      if value.is_a?(Hash)
        return true
      elsif value.is_a?(String)
        value.split(",").each do |kv|
          raise ArgumentError, "Key/value pairs must be separated by an =" unless value.include?("=")
        end
      else
        raise ArgumentError, "Invalid metadata #{value}. Requires a String or a Hash, not a #{value.class}"
      end
    end
  end

  newproperty(:hosts) do
    desc 'Single host or comma separated list of hosts'
    #convert DSL/string form to internal form
    munge do |value|
      if value.is_a?(Array)
        return value
      elsif value.is_a?(String)
        return value.split(",").map{|el| el.strip()}.sort
      else
        raise ArgumentError, "Invalid hosts #{value}. Requires a String or an Array, not a #{value.class}"
      end
    end
  end

  validate do
    raise ArgumentError, 'Name type must be set' unless self[:name]
  end

end
