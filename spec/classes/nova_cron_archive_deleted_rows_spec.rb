require 'spec_helper'

describe 'nova::cron::archive_deleted_rows' do

  shared_examples_for 'nova::cron::archive_deleted_rows' do

    let :params do
      { :minute         => 1,
        :hour           => 0,
        :monthday       => '*',
        :month          => '*',
        :weekday        => '*',
        :max_rows       => '100',
        :user           => 'nova',
        :until_complete => false,
        :maxdelay       => 0,
        :destination    => '/var/log/nova/nova-rowsflush.log' }
    end

    context 'until_complete is false' do
      it 'configures a cron without until_complete' do
        is_expected.to contain_cron('nova-manage db archive_deleted_rows').with(
          :command     => "nova-manage db archive_deleted_rows  --max_rows #{params[:max_rows]}  >>#{params[:destination]} 2>&1",
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
          :command     => "nova-manage db archive_deleted_rows  --max_rows #{params[:max_rows]} --until-complete >>#{params[:destination]} 2>&1",
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

    context 'purge is true' do
      before :each do
        params.merge!(
          :purge => true,
        )
      end

      it 'configures a cron with purge' do
        is_expected.to contain_cron('nova-manage db archive_deleted_rows').with(
          :command     => "nova-manage db archive_deleted_rows --purge --max_rows #{params[:max_rows]}  >>#{params[:destination]} 2>&1",
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

    context 'full purge' do
      before :each do
        params.merge!(
          :purge => true,
          :until_complete => true,
        )
      end

      it 'configures a cron with all purge params' do
        is_expected.to contain_cron('nova-manage db archive_deleted_rows').with(
          :command     => "nova-manage db archive_deleted_rows --purge --max_rows #{params[:max_rows]} --until-complete >>#{params[:destination]} 2>&1",
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

    context 'cron with maxdelay' do
      before :each do
        params.merge!(
          :maxdelay => 600
        )
      end

      it 'configures a cron with maxdelay' do
        is_expected.to contain_cron('nova-manage db archive_deleted_rows').with(
          :command     => "sleep `expr ${RANDOM} \\% #{params[:maxdelay]}`; nova-manage db archive_deleted_rows  --max_rows #{params[:max_rows]}  >>#{params[:destination]} 2>&1",
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

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end
      it_configures 'nova::cron::archive_deleted_rows'
    end
  end

end
