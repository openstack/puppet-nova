# -*- coding: utf-8 -*-
#
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
#  [*ip_protocol*]
#    IP protocol from new security rule
#    Required
#
#  [*from_port*]
#    Port range begin for security rule
#    Required
#
#  [*to_port*]
#    Port range end for security rule
#    Required
#
#  [*ip_range*]
#    IP range for security rule
#    Optional
#
#  [*source_group*]
#    Source group for security rule
#    Optional
#
#  [*security_group*]
#    Target security group for security rule
#    Required
#


require 'puppet'

Puppet::Type.newtype(:nova_security_rule) do

  desc "Manage nova security rules"

  ensurable

  newparam(:name) do
    isnamevar
  end

  newparam(:ip_protocol) do
    defaultto do
      raise Puppet::Error, 'You should give protocol!'
    end
    newvalues 'tcp', 'udp', 'icmp'
  end

  newparam(:from_port) do
    defaultto do
      raise Puppet::Error, 'You should give the source port!'
    end
    validate do |value|
      if value !~ /\d+/ or value.to_i <= 0 or value.to_i >= 65536
        raise Puppet::Error, 'Incorrect from port!'
      end
    end
  end

  newparam(:to_port) do
    defaultto do
      raise Puppet::Error, 'You should give the destination port!'
    end
    validate do |value|
      if value !~ /\d+/ or value.to_i <= 0 or value.to_i >= 65536
        raise Puppet::Error, 'Incorrect to port!'
      end
    end
  end

  newparam(:ip_range) do

    validate do |value|
      def is_cidr_net?(value)
        begin
          address, mask = value.split('/')
          return false unless address and mask
          octets = address.split('.')
          return false unless octets.length == 4

          cidr = true
          octets.each do |octet|
            n = octet.to_i
            cidr = false unless n <= 255
            cidr = false unless n >= 0
            break unless cidr
          end

          cidr = false unless mask.to_i <= 32
          cidr = false unless mask.to_i >= 0
          cidr
        rescue
          false
        end
      end

      raise Puppet::Error, 'Incorrect ip_range!' unless is_cidr_net? value
    end
  end

  newparam(:source_group) do
  end

  newparam(:security_group) do
    defaultto do
      raise Puppet::Error, 'You should provide the security group to add this rule to!'
    end
  end

  validate do
    unless !!self[:ip_range] ^ !!self[:source_group]
      raise Puppet::Error, 'You should give either ip_range or source_group. Not none or both!'
    end
    unless self[:from_port].to_i <= self[:to_port].to_i
      raise Puppet::Error, 'From_port should be lesser or equal to to_port!'
    end
  end

  autorequire(:nova_security_group) do
    self[:security_group]
  end

end
