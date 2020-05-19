# The Sanity script have the following condtions and features :

1- Operates on centos Linux distributions , please note that it can be easily modified to be on other distribution by changing the correct pakcage manager and the syslog file name.
2- The script installs some libraries which can measure the cpu load, in order to run the script smoothly.
3- The script works upon finding the free core within a percentage of more than 60% idle, since it can be heavily loaded the machine and this rule suits especially if there are a lot of log files needed to be checked.
4- The script needs to modify the directories of the app logs , you can put it as input variable and amend it in the section of App logs directory.
5- The script will send an email and will zip the sanity file if it is larger than 2 MB of size, modify your email/emails correspondingly .
6- I added some variety of using winter/summer time checks , and also can be done upon office hours checks ... this is just for practises and ideas .