#!/bin/bash
# Buscador de Maquinas Resueltas por S4vitar de la plataforma HTB, VulnHub y demas
# Script para ver si una maquina cualquiera tiene solucion por s4vitar y nada de buscar en youtube
# Tanto para ver las tecnicas utilizadas y desplegadas para comprometer la maquina, como material de refuerzo
# El desarrollo del script es con fines de aprendizaje y soltura en bash
# Autor Liandd
#!/bin/bash

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
  echo -e "\n\n ${redColour} [!] Saliendo... ${endColour}\n"
  tput cnorm && exit 1
}

# Variables Globales
main_url="https://htbmachines.github.io/bundle.js"

# Ctrl + C
trap ctrl_c INT

function helpPanel(){
  echo -e "\n${purpleColour}[#]${endColour}${grayColour} Autor: Liandd ${endColour}"
  echo -e "\n${yellowColour}[!]${endColour}${grayColour} Uso: ${endColour}"
  echo -e "\t${purpleColour}u)${endColour}${grayColour} Descargar o actualizar archivos necesarios. ${endColour}" 
  echo -e "\t${purpleColour}m)${endColour}${grayColour} Buscar por nombre de maquina. ${endColour}" 
  echo -e "\t${purpleColour}i)${endColour}${grayColour} Buscar por direccion IP. ${endColour}" 
  echo -e "\t${purpleColour}h)${endColour}${grayColour} Mostrar panel de ayuda. ${endColour}" 
}


function updateFiles(){
  if [ ! -f bundle.js ]; then
    tput civis
    echo -e "\n ${yellowColour} [+] ${endColour} ${grayColour} Descargando archivos necesarios... ${endColour}"
    curl -s $main_url > bundle.js 
    js-beautify bundle.js | sponge bundle.js
    echo -e "\n ${yellowColour} [+] ${endColour} ${grayColour} Todos los archivos han sido descargados. ${endColour}"
    tput cnorm
  else
    tput civis
    echo -e "\n ${yellowColour} [+] ${endColour} ${grayColour} Comprobando si hay actualizaciones pendientes... ${endColour}"
    curl -s $main_url > bundle_temp.js 
    js-beautify bundle_temp.js | sponge bundle_temp.js
    md5_tmp_value=$(md5sum bundle_temp.js | awk '{print $1}')
    md5_original_value=$(md5sum bundle.js | awk '{print $1}')

    if [ "$md5_tmp_value" == "$md5_original_value" ]; then
      echo -e "\n ${yellowColour} [+] ${endColour} ${grayColour} No se han detectado actualizaciones disponibles. ${endColour}"
      rm bundle_temp.js
    else
      echo -e "\n ${yellowColour} [!] ${endColour} Se han encontrado actualizaciones disponibles. ${endColour}"
      sleep 1

      rm bundle.js && mv bundle_temp.js bundle.js

      echo -e "\n ${yellowColour} [+] ${endColour} ${grayColour} Los archivos han sido actualizados. ${endColour}"
    fi

    tput cnorm
  fi
}


function searchMachine() {
  machineNameCheck="$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta:" | tr -d '"' | tr -d ',' | sed 's/^ *//')"
 
  if [ "$machineNameCheck" ]; then
    name=$(cat bundle.js | awk "/name: \"${machineName}\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta:" | tr -d '"' | tr -d ',' | sed 's/^ *//' | grep "name:" | sed 's/name:/Nombre:/' | sed 's/^ *//' | awk 'NF{print $NF}')
    ip=$(cat bundle.js | awk "/name: \"${machineName}\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta:" | tr -d '"' | tr -d ',' | sed 's/^ *//' | grep "ip:" | sed 's/ip:/IP:/' | sed 's/^ *//'| awk 'NF{print $NF}')
        so=$(cat bundle.js | awk "/name: \"${machineName}\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta:" | tr -d '"' | tr -d ',' | sed 's/^ *//' | grep "so:" | sed 's/so:/SO:/' | awk '{print $2}')
    dificultad=$(cat bundle.js | awk "/name: \"${machineName}\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta:" | tr -d '"' | tr -d ',' | sed 's/^ *//' | grep "dificultad:" | sed 's/dificultad:/Dificultad:/' | sed 's/^ *//'| awk 'NF{print $NF}')
    skills=$(cat bundle.js | awk "/name: \"${machineName}\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta:" | tr -d '"' | tr -d ',' | sed 's/^ *//' | grep "skills:" | sed 's/skills:/Skills:/' | sed 's/^ *//' | awk 'sub(/^Skills: /, "")')
    like=$(cat bundle.js | awk "/name: \"${machineName}\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta:" | tr -d '"' | tr -d ',' | sed 's/^ *//' | grep "like:" | sed 's/like:/Estilo:/' | sed 's/^ *//'| awk 'sub(/^Estilo: /, "")')
    youtube=$(cat bundle.js | awk "/name: \"${machineName}\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta:" | tr -d '"' | tr -d ',' | sed 's/^ *//' | grep "youtube:" | awk '{print $2}')
    activedir=$(cat bundle.js | awk "/name: \"${machineName}\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta:" | tr -d '"' | tr -d ',' | tr -d ':' | sed 's/^ *//' | grep "activeDirectory" | sed 's/activeDirectory/Active Directory:/' | sed 's/^ *//' | sed 's/Active Directory/✔/')
      
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Listando las propiedades de la máquina ${endColour}${blueColour}${machineName}${endColour}${grayColour}:${endColour}\n"
    echo -e "${turquoiseColour}Nombre:${endColour}${blueColour} ${name} ${endColour}"
    echo -e "${turquoiseColour}IP:${endColour}${grayColour} ${ip}${endColour}"
