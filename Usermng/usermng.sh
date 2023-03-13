#!/bin/bash

crearUsuario(){
        sudo useradd -m -s /bin/bash $1
        (echo $2; echo $2) | sudo passwd $2 > /dev/null 2>&1
        sudo touch /var/spool/mail/$1
        sudo chown $1:mail /var/spool/mail/$1
        sudo chmod 660 /var/spool/mail/$1
	echo "Se ha creado el usuario $1 correctamente."
}

modo=$1

if [ $modo = "-man" ]
then
        echo "Para usar el script deberás usar los siguientes argumentos:
	usermng -create <username> <password> --> Crear un usuario.
	usermng -create <username> <password> <grupo1> <grupo2>... --> Crear un usuario y añadirlo a tantos grupos como se pasen por parámetro.
	usermng -add <username> <groupname> --> Añadir el usuario a un grupo.
	usermng -extract <username> <groupname> --> Eliminar al usuario de un grupo
	usermng -delete <username> --> Eliminar un usuario
	usermng -remove <username> --> Eliminar un usuario incluyendo su carpeta de usuario
	usermng -password <username> <password> --> Cambiar la contraseña.
	usermng -lock <username> --> Bloquear un usuario.
	usermng -unlock <username> --> Desbloquear un usuario."

elif [ $modo = "-create" ]
then
	crearUsuario $2 $3
	if [[ $# -gt 3 ]]
	then
	usuario=$2
		while [ "$*" ]
		do
			let CONTADOR=$CONTADOR+1
			if [[ $CONTADOR -gt 3 ]]
			then
				sudo adduser $usuario $1
			fi
		shift
		done	
	fi
	echo "El usuario $2 se ha creado."
elif [ $modo = "-add" ]
then
	sudo adduser $2 $3
	echo "El usuario $2 se ha añadido al grupo $3"
elif [ $modo = "-extract" ]
then
	sudo deluser $2 $3
	echo "El usuario $2 se ha eliminado del grupo $3"
elif [ $modo = "-delete" ]
then
        sudo userdel $2
	echo "El usuario $2 se ha eliminado."
elif [ $modo = "-remove" ]
then
	sudo userdel -r $2
	echo "El usuario $2 se ha eliminado junto a sus directorios."
elif [ $modo = "-password" ]
then
	(echo $3; echo $3) | sudo passwd $2 > /dev/null 2>&1
	echo "Contraseña de $2 ha sido actualizada."
elif [ $modo = "-lock" ]
then
	sudo usermod -L $2
	echo "El usuario $2 se ha bloqueado."
elif [ $modo = "-unlock" ]
then
	sudo usermod -U $2
	echo "El usuario $2 se ha desbloqueado."
elif [ $modo = "-copy" ]
then
	echo "Copiando el usuario $2 como usuario $3."
	crearUsuario $3 $4
	groups=$(groups $2 | cut -d' ' -f 3-)
	echo "Añadiendo a $3 a los grupos de $2."
	for group in $groups
	do
		sudo adduser $3 $group
	done
	echo "El proceso de copia ha terminado."
elif [ $modo = "-install" ]
then
	if [ -e /usr/local/bin/usermng ]
	then
		echo "Usermng ya está instalado en el sistema."
	else
	        mv usermng.sh usermng
        	sudo cp usermng /usr/local/bin
        	sudo chmod +x /usr/local/bin/usermng
		echo "Usermng se ha instalado correctamente en el sistema."
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
else
	echo "$modo no es reconocido por el sistema"
fi
