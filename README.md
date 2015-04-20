# checklist-unix

Este é um conjunto de scripts criado de forma modular para gerar checklist e 
e comparar com datas.

Atualmente ele possui módulos para Linux, AIX, HP-UX, Solaris e MacOS.
Para criar modulos, veja mais abaixo.


## Instalação

1. Descompactar o checklist-unix em um diretório.
2. Alterar a variável CHKU_PATH no checklist-unix.sh conforme o diretório 
instalado.
 

## Como utilizar


    Usage:
         -h       : exibe este help
         -v       : versao do checklist
         -c       : Compara checklist
         -g       : Gera checklist
         -cd      : Compara checklist de uma data especifica (DDMMAAAA.hhmm)
         -cl      : Lista arquivos com datas disponiveis
         -e       : (nao implementado) Coleta arquivos de logs e armazena no diretorio especifico
         -pe      : (nao implementado) Informa os logs do Ultimo dia
         -ped     : (nao implementado) Imprime os logs do dia especificado (DDMMAAAA)
         -r       : Realiza rotate dos logs:
                    logs com 90 dias ou mais são excluidos
         -s       : (nao implementado) Exibe status do servidor no momento

## Desenvolvimento

checklist-unix.sh é o core, ele utiliza Shell Scripting.

### Modulos

Par-a criar modulos, basta seguir o mod_modelo.sh, utilizando shell script.
Basicamente, ele segue a seguinte regra:

1 - Dentro da funcao geracheck() criar o comando

nome_arquivo {NOME_DO_ARQUIVO}
 {COMANDO} > $CHKU_GFILE

Regras para o {NOME_DO_ARQUIVO}
    a. todo minusculo
    b. nao utiliza espaco ou caracteres especiais, apenas _ é permitido
    c. use de forma mais clara possivel seguindo as regras acima

Regras para o {COMANDO}
    a. saida final deve ser encaminhado para a variavel $CHKU_GFILE

Exemplo:

    file_name netstat_anv
    netstat -anv > $CHKU_GFILE

2 - Adicionar lista de arquivos

Adicionar no FILES_NAMES="" o nome do {NOME_DO_ARQUIVO} utilizados

 Exemplo:
FILE_NAMES="
    netstat_nav
    hostname df_h
    "

3 - Na duvida, veja o modelo.
