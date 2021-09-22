#!/bin/bash

#Irá rodar na pasta que se encontra e funcionará conforme configuração das variáveis

######################
# VARIÁVEIS
######################
#pastas separadas por | se tiver mais de uma
#PASTAS="dir1|dir2|dir3"
PASTAS="static/images|content"
#extensões das imagens que irá transformar em webp (se mais de um, separar por |)
EXTENSOESIMAGENS="jpg|png"
#extensões dos arquivos texto que serão modificados de jpg|png para webp (se mais de um, separar por |)
#EXTENSOESTEXTOS="php|html|htm"
EXTENSOESTEXTOS="md"

#organiza as extensões para o sed, para ficar jpg\|png por exemplo
EXTENSOESIMAGENSSED="`echo $EXTENSOESIMAGENS | sed -e 's@|@\\\|@g'`"


######################
# COMEÇANDO
######################
#checa se tem o webp instalado
if ! command -v cwebp &> /dev/null
then
    echo "O pacote webp não foi instalado!"
    echo "Instale-o para executar o script"
    echo "Se Debian/Ubuntu, execute: sudo apt install webp"
    exit
fi


echo "
##############################
## Gerando os arquivos webp ##
##############################
"
find . -type f -regextype posix-egrep -regex "./($PASTAS)/.*.($EXTENSOESIMAGENS)" -exec bash -c 'for arg; do cwebp -quiet -q 80 $arg -o ${arg%.*}.webp ; done' find+bash {} +


echo "
###########################################################
## Modificando arquivos para referenciarem os novos webp ##
###########################################################
"
find . -type f -regextype posix-egrep -regex "./($PASTAS)/.*.($EXTENSOESTEXTOS)" -print0 | xargs -0 sed -i "s@\($EXTENSOESIMAGENSSED\)@webp@g"


echo "
##############################
## Apagando os arquivos $EXTENSOESIMAGENS
##############################
"
find . -type f -regextype posix-egrep -regex "./($PASTAS)/.*.($EXTENSOESIMAGENS)" -exec \rm {} \;
