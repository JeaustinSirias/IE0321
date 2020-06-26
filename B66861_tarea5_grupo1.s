				#UNIVERSIDAD DE COSTA RICA
				#ESTRUCTURAS DE COMPURADORAS DIGITALES I
				#ESTUDIANTE: JEAUSTIN SIRIAS CHACON, CARNE B66861
				#TAREA #5 - I SEMESTRE 2020
				
#A continuacion se implementa un programa que calcula LA DIVISION de dos numeros enteros sin signo usando el algoritmo de desplazamiento optimizado visto en el curso
#Hay una funcion MAIN que hace llamadas a otras dos funciones	
	
#METODOS DE LECTURA EMPLEADOS	
.data 
	inicio: .asciiz "\n \nHola! Soy JEAUSTIN SIRIAS. Bienvenido a mi calculadora de DIVISIONES con numeros enteros!"
	input_MPDO: .asciiz "\nDigite el valor numerico del dividendo:"
	input_MPDR: .asciiz "\nDigite el valor numerico del divisor:"
	PrintResultH: .asciiz "\nLa parte alta del resultado es: "
	PrintResultL: .asciiz "\nLa parte baja del resultado es: "

#NOMENCLATURA
		# DVSR = DIVISOR
		# DVDO = DIVIDENDO
		
#*******************************************************************************************************************************	
.text
	main:
		li $v0, 4	
		la $a0,inicio		#Empiezo haciendo una llamada princicipal tipo string para imprimir una bienvenida al programa
        	syscall 
        									
        	jal menu 		#Una funcion encargada del menu de ingreso de DVDO y DVDR al programa 
        	addi $t2, $0, 0		#Habilito el registro $t0 para almacenar LA PARTE EN ALTO de la operacion
        	add $t4, $0, $0		#ESTE REGISTRO SERA SOLAMENTE UN CONTADOR PARA INDICARLE A 'F_division' que ya hizo 32+1 iteraciones del algoritmo
        	
        	jal F_division		#Una funcion encargargada de ejecutuar LA DIVISION OPTIMIZADA
       
        	li $v0, 4		
        	la $a0, PrintResultH	#Para imprimir un string que anuncia el resultado de la parte ALTA
        	syscall
        
        	li $v0, 36		#El codigo 36 se encarga de imprimir sin signo el resultado
        	move $a0, $t2		#Le entrego a $a0 el resultado de la parte ALTA
        	syscall			#IMPRIME LA PARTE ALTA EN PANTALLA 
        	
        	li $v0, 4		
        	la $a0, PrintResultL	#Para imprimir un string que anuncia el resultado de la parte BAJA
        	syscall

        	li $v0, 36
        	move $a0, $t0		#Le entrego a $a0 el resultado de la parte BAJA	
        	syscall			#IMPRIME LA PARTE ALTA EN PANTALLA 
        	
        	j main			#vuelva a repetir el programa desde el principio
     
#********************************************************************************************************************************

menu:					#ESTA FUNCION ES PARA INTERACTUAR CON EL USUARIO DEL PROGRAMA. INCLUYE ENTRADAS Y SALIDAS.
		li $v0, 4
		la $a0,input_MPDO	#empiezo solicitando un entero para el DIVIDENDO
        	syscall 
        	
        	li $v0, 5 		#habilito un metodo de entrada int para digitar DVDO
        	syscall
        	move $t0, $v0 		#vamos a guardar el DVDO en el registro temporal $t0
        	
        	li $v0, 4
		la $a0,input_MPDR	#luego, solicito al usuario un int para el DVSR
        	syscall 
        	
        	li $v0, 5	 	#Habilito ahora un metodo de entrada para ingresar DVSR
        	syscall
        	move $t1, $v0 		#Vamos a guardar el DVDR en el registro $t1
        
        	jr $ra			#Devuelvame al main y siga ejecutando
#*******************************************************************************************************************************************
			
F_division:  #Esta funcion ejecuta el algoritmo optimizado de la division visto en el curso

		sltiu $s1, $t4, 33			#esto es un contador. Cuando tenga 33 iteraciones entonces termino mi funcion
		beq $s1, $0, fin			
		subu $t2, $t2, $t1			#inicio restandole el DVSR a la parte alta del cociente
		
		slt $s1, $t2, $0			#si la resta es negativa entonces me voy a 'residuo negativo' a restaurar la parte alta 
		beq $s1, 1, residuo_negativo
		
		#SI RESIDUO - DVSR > 0:
		
		#PASO 2: CORRO A LA IZQUIERDA EL RESIDUO										
		sll $t2, $t2, 1				#corro 1 bit a la izquierda la parte alta del residuo		
		srl $s0, $t0, 31			#Tomo el MSb del DVDO y lo paso al LSb 
		or $t2, $t2, $s0			#con una mascara OR pego este MSb del DVDO en el LSb de la parte alta del cociente
		
		sll $t0, $t0, 1				#ahora desplazo 1-BIT a la izquierda el DVDO
		ori $t0, $t0, 1				#plasmo un 1 en el LSb 
		add $t4, $t4, 1				#aumento el contador en 1
		
		j F_division				#vuelvo a iterar
		
		
		#SI RESIDUO - DVSR < 0:	
		
	residuo_negativo:
		addu $t2, $t2, $t1			#RESTAURO EL RESIDUO PORQUE LA RESTA DIO UN NUMERO NEGATIVO		
		sll $t2, $t2, 1				#corro 1 bit a la izquierda la parte alta del residuo	
		srl $s0, $t0, 31			#Tomo el MSb del DVDO y lo paso al LSb 
		or $t2, $t2, $s0			#con una mascara OR pego este MSb del DVDO en el LSb de la parte alta del cociente
		sll $t0, $t0, 1				#ahora desplazo 1-BIT a la izquierda el DVDO
		
		add $t4, $t4, 1				#AUMENTO EL CONTADOR EN 1	
		j F_division				#VUELVO A ITERAR LA FUNCION
				
		fin:	#SI CAIGO ACA SIGNIFICA QUE YA ITERE 32 + 1 VECES
			
			srl $t2, $t2, 1 		#PASO EXTRA EN LA DIVISION: desplazo 1bit a la derecha la parte alta del residuo
			jr $ra				#me devuelvo a mi MAIN	
						
				
				
				