#!/usr/bin/env bash
export PATH=/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin

set -ef
IFS='
'
set -- $(cat firstfile.txt)
for j in $(cat Secondfile.txt)
do
  # do what you like
  # mysql example query with using i & j
  mysql -uroot -s -N -e " update table set column='$1' where id=$j;"
  shift
done


############ Another method ##############


#!/usr/bin/env bash
touch result
truncast -s 0 result

for i in $(awk '{for (i=1;i<=NR;i++) {print $1}}' firstfile.txt)
do
	for j in $(awk '{for (i=1;i<=NR;i++) {print $2}}' Secondfile.txt)
	do
		grep "${i}.*${j}" Thirdfile >> result
	done
done