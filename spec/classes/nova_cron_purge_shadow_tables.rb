require 'spec_helper'
require 'date'

describe 'nova::cron::purge_shadow_tables' do

  shared_examples_for 'nova::cron::purge_shadow_tables' do

    let :params do
      { :minute      => 0,
        :hour        => 12,
        :monthday    => '*',
        :month       => '*',
        :weekday     => '6',
        :user        => 'nova',
        :maxdelay    => 0,
        :destination => '/var/log/nova/nova-rowspurge.log',
        :age         => 10 }
    end

    context 'verbose is true' do
      before :each do
        params.merge!(
          :verbose => true,
        )
      end

      it 'configures a nova purge cron with verbose output' do
        is_expected.to contain_cron('nova-manage db purge').with(
          :command     => "nova-manage db purge --before `date --date='today - #{params[:age]} days' +\\%D` --verbose  >>#{params[:destination]} 2>&1",
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
          :command     => "nova-manage db purge --before `date --date='today - #{params[:age]} days' +\\%D`   >>#{params[:destination]} 2>&1",
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

    context 'all_cells is true' do
      before :each do
        params.merge!(
          :all_cells => true,
        )
      end

      it 'configures a nova purge cron with all cells enabled' do
        is_expected.to contain_cron('nova-manage db purge').with(
          :command     => "nova-manage db purge --before `date --date='today - #{params[:age]} days' +%D` --verbose --all-cells >>#{params[:destination]} 2>&1",
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

    context 'cron with maxdelay' do
      before :each do
        params.merge!(
          :maxdelay => 600
        )
      end

      it 'configures a nova purge cron with maxdelay' do
        is_expected.to contain_cron('nova-manage db purge').with(
          :command     => "sleep `expr ${RANDOM} \\% #{params[:maxdelay]}`; nova-manage db purge --before `date --date='today - #{params[:age]} days' +\\%D` --verbose --all-cells >>#{params[:destination]} 2>&1",
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

      it_configures 'nova::cron::purge_shadow_tables'
    end
  end

end
