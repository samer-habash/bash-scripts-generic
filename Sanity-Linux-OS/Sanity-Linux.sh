#!/usr/bin/env bash
export export PATH=/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin
array=("server1", "server2") # etc ...

#Check Installation of rsync/sysstat/taskset/perl packages
if [[ ! $(command -v rsync) ]]
then
  sudo yum install rsync -y
elif [[ ! $(command -v mpstat) ]]
then
  sudo yum install sysstat -y
elif [[ ! $(command -v taskset) ]]
then
  sudo yum install -y util-linux
elif [[ ! $(command -v perl) ]]
then
  sudo yum install -y perl
fi

for server in "${array[@]}"
do
`which ssh` sshuser@${server} 'bash -s' <<  \EOF
#Check which core is free and append it lastly in file /tmp/idle
NoOfCore=`nproc --all`
idleCol=$(mpstat -P ALL | awk '{for(i=1;i<=NF;i++) if($i == "%idle") print i}')
CPUCol=$(mpstat -P ALL | awk '{for(i=1;i<=NF;i++) if($i == "CPU") print i}')

freethread=$(mpstat -P ALL | awk '{print $'$CPUCol',$'$idleCol'}'| awk '{if ($2 > 60) {print $1}}' | tail -1)
export FC=$freethread

cat << \EOL > /tmp/Sanity.sh

#!/bin/bash
export PATH=/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin
export d=`date +%Y%m%d`
#export d=`date +%Y%m%d -d '1 days ago'`
export M=`date "+%b %d"`
export P=`date +"%H:%M %p"`
host=`hostname | awk -F"." '{print $1}'`
#IP=`curl -s checkip.amazonaws.com`
Date=`date`

truncate -s 0 /tmp/Sanity
touch /tmp/Sanity

#############################
### Services running checks #
#############################

# Service 1, 2, 3 is checked from below

if [[ -n $( ps aux | grep -E "(service1|service2|service3)" | grep -v grep ) ]];then
	touch /tmp/Sanity
	echo "                   ------  Sanity Daily Report AT $Date For $host   -------                " >> /tmp/Sanity
	echo " " >> /tmp/Sanity
	echo "NOTE :- If there is an empty lines after each header then there is no errors or results" >> /tmp/Sanity
	echo "
										-Service Status :-
	" >> /tmp/Sanity
	echo "Services is successfuly running  On Host $host" >> /tmp/Sanity
else
	touch /tmp/Sanity
	echo "                   ------   Sanity Daily Report AT $Date For $host   -------                " >> /tmp/Sanity
	echo " " >> /tmp/Sanity
	echo " NOTE :- If there is an empty lines after each header then there is no errors or results" >> /tmp/Sanity
	echo "
										-Service Status :-
	" >> /tmp/Sanity
	echo "Service1 is NOT running  On Host $host" >> /tmp/Sanity
fi

##############################
### Check Core Dump Statuses #
##############################

ls2=$(cd /var/lib/coredumps && ls -lh | awk 'NR>1' | awk '{print $6,$7}')
echo "
										-Coredumps Status :-
" >> /tmp/Sanity
if [[ `cd /var/lib/coredumps && ls` ]];then
echo 'there is coredumps in the folder but lets check if there is cordumps from today'
        if [[ "$ls2" == "$M" ]]
        then
        echo  "There are coredumps on today $d  AT  $P" >> /tmp/Sanity
        else
		echo "There is no coredumps for today $d" >> /tmp/Sanity
        fi
else
echo "The directory of Coredumps has no coredumps files" >> /tmp/Sanity
fi

##############################
### Check Core Dump Statuses #
##############################

export LC_ALL=C
echo "
                    - Disconnections/Errors check :-
 " >> /tmp/Sanity
for i in $(ls *$d* | grep -Eiv "log1|log2|log3");do grep -Ei "disconnect|err" ${i} >> /tmp/Sanity;done


#########################
### Check Syslog Errors #
#########################

ORIGIFS=$IFS; IFS=$(echo -en "\n\b")
errors=(
"error 1"
"error 2"
"error 3"
"segfault"
"SSL error while writing stream"
"socket timeout"
)

cd /var/log/
echo "
										-Errors in Syslog/Messages log :-
 " >> /tmp/Sanity

if perl -e 'exit ((localtime)[8])'
then
	echo "Winter Time Office Hours Check"
	for i in "${errors[@]}";do sed -n '/09:00:00/,/18:00:00/p' | grep -i "^$M.*${i}" messages >> /tmp/Sanity; done
else
  echo "Summer Time Office Hours Check"
	for i in "${errors[@]}";do sed -n '/09:00:00/,/18:00:00/p' | grep -i "^$M.*${i}" messages >> /tmp/Sanity; done
fi

#########################################
### Check Errors array in App log files #
#########################################

rm -f /tmp/Sanity.zip

echo "
										- Errors in App log files :-
 " >> /tmp/Sanity

echo "$(cd /var/log/applogs/ && ls *$d*)" > /tmp/applogs
mapfile -t appLogsArray < /tmp/applogs

for i in "${appLogsArray[@]}";do
	skip=
	for j in "${errors[@]}";do
	LC_ALL=C grep -i "$j" /var/log/applogs/$i >> /tmp/Sanity && { skip=1; break; }
	done
done

##########################
### State Memory/Hardisk #
##########################

echo "
										- Memmory & Hardisk Statuses :-
 " >> /tmp/Sanity

free -hm >> /tmp/Sanity
df -h >> /tmp/Sanity

#######################################################################
### Send it to email with compression if it exceeds size limit of 2MB #
#######################################################################

if [[ `du -m /tmp/Sanity | awk '{print $1}'` -ge 2 ]]
then
  echo "The Report file is more than 2 MB, So you will get it as a zip file"
  zip /tmp/Sanity.zip /tmp/CA-Sanity
  mail -s "Report For Host $host ON $d -AT- $P attached as a ZIP file" useremail1@email.com,useremail2@email.com < /tmp/Sanity.zip
else
  mail -s "Report For Host $host ON $d -AT- $P" useremail1@email.com,useremail2@email.com < /tmp/Sanity
fi

EOL

chmod 750 /tmp/Sanity.sh
###############Run the script on the free Core which decided at the first of the script#################
`which taskset` -c $FC bash -x /tmp/Sanity.sh

EOF

done
