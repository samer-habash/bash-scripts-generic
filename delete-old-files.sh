#!/usr/bin/env bash
export PATH=/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/sbin:/usr/sbin

display_help() {
    echo "$(tput setaf 2)       
  Usage: $0 [option...] {-h|--help}" >&2
    echo "              -h, --help         show script usage and explanation\
         "
    echo "
       This Script is intended to delete files and sub directories :
       The script should receives two input parameters as below :
             1) First Parameter : Absolute Path of the Directory that you want to delete from
                    e.g. = /path/to/files
             2) Second Parameter : Delete Files Older than N Days with specifying -d flag 
                    e.g. = -d 10
       Full usage example : ./delete-old-files.sh /path/to/files -d 10
          $(tput sgr0)"
    exit 1
}


case $1 in
 -h | --help | "")
    display_help
        ;;
 *)
    export directory=$1
       ;;
esac

case $2 in
  -d)
    export number_of_days=$3
       ;;
esac

#echo "Direcories older than ${number_of_days} days will be deleted"
find ${directory} -type d -mtime +${number_of_days} -exec rm -rf {} \;


#echo "Files older than ${number_of_days} days will be deleted"
find ${directory} -type f -mtime +${number_of_days} -exec rm -f {} \;
