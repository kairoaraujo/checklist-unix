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

   nome_arquivo "modulos_do_sistema"
   modinfo | awk '{print $6,$7,$8,$9,$10,$11,$12}' >$CHKU_GFILE

   #####################################################################
   ## Adicionado Modulo para checagem do Veritas Volume Manger!!!      #
   ## Adicionado Modulo para checagem do Veritas Cluster!!!!           #
   #####################################################################

   PATH=${PATH}:/usr/lib/vxvm/diag.d:/etc/vx/diag.d:/opt/VRTS/bin:/opt/VRTSvlic/bin
   export PATH

   
   if [ -f /opt/VRTS/bin/vxdg ]
   then

   nome_arquivo "status_dos_discos_veritas"
   vxdisk list >$CHKU_GFILE

   nome_arquivo "serial_dos_discos"
   vxdisk -e list >$CHKU_GFILE

   nome_arquivo "disk_groups"
   vxdg list >$CHKU_GFILE

   nome_arquivo "status_volumes"
   vxprint -ht >$CHKU_GFILE

   nome_arquivo "status_controladoras"
   vxdmpadm listctlr all >$CHKU_GFILE

   nome_arquivo "status_controladoras_storage"
   vxdmpadm listenclosure all >$CHKU_GFILE

   nome_arquivo "storages_suportados"
   vxddladm listsupport >$CHKU_GFILE

   nome_arquivo "status_daemon_vxdctl"
   vxdctl mode >$CHKU_GFILE

   nome_arquivo "status_cluster_enable"
   vxdctl -c mode

   nome_arquivo "checa_licencas_veritas"
   vxlicrep >$CHKU_GFILE

   nome_arquivo "checa_licencas_ativadas"
   vxlicrep -e >$CHKU_GFILE

   nome_arquivo "status_multipath_veritas"
   vxdmpadm stat restored >$CHKU_GFILE
  
   fi

   if  [ -f /opt/VRTSvcs/bin/hastatus ]
   then

   nome_arquivo "status_cluster"
   hastatus -summary >$CHKU_GFILE

   nome_arquivo "status_servicos_cluster"
   hares -display >$CHKU_GFILE

   nome_arquivo "configuracoes_cluster"
   hagrp -display >$CHKU_GFILE

   nome_arquivo "nodes_do_cluster"
   hasys -list >$CHKU_GFILE

   nome_arquivo "status_nodes_cluster"
   hasys -state >$CHKU_GFILE

   nome_arquivo "nodeid_do_host"
   hasys -nodeid >$CHKU_GFILE

   nome_arquivo "status_do_llstat"
   llstat >$CHKU_GFILE
  
   nome_arquivo "status_do_gab"   
   gabconfig -a >$CHKU_GFILE
   
fi

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
modulos_do_sistema
status_dos_discos_veritas
serial_dos_discos
disk_groups
status_volumes
status_controladoras
status_controladoras_storage
storages_suportados
status_daemon_vxdctl
status_cluster_enable
checa_licencas_veritas
checa_licencas_ativadas
status_multipath_veritas
status_cluster
status_servicos_cluster
configuracoes_cluster
nodes_do_cluster
status_nodes_cluster
nodeid_do_host
status_do_llstat
status_do_gab
"
