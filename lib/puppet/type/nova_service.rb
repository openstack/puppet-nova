# Copyright (C) 2016 Mirantis Inc.
#
# Author: Matthew Mosesohn <mmosesohn@mirantis.com>
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
# nova_security_group type
#
# == Parameters
#  [*name*]
#    Name for the host
#    Required
#
#  [*ensure*]
#    Marks status of service(s) on a given host.
#    Possible values are enabled, disabled, purged
#    Optional
#
#  [*service_name*]
#    Name of a given service. Defaults to "undef", which modifies all.
#    Optional
#


require 'puppet'

Puppet::Type.newtype(:nova_service) do

  @doc = "Manage status of nova services on hosts."

  ensurable

  newparam(:name, :namevar => true) do
    desc 'Name of host'
    validate do |value|
      if not value.is_a? String
        raise ArgumentError, "name parameter must be a String"
      end
      unless value =~ /^[a-zA-Z0-9\-_.]+$/
        raise ArgumentError, "#{value} is not a valid name"
      end
    end
  end

  newproperty(:ids) do
    desc 'The unique Ids of the compute service'
    validate do |v|
      raise ArgumentError, 'This is a read only property'
    end
  end

  newproperty(:service_name, :array_matching => :all) do
    desc "String or Array of services on a host to modify"
    validate do |value|
      raise(
        ArgumentError,
        'service_name parameter must be String or Array'
      ) unless [String, Array].any? { |type| value.is_a? type }
    end
    defaultto []
  end

end
