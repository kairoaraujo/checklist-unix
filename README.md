# checklist-unix

This is a group of scripts to make a checklist of server and compare those datas

The current version has module for Linux, AIX, HP-UX, Solaris e MacOS.

## Installation

1. Uncompress the script.
2. Change the variable CHKU_PATH on checklist-unix.sh
 

## Usage


		Usage:
         -h       : help
		 -v	  	  : version
         -c       : Compare checklist (two lasts)
         -g       : Make the checklist
         -cd      : Compare recently checklist with specific date (DDMMAAAA.hhmm)
         -cl      : List all available checklist dates
         -r       : Logs rotate
                    Default config: compress > 30 days
                                    remove > 60 days
                    edit checklist-unix to change the retention

## Development

checklist-unix.sh is the core and on folder modules has the OS modules

### Modules

1. Create the command

 file_name {FILE_NAME}
 {COMMAND} > $CHKU_GFILE

   Rules for {FILE_NAME}

               a. low case

               b. do not use special characters, only _ is permitted.

               c. be clear

   Rules for {COMMANDO}

       a. the final output needs to be send to variable $CHKU_GFILE

 Example 1:

       file_name netstat_anv
       netstat -anv > $CHKU_GFILE

 Example 2: (with conditional)

       if [ -f /usr/sbin/prtconf ]
       then
	        file_name prtconf
	        /usr/sbin/prtconf >$CHKU_GFILE
       fi

 2. Put the FILE_NAME on FILE_NAMES=""

 Example:
    FILE_NAMES="
    netstat_nav
    prtconf
    "