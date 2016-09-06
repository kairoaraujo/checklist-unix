#!/bin/sh
#
# checklist-unix.sh
#
# Kairo Araujo (c) 2010-2016
# 
##############################################################################
#
# GLOBAL VARIABLES
# checklist-unix Path
CHKU_PATH=/opt/checklist-unix
# checklist-unix retention compress (days)
CHKU_DAYS_RENTENTION_Z="7"
# checklist-unix retention remove (days)
CHKU_DAYS_RENTENTION_R="15"


# system variables
CHKU_MODULES=$CHKU_PATH/modules
CHKU_FILES=$CHKU_PATH/files
CHKU_LOGS=$CHKU_PATH/logs
CHKU_SO=`uname`
CHKU_FILE_CHECKLIST="`hostname`.`date +"%d%m%Y.%H%M"`.checklist"
CHKU_VERSION="2.7.1"


# START
##############################################################################


# Check if OS module exists
if [ ! -f $CHKU_MODULES/mod_$CHKU_SO.sh ]; then

	echo "Module for Operational System does not exist"
	echo $CHKU_SO
	exit 2

fi

# check root user
if [ `whoami` != "root" ]; then
	echo "Use root to execute"
	exit 5
fi

if [ ! -d $CHKU_FILES/$(hostname) ]; then
    mkdir -p $CHKU_FILES/$(hostname)
fi

echo "Using $CHKU_MODULES/mod_$CHKU_SO.sh module."
# loads OS module
. $CHKU_MODULES/mod_$CHKU_SO.sh


# Global functions
# function subject title
file_name ()
{
	FILE=$*
	CHKU_GFILE=$CHKU_FILES/$(hostname)/$FILE.$CHKU_FILE_CHECKLIST
	echo "-------------------------------------------------------------------"
	echo $FILE | sed 's/_/ /g'
}

# function compare
check_compare ()
{
	case $1 in

		-cd)

		# Compare checklist
		for CHECKLIST in $(cat $CHKU_MODULES/mod_$CHKU_SO.sh | grep -v ^# | grep file_name | awk '{ print $2 }');
		do
		   ls -la $CHKU_FILES/$(hostname)/$CHECKLIST.*.checklist >> /dev/null 2>&1
		   RC=$?
		   if [ $RC -eq 0 ]; then
                        LAST=` date +"%d%m%Y"`;
			CHECK_ITEM_LAST=`ls -ltr $CHKU_FILES/$(hostname)/$CHECKLIST.*.$LAST.*.checklist|awk '{print $9}'|tail -1`
			CHECK_ITEM_DATA=`ls -ltr $CHKU_FILES/$(hostname)/$CHECKLIST.*.$2.checklist|awk '{print $9}'|tail -1`

			diff $CHECK_ITEM_LAST $CHECK_ITEM_DATA >/dev/null 2>&1
			RC=$?

			if [ $RC -ne 0 ] ;then
				echo -e "`echo $CHECKLIST | sed 's/_/ /g'` !!**!! \033[1;31mNOK\033[0m"
				diff $CHECK_ITEM_LAST $CHECK_ITEM_DATA |egrep -e "^<|^>"
			else
				echo -e "`echo $CHECKLIST | sed 's/_/ /g'` ** \033[1;32m OK \033[0m"
			fi
			sleep 1
			echo '--------------------------------------------------------------------'
		   fi
		done
		;;

		-c)
		
		# Check with last date
		for CHECKLIST in $(cat $CHKU_MODULES/mod_$CHKU_SO.sh | grep -v ^# | grep file_name | awk '{ print $2 }');
		do
		   ls -la $CHKU_FILES/$(hostname)/$CHECKLIST.*.checklist >> /dev/null 2>&1
                   RC=$?
                   if [ $RC -eq 0 ]; then
			CHECK_ITEM=`ls -ltr $CHKU_FILES/$(hostname)/$CHECKLIST.*.checklist|awk '{print $9}'|tail -2`


			diff $CHECK_ITEM >/dev/null 2>&1
			RC=$?

			if [ $RC -ne 0 ] ;then
				echo -e "`echo $CHECKLIST | sed 's/_/ /g'` !!**!! STATUS: \033[1;31mNOK\033[0m"
				diff $CHECK_ITEM |egrep -e "^<|^>"
			else
				echo -e "`echo $CHECKLIST | sed 's/_/ /g'` ** STATUS: \033[1;32m OK \033[0m "
			fi
			echo '--------------------------------------------------------------------'
	    	   fi
			sleep 1
		done
		;;

	esac
}

# options
case $1 in

	-g)
		
		# makes OS checklist
		echo ""
		echo "Starting checklist collecting - $CHKU_SO"
		mkcheck
		echo ""
		echo "Collect finished"
		
	;;

	-c)

		# compare last two checklists
		echo ""
		echo "Starting to compare the checklists (last two)"
		echo ""
		check_compare $1
		echo ""
		echo "Compare finished"
		

	;;
	
	-cd)
	
		# Compare with specific date
		if [ ! -n "$2" ]; then
			echo ""
			echo "ERROR 3: -cd needs to have the format DDMMAAAA.hhmm"
			echo "Example: checklist-unix.sh -cd 10062010.1030"
			echo "To list all available dates use: $0 -cl"
			echo ""
			exit 3
		fi
		
		# Check if file date exists
		if [ ! -f $CHKU_FILES/$(hostname)/*.`hostname`.$2.checklist ]; then
			echo ""
			echo "ERROR 4: The file for date $2 not exists"
			echo "To list all available dates use: $0 -cl"
			echo ""
			exit 4
		fi

		echo ""
		echo "Starting checklist collecting - Last one with $2"
		echo ""
		check_compare $1 $2
		echo "Compare finished"
		echo ""
	
		
	;;
	
	-cl)
		
		# List all available dates
		echo ""
		echo "Available checklist dates"
		echo ""
		ls -la $CHKU_FILES | grep $(hostname) | grep -v .gz |awk -F. '{ print $3"."$4 }' | sort | uniq
		echo ""
		echo "List finished"
		echo ""
	
	;;

	-r)

		# File managements

		# File compress
		echo "Compressing files ($CHKU_FILES/$(hostname)/*) > $CHKU_DAYS_RENTENTION_Z ."
		find $CHKU_FILES/$(hostname)/ -type f -mtime +$CHKU_DAYS_RENTENTION_Z -exec gzip -v9 {} ';'

		# File remove
		echo "Removing files ($CHKU_FILES/$(hostname)/*) > $CHKU_DAYS_RENTENTION_R ."
		find $CHKU_FILES/$(hostname)/ -type f -mtime +CHKU_DAYS_RENTENTION_R -exec rm {} ';'

	;;

	-v)

		echo "checklist-unix version $CHKU_VERSION" 
	
	;;
        
	h|*)
		echo "
		Usage:
		-h   : help
		-v   : version
		-c   : Compare checklist (two lasts)
		-g   : Make the checklist
		-cd  : Compare recently checklist with specific date (DDMMAAAA.hhmm)
		-cl  : List all available checklist dates
		-r   : Logs rotate
		        Default config: compress > 7 days
		                        remove > 15 days
		                        edit checklist-unix.sh to change the retention
		"
	;;
esac
