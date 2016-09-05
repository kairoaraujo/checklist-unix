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
   
   nome_arquivo "analise_do_mirror"
   metastat  >$CHKU_GFILE

   nome_arquivo "status_do_mirror"
   metastat -c >$CHKU_GFILE

   nome_arquivo "release_do_servidor"
   cat /etc/release >$CHKU_GFILE

   nome_arquivo "filesystems_montados"
   df -h | awk '{ print $1" \t"$2" \t"$6 }' >$CHKU_GFILE

   nome_arquivo "status_do_veritas_volume_manager"
   vxdisk -o alldgs list | grep -v \( >$CHKU_GFILE
       
   nome_arquivo "rotas_de_rede"
   netstat -rnv | cut -c 1-65  >$CHKU_GFILE
       
   nome_arquivo "configuracao_de_rede"
   ifconfig -a  >$CHKU_GFILE
       
   nome_arquivo "arquivo_vfstab"
   cat /etc/vfstab|sort >$CHKU_GFILE
       
   nome_arquivo "dispositivos_de_io"
   iostat -En >$CHKU_GFILE

   nome_arquivo "configuracao_de_hardware_prtdiag"
   prtdiag >$CHKU_GFILE

   nome_arquivo "configuracao_de_hardware_prtconf"
   prtconf >$CHKU_GFILE

   nome_arquivo "interfaces_hba"
   fcinfo hba-port >$CHKU_GFILE

   nome_arquivo "dispositivos_ethernet"
   dladm show-dev >$CHKU_GFILE

   nome_arquivo "status_dos_servicos"
   svcs | awk '{ print $1" "$3 }' >$CHKU_GFILE

   nome_arquivo "compartilhamentos_share"
   share | awk '{ print $1" "$3 }' >$CHKU_GFILE

   nome_arquivo "compartilhamentos_showmount"
   showmount  | awk '{ print $1" "$3 }' >$CHKU_GFILE
   echo ""
}

FILE_NAMES="
hostname_do_servidor
versionamento_do_servidor
analise_do_mirror
status_do_mirror
release_do_servidor
filesystems_montados
status_do_veritas_volume_manager
rotas_de_rede
configuracao_de_rede
arquivo_vfstab
dispositivos_de_io
configuracao_de_hardware_prtdiag
configuracao_de_hardware_prtconf
interfaces_hba
dispositivos_ethernet
status_dos_servicos
compartilhamentos_share
compartilhamentos_showmount
"

