#!/bin/bash
echo $PATH
# initialize variables, not really necessary, but looks nice
TORQUE_VERSION=""
NEW_TORQUE_VERSION=""
ENVIRONMENT_VARIABLE=/etc/profile.d/torque.sh
echo "number of parameters $#"
if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root" 1>&2
	exit 1
#Check and see if they called the program with no parameters
elif [[ "$#" < 1 ]]
then

		#Test to see if torque is in exising path. 
		if `echo $PATH | grep "torque" 1>/dev/null 2>&1`
		then
		        #Save torque version to a variable
		        TORQUE_VERSION='pbs_server -v'
		        echo "Torque Version `$TORQUE_VERSION 2>&1` found running"
		else
		        #error_exit "Torque is not found in the path" 
		        #  error_exit "Torque is not found in the path" 
	        echo "Torque is not installed or it can not be found in the path"
		fi
	echo "second else parameters $#"
        echo -e \\n"###############################"
        echo -e "You can call this program with the version of torque you want to use\\nExample torque.sh 2.5.9"
        echo -e "###############################" \\n
        #echo -e "Enter the version you want now: \\n \\t"

        read -e -p "Enter the version to switch to: " -i "2.5.9"  NEW_TORQUE_VERSION
	echo " Version set to $NEW_TORQUE_VERSION"
elif [[ "$#" = 1 ]]
then
	echo "setting torque version to argument $1"
	NEW_TORQUE_VERSION=$1
elif [[ "$#" > 1 ]]
then
	echo "third else parameters $#"
	echo "This program only accepts 1 parameter" 1>&2
	exit 1
fi





###########################################################################
#End Pre Check




# -- TODO -- Make this code flexible enough to run on other peoples systems
#See if /etc/profile.d/torque.sh exists
#if [ -a !$ENVIRONMENT_VARIABLE ]
#then
#       echo "There is no file at /etc/profile.d/torque.sh"
#       echo -e "This is how this computer knows where the pbs_server command is"
#       read -p "Would you like to create this file? It will override all other torque environment variables" -i y {y/n}?





####################################################################





function stop_torque 
{
	echo `pkill -9 pbs`
	echo Torque Service Stoped
	#Version 4 of torque has extra service called trqauthd
	if (( "${TORQUE_VERSION:0:1}" >= "4" ))
	then
		echo `service trqauthd stop`
		echo trqauthd service stoped
	fi
}
 #end function stop_torque###########






function start_torque 
{
	#Start torque

       /usr/local/$NEW_TORQUE_VERSION/sbin/pbs_server 
	echo "torque version $NEW_TORQUE_VERSION started"
	echo `pbs_server -v` "Is now running"
	#Version 4 of torque has extra service called trqauthd
	if (( "${NEW_TORQUE_VERSION:0:1}" >= "4" ))
	then
		service trqauthd start;
		echo trqauthd started
	fi
}
#end function start_torque()###########





function set_env_variable 
{
	#NEW_PATH=cat /etc/profile.d/torque.sh | sed "s#torque[0-9]\(\.[0-9]\)\{0,\}#$NEW_TORQUE_VERSION#g"

	#Perminatly change the file /etc/profile.d/torque.d to the new variable
	sed -i "s#torque[0-9]\+\(\.[0-9]\+\)\{0,\}#torque$NEW_TORQUE_VERSION#g" $ENVIRONMENT_VARIABLE
	
	#Environment variables aren't updated until log out , here is fix to temporalily duplicate in current shell
		
	echo -e "$ENVIRONMENT_VARIABLE\\n has been modified with\\n $NEW_TORQUE_VERSION"
	#Overwrite the old path with the location of the new torque version
	#TODO -- This will only be temporary, needs to be perminant
	#echo `export PATH=$NEW_PATH`
	#echo "Session PATH was set to $NEW_PATH"
	

}
 #end function set_env_variable()############




stop_torque
set_env_variable
start_torque

echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
echo !!
echo !! Torque has been changed, but will only
echo !! apply to new shells, exit all shells and
echo !! reopen them 
echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
