require 'spec_helper'
require 'puppet'

describe 'encode_url_queries_for_python', :type => :puppet_function do

  it { is_expected.to run.with_params({}).and_return('') }
  it { is_expected.to run.with_params({'a' => 1, 'b' => 2}).and_return('?a=1&b=2') }
  it { is_expected.to run.with_params({'a' => 'b%c'}).and_return('?a=b%%25c') }
end
