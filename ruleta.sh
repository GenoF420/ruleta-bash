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

  echo -e "${yellowColour}[+]${endColour} ${grayColour}Vamos a jugar con la cantidad inical de${endColour} ${yellowColour}\$$initial_bet${endColour} ${turquoiseColour}$par_impar${endColour}\n"
  backup_bet=$initial_bet
  play_counter=1

  tput civis
  while true; do
    money=$(($money-$initial_bet))
    echo -e "\n${yellowColour}[+] ${endColour}${grayColour}Acabas de apostar${endColour} ${yellowColour}\$$initial_bet${endColour}${grayColour} y tienes ${endColour}${yellowColour}\$$money${endColour}"
    
    if [ ! $money -le 0 ]; then
      random_number="$(($RANDOM % 37))"
      echo -e "${yellowColour}[+]${endColour} ${grayColour}[+] Ha salido el numero $random_number${endColour}"
      if [ "$par_impar" == "par" ]; then
        if [ "$(($random_number % 2))" -eq 0 ]; then
          if [ $random_number -eq 0 ]; then
            echo -e "${redColour}[!] Ha salido 0, por lo tanto pierdes${endColour}"
            initial_bet=$(($initial_bet*2))
            echo -e "${purpleColour}[+]${endColour} ${grayColour} Ahora que quedas con: ${endColour}${yellowColour}\$$money${endColour}\n"
          else
            echo -e "${yellowColour}[+]${endColour} ${greenColour}El numero que ha salido es par, ¡ganaste :D !${endColour}"
            reward=$(($initial_bet*2))
            echo -e "${yellowColour}[+]${endColour} ${grayColour}Ganas un total de:${endColour} ${yellowColour}\$$reward${endColour}"
            money=$(($money+$reward))
            initial_bet=$backup_bet
            echo -e "${purpleColour}[+]${endColour} ${grayColour} Ahora te quedas con: ${endColour}${yellowColour}\$$money${endColour}\n"
          fi
        else
          echo -e "${yellowColour}[!]${endColour} ${redColour}El numero que ha salido es impar, pierdes!${endColour}"
          initial_bet=$(($initial_bet*2))
          echo -e "${purpleColour}[+]${endColour} ${grayColour} Ahora que quedas con: ${endColour}${yellowColour}\$$money${endColour}\n"
        fi
      fi
    else
      #nos quedamos sin money
      echo -e "\n\n${redColour}[!] Te quedaste sin plata mi bro!, pa fuera.${endColour}\n"
      echo -e "${purpleColour}[+]${endColour} ${grayColour} Total de jugadas: ${endColour}${yellowColour}$play_counter${endColour}\n"
      tput cnorm && exit 0
    fi

    let play_counter+=1
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
