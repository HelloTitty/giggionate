#!/bin/bash

NC='\033[0m' # No Color

# Reset
Color_Off='\033[0m'       # Text Reset

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

# Underline
UBlack='\033[4;30m'       # Black
URed='\033[4;31m'         # Red
UGreen='\033[4;32m'       # Green
UYellow='\033[4;33m'      # Yellow
UBlue='\033[4;34m'        # Blue
UPurple='\033[4;35m'      # Purple
UCyan='\033[4;36m'        # Cyan
UWhite='\033[4;37m'       # White

# Background
On_Black='\033[40m'       # Black
On_Red='\033[41m'         # Red
On_Green='\033[42m'       # Green
On_Yellow='\033[43m'      # Yellow
On_Blue='\033[44m'        # Blue
On_Purple='\033[45m'      # Purple
On_Cyan='\033[46m'        # Cyan
On_White='\033[47m'       # White

# High Intensity
IBlack='\033[0;90m'       # Black
IRed='\033[0;91m'         # Red
IGreen='\033[0;92m'       # Green
IYellow='\033[0;93m'      # Yellow
IBlue='\033[0;94m'        # Blue
IPurple='\033[0;95m'      # Purple
ICyan='\033[0;96m'        # Cyan
IWhite='\033[0;97m'       # White

# Bold High Intensity
BIBlack='\033[1;90m'      # Black
BIRed='\033[1;91m'        # Red
BIGreen='\033[1;92m'      # Green
BIYellow='\033[1;93m'     # Yellow
BIBlue='\033[1;94m'       # Blue
BIPurple='\033[1;95m'     # Purple
BICyan='\033[1;96m'       # Cyan
BIWhite='\033[1;97m'      # White

# High Intensity backgrounds
On_IBlack='\033[0;100m'   # Black
On_IRed='\033[0;101m'     # Red
On_IGreen='\033[0;102m'   # Green
On_IYellow='\033[0;103m'  # Yellow
On_IBlue='\033[0;104m'    # Blue
On_IPurple='\033[0;105m'  # Purple
On_ICyan='\033[0;106m'    # Cyan
On_IWhite='\033[0;107m'   # White


function header {
	clear
	echo "##########################################################################"
	echo "# Tims Backup Script - August 2009                                       #"
	echo "# (backup web folders and mysql databases to local and remote locations) #"
	echo "##########################################################################"
	echo
}

## Define Variables

# local folders and filenames
backupdir="/var/www_backup/"          # include trailing slash!
basedir="/var/www/"   # include trailing slash!
webfile="$(date +%Y%m%d)-www.tgz"

# MySQL variables (create a backup account)
sqlfile="$(date +%Y%m%d)-mysqldump.tgz"
sqlhost="localhost"
sqluser="root"
sqlpass="cmzu83x1"

# SSH variables (assumes you have already paired ssh key with remote host)
scphost="localhost"
scpuser="root"
scpremotepath="/var/www_backup"

# Mail  (requires /usr/bin/mail (mailutils package))
notify="gubi.ale@gmail.com"
tmpmailfile="/tmp/notifymsg.txt" # use this if you want to send stdout as email
finalmsgfile="./backupemail.txt" # use this for slim emails

######################################################################
###     USERS SHOULD NOT HAVE TO EDIT BELOW HERE!                  ###
######################################################################

# Define functions
function usage {
	echo "	Usage: $0 [OPTIONS] [confirm]"
	echo 
	echo " STANDALONE OPTIONS:"
	echo 
	echo "  --listvars  : List configured variables"
	echo "  --checkdirs : Check for required directories"
	echo "  --dumpmysql : Only dump MySQL"
	echo "  --dumpweb   : Only dump web file"
	echo "  --scp       : Only SCP existing files and exit"
	echo "  --rsync     : Only rsync existing files and exit"
	echo
	echo " AUTOMATED OPTIONS:"
	echo "  [confirm] sends email to $notify on completion"
	echo
	echo "  --local       : Create & copy to $backupdir locally ($HOSTNAME)"
	echo "  --remote scp  : Create & transfer files to $scphost using scp"
	echo "  --remote rsync: Create & transfer files to $scphost using rsync"
	echo
	exit
	}

