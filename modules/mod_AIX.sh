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
###############################################################################

mkcheck() 

{

# hostname
file_name hostname
hostname >$CHKU_GFILE

# uname
file_name uname_-a
uname -a >$CHKU_GFILE

# df -k
file_name df_-k
df -k | awk '{ print $1"\t"$7 }'  >$CHKU_GFILE

# ifconfig -a
file_name ifconfig_-a
ifconfig -a >$CHKU_GFILE

# netstat -nr
file_name netstat_-nr
netstat -nr | awk '{ print $1 "\t" $2 "\t" $3 "\t" $6 }' >$CHKU_GFILE

# lsvg (vgs)
file_name lsvg
lsvg >$CHKU_GFILE

# lsvg (vgs) ativos
file_name lsvg_ativos
lsvg -o|lsvg -il >$CHKU_GFILE

# lspv (discos)
file_name lspv
lspv >$CHKU_GFILE

# crontab
file_name crontab
crontab -l >$CHKU_GFILE

# hosts
file_name hosts
cat /etc/hosts >$CHKU_GFILE

# qconfig (impressao)
file_name qconfig
cat /etc/qconfig >$CHKU_GFILE

# resolv.conf (dns client)
file_name resolv_dns_client
cat /etc/resolv.conf >$CHKU_GFILE

# netsvc (ordem resolução de nomes)
file_name netsvc
cat /etc/netsvc.conf >$CHKU_GFILE

# lista pacotes (lslpp)
file_name lslpp_-l
lslpp -l >$CHKU_GFILE

# lista devices
file_name lsdev-C
lsdev -C >$CHKU_GFILE

# maymap
if [ -f /usr/bin/maymap ]
then
	file_name maymap_-ap_-4
	maymap -ap -4 >$CHKU_GFILE

	file_name maymap_-ah_-4
	maymap -ah -4 >$CHKU_GFILE
fi

# prtconf
if [ -f /usr/sbin/prtconf ]
then
	file_name prtconf
	/usr/sbin/prtconf >$CHKU_GFILE
fi

# netstat
file_name netstat
netstat -vn|awk ' $1 ~ /ETHERNET/ || $2 ~ /Speed/ {print $0}' >$CHKU_GFILE

# vmo
if [ -f /usr/sbin/vmo ]
then
	file_name vmo_-r_-a
	/usr/sbin/vmo -r -a | grep -v pinnable_frames >$CHKU_GFILE
fi


# no
if [ -f /usr/sbin/no ]
then
	file_name no_-r_-a
	/usr/sbin/no -r -a >$CHKU_GFILE
fi

# ioo
if [ -f /usr/sbin/ioo ]
then
	file_name ioo_-r_-a
	/usr/sbin/ioo -r -a >$CHKU_GFILE
fi

# nfso
if [ -f /usr/sbin/nfso ]
then
	file_name nfso_-r_-a
	/usr/sbin/nfso -r -a >$CHKU_GFILE
fi

# schedo
if [ -f /usr/sbin/schedo ]
then
	file_name schedo
	/usr/sbin/schedo -r -a >$CHKU_GFILE
fi

# lsfs
if [ -f /usr/sbin/lsfs ]
then
	file_name lsfs
	/usr/sbin/lsfs -q >$CHKU_GFILE
fi

# sysdumpdev
if [ -f /usr/bin/sysdumpdev ]
then
	file_name sysdumpdev_-l
	/usr/bin/sysdumpdev -l >$CHKU_GFILE
fi

# lssrc
if [ -f  /usr/bin/lssrc ]
then
	file_name lssrc_-a
	/usr/bin/lssrc -a >$CHKU_GFILE
fi

# lslicense
if [ -f /usr/bin/lslicense ]
then
	file_name lslicense_-c
	/usr/bin/lslicense -c  >$CHKU_GFILE
fi

# sendmail
if [ -f /etc/sendmail.cf ]
then
	file_name sendmail
	cat /etc/sendmail.cf  >$CHKU_GFILE
fi

# showmount
if [ -f /usr/bin/showmount ]
then
	file_name showmount_-e
	/usr/bin/showmount -e >$CHKU_GFILE
fi

# exportfs
if [ -f /usr/sbin/exportfs ]
then
	file_name exportfs
	/usr/sbin/exportfs -v >$CHKU_GFILE
fi

# filesystem
if [ -f /etc/filesystems ]
then
	file_name filesystems
	cat /etc/filesystems >$CHKU_GFILE
fi

# lspath
if [ -f /usr/sbin/lspath ]
then
 	file_name lspath_-H
	/usr/sbin/lspath -H >$CHKU_GFILE
fi

# powermt
if [ -f /usr/sbin/powermt ]
then
	file_name powermt_version
	/usr/sbin/powermt version >$CHKU_GFILE

	file_name powermt_display
 	/usr/sbin/powermt display >$CHKU_GFILE

	file_name powermt_display_paths
	/usr/sbin/powermt display paths >$CHKU_GFILE
	
	file_name powermt_display_options
	/usr/sbin/powermt display options >$CHKU_GFILE
	
	file_name powermt_display_dev_all
	/usr/sbin/powermt display dev=all >$CHKU_GFILE

	file_name powermt_display_unmanaged
	/usr/sbin/powermt display unmanaged >$CHKU_GFILE

fi

# lsrsrc
if [ -f /usr/bin/lsrsrc  ]
then
	file_name ibm_management_server
	/usr/bin/lsrsrc IBM.ManagementServer >$CHKU_GFILE

	file_name ibm_lpar
	/usr/bin/lsrsrc IBM.LPAR >$CHKU_GFILE

	file_name ibm_host
	/usr/bin/lsrsrc IBM.Host >$CHKU_GFILE
	
	file_name ibm_wlm
	/usr/bin/lsrsrc IBM.WLM >$CHKU_GFILE
	
fi

# cldump
if [ -f /usr/es/sbin/cluster/utilities/cldump ]
then

file_name hacmp_cllscf
/usr/sbin/cluster/utilities/cllscf >$CHKU_GFILE

file_name hacmp_cllsserv
/usr/sbin/cluster/utilities/cllsserv >$CHKU_GFILE

file_name hacmp_clshowres
/usr/sbin/cluster/utilities/clshowres >$CHKU_GFILE

file_name hacmp_cllsnode
/usr/sbin/cluster/utilities/cllsnode >$CHKU_GFILE

file_name hacmp_cllsif
/usr/sbin/cluster/utilities/cllsif >$CHKU_GFILE

file_name hacmp_cllsclstr
/usr/sbin/cluster/utilities/cllsclstr >$CHKU_GFILE

file_name hacmp_cllsvgdata
/usr/sbin/cluster/utilities/cllsvgdata >$CHKU_GFILE

file_name hacmp_cllssvcs
/usr/sbin/cluster/utilities/cllssvcs >$CHKU_GFILE

file_name hacmp_cllsstbys
/usr/sbin/cluster/utilities/cllsstbys >$CHKU_GFILE

file_name hacmp_cllsclstr
/usr/sbin/cluster/utilities/cllsclstr>$CHKU_GFILE

file_name hacmp_cllsserv
/usr/sbin/cluster/utilities/cllsserv >$CHKU_GFILE

file_name hacmp_cllssite
/usr/sbin/cluster/utilities/cllssite >$CHKU_GFILE

file_name hacmp_cllsfs
/usr/sbin/cluster/utilities/cllsfs >$CHKU_GFILE

file_name hacmp_cllsres
/usr/sbin/cluster/utilities/cllsres >$CHKU_GFILE

file_name hacmp_cllslv
/usr/sbin/cluster/utilities/cllslv >$CHKU_GFILE

file_name hacmp_cllstape
/usr/sbin/cluster/utilities/cllstape >$CHKU_GFILE

fi

# mmlspv
if [ -f /usr/lpp/mmfs/bin/mmlspv ]
then


 	file_name gfs_mmlspv
 	/usr/lpp/mmfs/bin/mmlspv >$CHKU_GFILE

 	file_name gfs_mmlscluster
 	/usr/lpp/mmfs/bin/mmlscluster >$CHKU_GFILE

 	file_name gfs_mmlsconfig
 	/usr/lpp/mmfs/bin/mmlsconfig >$CHKU_GFILE

 	file_name gfs_mmlsmgr
 	/usr/lpp/mmfs/bin/mmlsmgr >$CHKU_GFILE

 	file_name gfs_mmlsnode
 	/usr/lpp/mmfs/bin/mmlsnode -a >$CHKU_GFILE

 	file_name gfs_mmlsnsd
 	/usr/lpp/mmfs/bin/mmlsnsd >$CHKU_GFILE
fi

# rpm
if [ -f /usr/bin/rpm ]
then
 	file_name rpm_-qa
	/usr/bin/rpm -qa >$CHKU_GFILE

fi

# netstat 
file_name netstat_-an
/usr/bin/netstat -an | grep -i listen>$CHKU_GFILE

# netstat -v
file_name netstat_-v
/usr/bin/netstat -v | egrep -i 'ent|vlan' >$CHKU_GFILE


# lscfg
file_name lscfg
/usr/sbin/lscfg >$CHKU_GFILE
	

# lparstat
if [ -f /usr/bin/lparstat ]
then
	file_name lparstat_-i
	/usr/bin/lparstat -i >$CHKU_GFILE
fi

}

