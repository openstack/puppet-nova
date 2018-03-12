require 'spec_helper'

describe 'nova::cron::purge_shadow_tables' do

  let :facts do
    OSDefaults.get_facts({ :osfamily => 'Debian' })
  end

  let :params do
    { :minute         => 0,
      :hour           => 12,
      :monthday       => '*',
      :month          => '*',
      :weekday        => '6',
      :user           => 'nova',
      :destination    => '/var/log/nova/nova-rowspurge.log' }
  end

  context 'verbose is true' do
    before :each do
      params.merge!(
        :verbose => true,
      )
    end

    it 'configures a nova purge cron with verbose output' do
      is_expected.to contain_cron('nova-manage db purge').with(
        :command     => "nova-manage db purge --all --verbose >>#{params[:destination]} 2>&1",
        :user        => 'nova',
        :environment => 'PATH=/bin:/usr/bin:/usr/sbin SHELL=/bin/sh',
        :user        => params[:user],
        :minute      => params[:minute],
        :hour        => params[:hour],
        :monthday    => params[:monthday],
        :month       => params[:month],
        :weekday     => params[:weekday],
        :require     => 'Anchor[nova::dbsync::end]',
      )
    end
  end

  context 'verbose is false' do
    before :each do
      params.merge!(
        :verbose => false,
      )
    end

    it 'configures a nova purge cron without verbose output' do
      is_expected.to contain_cron('nova-manage db purge').with(
        :command     => "nova-manage db purge --all  >>#{params[:destination]} 2>&1",
        :user        => 'nova',
        :environment => 'PATH=/bin:/usr/bin:/usr/sbin SHELL=/bin/sh',
        :user        => params[:user],
        :minute      => params[:minute],
        :hour        => params[:hour],
        :monthday    => params[:monthday],
        :month       => params[:month],
        :weekday     => params[:weekday],
        :require     => 'Anchor[nova::dbsync::end]',
      )
    end
  end

end
