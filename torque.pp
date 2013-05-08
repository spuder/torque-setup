class torque::pbs_server {
  ##require puppetlabs-git
user { 'root':
	ensure  => present,
}

case $operatingsystem {
	centos,redhat: {$openssl_devel = 'openssl-devel'}
	centos,redhat: {$libxml2_devel	= 'libxml2-devel'}
  centos,redhat: {$c_plus_compiler = 'gcc-c++'}
	debian,ubuntu: {$openssl_devel = 'libssl-dev'}
	debian,ubuntu: {$libxml2_devel	= 'libxml2-dev'}
  debian,ubuntu: {$c_plus_compiler = 'build-essential'}
	default:{fail("Unable to set openssl-devel, os type not regognized") }
}
package {'openssl-devel':
	name     => $openssl_devel,
	ensure   => latest,
  require => Package['puppetlabs-git'],
}
package {'git':
	ensure => installed,
}
package {'libxml2-devel':
	name => $libxml2_devel,
	ensure => installed,
}
package {'gcc':
  ensure => installed,
}
package {'c++_compiler':
  name   => $c_plus_compiler,
  ensure => installed,
}
package {'libtool': 
  ensure => installed,
}


}
class {'torque::pbs_server':}
