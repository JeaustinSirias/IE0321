				#UNIVERSIDAD DE COSTA RICA
				#ESTRUCTURAS DE COMPURADORAS DIGITALES I
				#ESTUDIANTE: JEAUSTIN SIRIAS CHACON, CARNE B66861
				#TAREA #4 - I SEMESTRE 2020
				
#A continuacion se implementa un programa que calcula el producto de dos numeros enteros sin signo usando el algoritmo de desplazamiento optimizado visto en el curso
#Hay una funcion MAIN que hace llamadas a otras dos funciones	
	
#METODOS DE LECTURA EMPLEADOS	
.data 
	inicio: .asciiz "\n \nHola! Soy JEAUSTIN SIRIAS. Bienvenido a mi calculadora de multiplicaciones con numeros enteros!"
	input_MPDO: .asciiz "\nDigite el valor numerico del multiplicando:"
	input_MPDR: .asciiz "\nDigite el valor numerico del multiplicador:"
	PrintResultH: .asciiz "\nLa parte alta del resultado es: "
	PrintResultL: .asciiz "\nLa parte baja del resultado es: "

#NOMENCLATURA
		# MPDR = MULTIPLICADOR
		# MPDO = MULTIPLICANDO
		
#*******************************************************************************************************************************	
.text
	main:
		li $v0, 4	
		la $a0,inicio		#Empiezo haciendo una llamada princicipal tipo string para imprimir una bienvenida al programa
        	syscall 
        									
        	jal menu 		#Una funcion encargada del menu de ingreso de MPDO y MPDR al programa 
        	addi $t2, $0, 0		#Habilito el registro $t0 para almacenar LA PARTE EN ALTO de la operacion
        	add $t4, $0, $0		#ESTE REGISTRO SERA SOLAMENTE UN CONTADOR PARA INDICARLE A 'F_multiplicacion' que ya hizo 32 iteraciones del algoritmo
        	
        	jal F_multiplicacion	#Una funcion encargargada de ejecutuar el producto 
       
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
        	move $a0, $t1		#Le entrego a $a0 el resultado de la parte BAJA	
        	syscall			#IMPRIME LA PARTE ALTA EN PANTALLA 
        	
        	j main			#vuelva a repetir el programa desde el principio
     
#********************************************************************************************************************************

menu:					#ESTA FUNCION ES PARA INTERACTUAR CON EL USUARIO DEL PROGRAMA. INCLUYE ENTRADAS Y SALIDAS.
		li $v0, 4
		la $a0,input_MPDO	#empiezo solicitando un entero para el MULTIPLICANDO
        	syscall 
        	
        	li $v0, 5 		#habilito un metodo de entrada int para digitar MPDO
        	syscall
        	move $t0, $v0 		#vamos a guardar el MPDO en el registro temporal $t0
        	
        	li $v0, 4
		la $a0,input_MPDR	#luego, solicito al usuario un int para el MPDR
        	syscall 
        	
        	li $v0, 5	 	#Habilito ahora un metodo de entrada para ingresar MPDR
        	syscall
        	move $t1, $v0 		#Vamos a guardar el MPDR en el registro $t1
        
        	jr $ra			#Devuelvame al main y siga ejecutando
#*******************************************************************************************************************************************
			
F_multiplicacion:			#Esta funcion ejecuta el algoritmo optimizado visto en el curso, de forma iterativa

		sltiu $t5, $t4, 32	#Esta linea me asiga $t5 = 0 si ya se cumplieron las 32 iteraciones para 32-bit
		beq $t5, $0, fin	#Si $t5 = 0, vayase a 'fin' y termine la funcion
		
		#PASO #0:			
		andi $t3, $t1, 0x0001	#Uso un AND y una mascara para conservar solo el LSb del MPDR
		beq $t3, $0, paso_1	#Si $t3 = 1, entonces sumo el MPDO a la PARTE ALTA: $t0 + $t2. Si $t3 = 0, entonces el LSb del MPDR = 0 y brinco a 'paso_1'
			
		addu $s0, $t2, $t0	#Como el LSb del MPDR es 1, entonces le sumo el MPDO a la PARTE ALTA
			
		nor $s1, $t2, $0	#Reviso si la suma me genera un acarreo 
		sltu $s1, $s1, $t0	#Si $s1 = 1, entonces hay acarreo. Si $s1 = 0 no hay acarreo
			
		sll $s1, $s1, 31	#En cualquier caso anterior, pase el LSb de $s1 al MSb. Este registro lo usaremos en el PASO #4.
			
		move $t2, $s0		#Guarde la suma de la PARTE ALTA + MPDO en $t2
		
		#PASO #1:	
		paso_1:			
			srl $t1, $t1, 1 	#Desplazo el MPDR 1 byte a la derecha --->
			
			#PASO #2: 		#Muevo el LSb de la parte ALTA al MSb del MDPR	
			sll $v0, $t2, 31	#Desplazo el LSb de la parte ALTA al MSb y lo almaceno en $v0
			or $t1, $t1, $v0	#con una OR plasmo el registro anterior sobre el MPDR para cambiar solo el MSb.
			
			#PASO #3:	
			srl $t2, $t2, 1 	#Desplazo ahora en la PARTE ALTA, un bit a la derecha ---->
			
			#PASO#4:		#Luego del paso anterior, el MSb de la PARTE ALTA siempre será 0 en este punto
			or $t2, $t2, $s1	#uso ahora una OR para poner el ACARREO del PASO #0 en el MSb de la PARTE ALTA
			add $t4, $t4, 1		#Aumento el contador en 1
				
			j F_multiplicacion	#Repito el loop en la funcion hasta $t4 = 32
			
			fin:
				jr $ra		#Me devuelvo al 'main' para imprimir el resultado.
				
				
				
				
				
			







