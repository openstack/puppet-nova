require 'spec_helper'

describe 'Nova::SshKey' do
  describe 'valid types' do
    context 'with valid types' do
      [
        {'key' => 'foo'},
        {'type' => 'bar'},
        {'key' => 'foo', 'type' => 'bar'},
        {},
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
        {'key' => 1},
        {'fookey' => 'foo'},
        'foo',
        true,
        false,
        1,
        1.1,
        '<SERVICE DEFAULT>',
      ].each do |value|
        describe value.inspect do
          it { is_expected.not_to allow_value(value) }
        end
      end
    end
  end
end
