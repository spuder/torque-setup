## This is a script to download torque, compile and install it

#1. Check if running as root
	#a. Yes - continue
	#b. Die
#2. Check for parameters
	#a. Yes - continue
	#b. No - Ask for user parameters & inform them of their ineffeciency

#3. Download gcc, openssl-devel, git, hg, svn, libxml2-devel,libtool
#4. Download from Git
#5. Run autoconfi && autogen
#6. Run ./configure --with-debug --with-server-home=/var/spool/torque/{1} --prefix=/usr/local/torque/{1} --enable-docs
#7. Run make 
#8. Run ./torque-setup
#9. Add torque to path through export or profile.d
#10. Start trqauthd 
#11. Run make packages
#10. Ask if user would like to scp mom stuff to moms
	#a. Yes - scp packages
	#b. No - Do nothing
#11. Make /etc/profile.d/torque.sh file
#12. Add dummy file to /var/spool/torque/{1}/4.1.txt (See the moab script for explination on this)



#1. Check if running as root
if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root" 1>&2
	exit 1
else
	echo "Root permisions detected"
fi

#2. Check for parameters
if [[ "$#" > 1 ]];
then
	echo "This program only supports 1 parameter" 
	exit 1
elif [[ "$#" <1 ]]; then
	#statements
	echo "No Parameter definded, defaulting to 4.2.2 "
	TORQUEVERSION="4.2.2"
	echo "TORQUEVERSION = " $TORQUEVERSION
else 
	echo "1 Parameter defined "$1
	TORQUEVERSION=$1
fi

#3. Download gcc, openssl-devel, git, hg, svn, libxml2-devel,libtool
echo "Installing autogen, git, openssl ect.."
yum install autoconf make autogen gcc gcc-c++ openssl-devel git hg svn libxml2-devel libtool -y | tee /tmp/spencerTorqueInstall
#yum install glibc
#yum install libxcb-devel 


#4 Download from Git

REPOSITORY="git://github.com/adaptivecomputing/torque.git"

LOCALFOLDER="/var/spool/torque/src"


# Two decision trees depending if we have already cloned the git source code
if [ "$(ls -A $LOCALFOLDER)" ]; then
	echo "$LOCALFOLDER already exists, pulling existing repo!!!!"
    git pull
else
	echo "$LOCALFOLDER does not exist, creating directory"
	mkdir -p $LOCALFOLDER
	cd $LOCALFOLDER
    git clone -b $TORQUEVERSION $REPOSITORY $LOCALFOLDER
fi



#5 cd into src directory
cd $LOCALFOLDER
echo "cd into source folder" $LOCALFOLDER
ls
autoconf
./autogen.sh | tee /tmp/spencerTorqueInstall
./configure --with-debug --with-server-home=/var/spool/torque/$torqueVersion --prefix=/var/spool/torque/$torqueVersion
#./configure --with-debug --with-server-home=/var/spool/torque/$torqueVersion --prefix=/var/spool/torque/$torqueVersion --enable-docs

#7 Make
cd $LOCALFOLDER
make clean
make
make install

#8 Run torque setup
cd $LOCALFOLDER
./torque.setup root



