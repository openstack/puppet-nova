require 'spec_helper'

describe 'nova::cron::archive_deleted_rows' do

  let :facts do
    OSDefaults.get_facts({ :osfamily => 'Debian' })
  end

  let :params do
    { :minute         => 1,
      :hour           => 0,
      :monthday       => '*',
      :month          => '*',
      :weekday        => '*',
      :max_rows       => '100',
      :user           => 'nova',
      :until_complete => false,
      :destination    => '/var/log/nova/nova-rowsflush.log' }
  end

  context 'until_complete is false' do
    it 'configures a cron without until_complete' do
      is_expected.to contain_cron('nova-manage db archive_deleted_rows').with(
        :command     => "nova-manage db archive_deleted_rows --max_rows #{params[:max_rows]}  >>#{params[:destination]} 2>&1",
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

  context 'until_complete is true' do
    before :each do
      params.merge!(
        :until_complete => true,
      )
    end

    it 'configures a cron with until_complete' do
      is_expected.to contain_cron('nova-manage db archive_deleted_rows').with(
        :command     => "nova-manage db archive_deleted_rows --max_rows #{params[:max_rows]} --until-complete >>#{params[:destination]} 2>&1",
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
