# == Class: beaver::service
#
# This class installs the beaver package and init scripts.
# It should not be directly called
#
#
# === Authors
#
# * Justin Lambert <mailto:jlambert@letsevenup.com>
#
class beaver::service {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  case $beaver::enable {
    true: {
      $ensure_real = 'running'
      $enable_real = true
    }
    default: {
      $ensure_real = 'stopped'
      $enable_real = false
    }
  }

  if $::operatingsystem == 'Ubuntu' {
    file { '/etc/init/beaver.conf':
      ensure  => file,
      mode    => '0555',
      owner   => 'root',
      group   => 'root',
      content => template('beaver/beaver-upstart.erb'),
    } -> Service['beaver']
  } else {
    file { '/etc/init.d/beaver':
      ensure  => file,
      mode    => '0555',
      owner   => 'root',
      group   => 'root',
      content => template('beaver/beaver.init.erb'),
    } -> Service['beaver']
  }

  service { 'beaver':
    ensure => $ensure_real,
    enable => $enable_real,
  }
}
