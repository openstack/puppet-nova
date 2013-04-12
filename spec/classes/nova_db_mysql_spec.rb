require 'spec_helper'

describe 'nova::db::mysql' do
  let :required_params do
    { :password => "qwerty" }
  end

  context 'on a Debian osfamily' do
    let :facts do
      { :osfamily => "Debian" }
    end

    context 'with only required parameters' do
      let :params do
        required_params
      end

      it { should contain_mysql__db('nova').with(
        :user        => 'nova',
        :password    => 'qwerty',
        :charset     => 'latin1',
        :require     => "Class[Mysql::Config]"
      )}
    end

    context 'when overriding charset' do
      let :params do
        { :charset => 'utf8' }.merge(required_params)
      end

      it { should contain_mysql__db('nova').with_charset(params[:charset]) }
    end
  end

  context 'on a RedHat osfamily' do
    let :facts do
      { :osfamily => 'RedHat' }
    end

    context 'with only required parameters' do
      let :params do
        required_params
      end

      it { should contain_mysql__db('nova').with(
        :user        => 'nova',
        :password    => 'qwerty',
        :charset     => 'latin1',
        :require     => "Class[Mysql::Config]"
      )}
    end

    context 'when overriding charset' do
      let :params do
        { :charset => 'utf8' }.merge(required_params)
      end

      it { should contain_mysql__db('nova').with_charset(params[:charset]) }
    end
  end
end
