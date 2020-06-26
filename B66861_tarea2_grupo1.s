
				#UNIVERSIDAD DE COSTA RICA
				#ESTRUCTURAS DE COMPURADORAS DIGITALES I
				#ESTUDIANTE: JEAUSTIN SIRIAS CHACON, CARNE B66861
				#TAREA #2 - I SEMESTRE 2020
				
#A continuacion se implementa un programa que calcula la combinacion de dos numeros <n> y <k> enteros positivos mediante una funcion recursiva C(n, k)	
#Hay una funcion MAIN que hace llamadas a otras dos funciones	
	
#METODOS DE LECTURA EMPLEADOS	
.data 
	inicio: .asciiz "\n \nHola! Soy JEAUSTIN SIRIAS. Bienvenido a mi calculadora de combinatorias C(n,k)"
	input_n: .asciiz "\nDigite el valor numerico de <n>:"
	input_k: .asciiz "\nDigite el valor numerico de <k>:"
	error_n: .asciiz "\nERROR! El valor digitado para <n> NO puede ser negativo. Intentelo nuevamente"
	error_k: .asciiz "\nERROR! El valor digitado para <k> NO puede negativo. Intentelo nuevamente"
	error_c: .asciiz "\n****El valor digitado para <n> no puede ser menor al valor digitado en <k>. Intentelo nuevamente**** \n"
	PrintResult: .asciiz "\nEl resultado de la funcion C(n, k) para los valores digitados es: "
		
#*******************************************************************************************************************************	
.text
	main:
		li $v0, 4	
		la $a0,inicio		#Empiezo haciendo una llamada princicipal tipo string para imprimir 'inicio'
        	syscall 
        									
        	jal input_c_k  		#Llamo a la funcion que me va a recibir los metodos de entrada para n y k
        	
        	jal Funcion_C		#Apenas tenga n y k, entonces llame a 'Funcion_C' para hacer C(n, k)
        	
        	li $v0, 4		
        	la $a0, PrintResult	#Para imprimir un string que anuncia el resultado de C(n, k) luego de volver de 'Funcion_C'
        	syscall
        
        	li $v0, 1
        	move $a0, $v1		#Entrego mi resultado NUMERICO de C(n, k) en $v1 a $a0 para IMPRIMIRLO EN PANTALLA
        	syscall
        	
        	move $v1, $0		#Como ocupaba $v1 posterior a 'Funcion_C', entonces luego de imprimirlo haga $v1 = 0 para dejarlo como nuevo
        	
        	j main			#vuelva a repetir el programa desde el principio
     
#********************************************************************************************************************************

input_c_k:					#ESTA FUNCION ES PARA INTERACTUAR CON EL USUARIO DEL PROGRAMA. INCLUYE ENTRADAS Y SALIDAS.
		li $v0, 4
		la $a0,input_n			#empiezo solicitando un valor numerico tipo int para <n>
        	syscall 
        	
        	li $v0, 5 			#habilito un metodo de entrada int para digitar <n>
        	syscall
        	move $t0, $v0 			#vamos a guardar <n> en el registro temporal $t0
        	
        	li $v0, 4
		la $a0,input_k			#luego, solicito al usuario un int para <k>
        	syscall 
        	
        	li $v0, 5	 		#Habilito ahora un metodo de entrada para ingresar <k>
        	syscall
        	move $t1, $v0 			#vamos a guardar <k> en el registro temporal $t1
        	
        	#Para los n y k digitados reviso las siguientes excepciones: si n,k < 0; si n < k
        	
        	slt $t2, $t0, $0 		#REVISO N: si n >= 0, entonces $t2 = 0. Si $t2 = 1 significa que n < 0
        	beq $t2, $0, eval_k 		#si n resulta positivo o cero, entonces brinco a 'eval_k' para ver si k < 0
        	li $v0, 4
		la $a0,error_n			#si n < 0 entonces salte un error en pantalla. 
        	syscall 
        			
        	j input_c_k			#Tire al usuario al menu de ingreso para digitar c y k again
        	
        	eval_k:				
        		slt $t2, $t1, $0
        		beq $t2, $0, compare_n_k #Evaluo ahora si k < 0. Si es mayor paso a 'compare_n_k' para ver si n < k
        		li $v0, 4
			la $a0,error_k		#si k < 0 tire un error y pida al usuario volver a digitar c y k
        		syscall 
        		
        		j input_c_k		#para ir a digitar c y k en caso de error en k
        		
        	compare_n_k:			#Comparo si n < k
        		sltu $t2, $t0, $t1
        		beq $t2, $0, return	#si n > k entonce todo en orden le pido a 'return' devolverme al 'main' usando jr $ ra
        		li $v0, 4
			la $a0,error_c		# si n < k entonces tire un error y dirija al usuario a digitar c y k de nuevo.
        		syscall 
        		
        		j input_c_k
        		
        	return:
        		jr $ra
#*******************************************************************************************************************************************

Funcion_C:				#esta sera mi funcion C(n, k) de tipo RECURSIVA *recordar que n = $t0 y k = $t1*
			
       	bne $t1, $0, caso_2 		#Primera condicion de parada: C(n, 0) = 1
    	add $v1, $v1, 1			#El registro $v1 sera quien devuelva el resultado de C(n, k)
       	jr $ra				#si cumple la condicion devuelvame a la funcion que me ha llamado
       	
	caso_2:      	
       		bne $t0, $t1, rec	#Segunda condicion de parada: C(n, n) = 1
       		add $v1, $v1, 1
       		jr $ra
       	
	rec:				#esta sera la recursividad de mi funcion C
				
		addi $sp, $sp, -12
		sw $ra, 8($sp)		
		sw $t0, 4($sp)		#PRIMERO guardamos en la pila los parametros originales de $ra, $v1, n y k		
		sw $t1, 0($sp)
	
		addi $t0, $t0, -1 	#bajamos en 1 el valor de n para referenciar C(n-1, k)
		jal Funcion_C 		#Me llamo a mi mismo ahora con n = n-1

		lw $t0, 4($sp)		#al regresar de la ultima llamada restaure los valores de n y k 
		lw $t1, 0($sp)		
	
		addi $t0, $t0, -1	#Ahora hacemos n = n-1 y k = k-1	
		addi $t1, $t1, -1
	
		jal Funcion_C		#y me vuelvo a llamar a mi mismo para evaluar nuevas condiciones de parada
		
		lw $ra, 8($sp)		#restauro la direccion de la funcion main para poder volver al terminar 
		addi $sp, $sp, 12	#devuelvo la pila a su estado original y como yo lo encontre!
		
		jr $ra			#TERMINO. Ya tengo el valor de C(n, k) en $v1. Me devuelvo a 'main' a imprimirlo!
	
	
        	
        	
        	
        	
        	
        
        	
        	
        	
