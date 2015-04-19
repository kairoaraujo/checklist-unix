#!/bin/sh
#
# mod_SunOS.sh
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
# file_name {NOME_DO_ARQUIVO} 
# {COMANDO} > $CHKU_GFILE
#
#   Regras para o {NOME_DO_ARQUIVO}
# 		a. todo minusculo
#		b. nao utiliza espaco ou caracteres especiais, apenas _
#		c. use de forma mais clara possivel seguindo as regras acima
#
#	Regras para o {COMANDO}
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
#	 netstat_nav hostname df_h
#    "
     
geracheck ()
{
	nome_arquivo hostname
	hostname > $CHKU_GFILE
	
	nome_arquivo uname_-a
	uname -a > $CHKU_GFILE
	
}

# Arquivos gerados, apenas os {FILE_NAME} utilizados
FILES_NAMES="
hostname uname_-a
"


