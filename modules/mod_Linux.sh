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

mkcheck ()
{
   
   file_name hostname_do_servidor
   hostname >$CHKU_GFILE

   file_name versionamento_do_servidor
   uname -a >$CHKU_GFILE

   file_name release_do_servidor
   cat /etc/*-release >$CHKU_GFILE

   file_name filesystems_montados
   df -P | awk '{ print $1"\t\t"$6 }' >$CHKU_GFILE

   file_name rotas_de_rede
   netstat -rnv >$CHKU_GFILE
       
   file_name configuracao_de_rede
   ifconfig -a |grep -v -E 'RX |TX '>$CHKU_GFILE
       
   file_name arquivo_vfstab
   cat /etc/fstab|sort >$CHKU_GFILE

   file_name configuracao_de_hardware_dmidecode
   dmidecode >$CHKU_GFILE

   file_name dispositivos_pci
   lspci >$CHKU_GFILE

   file_name status_dos_servicos
   chkconfig --list >$CHKU_GFILE

   file_name compartilhamentos_exports
   cat /etc/exports >$CHKU_GFILE

   file_name compartilhamentos_showmount
   showmount  | awk '{ print $1" "$3 }' >$CHKU_GFILE

   file_name pacotes_rpm
   rpm -qa >$CHKU_GFILE 

   # cluster (RHCS e  SLE_HA)
   if [ -f /etc/cluster/cluster.conf ];then
   
 	file_name rhcs_config
	cat /etc/cluster/cluster.conf >$CHKU_GFILE 

	file_name rhcs_status
       	clustat | grep -v @ > $CHKU_GFILE

   fi

   if [ -f /etc/corosync/corosync.conf ]; then
     
       file_name sle_ha_status
       crm_mon -1 | grep -v crm_mon -1 | grep -v "Last updated"  > $CHKU_GFILE

   fi

   file_name vgs_servidor
   vgs >$CHKU_GFILE

   file_name lvs_servidor
   lvs >$CHKU_GFILE

   file_name pvs_servidor
   pvs >$CHKU_GFILE

   file_name crontab_root
   crontab -l >$CHKU_GFILE

   file_name arquivo_hosts
   cat /etc/hosts >$CHKU_GFILE

   # samba file se existir
   if [ -f /etc/samba/smb.conf ]; then
      file_name arquivo_smbconf
      cat /etc/samba/smb.conf >$CHKU_GFILE
   fi

   file_name resolv_conf_dns_client
   cat /etc/resolv.conf  >$CHKU_GFILE

   file_name ordem_resolucao_nsswitch
   cat /etc/nsswitch.conf >$CHKU_GFILE

   file_name sysctl
   cat /etc/sysctl.conf >$CHKU_GFILE
   
   # selinux se existir

   if [ -f /etc/sysconfig/selinux ]; then

      file_name selinux
      cat /etc/sysconfig/selinux >$CHKU_GFILE

   fi

   # multipath se existir

   if [ -f /etc/multipath.conf ]; then
      
      file_name arquivo_multipath
      cat /etc/multipath.conf >$CHKU_GFILE

   fi

   file_name multipath_-l
   multipath -ll >$CHKU_GFILE

   # powerpath
   if [ -f /usr/sbin/powermt ]; then
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

   file_name lista_servicos_chkconfig  
   chkconfig --list  >$CHKU_GFILE

   file_name filesystem_read_only
   awk '$4 ~ "^ro" && $3 !~ "(squashfs|iso9660)" {print $0}' /proc/mounts >$CHKU_GFILE
   
}

