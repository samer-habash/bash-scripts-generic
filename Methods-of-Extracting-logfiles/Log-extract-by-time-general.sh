#!/usr/bin/env bash
export PATH=/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/sbin:/usr/sbin
export d=`date "+%Y%m%d"`
export M=`date "+%b %d"`
export P=`date +"%H:%M:%S"`

#Log extract by time :
# There are 4 inputs variables :
input=$*
Start_Time=$1
End_Time=$2
input_log=${@:3: $(($# - 3))}
output_log=${@:$#}
mkdir -p /tmp/${output_log}


#Check which core/thread is free and is idle for 50% and Run the script on it
#NoOfCore=$(nproc --all)
idleCol=$(mpstat -P ALL | awk '{for(i=1;i<=NF;i++) if($i == "%idle") print i}')
CPUCol=$(mpstat -P ALL | awk '{for(i=1;i<=NF;i++) if($i == "CPU") print i}')

Free_thread=$(mpstat -P ALL | awk '{print $'$CPUCol',$'$idleCol'}' | awk '{if ($2 > 50) {print $1}}' | tail -1)
if [ -z "$Free_thread" ]
then
    echo "$(tput setaf 2) The script cannot run for the reason below :
                            There are no idle core/thread that is over 50% usage.
            $(tput sgr0)"
fi
export FC=${Free_thread}

cd /var/log/fixation/
for i in $(echo $input_log)
do
  taskset -c $FC sed -nE "/^[0-9]{4}[-]?[0-9]{2}[-]?[0-9]{2}(-|\s)?${Start_Time}.*$/,/^[0-9]{4}[-]?[0-9]{2}[-]?[0-9]{2}(-|\s)?${End_Time}.*$/p" ${i} > /tmp/${output_log}/${i} &
done

while true
do
  if [ -n "$(ps aux | grep -E "sed\s-nE.*${Start_Time}.*${End_Time}" | grep -v grep)" ]
  then
    continue
  else
    echo "finished"
    break
  fi
done