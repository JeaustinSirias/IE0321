				#UNIVERSIDAD DE COSTA RICA
				#ESTRUCTURAS DE COMPURADORAS DIGITALES I
				#ESTUDIANTE: JEAUSTIN SIRIAS CHACON, CARNE B66861
				#TAREA #3 - I SEMESTRE 2020
				
#Resumen: Se elabora un corto programa que evalua 3 arrays de palabras distintos y les calcula el promedio
#Se verifica si la suma es tan grande tal que no cabe por acarreos. El numero mas grande en mips es 0x7FFFFFFF	
#Si la suma es valida entonces se calcula el promedio y se imprime en pantalla su parte entera y su residuo, caso contrario se imprime -1 en ambas salidas
						
#METODOS DE ESCRITURA EMPLEADOS:	

.data
	intro: .asciiz "\nEl primer array es:"
	intro2: .asciiz "\n \nEl segundo array es:"
	intro3: .asciiz "\n \nEl tercer array es:"
	error: .asciiz "\nSe ha determinado un acarreo. La suma es muy grande y no es posible calcular el promedio"
	space: .asciiz ","
	
	array1: .word 10, 20, 30, 40, -1
	array2: .word 22, 0x7fffffff, 0x7fffffff -1
	array3: .word 1, 20, 300, 4000, 50000, 600000, 7000000, -1
	
	result_1: .asciiz "\nLa parte entera del promedio es:"
	result_2: .asciiz "\nEl residuo del promedio es:"
	
#***************************************************************************************************************		
.text
	main:				#INCLUYO SOLO LLAMADAS A FUNCIONES
		li $v0, 4	
		la $a0,intro	
        	syscall 
		la $a0, array1 		#load adress: imprimo en pantalla el array 1 usando la funcion 'PrintArray'
		jal PrintArray 		#llamo a print array 
		jal funcion_promedio	#Calculo el promedio de la suma y verifico si es valida o no 
		jal PrintResult		#imprimo el resultado de la parte entera y el residuo
		
		li $v0, 4	
		la $a0,intro2	
        	syscall 
		la $a0, array2 		#load adress: imprimo en pantalla el array 2 usando la funcion 'PrintArray'
		jal PrintArray 		#llamo a print array 
		jal funcion_promedio	#Calculo el promedio de la suma y verifico si es valida o no 
		jal PrintResult		#imprimo el resultado de la parte entera y el residuo
		
		li $v0, 4	
		la $a0,intro3	
        	syscall 
		la $a0, array3		#load adress: imprimo en pantalla el array 3 usando la funcion 'PrintArray'
		jal PrintArray 		#llamo a print array 
		jal funcion_promedio	#Calculo el promedio de la suma y verifico si es valida o no 
		jal PrintResult		#imprimo el resultado de la parte entera y el residuo
		
		li $v0,10		#Termino el programa	
		syscall 
	
#***********************************FUNCIONES****************************************************************************
	PrintArray:
	
		addi $sp, $sp, -16 		#Guardamos primero en la pila los registros importantes
		sw $t0, 0($sp)
		sw $s0, 4($sp)
		sw $t2, 8($sp)
		sw $s1, 12($sp)
		
		addi $t0, $t0, 0 		#defino mi i = 0 para el array de palabras
		move $t1, $a0			#paso a $t1, la direccion del array en $a0
				
		loop:	
			
			sll $t2, $t0, 2 	#Multiplico a i por 4 y lo pongo en $t2
			addu $t2, $t2, $t1	#aqui genero mi array de palabras A[i] = A + i*4
		
			li $v0, 1
			lw $a0, 0($t2)		#cargo en el registro $a0 el elemento actual de la direccion $t2
			syscall			#lo imprimo en pantalla
			
			slt $s1, $a0, $0	#si encuentro un elemento negativo, entonces se ha llegado al final del array
			bne $s1, $0, end	#brinco a 'end' para volver al main y proseguir 
			addi $t0, $t0, 1	#si no, entonces aumento el contador i en 1 para leer el siguiente elemento del array
			
			move $t3, $s0		#estas tres lineas iran almacenando la suma de los elementos del array 
			move $t4, $a0
			addu $s0, $s0, $a0
			
			li $v0, 4		
			la, $a0, space		#separo los elementos del array con una "," mientras los voy imprimiendo
			syscall			#imprimo la coma
			
			j loop			#repito el bucle hasta que se acaben los elementos del array
			
		end:
			jr $ra			#vuelvo al 'main'
				
#***************************************************************************************************************				

	funcion_promedio:
						#primero verificamos en la suma del array hay desborde antes de calcular la media
			nor $t5, $t3, $0	#asumo que los elementos del array son sin signo y hago una not con 0 para complementar el sumando $t3
			sltu $t5, $t5, $t4	#Comparo el complemento de $t3 con el otro sumando $t4. Si $t5 = 1, entonces hay acarreo 
			bne $t5, $0, desborde	#brinco a desborde si hay acarreo porque la suma no cabe
	
			div $s0, $t0		#caso contrario, aplico la division del resultado de la suma guardado en $t0 entre la cantidad de elementos del array en $t0
			mflo $s1		#guardo la parte entera en el registro $s1
			mfhi $v1		#guardo el residuo en $v1
		
			jr $ra			#devuelvame al main
		
		desborde:			#si hay desborde notifiquelo en pantalla e imprima -1 en la parte entera y el residuo
		
			li $v0, 4	
			la $a0, error		#notifique en pantalla que el array analizado tiene elementos muy grandes y se acarrean	
        		syscall 
        	
			addi $t6, $t6, -1
			move $s1, $t6		#Asigno -1 en los registros $s1 y $v1 
			move $v1, $s1
			
			jr $ra			#Termina la funcion. Devuelvame al main

#***************************************************************************************************************				
		
	PrintResult:
						
		li $v0, 4			#Para imprimir strings
		la $a0, result_1	
        	syscall 
        					#IMPRIMO EL RESULTADO DE LA PARTE ENTERA DEL ARRAY
        	li $v0, 1			#Para imprimir ints
        	move $a0, $s1		
        	syscall
		
		li $v0, 4			#Para imprimir strings
		la $a0, result_2	
        	syscall 
        					#IMPRIMO EL RESULTADO DEL RESIDUO DEL ARRAY
        	li $v0, 1			#Para imprimir ints
        	move $a0, $v1		
        	syscall
        	
        	lw $t0, 0($sp)
		lw $s0, 4($sp)
		lw $t2, 8($sp)			#restauro los valores guardados en la pila
		lw $s1, 12($sp)
		addi $sp, $sp, 16		#restauro los espacios usados en la pila.
        	
        	jr $ra				#TERMINA LA FUNCION. Devuelvase al main
		
		
	
			
			
			

			
		
			

		
		
		
		
		
