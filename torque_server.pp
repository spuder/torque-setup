class torque::server($install_version = '4.2.2') {
  include vcsrepo #http://livecipher.blogspot.com/2013/01/deploy-code-from-git-using-puppet.html
$repo = "git://github.com/adaptivecomputing/torque.git"
$install_dir = "/var/spool/torque"


  exec {'git_pull':
   command => "git clone ${repo} ${install_dir}",
  }
}
class {'torque::server':}
