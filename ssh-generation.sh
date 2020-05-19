#!/usr/bin/env bash
export PATH=/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/sbin:/usr/sbin

display_help() {
    echo "$(tput setaf 2)
  Usage: $0 [option...] {-h|--help}" >&2
    echo "              -h, --help         show script usage and explanation\
         "
    echo "
       This Script accepts two parameters :
          1. ssh username
          2. server name/IP
          3. cert_file name
          4. ssh port

       NOTES:
        a. If you did not enter the 3rd and 4th parameter then the script will default to id_rsa file as cert file and port 22 for ssh.
        b. If you face error like this:
             ERROR: ssh: Could not resolve hostname support: Name or service not known
             Reason: DNS issues, try to enter the server IP and not its name.

       Usage example : ./ssh-generation.sh sshuser serverip
       Full input Usage example :  ./ssh-generation.sh sshuser serverip client-cert client-ssh-port

          $(tput sgr0)"
    exit 1
}

case $1 in
 -h | --help | "")
    display_help
        ;;
 *)
    export ssh_user=$1
       ;;
esac

case $2 in
  *)
    export server=$2
       ;;
esac

if [[ $3 == "" && $4 == "" ]]
then
  # default cert file as is id_rsa, and ssh port as 22
  case $3 in
    *)
      export cert_file=id_rsa
         ;;
  esac

  case $4 in
    *)
      export Remote_FTP_Port=22
         ;;
  esac
else
    case $3 in
    *)
      export cert_file=$3
         ;;
  esac

  case $4 in
    *)
      export Remote_FTP_Port=$4
         ;;
  esac
fi


#Create ssh-keygen
if [[ ! -f "$HOME/.ssh/${cert_file}" ]]
then
	echo -e "\ny\n" | ssh-keygen -t rsa -b 4096 -N '' -f $HOME/.ssh/${cert_file}
	chmod 400 $HOME/.ssh/${cert_file}*
	#Copy the ssh-keygen to the remote server
	ssh-copy-id -i $HOME/.ssh/${cert_file} -p ${Remote_FTP_Port} ${ssh_user}@${server}
else
	ssh-copy-id -i $HOME/.ssh/id_rsa -p ${Remote_FTP_Port} ${ssh_user}@${server}
fi