# Logic for setting up a private tmp directory for the agent
# *** This type should be considered private to this module ***
define bamboo_agent::private_tmp(
  $path       = $title,
  $user,
  $group,
){

  file { $path:
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => '0755', # Only used by Bamboo user, no need for sticky
  }

  unless defined(Package['tmpwatch']){
    package { 'tmpwatch': ensure => installed }
  }

  cron { "${path}-tmp-cleanup":
    minute  => 15,
    command => "/usr/sbin/tmpwatch 10d ${path}",
    require => [Package['tmpwatch'],
                File[$path]],
  }
}
