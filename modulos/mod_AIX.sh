#!/bin/ksh
# mod_AIX.sh
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
#               a. todo minusculo
#
#               b. nao utiliza espaco ou caracteres especiais, apenas _ é permitido
#
#               c. use de forma mais clara possivel seguindo as regras acima
#
#       Regras para o {COMANDO}
#
#       a. saida final deve ser encaminhado para a variavel $CHKU_GFILE
#
# Exemplo:
#
#       file_name netstat_anv
#       netstat -anv > $CHKU_GFILE
#
# 2. Adicionar lista de arquivos
#
# Adicionar no FILES_NAMES="" o nome do {NOME_DO_ARQUIVO} utilizados
#
# Exemplo: 
#    FILE_NAMES="
#    netstat_nav
#     hostname df_h
#    "
###############################################################################
#
#
geracheck() 

{

# hostname
nome_arquivo "hostname"
hostname >$CHKU_GFILE

# uname
nome_arquivo "uname_-a"
uname -a >$CHKU_GFILE

# df -k
nome_arquivo "df_-k"
df -k | awk '{ print $1"\t"$7 }'  >$CHKU_GFILE

# ifconfig -a
nome_arquivo "ifconfig_-a"
ifconfig -a >$CHKU_GFILE

# netstat -nr
nome_arquivo "netstat_-nr"
netstat -nr | awk '{ print $1 "\t" $2 "\t" $3 "\t" $6 }' >$CHKU_GFILE

# lsvg (vgs)
nome_arquivo "lsvg"
lsvg >$CHKU_GFILE

# lsvg (vgs) ativos
nome_arquivo "lsvg_ativos" 
lsvg -o|lsvg -il >$CHKU_GFILE

# lspv (discos)
nome_arquivo "lspv"
lspv >$CHKU_GFILE

# crontab
nome_arquivo "crontab"
crontab -l >$CHKU_GFILE

# hosts
nome_arquivo "hosts"
cat /etc/hosts >$CHKU_GFILE

# qconfig (impressao)
nome_arquivo "qconfig" 
cat /etc/qconfig >$CHKU_GFILE

# resolv.conf (dns client)
nome_arquivo "resolv_dns_client"
cat /etc/resolv.conf >$CHKU_GFILE

# netsvc (ordem resolução de nomes)
nome_arquivo "netsvc"
cat /etc/netsvc.conf >$CHKU_GFILE

# lista pacotes (lslpp)
nome_arquivo "lslpp_-l"
lslpp -l >$CHKU_GFILE

# lista devices
nome_arquivo "lsdev-C"
lsdev -C >$CHKU_GFILE

# maymap
if [ -f /usr/bin/maymap ]
then
	nome_arquivo "maymap_-ap_-4"
	maymap -ap -4 >$CHKU_GFILE

	nome_arquivo "maymap_-ah_-4"
	maymap -ah -4 >$CHKU_GFILE
fi

# prtconf
if [ -f /usr/sbin/prtconf ]
then
	nome_arquivo "prtconf"
	/usr/sbin/prtconf >$CHKU_GFILE
fi

# netstat
nome_arquivo "netstat"
netstat -vn|awk ' $1 ~ /ETHERNET/ || $2 ~ /Speed/ {print $0}' >$CHKU_GFILE

# vmo
if [ -f /usr/sbin/vmo ]
then
	nome_arquivo "vmo_-r_-a"
	/usr/sbin/vmo -r -a | grep -v pinnable_frames >$CHKU_GFILE
fi


# no
if [ -f /usr/sbin/no ]
then
	nome_arquivo "no_-r_-a"
	/usr/sbin/no -r -a >$CHKU_GFILE
fi

# ioo
if [ -f /usr/sbin/ioo ]
then
	nome_arquivo "ioo_-r_-a"
	/usr/sbin/ioo -r -a >$CHKU_GFILE
fi

# nfso
if [ -f /usr/sbin/nfso ]
then
	nome_arquivo "nfso_-r_-a"
	/usr/sbin/nfso -r -a >$CHKU_GFILE
fi

# schedo
if [ -f /usr/sbin/schedo ]
then
	nome_arquivo "schedo"
	/usr/sbin/schedo -r -a >$CHKU_GFILE
fi

# lsfs
if [ -f /usr/sbin/lsfs ]
then
	nome_arquivo "lsfs"
	/usr/sbin/lsfs -q >$CHKU_GFILE
fi

# sysdumpdev
if [ -f /usr/bin/sysdumpdev ]
then
	nome_arquivo "sysdumpdev_-l"
	/usr/bin/sysdumpdev -l >$CHKU_GFILE
fi

# lssrc
if [ -f  /usr/bin/lssrc ]
then
	nome_arquivo "lssrc_-a"
	/usr/bin/lssrc -a >$CHKU_GFILE
fi

# lslicense
if [ -f /usr/bin/lslicense ]
then
	nome_arquivo "lslicense_-c"
	/usr/bin/lslicense -c  >$CHKU_GFILE
fi

# sendmail
if [ -f /etc/sendmail.cf ]
then
	nome_arquivo "sendmail"
	cat /etc/sendmail.cf  >$CHKU_GFILE
fi

# showmount
if [ -f /usr/bin/showmount ]
then
	nome_arquivo "showmount_-e"
	/usr/bin/showmount -e >$CHKU_GFILE
fi

# exportfs
if [ -f /usr/sbin/exportfs ]
then
	nome_arquivo "exportfs"
	/usr/sbin/exportfs -v >$CHKU_GFILE
fi

# filesystem
if [ -f /etc/filesystems ]
then
	nome_arquivo "filesystems"
	cat /etc/filesystems >$CHKU_GFILE
fi

# lspath
if [ -f /usr/sbin/lspath ]
then
 	nome_arquivo "lspath_-H"
	/usr/sbin/lspath -H >$CHKU_GFILE
fi

# powermt
if [ -f /usr/sbin/powermt ]
then
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

# lsrsrc
if [ -f /usr/bin/lsrsrc  ]
then
	nome_arquivo "ibm_management_server"
	/usr/bin/lsrsrc IBM.ManagementServer >$CHKU_GFILE

	nome_arquivo "ibm_lpar"
	/usr/bin/lsrsrc IBM.LPAR >$CHKU_GFILE

	nome_arquivo "ibm_host"
	/usr/bin/lsrsrc IBM.Host >$CHKU_GFILE
	
	nome_arquivo "ibm_wlm"
	/usr/bin/lsrsrc IBM.WLM >$CHKU_GFILE
	
fi

# cldump
if [ -f /usr/es/sbin/cluster/utilities/cldump ]
then

nome_arquivo "hacmp_cllscf"
/usr/sbin/cluster/utilities/cllscf >$CHKU_GFILE

nome_arquivo "hacmp_cllsserv"
/usr/sbin/cluster/utilities/cllsserv >$CHKU_GFILE

nome_arquivo "hacmp_clshowres"
/usr/sbin/cluster/utilities/clshowres >$CHKU_GFILE

nome_arquivo "hacmp_cllsnode"
/usr/sbin/cluster/utilities/cllsnode >$CHKU_GFILE

nome_arquivo "hacmp_cllsif"
/usr/sbin/cluster/utilities/cllsif >$CHKU_GFILE

nome_arquivo "hacmp_cllsclstr"
/usr/sbin/cluster/utilities/cllsclstr >$CHKU_GFILE

nome_arquivo "hacmp_cllsvgdata"
/usr/sbin/cluster/utilities/cllsvgdata >$CHKU_GFILE

nome_arquivo "hacmp_cllssvcs"
/usr/sbin/cluster/utilities/cllssvcs >$CHKU_GFILE

nome_arquivo "hacmp_cllsstbys"
/usr/sbin/cluster/utilities/cllsstbys >$CHKU_GFILE

nome_arquivo "hacmp_cllsclstr"
/usr/sbin/cluster/utilities/cllsclstr>$CHKU_GFILE

nome_arquivo "hacmp_cllsserv"
/usr/sbin/cluster/utilities/cllsserv >$CHKU_GFILE

nome_arquivo "hacmp_cllssite"
/usr/sbin/cluster/utilities/cllssite >$CHKU_GFILE

nome_arquivo "hacmp_cllsfs"
/usr/sbin/cluster/utilities/cllsfs >$CHKU_GFILE

nome_arquivo "hacmp_cllsres"
/usr/sbin/cluster/utilities/cllsres >$CHKU_GFILE

nome_arquivo "hacmp_cllslv"
/usr/sbin/cluster/utilities/cllslv >$CHKU_GFILE

nome_arquivo "hacmp_cllstape"
/usr/sbin/cluster/utilities/cllstape >$CHKU_GFILE

fi

# mmlspv
if [ -f /usr/lpp/mmfs/bin/mmlspv ]
then


 	nome_arquivo "gfs_mmlspv"
 	/usr/lpp/mmfs/bin/mmlspv >$CHKU_GFILE

 	nome_arquivo "gfs_mmlscluster"
 	/usr/lpp/mmfs/bin/mmlscluster >$CHKU_GFILE

 	nome_arquivo "gfs_mmlsconfig"
 	/usr/lpp/mmfs/bin/mmlsconfig >$CHKU_GFILE

 	nome_arquivo "gfs_mmlsmgr"
 	/usr/lpp/mmfs/bin/mmlsmgr >$CHKU_GFILE

 	nome_arquivo "gfs_mmlsnode"
 	/usr/lpp/mmfs/bin/mmlsnode -a >$CHKU_GFILE

 	nome_arquivo "gfs_mmlsnsd"
 	/usr/lpp/mmfs/bin/mmlsnsd >$CHKU_GFILE
fi

# rpm
if [ -f /usr/bin/rpm ]
then
 	nome_arquivo "rpm_-qa"
	/usr/bin/rpm -qa >$CHKU_GFILE

fi

# netstat 
nome_arquivo "netstat_-an"
/usr/bin/netstat -an | grep -i listen>$CHKU_GFILE

# netstat -v
nome_arquivo "netstat_-v"
/usr/bin/netstat -v | egrep -i 'ent|vlan' >$CHKU_GFILE


# lscfg
nome_arquivo "lscfg"
/usr/sbin/lscfg >$CHKU_GFILE
	

# lparstat
if [ -f /usr/bin/lparstat ]
then
	nome_arquivo "lparstat_-i"
	/usr/bin/lparstat -i >$CHKU_GFILE
fi

}