function checkdirs {
	echo
	echo "Checking for backupdir $backupdir :"
		if [ -d $backupdir ]; then
			echo " ...Backup directory found!"
			echo
		elif [ ! -d $backupdir ]
			then 
				echo " ...Your backup directory does not exist!"
				echo
				echo "You can try manually creating it."
				echo
				echo "I am now crashing to your command prompt."
				exit
		fi
}

function web2local {
	echo "Backing up web directory (may require sudo password):"
	# create a tgz with permissions from basedir to backupdir
	sudo tar cpPzf $backupdir$webfile $basedir 
	echo -e "${BGreen}...finished creating web backup${NC}"
	echo 
}
	
function dumpmysql {
	echo "Now performing MySQL dump on entire server."
	# dump mysql data to tgz in backup directory
	mysqldump -h $sqlhost --user="$sqluser" --password="$sqlpass" --all-databases | gzip > $backupdir$sqlfile
	echo -e "${BGreen}...finished MySQL dump${NC}"
	echo
}

function scpfiles {
	echo -e "${BGreen}Copying $backupdir$sqlfile to $scpuser@$scphost:$scpremotepath$sqlfile${NC}"
	scp $backupdir$sqlfile $scpuser@$scphost:$scpremotepath$sqlfile
	echo -e "${BGreen}Copying $backupdir$webfile to $scpuser@$scphost:$scpremotepath$sqlfile${NC}"
	scp $backupdir$webfile $scpuser@$scphost:$scpremotepath$webfile
}

function rsyncfiles {
	echo -e "${BGreen}Copying $backupdir$sqlfile to $scpuser@$scphost:$scpremotepath$sqlfile${NC}"
	rsync -av $backupdir$sqlfile $scpuser@$scphost:$scpremotepath
	echo -e "${BGreen}Copying $backupdir$webfile to $scpuser@$scphost:$scpremotepath$sqlfile${NC}"
	rsync -av $backupdir$webfile $scpuser@$scphost:$scpremotepath
}

function tasktimer {
	endtime="$(date +%s)"
	elapsedtime="$(expr $endtime - $starttime)"
	elapsedminutes=$(($elapsedtime/60))
	elapsedseconds=$(($elapsedtime%60))
	echo
		if [ "$elapsedtime" -lt "60" ]; then
			echo "Total elapsed time = $elapsedtime seconds"
		else
			echo "Total elapsed time = $elapsedminutes min $elapsedseconds secs"
		fi
	echo
}

function finalstats {
	webfilesize="$(stat -c%s "$backupdir$webfile")"
	webfilesizemb="$(expr $webfilesize / 1024 / 1024)"
	sqlfilesize="$(stat -c%s "$backupdir$sqlfile")"
	sqlfilesizemb="$(expr $sqlfilesize / 1024 / 1024)"
	echo
	echo "Final Results:"
	echo " $backupdir$webfile = $webfilesize bytes ($webfilesizemb MB)"
	echo " $backupdir$sqlfile = $sqlfilesize bytes ($sqlfilesizemb MB)"
		if [ "$backuptype" != "Local" ]; then
			echo
			echo "Transferred to $webfile and $sqlfile to $scphost using $backuptype"
		fi
	tasktimer
}

function mailresults {
	SUBJECT="Backup Results for $UID on $HOSTNAME"
	TO="$notify"
	finalstatsmsg=$(finalstats)

	echo "$backuptype backup has been completed!" > $finalmsgfile
	echo "$finalstatsmsg" >> $finalmsgfile
	echo "Attempting to send mail to $notify"
#	if [ "$3" == "slim" ]; then
		/usr/bin/mail -s "$SUBJECT" -t "$TO" < $finalmsgfile
		rm $finalmsgfile
#	elif [ "$3" != "slim" ]; then
#		/usr/bin/mail -s "$SUBJECT" -t "$TO" < $tmpmailfile
#		rm $tmpmailfile
		echo " ...sent!"
#	fi
}


