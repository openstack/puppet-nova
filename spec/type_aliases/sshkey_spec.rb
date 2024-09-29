require 'spec_helper'

describe 'Nova::SshKey' do
  describe 'valid types' do
    context 'with valid types' do
      [
        {'key' => 'foo', 'type' => 'ssh-rsa'},
        {'key' => 'foo', 'type' => 'ssh-dsa'},
        {'key' => 'foo', 'type' => 'ssh-ecdsa'},
        {'key' => 'foo', 'type' => 'ssh-ed25519'},
      ].each do |value|
        describe value.inspect do
          it { is_expected.to allow_value(value) }
        end
      end
    end
  end

  describe 'invalid types' do
    context 'with garbage inputs' do
      [
        {},
        {'key' => 'foo'},
        {'type' => 'ssh-rsa'},
        {'key' => 'foo', 'type' => 'ssh-invalid'},
        {'key' => '', 'type' => 'ssh-rsa'},
        {'key' => 1, 'type' => 'ssh-rsa'},
        nil,
        '<SERVICE DEFAULT>',
      ].each do |value|
        describe value.inspect do
          it { is_expected.not_to allow_value(value) }
        end
      end
    end
  end
end
