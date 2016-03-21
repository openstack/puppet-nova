# Copyright (C) 2016 Mirantis Inc.
#
# Author: Alexey Deryugin <aderyugin@mirantis.com>
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
#    Name for the new security group
#    Required
#
#  [*description*]
#    Description for the new security group
#    Optional
#


require 'puppet'

Puppet::Type.newtype(:nova_security_group) do

  @doc = "Manage creation of nova security groups."

  ensurable

  newparam(:name, :namevar => true) do
    desc 'Name for the new security group'
    validate do |value|
      if not value.is_a? String
        raise ArgumentError, "name parameter must be a String"
      end
      unless value =~ /^[a-zA-Z0-9\-_]+$/
        raise ArgumentError, "#{value} is not a valid name"
      end
    end
  end

  newproperty(:id) do
    desc 'The unique Id of the security group'
    validate do |v|
      raise ArgumentError, 'This is a read only property'
    end
  end

  newproperty(:description) do
    desc "Description of the security group"
    defaultto ''
  end

  validate do
    raise ArgumentError, 'Name type must be set' unless self[:name]
  end

end