###  The goods.

starttime="$(date +%s)"
header

	if [ -z "$1" ]; then
		usage
		exit

	elif [ "$1" == "--help" ]; then
		usage
		exit

	elif [ "$1" == "--listvars" ]; then
		echo "Defined Variables:"
		echo
		echo "  Root Web Directory      : $basedir"
		echo "  Backup Directory        : $backupdir"
		echo "  Web Archive File        : $backupdir$webfile"
		echo "  MySQL Archive File      : $backupdir$sqlfile"
		echo
		echo "  MySQL Host              : $sqlhost"
		echo "  MySQL User              : $sqluser"
		echo "  MySQL Pass              : $sqlpass"
		echo
		echo "  SCP / Rsync Host        : $scphost"
		echo "  SCP / Rsync User        : $scpuser"
		echo "  SCP / Rsync Remote Path : $scpremotepath"
		echo
		echo "  Notification E-Mail     : $notify"
		echo
				
	elif [ "$1" == "--checkdirs" ]; then
		echo "** SINGLE TASK MODE **"
		checkdirs
		tasktimer
		echo -e "${BGreen}** TASK COMPLETED **${NC}"
		
	elif [ "$1" == "--dumpmysql" ]; then
		echo "** SINGLE TASK MODE **"
		dumpmysql
		tasktimer
		echo -e "${BGreen}** TASK COMPLETED **${NC}"
		
	elif [ "$1" == "--dumpweb" ]; then
		echo "** SINGLE TASK MODE **"
		web2local
		tasktimer
		echo -e "${BGreen}** TASK COMPLETED **${NC}"
		
	elif [ "$1" == "--scp" ]; then
		echo "** SINGLE TASK MODE **"
		scpfiles
		tasktimer
		echo -e "${BGreen}** TASK COMPLETED **${NC}"
		
	elif [ "$1" == "--rsync" ]; then
		echo "** SINGLE TASK MODE **"
		rsyncfiles
		tasktimer
		echo -e "${BGreen}** TASK COMPLETED **${NC}"
			
	elif [ "$1" == "--local" ]; then
		backuptype="Local"
		echo "** BEGINNING LOCAL BACKUP SEQUENCE **"
		echo
		checkdirs
		web2local
		dumpmysql
		echo -e "${BGreen}** LOCAL BACKUP SEQUENCE COMPLETE **${NC}"
		finalstats
			if [ "$2" == "confirm" ]; then
				mailresults
			fi
	
	elif [ "$1" == "--remote" ]; then
		if [ -z "$2" ]; then
			usage
			exit

		elif [ "$2" == "scp" ]; then
			backuptype="Remote SCP"
			echo "** BEGINNING REMOTE SCP BACKUP SEQUENCE **"
			checkdirs
			web2local
			dumpmysql
			scpfiles
			echo 
			echo -e "${BGreen}** SCP BACKUP COMPLETED **${NC}"
			echo
			finalstats
				if [ "$3" == "confirm" ]; then
					mailresults
				fi
			echo
			
		elif [ "$2" == "rsync" ]; then
			backuptype="Remote RSYNC"
			echo "** BEGINNING REMOTE RSYNC BACKUP SEQUENCE **"
			checkdirs
			web2local
			dumpmysql
			rsyncfiles
			echo
			echo -e "${BGreen}** RSYNC BACKUP COMPLETED **${NC}"
			echo
			finalstats
				if [ "$3" == "confirm" ]; then
					mailresults
				fi
			echo
		else 
			usage
			exit
		fi
	else
		usage
		exit
	fi
echo
exit
