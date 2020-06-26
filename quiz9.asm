
#UNIVERSIDAD DE COSTA RICA
#ESTRUCTURAS DE COMPUTADORES DIGITALES I, GRUPO #01
#ESTUDIANTE: JEAUSTIN SIRIAS CHACON, B66861
#QUIZ #9
#I SEMESTRE DE 2020

#FUNCION CONVERTUDORA DE CELCIUS A FARENHEINT Y VICEVERSA
#suponer que en $a0 tengo una temperatura: si $a1 = 0 vamos de celcius a farenheint. Si $a1 = 1, viceversa.

funcion:
	addi $t1, $0, 5		#guardo el numero 5 en $t1 para hacer las operaciones de conversion
	addi $t2, $0, 9		#guardo el numero 9 en $t2 para hacer las operaciones de conversion
	bne $a1, $0, F_to_C	#si $a1 = 0, pasamos de CELCIUS A FARENHEINT. Si no, vayase a 'F_to_C'
	
	#DE CELCIUS A FARENHEINT
	
	subi $t0, $a0, 32	#le resto 32 a la temperatura ingresada	
	mult $t0, $t1		#multiplico el resultado anterior por 5
	
	mflo $t0		#guardo solo su parte entera asumiendo que en $a0 hay un entero con signo
	
	div $t0, $t2		#divido el resultado anterior entre 9
	
	mflo $v0		#guardo la parte entera del resultado final en $v0
	mfhi $v1		#guardo el residuo del resultado en $v1
	
	j fin			#vayase a 'fin' y termine la funcion
	
	#DE FARENHEINT A CELCIUS
	
	F_to_C:
		mult $a0, $t2	#multiplico la temperatura en $a0 por 9
		
		mflo $t0	#guardo solo su parte entera asumiendo que en $a0 hay un entero con signo
		
		div $t0, $t1	#Divido el resultado anterior entre 5
		mflo $v0	#guardo la parte entera del resultado final en $v0
		mfhi $v1	#guardo el residuo del resultado en $v1
		
		addi $v0, $v0, 32 #Le sumo 32 a la parte entera y termina la conversion 	

	fin:
		
	jr $ra			#vayase a la funcion que me llamo al principio.
	
	
	
	