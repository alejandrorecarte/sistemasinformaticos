#!/bin/bash

# FUNCIÓN PARA COMPROBAR LA INSTALACIÓN DEL PAQUETE MDADM #

comprobarInstalacion(){
       	dpkg -s $1 &> /dev/null
       	if [ $? = 0 ]
	then
	echo 'Instalación verificada.'
	else
		if [[ $4 == '-d' ]]
		then
               	read -p "AVISO: El paquete mdadm no está instalado, a continuación se va a instalar, pulse ENTER para continuar." enter
		fi
		sudo apt install mdadm rsync initramfs-tools -y
        fi

}

# PRESENTACIÓN DEL PROGRAMA #

if [ $# -ne 3 ]  && [ $# -ne 4 ] 
then
	echo 'ERROR: Para poder usar este script debes introducir los nombres de los discos correctamente.' 
	echo '(sudo ./raid5.sh [disco1] [disco2] [disco3] o sudo ./raid5.sh [disco1] [disco2] [disco3] -d para hacer la instalación desasistida)'
else
echo 'O------------------------------------O'
echo '|  ____                     _        |'
echo '| |  _ \ ___  ___ __ _ _ __| |_ ___  |'
echo '| | |_) / _ \/ __/ _` | `__| __/ _ \ |'
echo '| |  _ <  __/ (_| (_| | |  | ||  __/ |'
echo '| |_| \_\___|\___\__,_|_|   \__\___| |'
echo 'O------------------------------------O'
echo '|                                    |'
echo '|          ⠀⠀⠀⠀⠀⠀⣖⢤⡀⠀⠀⠀⠀⠀⠀⠀          |'
echo '|          ⡐⠣⡄⠀⠀⠀⠑⡄⠙⠆⠀⠀⠀⠀⠀⠀          |'
echo '|          ⡇⠘⢄⡄⠂⠉⠀⡀⠀⢸⠀⠀⠀⠀⠀⠀          |'
echo '|          ⢃⡐⠁⠀⠀⠀⠀⠀⠀⡼⠆⠀⠀⢀⣴⠂          |'
echo '|          ⠀⢁⠀⠀⣠⡀⠀⠀⠀⠀⢸⢀⣴⣿⠏⠀          |'
echo '|          ⠀⠈⣿⡄⢹⣿⡄⠀⢀⡀⢠⣿⣿⠏⠀⠀          |'
echo '|          ⠀⠀⠈⢇⠀⢉⣥⣾⣿⣷⣿⣿⠏⠀⠀⠀          |'
echo '|          ⠀⠀⠀⠀⣽⣿⣿⣿⣿⣿⣿⣯⠱⡀⠀⠀          |'
echo '|          ⠀⠀⠀⠀⠙⠋⢻⣿⣿⣿⣿⣿⡄⡇⠀⠀          |'
echo '|          ⠀⠀⠀⠀⠀⠘⣼⣿⣿⣿⣿⣿⣷⡇⠀⠀          |'
echo '|          ⠀⠀⠀⠀⠀⢠⣿⣿⡿⠛⡿⣿⡇⡇⠀⠀          |'
echo '|          ⠀⠀⠀⠀⠠⠟⠋⠀⠈⠂⠌⠺⠇⠀⠀⠀          |'
echo 'O------------------------------------O'

if [[ $4 != '-d' ]]
then
read -p "A continuación se va a ejecutar un script para instalar una gestión d e archivos tipo Raid-5 usando los discos pasados como parámetros. Escriba s/n para continuar." continuar

else
	continuar='s'
fi

comprobarInstalacion mdadm

if [ $continuar = 's' ]
then

	# CONFIGUARACIÓN DE LOS DISCOS 1, 2 Y 3 #

	wipefs -a $1
	wipefs -a $2
	wipefs -a $3
	
	echo "Configurando disco " $1":"

	(echo n; echo p; echo 1; echo; echo; echo t; echo fd; echo p; echo w) |sudo fdisk $1

	echo "Configurando disco "$2":"

	(echo n; echo p; echo 1; echo; echo; echo t; echo fd; echo p; echo w) |sudo fdisk $2

	echo "Configurando disco"$3":"

	(echo n; echo p; echo 1; echo; echo; echo t; echo fd; echo p; echo w) |sudo fdisk $3
	
	# CONFIGURACIÓN DE RAID-5 #

	echo "Configurando los discos en Raid-5:"

	num=1
	sudo mdadm -C /dev/md0 -l raid5 -n 3 $1$num $2$num $3$num
	
	# FORMATEO DEL RAID-5 #
	
	echo "Dando formato al nuevo volumen:"

	sudo mkfs.ext4 /dev/md0

	# SOLICITUD DE REINICIO #


	if [[ $4 != '-d' ]]
	then
		echo
		read -p 'La instalación ya ha terminado, a continuación sería conveniente reiniciar el sistema, escriba s/n si quiere reiniciar ahora:' reinicio
		if [[ $reinicio == 's' ]]
		then
			sudo reboot
		else
		echo 'No se reiniciará el sistema.'
		fi
	else
		echo 'La instalación ya ha terminado, a continuación sería conveniente reiniciar el sistema.'
	fi
fi

# DESPEDIDA DEL PROGRAMA #

echo 'Cerrando instalador.'
echo ''
echo '            	⠀⠀⠀⠀⠀⠀⠀⠀⠀ ⠀  ⡀⠀⠀⠀⠀⠀'
echo '          ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⠶⠀⠀⠀⠀⠀⣈⣿⣦⠀⠀⠀⠀'
echo '          ⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⣿⡿⠋⠀⠀⠀⠀⠀⠹⣿⣿⡆⠀⠀⠀'
echo '          ⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⣿⣤⣤⣴⣤⣤⣄⠀⢠⣿⣿⠇⠀⠀⠀'
echo '          ⠀⠀⠀⠀⠀⠀⠀⠀⢸⡿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠀⠀⠀⠀'
echo '          ⠀⠀⠀⠀⠀⠀⠀⠀⣾⠋⠈⢻⣿⡝⠁⠀⢻⣿⣿⠋⠀⠀⠀⠀⠀'
echo '          ⠀⠀⠀⠀⠀⠀⠀⠈⣿⣄⣠⣿⣿⣧⣀⣠⣿⣿⣿⠀⠀⠀⠀⠀⠀'
echo '          ⠀⠀⠀⠀⠀⠀⠀⠀⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠀⠀⠀⠀⠀⠀'
echo '          ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⣿⣿⣿⣿⣿⣿⡿⠟⠀⣀⠀⠀⠀⠀⠀'
echo '          ⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⣿⣿⣿⣿⣷⡾⠿⠛⠀⠀⠀⠀⠀'
echo '          ⠀⠀⠀⠀⠀⢀⣠⣴⣿⣿⣿⣿⣿⣿⣿⣿⡿⠓⠀⠀⠀⠀⠀⠀⠀'
echo '          ⠀⠀⢀⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⣀⡀⠀⠀⠀⠀⠀'
echo '          ⠀⣰⡟⠉⣼⣿⠟⣡⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣤⡀⠀'
echo '          ⢠⣿⠀⠀⣿⣿⣾⠿⠛⣿⣿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡛⠻⠑⡀'
echo '          ⠈⣿⠀⡼⢿⡏⠀⠀⠀⠹⣿⡆⠉⠻⣿⣿⣿⣿⣿⡻⢿⣿⠷⠞⠁'
echo '          ⠀⢸⠇⠀⠈⡇⠀⠀⠀⠀⠘⢿⡄⠀⠸⡏⠀⠀⠉⡇⠀⠹⢦⡄⠀'
echo '          ⠀⠀⠀⠀⠈⠁⠀⠀⠀⠀⠀⠸⠁⠀⠀⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀'
echo ''
fi