FILES_NAMES="
hostname
uname_-a
df_-k
ifconfig_-a
netstat_-nr
lsvg
lsvg_ativos
lspv
crontab
hosts
qconfig
resolv.conf
netsvc
lslpp_-l
lsdev_-C
maymap_-ap_-4
maymap_-ah_-4
prtconf
netstat
vmo_-r_-a
no_-r_-a
ioo_-r_-a
nfso_-r_-a
schedo
lsfs
sysdumpdev_-l
lssrc_-a
lslicense_-c
sendmail
showmount_-e
exportfs
filesystems
lspath_-H
powermt_version
powermt_display
powermt_display_paths
powermt_display_options
powermt_display_dev_all
powermt_display_unmanaged
ibm_management_server
ibm_lpar
ibm_host
ibm_wlm
hacmp_cllscf
hacmp_cllsserv
hacmp_clshowres
hacmp_cllsnode
hacmp_cllsif
hacmp_cllsclstr
hacmp_cllsvgdata
hacmp_cllssvcs
hacmp_cllsstbys
hacmp_cllsclstr
hacmp_cllsserv
hacmp_cllssite
hacmp_cllsfs
hacmp_cllsres
hacmp_cllslv
hacmp_cllstape
gfs_mmlspv
gfs_mmlscluster
gfs_mmlsconfig
gfs_mmlsmgr
gfs_mmlsnode
gfs_mmlsnsd
rpm_-qa
netstat_-an
netstat_-v
lscfg
lparstat_-ibm_wlm
"

