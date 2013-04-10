Torque-Switch
=============

A custom script to switch versions of torque resource manager


INSTALLATION

This script assumes that you have more than 1 torque version installed in the /var/spool directory like this

/var/spool/torque4.0
/var/spool/torque2.5.9

It also assumes that you have your environment variables in a specific place. 
Typically in linux you can put the environment variables in ~/.bashrc for each user
or in /etc/profile

However it is recomended that you put the environment variables in a file named torque.sh in the /etc/profile.d/ directort

/etc/profile.d/torque.sh

an example of this file would be

export PATH=$PATH:/var/spool/torque4.0:/var/spool/torque4.0/bin:/var/spool/torque4.0/sbin


