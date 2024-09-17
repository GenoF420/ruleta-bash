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

function martingala() {
  echo -e "\n${yellowColour}[+] Dinero actual: \$$money${endColour}"
  echo -ne "${yellowColour}[+] ${endColour}${grayColour}¿Cuánto dinero tienes pensado apostar? -> ${endColour}" && read initial_bet
  echo -ne "${yellowColour}[+] ${endColour}${grayColour}¿A qué deseas apostar continuamente? ${endColour}${turquoiseColour}(par/impar)${endColour} ${grayColour}-> ${endColour}" && read par_impar

  echo -e "[+] Vamos a jugar con la cantidad inical de \$$initial_bet a $par_impar"

  tput civis
  while true; do
    random_number="$(($RANDOM % 37))"
    echo -e "ha salido el numero $random_number"

    if [ "$(($random_number % 2))" -eq 0 ]; then
      if [ $random_number -eq 0 ]; then
        echo "ha salido 0, por lo tanto perdemos"
      else
        echo "el numero que ha salido es par"
      fi
    else
      echo "el numero que ha salido es impar"
    fi
    sleep 0.3
  done
  tput cnorm
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
