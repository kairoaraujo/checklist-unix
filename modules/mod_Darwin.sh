#!/bin/sh
#
# checklist-unix
#
# Kairo Araujo (c) 2010
#
##############################################################################
#
# mkcheck()
#
# 1. Create the command
#
# file_name {FILE_NAME}
# {COMMAND} > $CHKU_GFILE
#
#   Rules for {FILE_NAME}
#
#               a. low case
#
#               b. do not use special characters, only _ is permitted.
#
#               c. be clear
#
#   Rules for {COMMANDO}
#
#       a. the final output needs to be send to variable $CHKU_GFILE
#
# Example 1:
#
#       file_name netstat_anv
#       netstat -anv > $CHKU_GFILE
#
# Example 2: (with conditional)
#
#       if [ -f /usr/sbin/prtconf ]
#       then
#	        file_name prtconf
#	        /usr/sbin/prtconf >$CHKU_GFILE
#       fi
#
# 2. Put the FILE_NAME on FILE_NAMES=""
#
# Example:
#    FILE_NAMES="
#    netstat_nav
#    prtconf
#    "
###############################################################################
#
#
mkcheck ()
{
	nome_arquivo hostname
	hostname > $CHKU_GFILE
	
	nome_arquivo uname_-a
	uname -a > $CHKU_GFILE
	
}

# Arquivos gerados, apenas os {FILE_NAME} utilizados
FILE_NAMES="
hostname uname_-a
"


