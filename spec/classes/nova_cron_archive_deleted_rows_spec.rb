require 'spec_helper'

describe 'nova::cron::archive_deleted_rows' do

  let :facts do
    OSDefaults.get_facts({ :osfamily => 'Debian' })
  end

  let :params do
    { :minute      => 1,
      :hour        => 0,
      :monthday    => '*',
      :month       => '*',
      :weekday     => '*',
      :max_rows    => '100',
      :user        => 'nova',
      :destination => '/var/log/nova/nova-rowsflush.log' }
  end

  it 'configures a cron' do
    is_expected.to contain_cron('nova-manage db archive_deleted_rows').with(
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
