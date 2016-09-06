# Declares the agent a Puppet service and ensures it is running and enabled,
# after rendering an init script that delegates to the agent's bamboo-agent.sh
# script.
# *** This type should be considered private to this module ***
define bamboo_agent::service(
  $home,
  $id = $title,
  $user,
){

  $service = "bamboo-agent${id}"
  $script  = "${home}/bin/bamboo-agent.sh"

  if $::osfamily == 'RedHat' and $::operatingsystemmajrelease == '7' {
    file { "/usr/lib/systemd/system/${service}.service":
      ensure  => file,
      alias   => "${service} init file",
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('bamboo_agent/systemd-script.erb'),
    }
  } else {
    file { "/etc/init.d/${service}":
      ensure  => file,
      alias   => "${service} init file",
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      content => template('bamboo_agent/init-script.erb'),
    }
    ->
    exec { "reload-systemd-after-${service}-change":
      command     => 'systemctl daemon-reload',
      refreshonly => true
    }
  }

  service { $service:
    ensure  => running,
    enable  => true,
    require => File["${service} init file"]
  }
}
