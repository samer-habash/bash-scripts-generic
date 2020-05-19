Added 3 scripts for extracting/organizing files :

1- The script "mplex-log-extraction.sh" do the following :

    a. Accepts as first paramter input logfile
    b. Can be modified to add patterns as input parameters, they are hardcoded at the moment
    c. The script will extract multiple patterns from same line and also if the patterns are in multiple lines then it will also grab them using "pcregrep" tool
    d. The script needs to be modified according to your schema of the logs, the idea here is to have multiple patterns that can share the same line or multiple lines at the same time.
    e. The script have an additional calculation that it will calculate the minus of the two patterns , as an example.

2- The script "Hourly-Split.sh" do the following :

    a. The script accepts one input which is the file that you would like to hourly extract
    b. The logfile must be a 24 hours only(one day log), the script is a dynamic extraction of a daily logfile, the script will measure the hour in the first lines.
    c. formats of date format - please check the script for practical examples of date
    d. The script will use daemon processes in order to extract each hour in the log, for large files it will load up the server

3- The script "Log-extract-by-time-general.sh" do the following :

    a. The script accepts at least 4 input parameters :
     1. 1st and 2nd parameter is the start/end time in hours:minutes:seconds format , you can also add only hours or hours:minutes (as you wish !!!)
     2. 3rd and nth parameter : multiple input logs that you would like to extract at the same time
     3. Last parameter : Output file name in the /tmp/ directory (can be modified upon your needs)
     4. The script will keep monitoring the extraction , and when all the log files has been done extracting , the script will type the word "finished" on the terminal
     5. Note that the date format here is the same format as "Hourly-Split.sh" script
      
4- The script "organize-yearly-files-months-and-days-.sh" do the following :

     a. The script will organize a pre-defined files that have date format as year/month/day format (e.g. 20200101-recording.mp3), and then it will do a directory with month 01 with day 01 and copy the files in it correspondingly.
     b. The script reads two inputs parameters : 
        1. year which you would like to organize the files
        2. The absolute path of the year directory chosen above


