
#UNIVERSIDAD DE COSTA RICA
#ESTRUCTURAS DE COMPUTADORES DIGITALES I, GRUPO #01
#ESTUDIANTE: JEAUSTIN SIRIAS CHACON, B66861
#QUIZ #8
#I SEMESTRE DE 2020


.text
funcion_volumen:
		#Suponemos que en $a0 y $a1 esta el area basal Ab y la altura h de la piramide, respectivamente
		
		addi $t0, $0, 3 	#guardo un 3 en $t0 para ejecutar la division de la formula geometrica
		
		multu $a0, $a1		#hago el producto entre Ab y h
		
		mflo $t1		#guardo la parte entera en $t1
		mfhi $t2		#se supone que no hay residuo pues se asume que es un producto de enteros positivos. No se han estudiado floats en el curso.
		
		divu $t1, $t0		#hago la division del producto en $t1 y 3
		
		mflo $v0 		#guarde la parte entera del volumen en $v0 
		mfhi $v1		#guarde el residuo del volumen en $v1
		
		jr $ra			#me devuelvo a la funcion que me llamo
		
		
		
		
		

