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
        :verbose        => false,
        :until_complete => false,
        :all_cells      => false,
        :age            => false,
        :maxdelay       => 0,
        :task_log       => false,
        :destination    => '/var/log/nova/nova-rowsflush.log' }
    end

    context 'ensure the cron job is absent' do
      before :each do
        params.merge!(
          :ensure => :absent,
        )
      end

      it 'removes the cron job' do
        is_expected.to contain_cron('nova-manage db archive_deleted_rows').with_ensure(:absent)
      end
    end

    context 'until_complete and all_cells is false' do
      it 'configures a cron without until_complete and all_cells' do
        is_expected.to contain_cron('nova-manage db archive_deleted_rows').with(
          :ensure      => :present,
          :command     => "nova-manage db archive_deleted_rows --max_rows #{params[:max_rows]} >>#{params[:destination]} 2>&1",
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

    context 'verbose is true' do
      before :each do
        params.merge!(
          :verbose => true,
        )
      end

      it 'configures a cron with until_complete' do
        is_expected.to contain_cron('nova-manage db archive_deleted_rows').with(
          :ensure      => :present,
          :command     => "nova-manage db archive_deleted_rows --max_rows #{params[:max_rows]} --verbose >>#{params[:destination]} 2>&1",
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
          :ensure      => :present,
          :command     => "nova-manage db archive_deleted_rows --max_rows #{params[:max_rows]} --until-complete >>#{params[:destination]} 2>&1",
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

    context 'all_cells is true' do
      before :each do
        params.merge!(
          :all_cells => true,
        )
      end

      it 'configures a cron with all_cells' do
        is_expected.to contain_cron('nova-manage db archive_deleted_rows').with(
          :ensure      => :present,
          :command     => "nova-manage db archive_deleted_rows --max_rows #{params[:max_rows]} --all-cells >>#{params[:destination]} 2>&1",
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

    context 'task_log is true' do
      before :each do
        params.merge!(
          :task_log => true,
        )
      end

      it 'configures a cron with task_log' do
        is_expected.to contain_cron('nova-manage db archive_deleted_rows').with(
          :ensure      => :present,
          :command     => "nova-manage db archive_deleted_rows --max_rows #{params[:max_rows]} --task-log >>#{params[:destination]} 2>&1",
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
          :ensure      => :present,
          :command     => "nova-manage db archive_deleted_rows --purge --max_rows #{params[:max_rows]} >>#{params[:destination]} 2>&1",
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
          :ensure      => :present,
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
          :ensure      => :present,
          :command     => "sleep `expr ${RANDOM} \\% #{params[:maxdelay]}`; nova-manage db archive_deleted_rows --max_rows #{params[:max_rows]} >>#{params[:destination]} 2>&1",
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

    context 'cron with age' do
      before :each do
        params.merge!(
          :age => 5
        )
      end

      it 'configures a cron with --before' do
        is_expected.to contain_cron('nova-manage db archive_deleted_rows').with(
          :ensure      => :present,
          :command     => "nova-manage db archive_deleted_rows --max_rows #{params[:max_rows]} --before `date --date='today - #{params[:age]} days' +\\%F` >>#{params[:destination]} 2>&1",
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

    context 'until_complete enabled and sleep set' do
      before :each do
        params.merge!(
          :until_complete => true,
          :sleep          => 5,
        )
      end

      it 'configures a cron with --before' do
        is_expected.to contain_cron('nova-manage db archive_deleted_rows').with(
          :ensure      => :present,
          :command     => "nova-manage db archive_deleted_rows --max_rows #{params[:max_rows]} --until-complete --sleep #{params[:sleep]} >>#{params[:destination]} 2>&1",
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
