#!/bin/bash

##############################################################################
#VARIABLES GLOBALES
##############################################################################

#Resultado es la variable que vamos a usar como pila de datos que servirá a la vez de primer operando y de resultado, permitiendo que todos lo métodos sean iterativos.
resultado=0

##############################################################################
#FUNCIONES
##############################################################################

#SUMA: Lo que hace es sumar el resultado que haya más el primer argumento que se le pase. 
#($resultado -> Primer operando + $1 -> Segundo operando = Resultado -> $resultado)

suma(){
	resultado=$(($resultado + $1))
}

#RESTA: Lo que hace es restar el resultado que haya menos el primer argumento que se le pase. 
#($resultado -> Primer operando +  $1 -> Segundo operando = Resultado -> $resultado)

resta(){
	resultado=$(($resultado - $1))
}

#MULTIPLICAR: Lo que hace es multiplicar el resultado que haya por el primer argumento que se le pase.
#($resultado -> Primer multiplicando * $1 -> Segundo multiplicando = Resultado -> $resultado)

multiplicar(){
	resultado=$(($resultado * $1))
}

#DIVIDIR: Lo que hace es dividir el resultado que haya entre el primer argumento que se le pase.
#($resultado -> Dividendo / $1 -> Divisor = Cociente -> $resultado)

dividir(){
	resultado=$(($resultado / $1))
}

#EXPONENTE: Lo que hace es elevar el resultado al primer argumento que se le pase.
#($resultado -> Base ^ $1 -> Exponente = Resultado -> $resultado)

exponente(){
base=$resultado
exp=$1
if [ $exp -gt 1 ]
then
	exp=$(($exp - 1))	
	while [ $exp -gt 0 ]
	do

		multiplicar $base
		exp=$(($exp - 1))
	
	done
elif [ $exp -eq 0 ]
then
	resultado=1
elif [ $exp -eq 1 ]
then
	resultado=$resultado
else
	resultado=-1
	echo "ERROR: No se pueden introducir exponentes negativos."
fi
}

#RESTO: Lo que hace es dividir el resultado que haya entre el primer argumento que se le pase y guarda el resto.
#($resultado -> Dividendo / $1 -> Divisor = Resto -> $resultado)

resto(){
	while [ $resultado -gt $1 ] || [ $resultado -eq $1 ]
	do
		resultado=$(($resultado - $1))
	done
}

#BINARIO: Lo que hace es convertir a binario cualquier número entero en base decimal que se le pase.
#($resultado -> Número en base 10 = Número en base 2 -> $resultado)

binario(){
cuantosceros=1
bin=0
i=1
cocientes[0]=$resultado

while [ $resultado -gt 0 ]
do
	dividir 2
	cocientes[i]=$resultado
	i=$(($i + 1))	

done

for cociente in ${cocientes[*]}
do
	i=$(($i - 1))
	resultado=$cociente
	resto 2
	bin=$(($bin + $(($resultado * $cuantosceros))))
	cuantosceros=$(($cuantosceros *	10))

done

resultado=$bin
}

#DECIMAL: Lo que hace es convertir a decimal cualquier número en base binaria que se le pase.
#($resultado -> Número en base 2 = Número en base 10 -> $resultado)

decimal(){
bin=$1
decimal=0
i=0

	while [ $bin -gt 0 ]
	do
	
	resultado=$bin
	resto 10

	if [[ $resultado -eq 1 ]]
	then
		resultadoparcial=$resultado
		resultado=2
		exponente $i
		decimal=$(($decimal + $(($resultadoparcial * $resultado))))
	
	fi
	resultado=$bin
	dividir 10
	bin=$resultado
	i=$(($i + 1))
	done
resultado=$decimal
}

##############################################################################
#LÍNEA PRINCIPAL DE CÓDIGO
##############################################################################

#DESCRIPTOR NO INTERACTIVO: Esta parte del programa lo que hace es leer los argumentos que se le pasan cuando se pone -i como segundo argumento.

if [[ $2 == '-i' ]]
then
	operandos=$@
	resultado=$(($resultado + $3))
	i=0
	for operando in $operandos
	do

#Descriptor para las funciones no iterativas

		if [ $i -eq 2 ]
		then
			if [[ $1 == '-b' ]]
			then
				binario $3
			fi

			if [[ $1 == '-l' ]]
			then
				decimal $3
			fi
		fi

#Descriptor para las funciones iterativas

		if [ $i -gt 2 ]
		then
			if [[ $1 == '-s' ]]
			then
				suma $operando

			elif [[ $1 == '-r' ]]
			then 
				resta $operando
		
			elif [[ $1 == '-m' ]]
			then
				multiplicar $operando
		
			elif [[ $1 == '-d' ]]
			then
				dividir $operando

			elif [[ $1 == '-e' ]]
			then
				exponente $operando

			elif [[ $1 == '-o' ]]
			then
				resto $operando	
			fi
		fi
		i=$(($i + 1))
	done
echo $resultado

#DESCRIPTOR INTERACTIVO: Esta parte del programa permite al usuario usar el programa con una interfaz haciendo uso del read.

else

	if [[ $1 == '-s' ]]
	then
		read -p 'introduce el primer valor: ' operando1
		resultado=$(($resultado + $operando1))
		read -p 'introduce el segundo valor: ' operando2
		suma $operando2

	elif [[ $1 == '-r' ]]
	then
		read -p 'introduce el primer valor: ' operando1
		resultado=$(($resultado + $operando1))
		read -p 'introduce el segundo valor: ' operando2
		resta $operando2
	
	elif [[ $1 == '-m' ]]
	then
		read -p 'introduce el factor multiplicando: ' operando1
		resultado=$(($resultado + $operando1))
		read -p 'introduce el factor multiplicador: ' operando2
		multiplicar $operando2

	elif [[ $1 == '-d' ]]
	then
		read -p 'introduce el dividendo: ' operando1
		resultado=$(($resultado + $operando1))
		read -p 'introduce el divisor: ' operando2
		dividir $operando2
	
	elif [[ $1 == '-e' ]]
	then
		read -p 'introduce la base: ' operando1
		resultado=$(($resultado + $operando1))
		read -p 'introduce la potencia: ' operando2
		exponente $operando2

	elif [[ $1 == '-o' ]]
	then
		read -p 'introduce el dividendo: ' operando1
		resultado=$(($resultado + $operando1))
		read -p 'introduce el divisor: ' operando2
		resto $operando2
	
	elif [[ $1 == '-b' ]]
	then
		read -p 'introduce el valor en decimal: ' operando
		resultado=$(($resultado + $operando))
		binario $operando
	
	elif [[ $1 == '-l' ]]
	then
		read -p 'introduce el valor en binario: ' operando
		resultado=$(($resultado + $operando))
		decimal $operando
	
	else
		echo "ERROR: No se ha podido reconcer la operación que desea realizar"
	
	fi
	echo $resultado
fi