# Colorear segun el so
  if [ "$so" == "Windows" ]; then
    echo -e "${turquoiseColour}SO:${endColour}${greenColour} ${so}${endColour}"
  elif [ "$so" == "Linux" ]; then
    echo -e "${turquoiseColour}SO:${endColour}${purpleColour} ${so}${endColour}"
  fi
# Colorear según la dificultad
  if [ "$dificultad" == "Fácil" ]; then
    echo -e "${turquoiseColour}Dificultad:${endColour} ${turquoiseColour}${dificultad}${endColour}"
  elif [ "$dificultad" == "Media" ]; then
    echo -e "${turquoiseColour}Dificultad:${endColour} ${blueColour}${dificultad}${endColour}"
  elif [ "$dificultad" == "Difícil" ]; then
    echo -e "${turquoiseColour}Dificultad:${endColour} ${yellowColour}${dificultad}${endColour}"
  elif [ "$dificultad" == "Insane" ]; then
    echo -e "${turquoiseColour}Dificultad:${endColour} ${redColour}${dificultad}${endColour}"
  else
    echo -e "${turquoiseColour}Dificultad:${endColour} ${turquoiseColour}${dificultad}${endColour}"
  fi
    echo -e "${blueColour}Skills:${endColour}${grayColour} ${skills}${endColour}"
    echo -e "${blueColour}Estilo:${endColour}${grayColour} ${like}${endColour}"
    echo -e "${redColour}YouTube:${endColour}${blueColour} ${youtube}${endColour}\n"
    if [ "$activedir" ]; then 
      echo -e "${blueColour}Active Directory:${endColour}${greenColour}  ${endColour}"
    fi
  else
    echo -e "\n${redColour}[!]${endColour}${grayColour} La máquina ${endColour}${blueColour}${machineName}${endColour}${grayColour} no existe.${endColour}\n"
  fi
}

function searchIP(){
  ipAddress="$1"
  machineName=$(cat bundle.js | grep "ip: \"$ipAddress\"" -B 3 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',')
  if [ "$machineName" ]; then
     echo -e "\n${yellowColour}[+]${endColour}${grayColour} La máquina correspondiente para la IP${endColour}${blueColour} $ipAddress${endColour}${grayColour} es${endColour}${purpleColour} $machineName${endColour}\n" 
   else
  echo -e "\n${yellowColour}[+]${endColour}${grayColour} La máquina correspondiente para la IP${endColour}${blueColour} $ipAddress${endColour}${grayColour} no existe.${endColour}\n" 
  fi
}

# Indicadores
declare -i parameter_counter=0

while getopts "m:ui:h" arg; do
  case $arg in
    m) machineName=$OPTARG;let parameter_counter+=1;;
    u) let parameter_counter+=2;;
    i) ipAddress=$OPTARG;let parameter_counter+=3;;
    h) ;;
  esac
done

if [ $parameter_counter -eq 1 ]; then
  searchMachine $machineName
elif [ $parameter_counter -eq 2 ]; then
  updateFiles
elif [ $parameter_counter -eq 3 ]; then
  searchIP $ipAddress
else
  helpPanel
fi