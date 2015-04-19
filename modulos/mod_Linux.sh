#!/bin/sh
#
# mod_Linux.sh
# checklist-unix
#
# Created by kairo.araujo on 29/06/10.
#
##############################################################################
#
# geracheck()
#
# 1. Criar comando
#
# nome_arquivo {NOME_DO_ARQUIVO} 
# {COMANDO} > $CHKU_GFILE
#
#   Regras para o {NOME_DO_ARQUIVO}
#
# 		a. todo minusculo
#
#		b. nao utiliza espaco ou caracteres especiais, apenas _ é permitido
#
#		c. use de forma mais clara possivel seguindo as regras acima
#
#	Regras para o {COMANDO}
#
#       a. saida final deve ser encaminhado para a variavel $CHKU_GFILE
#
# Exemplo:
#
#	file_name netstat_anv
#	netstat -anv > $CHKU_GFILE
#
# 2. Adicionar lista de arquivos
#
# Adicionar no FILES_NAMES="" o nome do {NOME_DO_ARQUIVO} utilizados
#
# Exemplo: 
#    FILE_NAMES="
#    netstat_nav
#    hostname df_h
#    "
###############################################################################
geracheck ()
{
   
   nome_arquivo "hostname_do_servidor"
   hostname >$CHKU_GFILE

   nome_arquivo "versionamento_do_servidor"
   uname -a >$CHKU_GFILE

   nome_arquivo "release_do_servidor"
   cat /etc/*-release >$CHKU_GFILE

   nome_arquivo "filesystems_montados"
   df -P | awk '{ print $1"\t\t"$6 }' >$CHKU_GFILE

   nome_arquivo "rotas_de_rede"
   netstat -rnv >$CHKU_GFILE
       
   nome_arquivo "configuracao_de_rede"
   ifconfig -a |grep -v -E 'RX |TX '>$CHKU_GFILE
       
   nome_arquivo "arquivo_vfstab"
   cat /etc/fstab|sort >$CHKU_GFILE

   nome_arquivo "configuracao_de_hardware_dmidecode"
   dmidecode >$CHKU_GFILE

   nome_arquivo "dispositivos_pci"
   lspci >$CHKU_GFILE

   nome_arquivo "status_dos_servicos"
   chkconfig --list >$CHKU_GFILE

   nome_arquivo "compartilhamentos_exports"
   cat /etc/exports >$CHKU_GFILE

   nome_arquivo "compartilhamentos_showmount"
   showmount  | awk '{ print $1" "$3 }' >$CHKU_GFILE

   nome_arquivo "pacotes_rpm"
   rpm -qa >$CHKU_GFILE 

   # cluster (RHCS e  SLE_HA)
   if [ -f /etc/cluster/cluster.conf ];then
   
 	nome_arquivo "rhcs_config"
	cat /etc/cluster/cluster.conf >$CHKU_GFILE 

	nome_arquivo "rhcs_status"
       	clustat | grep -v @ > $CHKU_GFILE

   fi

   if [ -f /etc/corosync/corosync.conf ]; then
     
       nome_arquivo "sle_ha_status"
       crm_mon -1 | grep -v crm_mon -1 | grep -v "Last updated"  > $CHKU_GFILE

   fi

   nome_arquivo "vgs_servidor"
   vgs >$CHKU_GFILE

   nome_arquivo "lvs_servidor"
   lvs >$CHKU_GFILE

   nome_arquivo "pvs_servidor"
   pvs >$CHKU_GFILE

   nome_arquivo "crontab_root"
   crontab -l >$CHKU_GFILE

   nome_arquivo "arquivo_hosts"
   cat /etc/hosts >$CHKU_GFILE

   # samba file se existir
   if [ -f /etc/samba/smb.conf ]; then
      nome_arquivo "arquivo_smbconf"
      cat /etc/samba/smb.conf >$CHKU_GFILE
   fi

   nome_arquivo "resolv_conf_dns_client"
   cat /etc/resolv.conf  >$CHKU_GFILE

   nome_arquivo "ordem_resolucao_nsswitch"
   cat /etc/nsswitch.conf >$CHKU_GFILE

   nome_arquivo "sysctl"
   cat /etc/sysctl.conf >$CHKU_GFILE
   
   # selinux se existir

   if [ -f /etc/sysconfig/selinux ]; then

      nome_arquivo "selinux"
      cat /etc/sysconfig/selinux >$CHKU_GFILE

   fi

   # multipath se existir

   if [ -f /etc/multipath.conf ]; then
      
      nome_arquivo "arquivo_multipath"
      cat /etc/multipath.conf >$CHKU_GFILE

   fi

   nome_arquivo "multipath_-l"
   multipath -ll >$CHKU_GFILE

   # powerpath
   if [ -f /usr/sbin/powermt ]; then
	nome_arquivo "powermt_version"
	/usr/sbin/powermt version >$CHKU_GFILE

	nome_arquivo "powermt_display"
 	/usr/sbin/powermt display >$CHKU_GFILE

	nome_arquivo "powermt_display_paths"
	/usr/sbin/powermt display paths >$CHKU_GFILE
	
	nome_arquivo "powermt_display_options"
	/usr/sbin/powermt display options >$CHKU_GFILE
	
	nome_arquivo "powermt_display_dev_all"
	/usr/sbin/powermt display dev=all >$CHKU_GFILE

	nome_arquivo "powermt_display_unmanaged"
	/usr/sbin/powermt display unmanaged >$CHKU_GFILE

   fi

   nome_arquivo "lista_servicos_chkconfig"  
   chkconfig --list  >$CHKU_GFILE

   nome_arquivo "filesystem_read_only"
   awk '$4 ~ "^ro" && $3 !~ "(squashfs|iso9660)" {print $0}' /proc/mounts >$CHKU_GFILE
   
}


FILES_NAMES="
hostname_do_servidor
versionamento_do_servidor
release_do_servidor
filesystems_montados
rotas_de_rede
configuracao_de_rede
arquivo_vfstab
configuracao_de_hardware_dmidecode
dispositivos_pci
status_dos_servicos
compartilhamentos_exports
compartilhamentos_showmount
pacotes_rpm
rhcs_config
rhcs_status
sle_ha_status
vgs_servidor
lvs_servidor
pvs_servidor
crontab_root
arquivo_hosts
arquivo_smbconf
resolv_conf_dns_client
ordem_resolucao_nsswitch
sysctl
selinux
arquivo_multipath
multipath_-l
powermt_version
powermt_display
powermt_display_paths
powermt_display_options
powermt_display_dev_all
powermt_display_unmanaged
lista_servicos_chkconfig
filesystem_read_only
"
