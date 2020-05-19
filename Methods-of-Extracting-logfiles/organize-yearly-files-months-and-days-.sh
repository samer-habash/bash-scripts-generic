#!/usr/bin/env bash
export PATH=/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin
set -e

tee year.txt << EOF
Jan 01
Feb 02
March 03
April 04
May 05
June 06
July 07
Aug 08
Sep 09
Oct 10
Nov 11
Dec 12
EOF

tee day.txt <<EOF
01
02
03
04
05
06
07
08
09
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
EOF

month_in_letters=( "Jan" "Feb" "March" "April" "May" "June" "July" "Aug" "Sep" "Oct" "Nov" "Dec" )
months_in_numbers=( "01" "02" "03" "04" "05" "06" "07" "08" "09" "10" "11" "12" )

read -p "Please enter the year that you would like to extract from :" year
read -p "Please enter the absolute path for the directory of year chosen above :" dir
mkdir -p ${dir}/${year}

for month in {0..11}
do
  mkdir -p ${dir}/${year}/${month_in_letters[month]}
  for day in $(cat day.txt)
  do
    if [[ "$(find ${dir} -name *-${year}${months_in_numbers[month]}${day}-* -or -name ${year}${month_in_letters1[month]}${day}-* | wc -l)" != "0" ]];
    then
      mkdir -p ${dir}/${year}/${month_in_letters[month]}/${day}
      find ${dir} -name *-${year}${months_in_numbers[month]}${day}-* -or -name ${year}${month_in_letters1[month]}${day}-* | xargs -I{} cp -ap "{}" ${dir}/${year}/${month_in_letters[month]}/${day}
    fi
  done
done