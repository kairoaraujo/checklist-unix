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
#
#

mkcheck ()
{

   file_name hostname_do_servidor
   hostname >$CHKU_GFILE

   file_name versionamento_do_servidor
   uname -a >$CHKU_GFILE

   file_name analise_do_mirror
   metastat  >$CHKU_GFILE

   file_name status_do_mirror
   metastat -c >$CHKU_GFILE

   file_name release_do_servidor
   cat /etc/release >$CHKU_GFILE

   file_name filesystems_montados
   df -h | awk '{ print $1" \t"$2" \t"$6 }' >$CHKU_GFILE

   file_name status_do_veritas_volume_manager
   vxdisk -o alldgs list | grep -v \( >$CHKU_GFILE

   file_name rotas_de_rede
   netstat -rnv | cut -c 1-65  >$CHKU_GFILE

   file_name configuracao_de_rede
   ifconfig -a  >$CHKU_GFILE

   file_name arquivo_vfstab
   cat /etc/vfstab|sort >$CHKU_GFILE

   file_name dispositivos_de_io
   iostat -En >$CHKU_GFILE

   file_name configuracao_de_hardware_prtdiag
   prtdiag >$CHKU_GFILE

   file_name configuracao_de_hardware_prtconf
   prtconf >$CHKU_GFILE

   file_name interfaces_hba
   fcinfo hba-port >$CHKU_GFILE

   file_name dispositivos_ethernet
   dladm show-dev >$CHKU_GFILE

   file_name status_dos_servicos
   svcs | awk '{ print $1" "$3 }' >$CHKU_GFILE

   file_name compartilhamentos_share
   share | awk '{ print $1" "$3 }' >$CHKU_GFILE

   file_name compartilhamentos_showmount
   showmount  | awk '{ print $1" "$3 }' >$CHKU_GFILE
   echo ""

   file_name modulos_do_sistema
   modinfo | awk '{print $6,$7,$8,$9,$10,$11,$12}' >$CHKU_GFILE

   #####################################################################
   ## Adicionado Modulo para checagem do Veritas Volume Manger!!!      #
   ## Adicionado Modulo para checagem do Veritas Cluster!!!!           #
   #####################################################################

   PATH=${PATH}:/usr/lib/vxvm/diag.d:/etc/vx/diag.d:/opt/VRTS/bin:/opt/VRTSvlic/bin
   export PATH

   
   if [ -f /opt/VRTS/bin/vxdg ]
   then

   file_name status_dos_discos_veritas
   vxdisk list >$CHKU_GFILE

   file_name serial_dos_discos
   vxdisk -e list >$CHKU_GFILE

   file_name disk_groups
   vxdg list >$CHKU_GFILE

   file_name status_volumes
   vxprint -ht >$CHKU_GFILE

   file_name status_controladoras
   vxdmpadm listctlr all >$CHKU_GFILE

   file_name status_controladoras_storage
   vxdmpadm listenclosure all >$CHKU_GFILE

   file_name storages_suportados
   vxddladm listsupport >$CHKU_GFILE

   file_name status_daemon_vxdctl
   vxdctl mode >$CHKU_GFILE

   file_name status_cluster_enable
   vxdctl -c mode

   file_name checa_licencas_veritas
   vxlicrep >$CHKU_GFILE

   file_name checa_licencas_ativadas
   vxlicrep -e >$CHKU_GFILE

   file_name status_multipath_veritas
   vxdmpadm stat restored >$CHKU_GFILE
  
   fi

   if  [ -f /opt/VRTSvcs/bin/hastatus ]
   then

   file_name status_cluster
   hastatus -summary >$CHKU_GFILE

   file_name status_servicos_cluster
   hares -display >$CHKU_GFILE

   file_name configuracoes_cluster
   hagrp -display >$CHKU_GFILE

   file_name nodes_do_cluster
   hasys -list >$CHKU_GFILE

   file_name status_nodes_cluster
   hasys -state >$CHKU_GFILE

   file_name nodeid_do_host
   hasys -nodeid >$CHKU_GFILE

   file_name status_do_llstat
   llstat >$CHKU_GFILE
  
   file_name status_do_gab
   gabconfig -a >$CHKU_GFILE
   
fi

}