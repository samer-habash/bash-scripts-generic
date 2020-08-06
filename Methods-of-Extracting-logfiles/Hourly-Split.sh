#!/usr/bin/env bash
# The script needs the path/of/the/inputfilelog to extract it
input_log=$1

# Date-Log-Format = it has multiple choices and can be with spaces and dashes
#             e.g : 20200101 00:00:00
#                   20200101-00:00:00
#                   2020-01-01 00:00:00
#                   2020-01-01-00:00:00

Initial_Time=$(grep -aoP -m1 "^[0-9]{4}[-]?[0-9]{2}[-]?[0-9]{2}[-\s]?[0-9]{2}:[0-9]{2}" ${input_log})
End_Time=$(bash -c 'tail -n +0 --pid=$$ -f ${input_log} | { grep -aoP -m1 "^[0-9]{4}[-]?[0-9]{2}[-]?[0-9]{2}[-\s]?[0-9]{2}:[0-9]{2}" && kill $$ ;}' | head -1)

# limit the logs file as 15 GB - this is my choice - you can modify it upon your needs because it will eat all the cpus
#15GB = 16106127360 bytes
if [[ $(stat -c%s ${input_log}) < 16106127360 ]]
then
  echo "The file is below 15GB"
  Hours=(00,01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23)
  for i in ${Hours[@]}; do
      grep -E "^[0-9]{4}[-]?[0-9]{2}[-]?[0-9]{2}[-\s]?[0-9]{2}:${i}" ${input_log} > ${input_log}_Hour_${i}.log &
  done
else
  echo "The file is above 15GB"
fi


