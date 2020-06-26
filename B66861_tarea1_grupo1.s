
				#UNIVERSIDAD DE COSTA RICA
				#ESTRUCTURAS DE COMPURADORAS DIGITALES I
				#ESTUDIANTE: JEAUSTIN SIRIAS CHACON, CARNE B66861
				#TAREA #1 - I SEMESTRE 2020
				
				
#METODOS DE LECTURA EMPLEADOS				
.data
	default: .asciiz "****HOLA me llamo Jeaustin Sirias! Este es un string de prueba para testear el programa****"
	inicio: .asciiz "\n \n DIGITE 1 para ingresar una nueva frase o DIGITE 0 para saltar al menu de opciones usando el string anterior:"
	newstring: .asciiz "\nDIGITE LA FRASE QUE DESEA PROCESAR:"	
	menu2: .asciiz "\n DIGITE 2 para colocar en MAYUSCULA solamente la inicial de cada palabra \n DIGITE 3 para colocar solo la PRIMERA LETRA de la frase, en mayuscula  \n DIGITE 4 para CAMBIAR TODO a mayusculas \n DIGITE 5 para CAMBIAR TODO a minusculas \n DIGITE 6 para introducir una nueva frase \n \n Su opcion a elegir es: "
	digitado: .asciiz "Su eleccion a digitar es:" 
	printed: .ascii "\n El resultado es:"
	#buffer: .space 0x7fff

.text
#***********************************************************************************************************************
	main:
		li $v0, 4
		la $a0,default #INICIO IMPRIMEINDO UN STRING POR DEFERCTO PARA USAR EL PROGRAMA SIN NECESIDAD DE DIGITAR UNO
        	syscall 
        	move $t0, $a0 #Guardo en $t0 la direccion en memoria del string de prueba, por si el usuario decide usarlo
        	
        	jal INICIO #Llamo a la funcion de inicio de ejecucion que contiene el menu de seleccion
        
        	fin:	
        	jal printResult  #Una vez retornado el resultado llame a la funcion printResultado e imprimalo en pantalla
        	
        	     	
#***********************************************************************************************************************


#*********FUNCIONES*************

	INICIO:
	
        	li $v0, 4 
        	la $a0, inicio #Primer MENU: digito 0 para usar la el string de prueba o 1 para digitar uno nuevo
        	syscall
        	
        	li $v0, 5 #Para que salte una interfaz int input para elegir que quiero hacer
        	syscall
        	move $t1, $v0 #almaceno en $t1 el valor entero digitado para tomar desiciones
      
        	slti $t1,$t1,1 #si $t1 < 1 entonces $t1 = 1. Siginifica que el usuario quiere usar el string de prueba
        	bne $t1, $0, menu #Brinque al menu de opciones de manipulacion del string, si $t1 != $0
        repetir:
        	li $v0, 4
        	la $a0, newstring #Caso contrario, la rutina pide digitar un nuevo string al usuario
        	syscall
        
        	li $v0, 8
        	la $a0, default #Estas lineas permiten digitar el nuevo STRING que quiere el usuario
        	li $a1, 0x7fff #asigno un numero grande para no preocuparse por el tamano del string digitado
        	
        	move $t0, $a0 #vuelvo a guardar la direccion en memoria pero del nuevo string en $t0
        	syscall
        
        menu:
      	 	#++++++++++++++++++++++++++++++++++++++++++++
      	 	 #Coloco un puntero de pila para no perder la direccion en memoria del string digitado o el generico
      	 	addi $sp, $sp -4
        	sw $t0, 0($sp)
        	#++++++++++++++++++++++++++++++++++++++++++++
      	   	 
		li, $v0, 4
		la $a0, menu2 #Llamo al menu de opciones para decidir que le quiero hacer al string elegido
		syscall
		
               
		li $v0, 5 # DIGITO LA OPCION QUE ME INTERESA digitando 2, 3, 4, 5 o 6 (para digitar un nuevo string)
        	syscall
        	
        	
        	addi $t2, $0, 6 #guardo en $t2 un 6
        	sltu $t2, $v0, $t2 # si $v0 (valor digitado por el usuario) es >= 6 entonces guarde un 1 en $t2
        	bne $t2, $0, if #si $t2 = 0, entonces el usuario no ha digitado 6. Pase al siguiente bucle
        	j repetir #lleveme a digitar un nuevo strin, si $t2 != 0
        	
#******************************************************************************************

