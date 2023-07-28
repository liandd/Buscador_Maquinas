#!/bin/bash
# Buscador de Maquinas Resueltas por S4vitar de la plataforma HTB, VulnHub y demas
# Script para ver si una maquina cualquiera tiene solucion por s4vitar y nada de buscar en youtube
# Tanto para ver las tecnicas utilizadas y desplegadas para comprometer la maquina, como material de refuerzo
# El desarrollo del script es con fines de aprendizaje y soltura en bash
# Autor Liandd
#Colours
greenColour="\e[0;32m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m"
blueColour="\e[0;34m"
yellowColour="\e[0;33m"
purpleColour="\e[0;35m"
turquoiseColour="\e[0;36m"
grayColour="\e[0;37m"

function ctrl_c(){
  echo -e "\n\n${redColour}[!] Saliendo...${endColour}\n"
  tput cnorm && exit 1
}

# Variables Globales
main_url="https://htbmachines.github.io/bundle.js"

# Ctrl + C
trap ctrl_c INT

function helpPanel(){
  echo -e "\t${purpleColour}[#]${endColour} ${grayColour}Autor : Liandd${endColour}"
  echo -e "\n${yellowColour}[!]${endColour} ${grayColour}Uso:${endColour}\n"
  echo -e "\t${purpleColour}u)${endColour} ${grayColour}Descargar o actualizar archivos necesarios${endColour}" 
  echo -e "\t${purpleColour}m)${endColour} ${grayColour}Buscar por nombre de maquina${endColour}" 
  echo -e "\t${purpleColour}h)${endColour} ${grayColour}Mostrar panel de ayuda${endColour}" 
}

function searchMachine(){
 machineName="$1"
 echo "$machineName"
}

function updateFiles(){
  if [ ! -f bundle.js ]; then
    tput civis
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Descargando archivos necesarios...${endColour}"
    curl -s $main_url > bundle.js 
    js-beautify bundle.js | sponge bundle.js
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Todos los archivos han sido descargados${endColour}"
    tput cnorm
  else
    tput civis
    curl -s $main_url > bundle_temp.js 
    js-beautify bundle_temp.js | sponge bundle_temp.js
    md5_tmp_value=$(md5sum bundle_temp.js | awk '{print $1}')
    md5_original_value=$(md5sum bundle.js | awk '{print $1}')

    if [ "$md5_tmp_value" == "$md5_original_value" ]; then
      echo -e "[+] No hay actualizaciones"
      rm bundle_temp.js
    else
      echo -e "[!] Hay actualizaciones"
    fi

    tput cnorm
  fi
}


# Indicadores
declare -i parameter_counter=0

while getopts "m:uh" arg; do
  case $arg in
    m) machineName=$OPTARG;let parameter_counter+=1;;
    u) let parameter_counter+=2;;
    h) ;;
  esac
done

if [ $parameter_counter -eq 1 ]; then
  searchMachine $machineName
elif [ $parameter_counter -eq 2 ]; then
  updateFiles
else
  helpPanel
fi