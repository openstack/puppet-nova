require 'spec_helper'

describe 'to_array_of_json_strings' do
  it 'exists' do
    is_expected.not_to eq(nil)
  end

  it 'fails with no arguments' do
    is_expected.to run.with_params.and_raise_error(Puppet::ParseError)
  end

  it 'fails with too many arguments' do
    is_expected.to run.with_params('arg1', 'arg2').and_raise_error(Puppet::ParseError)
  end

  it 'fails with invalid json string' do
    data = 'invalid json'
    is_expected.to run.with_params(data).and_raise_error(Puppet::ParseError)
  end

  it 'fails with array of json string' do
    data = ['{"valid": "json", "syntax": "here"}', '{"some": "data"}']
    is_expected.to run.with_params(data).and_raise_error(Puppet::ParseError)
  end

  it 'works with valid json string' do
    data = '{"valid": "json", "syntax": "here"}'
    retval = ['{"valid":"json","syntax":"here"}']
    is_expected.to run.with_params(data).and_return(retval)
  end

  it 'fails unless its an array or string' do
    is_expected.to run.with_params(1234).and_raise_error(Puppet::ParseError)
  end

  it 'fails unless array doesnt have hashes' do
    data = [12, 23]
    is_expected.to run.with_params(data).and_raise_error(Puppet::ParseError)
  end

  it 'fails if array but only some entries are valid' do
    data = [{:some => "entry"}, 23]
    is_expected.to run.with_params(data).and_raise_error(Puppet::ParseError)
  end

  it 'works with an array of hashes' do
    data = [{:some => "entry"}, {:with => "data"}]
    retval = ['{"some":"entry"}','{"with":"data"}']
    is_expected.to run.with_params(data).and_return(retval)
  end
end