#PARA CONVERTIR DE MAYUSCULAS A MINUSCULAS 

if:			
		addi $t2, $0, 5
        	sltu $t2, $v0, $t2 #si $v0 > 5 entonces guarde $v0 = 0 
        	bne $t2, $0, else
        	If:
        		addi $t3, $0, 'Z' #Guarde una Z para ver si str[i] se esta antes de o en Z
        		lbu $t1, 0($t0) #vaya cargando byte a byte de str[i]
        		beq $t1, $0, fin
        		sltiu $t4, $t1, 'A'		 # se busca que $t1 este despues de A para que $t4 = 0
        		bne $t4, $0, incremento_1	 #si no son iguales brinque a incrementar
        		sltu $t4, $t3, $t1 		#reviso si 'Z' < str[i] para que $t4 = 0
        		bne $t4, $0, incremento_1
        		
        		ori $t1, $t1, 0x20 #aplique la mascara
        		sb $t1, 0($t0)
        		
        	incremento_1:
        		
        		addi $t0, $t0, 1 #aumente en 1 el bucle
     			j If





#********************************************************************************************
   
   #PARA CONVERTIR TODO EL STRING DE MINUSCULAS A MAYUSCULAS	
	else: 	
		addi $t2, $0, 4     
		sltu $t2, $v0, $t2 #proceda solo si el valor digitado por el usuario en $v0 es mayor o igual a 4
		bne $t2, $0, elif
        	bucle_2:
        		addi $t3, $0, 'z' #fije z en $t3 para comparar si el i-esimo termino de str[i] esta en z o antes de z
        		lbu $t1, 0($t0)
        		beq $t1, $0, fin
        		sltiu $t4, $t1, 'a' # se busca que $t1 este despues de a para que $t4 = 0
        		bne $t4, $0, incremento_2 #si no son iguales brinque a incrementar
        		sltu $t4, $t3, $t1 #reviso si 'z' < str[i] para que $t4 = 0
        		bne $t4, $0, incremento_2
        		
        		andi $t1, $t1, 0xDF #aplico una mascara or para cambiar de minuscula a MAYUSCULA
        		sb $t1, 0($t0)
        			
        	incremento_2:
        		
        		addi $t0, $t0, 1 #aumente en 1 el contador i de str[i]
       			j bucle_2
   	

		
#********************************************************************************************

#PARA FIJAR LA PRIMERA LETRA DEL STRING, EN MAYUSCULA Y LAS DEMAS EN MINUSCULA

elif:
		addi $t3, $0, 'z' 
		addi $t2, $0, 3 #proceda solo si el valor digitado por el usuario en $v0 es mayor o igual a 4
		sltu $t2, $v0, $t2
		bne $t2, $0, elif_2 #si brinco a elif_2 significa que el usuario ha digitado una opcion mas chica que 3
		
		bucle_3:
			
			addi $t5, $0, 'Z'
        		lbu $t1, 0($t0)
        		beq $t1, $0, fin	
        		sltiu $t4, $t1,'A'	 #este cumulo inicia leyendo el string hasta encontrar un caracter en mayuscula	
        		bne $t4, $0, eval	 #si no lo encuentra, entonces brinca a eval para ver si es minuscula para hacerlo MAYUSCULA	
        		sltu $t4, $t5, $t1 		
        		bne $t4, $0, eval #brinque a eval si el caracter no es mayuscula
        		j incremento_3	
        				#no agrego mascara porque si el caracter MAYUSCULA quiero mantenerlo asi para que sea el primer elemento
			
		eval:
			beq $t1, $0, fin	#revise si el primer caracter es en minuscula para que lo convierta a MAYUSCULA
			sltiu $t4 $t1, 'a'
			bne $t4, $0, inc
			sltu $t4, $t3, $t1
			bne $t4, $0, inc
			
			andi $t1, $t1, 0xDF #aplico la mascara si es en minuscula
			sb $t1, 0($t0)
			
			j incremento_3 #si es aplique la mascara entonces aumente el contador en 1 y mandeme a minusculas
			
		inc:
			add $t0, $t0, 1
			j bucle_3	
				
		minusculas:	 		#este bloque me va a convertir en minuscula los caracteres alfabeticos restantes por leer a patir del primero del string
			addi $t3, $0, 'Z'
        		lbu $t1, 0($t0)
        		beq $t1, $0, fin #cuando no hallan mas caracteres por leer entonces lleveme a imprimir el resultado a la funcion main
        		sltiu $t4, $t1, 'A'		 
        		bne $t4, $0, incremento_3	 #aumente el contador si el caracter en proceso no es alfabetico o ya es minuscula
        		sltu $t4, $t3, $t1 		
        		bne $t4, $0, incremento_3	#aumentelo en cualquier caso 
        		
        		ori $t1, $t1, 0x20	#aplique la mascara para pasar el caracter a minuscula en caso de ser MAYUSCULA
        		sb $t1, 0($t0) #guardelo
        		
        	incremento_3:
			add $t0, $t0,1
			j minusculas		#repita el bucle hasta acabar el string
					
