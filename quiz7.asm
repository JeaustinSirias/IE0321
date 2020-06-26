

#UNIVERSIDAD DE COSTA RICA
#ESTRUCTURAS DE COMPUTADORES DIGITALES, GRUPO #01
#ESTUDIANTE: JEAUSTIN SIRIAS CHACON, B66861
#QUIZ #7



#se asumen dos numeros enteros con signo en los registros $a0 y $a1. Hay que hacer una funcion que los sume
#debo corroborar si la suma es valida o no. Revisar si hay desbordamiento.



funcion_suma:
		addu $t0, $a0, $a1 		#Elaboro la suma de ambos numeros. Uso addu para no generar excepciones
		
		xor $t1, $a0, $a1 		#uso un xor para verificar el signo. Si $a0 y $a1 son de signo opuesto, no hay desborde
		slt $t1, $t1, $0 		#Si $t3 < 0, entonces el MSB de de $t3 es 1. Asigne un
		bne $t1, $0, sin_desborde 	#Si $t3=1, significa que $t3 < 0 y que no hay desborde. Brinque a 'sin_desborde'
		
		#Si caemos de aqui en adelante, significa que $a0 y $a1 tienen el mismo signo
		
		xor $t2, $t0, $a0 		#Reviso los signos del resultado $t0 y uno de los sumandos tienen diferente signo
				  		#Si tienen diferente signo implica que hay desborde porque posit + posit = posit
		slt $t2, $t2, $0  		#$t2 = 1, si los signos del resultado $t0 y $a0 son distintos 
		bne $t2, $0, desborde	
			
	sin_desborde: #el numero es VALID0
			move $v0, $t0		#guardo el resultado en $v0 y pongo un cero en $v1
			add $v1, $0, $0
			
			jr $ra			#TERMINO LA FUNCION Y ME DEVUELVO DE DONDE ME LLAMARON
	
	desborde: #el numero es INVALIDO
			move $v0, $t0		#guardo el resultado en $v0 y pongo un -1 en $v1
			addi $v1, $0, -1
			
			jr $ra			#TERMINO LA FUNCION Y ME DEVUELVO DE DONDE ME LLAMARON
	
	
		
			


