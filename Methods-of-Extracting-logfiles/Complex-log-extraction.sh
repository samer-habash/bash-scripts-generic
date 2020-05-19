#!/usr/bin/env bash

#!/bin/bash
export PATH=/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/sbin:/usr/sbin

INPUT_FILE=$1
#Optional multiple input patterns
#multiple_input=${@:2: $(($#))}

if [[ $1 == "" ]]
then
  echo "Please enter the input logfile"
  exit 1
fi

display_help() {
    echo "$(tput setaf 2)       Usage: $0 [option...] {-h|--help}" >&2
    echo "              -h, --help         show script usage and explanation\
         "
    echo "
       This Script is intended to grab the log and filter it to be one layer of messages
                -l : assign output file
            example : ./Complex-log-extraction.sh log -l outputfile
          $(tput sgr0)"
    exit 1
}

if [[ ! $(command -v pcregrep) ]]
then
  sudo yum install rsync -y
fi

case $1 in
 "")
    display_help
       ;;
 -h | --help)
    display_help
        ;;
esac

case $2 in
 -l)
    outputfile=$3
        ;;
  *)
    echo "$(tput setaf 2)
    Please use the -l flag and then type your output file name.
    $(tput sgr0)"
    exit 1
esac

echo "Creating Output File : ${outputfile} on your current directory !"
LC_ALL=C grep -oP ".*\Kpattern1.*pattern2" ${INPUT_FILE} | pcregrep -M '(?s)pattern1\.*?pattern2' | sed 'N;N;N;N; s/\n/ /g' | awk '{print $0, "| pattern1-pattern2 ="}' | awk '{pattern1_minus_pattern2=$25-$16;print $0,pattern1_minus_pattern2;}' > ${outputfile}