#********************************************************************************************

#PARA FIJAR LAS INICIALES DE CADA PALABRA DEL STRING EN MAYUSCULA Y el resto en minuscula		
	elif_2:			
			addi $t5, $0, 'Z' #inicio de igual forma cargando el caracter Z 
        		lbu $t1, 0($t0) #cargo caracter por caracter del array 
        
        		beq $t1, $0, fin
        		sltiu $t4, $t1,'A'		 # se busca que $t1 este despues de A para que $t4 = 0
        		bne $t4, $0, evaluacion	 	#si no son iguales brinque a evaluacion
        		sltu $t4, $t5, $t1 		#reviso si 'Z' < str[i] para que $t4 = 0
        		bne $t4, $0, evaluacion
        		j incerp	#si el primer caracter de la palabra es mayuscula entonces brinque a incerp
			
		evaluacion: 		#se brinca aca si el bloque anterior determina que el caracter no esta entre A-Z
			beq $t1, $0, fin
			sltiu $t4 $t1, 'a'
			bne $t4, $0, incremento_4
			sltu $t4, $t3, $t1
			bne $t4, $0, incremento_4
			
			andi $t1, $t1, 0xDF
			j incerp
		
		incerp: #si se brinca aca significa que el primer caracter de la palabra es mayuscula
			sb $t1, 0($t0) #lo guardo
			add $t0, $t0, 1 #aumento en 1 str[i]
			j intermedios #brinco a sta etiqueta para evaluar el resto de caracteres de la palabra 
		incremento_4:
			add $t0, $t0, 1 # si caigo aca implica que he terimado de procesar una palabra del array y voy a buscar una nueva
			j elif_2
		
		intermedios: #refiero a intermedios como los caracteres en una palabra posteriores al primero
		
        		lbu $t1, 0($t0) #leo que tengo en $t0 luego de pasar por la etiqueta incerp
        		beq $t1, $0, fin 
        		sltiu $t4, $t1,'A'		 
        		bne $t4, $0, min 	#evaluo si el caracter intermedio es mayuscula
        		sltu $t4, $t5, $t1 	#si es mayuscula hagalo minuscula	
        		bne $t4, $0, min	#si no es mayuscula brinque a min y evalue si es minuscula
        		
        		ori $t1, $t1, 0x20 #mascara 
        		sb $t1, 0($t0)
        		add $t0, $t0, 1
        		j intermedios #siga repitiendo el bucle hasta que la plabra acabe
        	
        	min:
        		beq $t1, $0, fin #si el bloque intermedios me manda aca es porque quiero ver si tengo minusculas
			sltiu $t4 $t1, 'a'
			bne $t4, $0, incremento_4 #si me manda a incremento_4 siginifa que el caracter no es alfabetico 
			sltu $t4, $t3, $t1	  # esto implica que la palabra ha terminado e inicia la lectura a lo sumo de una nueva
			bne $t4, $0, incremento_4
			
			sb $t1, 0($t0)
			add $t0, $t0, 1
			j intermedios
			
	
		
#********************************************************************************************		
		
		printResult:
        	 	
        	 	li, $v0, 4 #para imprimir strings en pantalla uso el codigo 4
        	 	la $a0, printed #cargue el string en .data con etiueta printed "el resultado es"
        		syscall
        		la $a0, default #numero de caracteres definido
        		
        		lw $t0, 0($sp)	#RESTAURE el regsistro $t0 a como estaba al principio 	
      			addi $sp, $sp, 4 #RESTAURE EL PUNETRO DE PILA
        		
        		move $a0, $t0 #cargueme la direccion en memoria de $t0 en $a0 para poder imprimir el resultado
        		li $v0, 4
        		syscall
        
        	 	j menu # vuelva a imprimirle el menu al usuario
        	
               
       
       
       
        	
        	
       
        	

        
           