#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"


function ctrl_c() {
  echo -e "\n\n${redColour}[!] Saliendo...${endColour}\n\n"
  tput cnorm && exit 1
}

trap ctrl_c INT

function helpPanel() {
  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Uso:${endColour}\n"
  echo -e "\t${blueColour}m)${endColour} ${grayColour}Dinero con el que se desea jugar${endColour}"
  echo -e "\t${blueColour}t)${endColour} ${grayColour}Técnica con la que se desea jugar${endColour} ${turquoiseColour}(martingala/inverseLabrouchere)${endColour}"
  exit 1
}

while getopts "m:t:h" arg; do
  case $arg in
    m) money=$OPTARG;;
    t) technique=$OPTARG;;
    *) helpPanel;;  
  esac
done;

if [ $money ] && [ $technique ]; then
  if [ "$technique" == "martingala" ]; then
    martingala
  else
    echo -e "${redColour}[!] La técnica introducida no es correcta${endColour}"
    helpPanel
  fi
else
  helpPanel
fi
