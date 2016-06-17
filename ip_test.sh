#######################[CUT ME]#######################

#!/bin/bash
#
# SIMPLE IP CHECKER by @arkanet arkantiko@gmail.com
#
mkdir /var/log/IP_CHECK
#DIR="./"
DIR="/var/log/IP_CHECK/"
# Do the work
while true; do
	FILE=${DIR}`date "+%Y_%m_%d"`.log
	echo -e "\n#################### [$(date +"\033[01;32m%F\033[00m \033[01;31m%T\033[00m")] ######################" >> ${FILE}
	test_ping=$(ping -c 3 www.google.com | while read pong; do echo -e "[$(date +"\033[01;32m%F\033[00m \033[01;31m%T\033[00m")] ${pong}"; done)
	test_ip=$(curl -s checkip.dyndns.com | awk ' BEGIN { FS = ": " } ; {print $2} ' | cut -d '<' -f1 | while read pong; do echo -e "[$(date +"\033[01;32m%F\033[00m \033[01;31m%T\033[00m")] ${pong}"; done)
	echo -e "${test_ping}\n" >> ${FILE}
	echo "${test_ip}" >> ${FILE}
	echo -e "#################################################################\n" >> ${FILE}
	sleep 60
done
exit 0

#######################[CUT ME]#######################

#!/bin/bash
#
# SIMPLE IP CHECKER BETA by @arkanet arkantiko@gmail.com
#
mkdir /var/log/IP_CHECK
#DIR="./"
DIR="/var/log/IP_CHECK/"
# Do the work
while true; do
	FILE=${DIR}`date "+%Y_%m_%d"`.log
	echo -e "\n#################### [$(date +"\033[01;32m%F\033[00m \033[01;31m%T\033[00m")] ######################" >> ${FILE}
	test_ping=$(echo $(ping -c 1 www.google.com | grep "packet loss" | awk ' BEGIN { FS = ", " } ; {print $3} ' | awk ' {print $1} ' | cut -d'%' -f1))
	if [ ${test_ping} = 0 ]
		then
			ping=$(ping -c 3 www.google.com | while read pong; do echo -e "[$(date +"\033[01;32m%F\033[00m \033[01;31m%T\033[00m")] ${pong}"; done)
			echo -e "${ping}" >> ${FILE}
			test_ip=$(curl -s checkip.dyndns.com | awk ' BEGIN { FS = ": " } ; {print $2} ' | cut -d '<' -f1 | while read pong; do echo -e "[$(date +"\033[01;32m%F\033[00m \033[01;31m%T\033[00m")] MY IP IS: ${pong}"; done)
			echo -e "[$(date +"\033[01;32m%F\033[00m \033[01;31m%T\033[00m")]" >> ${FILE}
			echo -e "${test_ip}" >> ${FILE}
		else
			ping=$(ping -c 1 192.168.1.254 | while read pong; do echo -e "[$(date +"\033[01;32m%F\033[00m \033[01;31m%T\033[00m")] ${pong}"; done)
			echo -e "${ping}" >> ${FILE}
			echo -e "[$(date +"\033[01;32m%F\033[00m \033[01;31m%T\033[00m")] NO INTERNET CONNECTION AVAILABLE \n" >> ${FILE}
	fi
	echo -e "#################################################################\n" >> ${FILE}
	sleep 60
done
exit 0

#######################[CUT ME]#######################

#!/bin/bash
#
# EASY IP LOGGER RC1 by @arkanet arkantiko@gmail.com
#
DIR="/var/log/IP_LOG/"
if [ -d ${DIR} ]
	then
		DIR=$DIR
	else
		mkdir /var/log/IP_LOG
		DIR="/var/log/IP_LOG/"
fi
HOST="www.google.com"
GW="192.168.1.254"
while true; do
        FILE=${DIR}`date "+%Y_%m_%d"`.log
        test_ping=$(echo $(ping -c 1 ${HOST} | grep "packet loss" | awk ' BEGIN { FS = ", " } ; {print $3} ' | awk ' {print $1} ' | cut -d'%' -f1))
        test_gw=$(echo $(ping -c 1 ${GW} | grep "packet loss" | awk ' BEGIN { FS = ", " } ; {print $3} ' | awk ' {print $1} ' | cut -d'%' -f1))
        if [ ${test_ping} -eq 0 -a ${test_gw} -eq 0 ]
                then
			echo -e $(curl -s checkip.dyndns.com | awk ' BEGIN { FS = ": " } ; {print $2} ' | cut -d '<' -f1 | while read host; do echo -e "[$(date +"\033[01;32m%F\033[00m \033[01;31m%T\033[00m")] MY IP IS REACHABLE: [${host}]"; done) >> ${FILE}
        elif [ ${test_ping} -ne 0 -a ${test_gw} -eq 0 ]
                then
                        echo -e "[$(date +"\033[01;32m%F\033[00m \033[01;31m%T\033[00m")] YOUR INTERNET CONNECTION UNAVAILABLE" >> ${FILE}
                        echo -e "[$(date +"\033[01;32m%F\033[00m \033[01;31m%T\033[00m")] BUT YOUR GW [${GW}] IS REACHABLE" >> ${FILE}
	else
		echo -e "[$(date +"\033[01;32m%F\033[00m \033[01;31m%T\033[00m")] YOUR INTERNET CONNECTION IS UNAVAILABLE" >> ${FILE}
		echo -e "[$(date +"\033[01;32m%F\033[00m \033[01;31m%T\033[00m")] AND YOUR GW [${GW}] IS UNREACHABLE" >> ${FILE}
        fi
        sleep 60
done
exit 0


#######################[CUT ME]#######################
