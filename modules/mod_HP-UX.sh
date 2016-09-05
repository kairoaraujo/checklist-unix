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

mkcheck ()
{
   
   nome_arquivo "hostname_do_servidor"
   hostname >$CHKU_GFILE

   nome_arquivo "versionamento_do_servidor"
   uname -a >$CHKU_GFILE

   nome_arquivo "filesystems_montados"
   bdf | awk '{ print $1"\t\t"$6 }' >$CHKU_GFILE

   nome_arquivo "rotas_de_rede"
   netstat -rnv >$CHKU_GFILE
       
   nome_arquivo "configuracao_de_rede"
   netstat -ni | awk '{print $1, "\t" $3, "\t" $4}'| sort -n >$CHKU_GFILE
       
   nome_arquivo "arquivo_vfstab"
   cat /etc/fstab|sort >$CHKU_GFILE

   nome_arquivo "configuracao_de_hardware_ioscan"
   ioscan -fn >$CHKU_GFILE

   nome_arquivo "dispositivos_memoria"
   print_manifest | grep Memory  >$CHKU_GFILE

# powermt
if [ -f /sbin/powermt ]
then
        nome_arquivo "powermt_version"
        /sbin/powermt version >$CHKU_GFILE

        nome_arquivo "powermt_display"
        /sbin/powermt display >$CHKU_GFILE

        nome_arquivo "powermt_display_paths"
        /sbin/powermt display paths >$CHKU_GFILE

        nome_arquivo "powermt_display_options"
        /sbin/powermt display options >$CHKU_GFILE

        nome_arquivo "powermt_display_dev_all"
        /sbin/powermt display dev=all >$CHKU_GFILE

        nome_arquivo "powermt_display_unmanaged"
        /sbin/powermt display unmanaged >$CHKU_GFILE

fi

   nome_arquivo "compartilhamentos_exports"
   cat /etc/exports >$CHKU_GFILE

   nome_arquivo "compartilhamentos_showmount"
   showmount -e localhost >$CHKU_GFILE

   nome_arquivo "pacotes_sistema"
   swlist >$CHKU_GFILE 

   nome_arquivo "pacotes_produtos"
   swlist -l product >$CHKU_GFILE 

   nome_arquivo "pacotes_patches"
   swlist -l patch >$CHKU_GFILE

   # cluster HP ServiceGuard
   if [ -f /etc/cmcluster/cmclconfig ];then
   
 	nome_arquivo "sg_config"
	cmgetconf > $CHKU_GFILE 

	nome_arquivo "sg_status"
       	cmviewcl > $CHKU_GFILE

   fi

   nome_arquivo "lvm_servidor"
   vgdisplay -v >$CHKU_GFILE

   nome_arquivo "lvmtab_servidor"
   strings /etc/lvmtab >$CHKU_GFILE

   nome_arquivo "crontab_root"
   crontab -l >$CHKU_GFILE

   nome_arquivo "arquivo_hosts"
   cat /etc/hosts >$CHKU_GFILE

   # samba file se existir
   if [ -f /etc/opt/samba/smb.conf ]; then
      nome_arquivo "arquivo_smbconf"
      cat /etc/opt/samba/smb.conf >$CHKU_GFILE
   fi

   nome_arquivo "resolv_conf_dns_client"
   cat /etc/resolv.conf  >$CHKU_GFILE

   nome_arquivo "ordem_resolucao_nsswitch"
   cat /etc/nsswitch.conf >$CHKU_GFILE

   nome_arquivo "parametros_kernel"
   cat /stand/system >$CHKU_GFILE
   
   nome_arquivo "parametros_seguranca_usuario"
   cat /etc/default/security >$CHKU_GFILE

   nome_arquivo "drivers"
   lsdev >$CHKU_GFILE

   
}


FILE_NAMES="
hostname_do_servidor
versionamento_do_servidor
filesystems_montados
rotas_de_rede
configuracao_de_rede
arquivo_vfstab
configuracao_de_hardware_ioscan
dispositivos_memoria
compartilhamentos_exports
compartilhamentos_showmount
pacotes_sistema
pacotes_produtos
pacotes_patches
sg_config
sg_status
lvm_servidor
lvmtab_servidor
crontab_root
arquivo_hosts
arquivo_smbconf
resolv_conf_dns_client
ordem_resolucao_nsswitch
parametros_kernel
parametros_seguranca_usuario
powermt_version
powermt_display
powermt_display_paths
powermt_display_options
powermt_display_dev_all
powermt_display_unmanaged
drivers
"
