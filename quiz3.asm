


#Suponer que la direccion de la base A del array esta en $a0

#primero construimos la direccion del i-esimo elemento del array A[i]=A+i*4

.data
	array: .asciiz "23477682"


.text




la $a0, array	#primero construimos la direccion del i-esimo elemento del array A[i]=A+i*4
		#Se supone que la base del array esta en $a0
add $t0, $0, $0 #este va a ser el elemento i=0 del array

funcion:
	sll $t1, $t0, 2 # guardo i*4 en $t1
	add $t1, $t1, $a0 #i-esimo elemento A[i]=A+i*4 guardado en $t1
	lw $t2, 0($t1)#leo la direccion del i-esimo elemento en $t2
	
	beq $t2, $0, end #si lee un NULL entonces termine el programa. Si no, entonces siga.
	andi $t3, $t2, 0x00000001 #mascara AND para forzar ceros en los bits de $t2 excepto en el LSB que intacto. Si LSB = 1, A[i] es impar; si LSB = 0, A[i] es par
	sltiu $t4, $t3, 1 #$t4 = 1 si $t3 < 1; caso contrario $t4 = 0
	bne $t4, $0, par
	
	#si la palabra es impar:
	sub $t2, $t2, 1 #le resto 1 a la palabra por ser impar
	sw $t2, 0($t1) #guarde el resultado en la direccion de memoria
	
	add $t0, $t0, 1 #aumento el contador de i en 1 cada vez que pase por aca para leer la siguiente palabra cuando salte a 'funcion'
	add $v1, $v1, 1 #aumente $v1 en 1 dado a que una palabra impar fue identificada
	j funcion
	
	par: #si la palabra es par
	add $t2, $t2, 1 #le sumo 1 a la palabra por ser par
	sw $t2, 0($t1) #guarde este resultado en la direccion 0($t1)
	add $t0, $t0, 1 #aumente i en 1 para leer la siguiente palabra
	add $v0, $v0, 1 #aumente la salida $v0 en 1 cada vez que una palabra sea par
	j funcion

	end:
		#cuando se lee un NULL caiga aca y termine
 