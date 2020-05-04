print MACRO cadena
	pushear
	MOV AX, @data
	MOV DS, AX
	MOV AH, 09H
	MOV DX, offset cadena
	INT 21H
	poppear
ENDM

getChar MACRO
	MOV AH, 01H
	INT 21H
ENDM

clearScreen MACRO
	MOV AH, 0000H
	MOV AL, 0002H
	INT 10H
ENDM

stringRead MACRO texto
	LOCAL CAPTURAR, SALIR
	pushear
	MOV AH, 1
	XOR SI, SI
	CAPTURAR:
		INT 21H
		CMP AL, 13
		JZ SALIR
		MOV texto[SI], AL
		INC SI
		INC contadorCaracteres
		JMP CAPTURAR
	SALIR:
		poppear
ENDM

stringReadU MACRO texto
	LOCAL CAPTURAR, SALIR
	pushear
	MOV AH, 1
	XOR SI, SI
	CAPTURAR:
		INT 21H
		CMP AL, 13
		JZ SALIR
		MOV texto[SI], AL
		INC SI
		INC contadorCaracteres
		CMP SI, 0006
		JLE CAPTURAR
	SALIR:
		poppear
ENDM

stringReadP MACRO texto
	LOCAL CAPTURAR, SALIR
	pushear
	MOV AH, 1
	XOR SI, SI
	CAPTURAR:
		INT 21H
		CMP AL, 13
		JZ SALIR
		MOV texto[SI], AL
		INC SI
		INC contadorCaracteres
		CMP SI, 0003
		JLE CAPTURAR
	SALIR:
		poppear
ENDM

pushear MACRO 
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	PUSH SI
	PUSH DI
ENDM

poppear MACRO
	POP DI
	POP SI
	POP DX
	POP CX
	POP BX
	POP AX
ENDM

fileCreate MACRO texto, archivo
	pushear
	MOV AX,@data  ;Cargamos el segmento de datos para sacar el nombre del archivo.
	MOV DS, AX
	MOV AH,3CH ;instrucción para crear el archivo.
	MOV CX, 0
	MOV DX, offset archivo ;crea el archivo con el nombre ingresado
	INT 21H

	MOV BX, AX
	MOV AH,3EH ;cierra el archivo
	INT 21H
	fileOnlyReadOpen texto, archivo
	poppear
ENDM

fileOnlyReadOpen MACRO texto, archivo
	pushear
	MOV AH, 3DH
	MOV AL, 01H ; Abrimos en solo lectura
	MOV DX, offset archivo
	INT 21H
	fileWrite texto
	poppear
ENDM

fileWrite MACRO texto
	pushear
	MOV BX, AX ; mover hadfile
	MOV CX, indexFinal ; numero de caracteres a guardar
	MOV DX, offset texto
	MOV AH, 40H ; escribe la fila 1
	INT 21H

	CMP CX, AX
	MOV AH, 3EH ; cerrar el archivo
	INT 21H
	poppear
ENDM

getTime MACRO bufferFecha
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	PUSH SI
	XOR SI, SI
	XOR BX, BX

	MOV AH, 2AH
	INT 21H

	setNumber bufferFecha, DL
	MOV bufferFecha[SI], 2FH
	INC SI
	setNumber bufferFecha, DH
	MOV bufferFecha[SI], 2FH
	INC SI
	MOV bufferFecha[SI], 31H
	INC SI
	MOV bufferFecha[SI], 39H
	INC SI
	MOV bufferFecha[SI], 20H
	INC SI
	MOV bufferFecha[SI], 20H
	INC SI

	MOV AH, 2CH
	INT 21H
	setNumber bufferFecha, CH
	MOV bufferFecha[SI], 3AH
	INC SI
	setNumber bufferFecha, CL

	POP SI
	POP DX
	POP CX
	POP BX
	POP AX
ENDM

setNumber MACRO bufferFecha, registro
	PUSH AX
	PUSH BX

	XOR AX, AX
	XOR BX, BX
	MOV BL, 0AH
	MOV AL, registro
	DIV BL

	getNumber bufferFecha, AL
	getNumber bufferFecha, AH

	POP BX
	POP AX
ENDM

getNumber MACRO bufferFecha, registro
	LOCAL L0, L1, L2, L3, L4, L5, L6, L7, L8, L9, SALIR
	CMP registro , 00H
	JE L0
	CMP registro , 01H
	JE L1
	CMP registro , 02H
	JE L2
	CMP registro , 03H
	JE L3
	CMP registro , 04H
	JE L4
	CMP registro , 05H
	JE L5
	CMP registro , 06H
	JE L6
	CMP registro , 07H
	JE L7
	CMP registro , 08H
	JE L8
	CMP registro , 09H
	JE L9
	JMP SALIR

	L0:
		MOV bufferFecha[SI],30H 	;0
		INC SI
		JMP SALIR
	L1:
		MOV bufferFecha[SI],31H 	;1
		INC SI
		JMP SALIR
	L2:
		MOV bufferFecha[SI],32H 	;2
		INC SI
		JMP SALIR
	L3:
		MOV bufferFecha[SI],33H 	;3
		INC SI
		JMP SALIR
	L4:
		MOV bufferFecha[SI],34H 	;4
		INC SI
		JMP SALIR
	L5:
		MOV bufferFecha[SI],35H 	;5
		INC SI
		JMP SALIR
	L6:
		MOV bufferFecha[SI],36H 	;6
		INC SI
		JMP SALIR
	L7:
		MOV bufferFecha[SI],37H 	;7
		INC SI
		JMP SALIR
	L8:
		MOV bufferFecha[SI],38H 	;8
		INC SI
		JMP SALIR
	L9:
		MOV bufferFecha[SI],39H 	;9
		INC SI
		JMP SALIR
	SALIR:
ENDM

;Modificar a .ply
comprobarExtension MACRO
	pushear
	XOR SI, SI
	XOR AX, AX
	MOV AL, contadorCaracteres
	MOV SI, AX
	DEC SI
	DEC SI
	DEC SI

	CMP calculadoraNombreArchivo[SI], 0071H ; Ultimo caracter con la letra q
	JNE ERROR_EXTENSION
	CMP calculadoraNombreArchivo[SI - 1], 0072H ; Ultimo - 1 caracter con la letra r
	JNE ERROR_EXTENSION
	CMP calculadoraNombreArchivo[SI - 2 ], 0061H ; Ultimo - 2 caracter con la letra a
	JNE ERROR_EXTENSION
	poppear
ENDM

stringCompare MACRO usuarioIngresado, usuarioExistente	
	LOCAL COMPARAR, IGUAL, DIFERENTE, FIN
	pushear
	XOR SI,SI ; Resetea SI
	COMPARAR:
		MOV BH, usuarioIngresado[SI] ; almacena en BH el caracter en la posicion SI del usuarioIngresado
		MOV BL, usuarioExistente[SI] ; almacena en BL el caracter en la posicion SI del usuarioExistente
		CMP BH, BL ; compara los contenidos de BH y BL
		JNE DIFERENTE ; Son diferentes
		CMP BH, '$' ; Son iguales -> verifica si es fin de cadena
		JE IGUAL ; Es fin de cadena -> son iguales
		INC SI ; incrementa SI
		JMP COMPARAR ; compara el siguiente caracter
	DIFERENTE:
		MOV comparation, 0000 ; comprobacion es negativa
		JMP FIN
	IGUAL:
		MOV comparation, 0001 ; comprobacion es positiva
		JMP FIN
	FIN:
		poppear
ENDM

fileReader MACRO archivo, texto
	pushear
	MOV AH, 3DH ; abre el archivo
   	MOV AL, 0 ; abre para lectura
   	LEA DX, archivo
   	INT 21H ; interrupcion
   	MOV [filehandle], AX ; carga el handler

   	MOV AH, 3FH ; leer
   	LEA DX, texto ; se almacena en texto
   	MOV CX, 9999 ; lee 65 caracteres
   	MOV BX, [filehandle] ; recorre buffer
   	INT 21H ; interrupcion

   	MOV BX, [filehandle]
   	MOV AH, 3EH ; cierra el archivo
   	INT 21H	; interrupcion
	poppear
ENDM

resetTmp MACRO
	MOV tmpUsuario[0000], '$'
	MOV tmpUsuario[0001], '$'
	MOV tmpUsuario[0002], '$'
	MOV tmpUsuario[0003], '$'
	MOV tmpUsuario[0004], '$'
	MOV tmpUsuario[0005], '$'
	MOV tmpUsuario[0006], '$'
	MOV tmpUsuario[0007], '$'

	MOV tmpPassword[0000], '$'
	MOV tmpPassword[0001], '$'
	MOV tmpPassword[0002], '$'
	MOV tmpPassword[0003], '$'
	MOV tmpPassword[0004], '$'
ENDM

resetOriginales MACRO
	MOV datoUsuario[0000], '$'
	MOV datoUsuario[0001], '$'
	MOV datoUsuario[0002], '$'
	MOV datoUsuario[0003], '$'
	MOV datoUsuario[0004], '$'
	MOV datoUsuario[0005], '$'
	MOV datoUsuario[0006], '$'
	MOV datoUsuario[0007], '$'

	MOV datoPassword[0000], '$'
	MOV datoPassword[0001], '$'
	MOV datoPassword[0002], '$'
	MOV datoPassword[0003], '$'
	MOV datoPassword[0004], '$'
ENDM

insertarNuevoUsuario MACRO texto
	LOCAL CICLO1, CICLO2, CICLO3, SALIR1, SALIR2, SALIR3
	pushear

	XOR SI, SI
	CICLO1:
		CMP texto[SI], 36D ; 36 = $
		JE SALIR1
		INC SI
		JMP CICLO1

	SALIR1:
		MOV texto[SI], 10D ; 10 = Salto de linea
		MOV AH, datoUsuario[0000]
		MOV texto[SI + 1], AH
		MOV AH, datoUsuario[0001]
		MOV texto[SI + 2], AH
		MOV AH, datoUsuario[0002]
		MOV texto[SI + 3], AH
		MOV AH, datoUsuario[0003]
		MOV texto[SI + 4], AH
		MOV AH, datoUsuario[0004]
		MOV texto[SI + 5], AH
		MOV AH, datoUsuario[0005]
		MOV texto[SI + 6], AH
		MOV AH, datoUsuario[0006]
		MOV texto[SI + 7], AH

	XOR SI, SI
	CICLO2:
		CMP texto[SI], 36D ; 36 = $
		JE SALIR2
		INC SI
		JMP CICLO2

	SALIR2:
		MOV texto[SI], 59D ; 59 = ;
		MOV AH, datoPassword[0000]
		MOV texto[SI + 1], AH
		MOV AH, datoPassword[0001]
		MOV texto[SI + 2], AH
		MOV AH, datoPassword[0002]
		MOV texto[SI + 3], AH
		MOV AH, datoPassword[0003]
		MOV texto[SI + 4], AH


	XOR SI, SI
	CICLO3:
		CMP texto[SI], 36D ; 36 = $
		JE SALIR3
		INC SI
		JMP CICLO3

	SALIR3:
		MOV indexFinal, SI
		poppear
ENDM

insertarNuevoPuntaje MACRO texto, user, score, time, nivel
	LOCAL CICLO1, CICLO2, CICLO3, SALIR1, SALIR2, SALIR3
	pushear

	XOR SI, SI
	CICLO1:
		CMP texto[SI], 36D ; 36 = $
		JE SALIR1
		INC SI
		JMP CICLO1

	SALIR1:
		MOV texto[SI], 10D ; 10 = Salto de linea
		MOV AH, user[0000]
		MOV texto[SI + 1], AH
		MOV AH, user[0001]
		MOV texto[SI + 2], AH
		MOV AH, user[0002]
		MOV texto[SI + 3], AH
		MOV AH, user[0003]
		MOV texto[SI + 4], AH
		MOV AH, user[0004]
		MOV texto[SI + 5], AH
		MOV AH, user[0005]
		MOV texto[SI + 6], AH
		MOV AH, user[0006]
		MOV texto[SI + 7], AH

	XOR SI, SI
	CICLO2:
		CMP texto[SI], 36D ; 36 = $
		JE SALIR2
		INC SI
		JMP CICLO2

	SALIR2:
		MOV texto[SI], 59D ; 59 = ;
		MOV AH, score[0000]
		ADD AH, 48D
		MOV texto[SI + 1], AH
		MOV AH, score[0001]
		ADD AH, 48D
		MOV texto[SI + 2], AH
		MOV texto[SI + 3], 59D ; 59 = ;
		MOV AH, time[0000]
		ADD AH, 48D
		MOV texto[SI + 4], AH
		MOV AH, time[0001]
		ADD AH, 48D
		MOV texto[SI + 5], AH


	XOR SI, SI
	CICLO3:
		CMP texto[SI], 36D ; 36 = $
		JE SALIR3
		INC SI
		JMP CICLO3

	SALIR3:
		MOV texto[SI], 59D
		MOV AH, nivel
		MOV AH, 48D
		MOV texto[SI + 1], AH

		ADD SI, 0002 
		MOV indexFinal, SI
		poppear
ENDM

dibujarMensaje MACRO mensaje
	LOCAL CICLO, SALIR
	pushear
	XOR SI, SI
	XOR CX, CX

	CICLO:
		;Mover el cursor
			MOV AH, 2
			MOV BH, 0
			MOV DH, 0
			MOV DL, CL
			INT 10H

		;Escribir
			MOV AH, 9
			MOV AL, mensaje[SI]
			MOV BL, 1111B
			MOV BH, 0
			MOV CX, 1
			INT 10H

		INC SI
		MOV CX, SI
		CMP mensaje[SI], 0036D ; 36 = $
		JNE CICLO

	poppear
ENDM

dibujarColumna MACRO posicion, ancho, alto, decena, unidad, color, mensaje
	pushear
	dibujarMensaje mensaje
	obtenerSize decena
	;Area de columna
		MOV AH, 06H
		MOV AL, 0
		MOV BH, colorColumna
		MOV CH, alturaColumna
		MOV CL, posicion
		MOV DH, 20
		MOV DL, ancho
		ADD DL, posicion
		DEC DL
		DEC DL
		INT 10H

	;Area de texto de columna
		;Mover el cursor
			MOV AH, 2
			MOV BH, 0
			MOV DH, 24
			MOV DL, posicion
			INT 10H

		;Escribir
			MOV AH, 9
			MOV AL, decena
			MOV BL, 1111B
			MOV BH, 0
			MOV CX, 1
			INT 10H

		;Mover el cursor
			MOV AH, 2
			MOV BH, 0
			MOV DH, 24
			MOV DL, posicion
			INC DL
			INT 10H

		;Escribir
			MOV AH, 9
			MOV AL, unidad
			MOV BL, 1111B
			MOV BH, 0
			MOV CX, 1
			INT 10H
	poppear
ENDM

insertarTop MACRO resultado, index
	LOCAL CICLO, SALIR
	pushear
	XOR SI, SI
	CICLO:
		CMP punteosJugadoresTopDesOrdenados[SI], 0 ; 36 = $
		JE SALIR
		INC SI
		JMP CICLO

	SALIR:
		XOR AH, AH
		MOV punteosJugadoresTopDesOrdenados[SI], AL
		MOV punteosJugadoresTopOrdenados[SI], AL
		MOV BH, numeroPrueba[0001]
		MOV BL, numeroPrueba[0000]
		MOV unidadJugadoresTop[SI], BH
		MOV decenaJugadoresTop[SI], BL
		MOV CL, index
		MOV indexJugadoresTopDesOrdenados[SI], CL
		MOV indexJugadoresTopOrdenados[SI], CL
	poppear
ENDM

insertarArr MACRO resultado
	LOCAL CICLO, SALIR
	pushear
	XOR SI, SI
	CICLO:
		CMP arr[SI], 0
		JE SALIR
		INC SI
		JMP CICLO

	SALIR:
		XOR AH, AH
		MOV arr[SI + 1], AX
	poppear
ENDM

imprimirPunteo MACRO
	LOCAL CICLO, SALIR
	pushear

	XOR SI, SI
	CICLO:
		CMP punteosJugadoresTopDesOrdenados[SI], 36D ; 36 = $
		JE SALIR
		MOV AL, unidadJugadoresTop[SI]
		MOV AH, decenaJugadoresTop[SI]
		MOV numeroPrueba[0000], AH
		MOV numeroPrueba[0001], AL
		INC SI
		JMP CICLO

	SALIR:
		poppear
ENDM

desOrdenar MACRO
	LOCAL CICLO
	pushear
	XOR SI, SI

	CICLO:
		MOV AH, punteosJugadoresTopDesOrdenados[SI]
		MOV punteosJugadoresTopOrdenados[SI], AH
		MOV AH, indexJugadoresTopDesOrdenados[SI]
		MOV indexJugadoresTopOrdenados[SI], AH
		INC SI
		CMP SI, 98D
		JLE CICLO
	poppear
ENDM

ordenarTop MACRO
	LOCAL N1, N2, N3
	pushear
	XOR SI, SI
	XOR DI, DI

	N3:
		MOV SI, DI
		INC SI
	N2:
		MOV AL, punteosJugadoresTopOrdenados[DI]
		MOV AH, punteosJugadoresTopOrdenados[SI]
		CMP AH, AL
		JBE N1
		MOV punteosJugadoresTopOrdenados[DI], AH
		MOV punteosJugadoresTopOrdenados[SI], AL

		MOV AL, indexJugadoresTopOrdenados[DI]
		MOV AH, indexJugadoresTopOrdenados[SI]
		MOV indexJugadoresTopOrdenados[DI], AH
		MOV indexJugadoresTopOrdenados[SI], AL
	N1:
		INC SI
		CMP SI, 99D
		JNE N2
		INC DI
		CMP DI, 98D
		JNE N3
	repararBurbuja
	poppear
ENDM

repararBurbuja MACRO
	LOCAL CICLO, CAMBIAR, SALIR
	pushear
	XOR SI, SI
	CICLO:
		CMP punteosJugadoresTopOrdenados[SI], 117D
		JE CAMBIAR
		INC SI
		CMP SI, 98D
		JLE CICLO
		JMP SALIR

	CAMBIAR:
		MOV punteosJugadoresTopOrdenados[SI], 36D
		INC SI
		CMP SI, 98D
		JLE CICLO
		JMP SALIR
	SALIR:
		poppear
ENDM

mostrarTop MACRO
	LOCAL CICLO, SALIR, REGRESAR, DIEZ
	pushear
	MOV numeroActual[0037], 0AH
	MOV numeroActual[0038], 0DH
	MOV numeroActual[0039], '$'

	clearScreen
	;MOV AX, 0013H
	;INT 0010H
	;MOV CX, 013EH
	XOR SI, SI
	XOR BX, BX
	print mensajevacio
	print mensajeEncabezadoTop
	print mensajevacio
	CICLO:
		XOR DX, DX
		MOV DL, indexJugadoresTopOrdenados[BX]
		MOV SI, DX
		ADD BL, 49D
		MOV numeroActual[0004], BL
		CMP BL, 58D
		JE DIEZ

	REGRESAR:
		SUB BL, 49D
		MOV DL, unidadJugadoresTop[SI]
		MOV DH, decenaJugadoresTop[SI]
		MOV numeroActual[0026], DH
		MOV numeroActual[0027], DL


		MOV DL, caracterPosicion0[SI]
		CMP DL, 32D ; 32 = Espacio
		JE SALIR
		MOV DH, caracterPosicion1[SI]
		MOV numeroActual[0014], DL
		MOV numeroActual[0015], DH
		MOV DL, caracterPosicion2[SI]
		MOV DH, caracterPosicion3[SI]
		MOV numeroActual[0016], DL
		MOV numeroActual[0017], DH
		MOV DL, caracterPosicion4[SI]
		MOV DH, caracterPosicion5[SI]
		MOV numeroActual[0018], DL
		MOV numeroActual[0019], DH
		MOV DL, caracterPosicion6[SI]
		MOV numeroActual[0020], DL

		MOV DL, caracterPosicion7[SI]
		MOV numeroActual[0036], DL

		print numeroActual
		print mensajevacio
		INC BX
		CMP BX, 0010D
		JL CICLO
		JMP SALIR

	DIEZ:
		MOV CL, 48D
		MOV CH, 49D
		MOV numeroActual[0003], CH
		MOV numeroActual[0004], CL
		JMP REGRESAR

	SALIR:
		poppear
ENDM

buscarNombreUsuario MACRO
	LOCAL CICLO, AGREGAR, S0, S1, S2, S3, S4, S5, S6, CONTINUAR, IGNORAR, NUEVALINEA, SALIR, LVL
	PUSH SI
	PUSH BX
	PUSH AX
	PUSH CX
	XOR SI, SI
	XOR CX, CX
	CICLO:

		XOR CX, CX
		AGREGAR:
			CMP textoUst[SI], 59D ; 59 = ; -> Empieza Score
			JE IGNORAR

			CMP CX, 0000
			JE S0
			CMP CX, 0001
			JE S1
			CMP CX, 0002
			JE S2
			CMP CX, 0003
			JE S3
			CMP CX, 0004
			JE S4
			CMP CX, 0005
			JE S5
			CMP CX, 0006
			JE S6

			S0:
				MOV AL, textoUst[SI]
				MOV caracterPosicion0[BX], AL
				JMP CONTINUAR

			S1:
				MOV AL, textoUst[SI]
				MOV caracterPosicion1[BX], AL
				JMP CONTINUAR

			S2:
				MOV AL, textoUst[SI]
				MOV caracterPosicion2[BX], AL
				JMP CONTINUAR

			S3:
				MOV AL, textoUst[SI]
				MOV caracterPosicion3[BX], AL
				JMP CONTINUAR

			S4:
				MOV AL, textoUst[SI]
				MOV caracterPosicion4[BX], AL
				JMP CONTINUAR

			S5:
				MOV AL, textoUst[SI]
				MOV caracterPosicion5[BX], AL
				JMP CONTINUAR

			S6:
				MOV AL, textoUst[SI]
				MOV caracterPosicion6[BX], AL
				JMP CONTINUAR

			CONTINUAR:
				INC SI
				INC CX
				JMP AGREGAR

		IGNORAR:
			INC SI
			CMP textoUst[SI], 36D ; 36 = Fin
			JE SALIR
			CMP textoUst[SI], 13D ; 13 = Nueva linea
			JE NUEVALINEA
			CMP textoUst[SI], 64D ; 64 = @
			JE LVL
			JMP IGNORAR

		LVL:
			INC SI
			MOV AL, textoUst[SI]
			MOV caracterPosicion7[BX], AL
			JMP IGNORAR


		NUEVALINEA:
			INC BX
			INC SI
			INC SI
			JMP CICLO

	SALIR:
		POP CX
		POP AX
		POP BX
		POP SI
ENDM

comprobarVelocidad MACRO
	LOCAL ERROR, SALIR
	PUSH AX
	XOR AX, AX
	MOV AH, velocidad
	MOV hayError, 0000

	CMP AH, 0048D ; 48 = 0
	JB ERROR
	CMP AH, 0057D ; 57 = 9
	JA ERROR
	JMP SALIR

	ERROR:
		MOV hayError, 0001

	SALIR:
		SUB AH, 48D
		MOV velocidad, AH
		POP AX
ENDM

dibujarPlano MACRO
	LOCAL CICLO
	pushear
	MOV AX, 0013H
	INT 0010H
	MOV CX, 013EH

	XOR BX, BX
	XOR AX, AX
	XOR CX, CX
	XOR DX, DX

	MOV SI, totalUsuarios[0002]
	DEC SI
	MOV AH, inicioColumna[SI]
	MOV DH, sumaColumna[SI]
	MOV AL, anchoColumna[SI]

	XOR SI, SI
	CICLO:
		MOV mandarPosicion, AH
		MOV mandarAncho, AL
		MOV mandarAlto, 0022

		MOV CH, decenaJugadoresTop[SI]
		MOV CL, unidadJugadoresTop[SI]

		MOV mandarDecena, CH
		MOV mandarUnidad, CL


		MOV mandarColor, 0001B

		dibujarColumna mandarPosicion, mandarAncho, mandarAlto, mandarDecena, mandarUnidad, mandarColor, mensajeExtra

		;Area de sonido
		PUSH AX
		MOV AL, mandarDecena
		SUB AL, 48D
		reproducirSonido AL
		delayX
		POP AX

		ADD AH, DH
		INC SI
		CMP SI, totalUsuarios[0002]
		JL CICLO

	poppear
ENDM

burbujaDescendente MACRO tipo, mensaje
	LOCAL N1, N2, N3, ASCENDENTE, DESCENDENTE
	pushear
	XOR SI, SI
	XOR DI, DI

	N3:
		MOV SI, DI
		INC SI
	N2:
		MOV AL, punteosJugadoresTopOrdenados[DI]
		MOV AH, punteosJugadoresTopOrdenados[SI]
		CMP AH, AL
		JBE N1
		MOV punteosJugadoresTopOrdenados[DI], AH
		MOV punteosJugadoresTopOrdenados[SI], AL

		MOV AL, indexJugadoresTopOrdenados[DI]
		MOV AH, indexJugadoresTopOrdenados[SI]
		MOV indexJugadoresTopOrdenados[DI], AH
		MOV indexJugadoresTopOrdenados[SI], AL

		;Area de sonido
		PUSH AX
		MOV AL, decenaJugadoresTop[SI]
		SUB AL, 48D
		reproducirSonido AL
		POP AX

		MOV AH, tipo
		CMP AH, 0000
		JE ASCENDENTE
		JMP DESCENDENTE

	ASCENDENTE:
		PUSH SI
		dibujarAscendente mensaje
		delay
		POP SI
		JMP N1

	DESCENDENTE:
		PUSH SI
		dibujarDescendente mensaje
		delay
		POP SI
		JMP N1

	N1:
		INC SI
		CMP SI, 99D
		JNE N2
		INC DI
		CMP DI, 98D
		JNE N3
	poppear
ENDM

dibujarDescendente MACRO mensaje
	LOCAL CICLO
	pushear
	MOV AX, 0013H
	INT 0010H
	MOV CX, 013EH

	XOR BX, BX
	XOR AX, AX
	XOR CX, CX
	XOR DX, DX

	MOV SI, totalUsuarios[0002]
	DEC SI
	MOV AH, inicioColumna[SI]
	MOV DH, sumaColumna[SI]
	MOV AL, anchoColumna[SI]

	XOR SI, SI
	CICLO:
		MOV mandarPosicion, AH
		MOV mandarAncho, AL
		MOV mandarAlto, 0022

		XOR BX, BX
		MOV BL, indexJugadoresTopOrdenados[SI]

		MOV CH, decenaJugadoresTop[BX]
		MOV CL, unidadJugadoresTop[BX]

		MOV mandarDecena, CH
		MOV mandarUnidad, CL


		MOV mandarColor, 0001B

		dibujarColumna mandarPosicion, mandarAncho, mandarAlto, mandarDecena, mandarUnidad, mandarColor, mensaje

		ADD AH, DH
		INC SI
		CMP SI, totalUsuarios[0002]
		JL CICLO

	poppear
ENDM

dibujarAscendente MACRO mensaje
	LOCAL CICLO
	pushear
	MOV AX, 0013H
	INT 0010H
	MOV CX, 013EH

	XOR BX, BX
	XOR AX, AX
	XOR CX, CX
	XOR DX, DX

	MOV SI, totalUsuarios[0002]
	DEC SI
	MOV AH, inicioColumna[SI]
	MOV DH, sumaColumna[SI]
	MOV AL, anchoColumna[SI]
	MOV DI, SI

	XOR SI, SI
	CICLO:
		MOV mandarPosicion, AH
		MOV mandarAncho, AL
		MOV mandarAlto, 0022

		XOR BX, BX
		MOV BL, indexJugadoresTopOrdenados[DI]

		MOV CH, decenaJugadoresTop[BX]
		MOV CL, unidadJugadoresTop[BX]

		MOV mandarDecena, CH
		MOV mandarUnidad, CL


		MOV mandarColor, 0001B

		dibujarColumna mandarPosicion, mandarAncho, mandarAlto, mandarDecena, mandarUnidad, mandarColor, mensaje
		ADD AH, DH
		INC SI
		DEC DI
		CMP SI, totalUsuarios[0002]
		JL CICLO

	poppear
ENDM

delay MACRO
  LOCAL LOOP1, LOOP2,LOOP3
	pushear
	MOV AH, 10D
	SUB AH, velocidad
	MOV AL, AH
	LOOP1:
    	MOV SI, 4000
		LOOP2:
    		PUSH SI
    		MOV SI, 10
    		LOOP3:
      			DEC SI
      			JNZ LOOP3
    		POP SI  
    		DEC SI
    		JNZ LOOP2
    	DEC AL
		JNZ LOOP1
	MOV AH, contadorCiclos
	INC AH
	MOV contadorCiclos, AH

	poppear
	relojBubble
ENDM

relojBubble MACRO
	LOCAL V0, V1, V2, V3, V4, V5, V6, V7, V8, V9, SALIR
	pushear

	MOV AL, velocidad
	CMP AL, 0000
	JE V0
	CMP AL, 0001
	JE V1
	CMP AL, 0002
	JE V2
	CMP AL, 0003
	JE V3
	CMP AL, 0004
	JE V4
	CMP AL, 0005
	JE V5
	CMP AL, 0006
	JE V6
	CMP AL, 0007
	JE V7
	CMP AL, 0008
	JE V8
	CMP AL, 0009
	JE V9

	V0:
		MOV AL, contadorCiclos
		CMP AL, 0004
		JNE SALIR
		MOV AL, 0000
		MOV contadorCiclos, AL
		aumentarTiempoBubble
		JMP SALIR

	V1:
		MOV AL, contadorCiclos
		CMP AL, 0007
		JNE SALIR
		MOV AL, 0000
		MOV contadorCiclos, AL
		aumentarTiempoBubble
		JMP SALIR

	V2:
		MOV AL, contadorCiclos
		CMP AL, 0004
		JNE SALIR
		MOV AL, 0000
		MOV contadorCiclos, AL
		aumentarTiempoBubble
		JMP SALIR

	V3:
		MOV AL, contadorCiclos
		CMP AL, 0005
		JNE SALIR
		MOV AL, 0000
		MOV contadorCiclos, AL
		aumentarTiempoBubble
		JMP SALIR

	V4:
		MOV AL, contadorCiclos
		CMP AL, 0005
		JNE SALIR
		MOV AL, 0000
		MOV contadorCiclos, AL
		aumentarTiempoBubble
		JMP SALIR

	V5:
		MOV AL, contadorCiclos
		CMP AL, 0006
		JNE SALIR
		MOV AL, 0000
		MOV contadorCiclos, AL
		aumentarTiempoBubble
		JMP SALIR

	V6:
		MOV AL, contadorCiclos
		CMP AL, 0007
		JNE SALIR
		MOV AL, 0000
		MOV contadorCiclos, AL
		aumentarTiempoBubble
		JMP SALIR

	V7:
		MOV AL, contadorCiclos
		CMP AL, 0008
		JNE SALIR
		MOV AL, 0000
		MOV contadorCiclos, AL
		aumentarTiempoBubble
		JMP SALIR

	V8:
		MOV AL, contadorCiclos
		CMP AL, 0011
		JNE SALIR
		MOV AL, 0000
		MOV contadorCiclos, AL
		aumentarTiempoBubble
		JMP SALIR

	V9:
		MOV AL, contadorCiclos
		CMP AL, 0021
		JNE SALIR
		MOV AL, 0000
		MOV contadorCiclos, AL
		aumentarTiempoBubble
		JMP SALIR

	SALIR:
		poppear
ENDM

aumentarTiempoBubble MACRO
	LOCAL DECENA, CENTENA, SALIR
	pushear
	MOV AL, mensajeBubble[0024]
	INC AL
	CMP AL, 58D
	JE DECENA

	MOV mensajeBubble[0024], AL
	JMP SALIR

	DECENA:
		MOV AL, mensajeBubble[0023]
		INC AL
		CMP AL, 54D
		JE  CENTENA

		MOV mensajeBubble[0023], AL
		MOV AL, 48D
		MOV mensajeBubble[0024], AL
		JMP SALIR

	CENTENA:
		MOV AL, mensajeBubble[0021]
		INC AL
		MOV mensajeBubble[0021], AL
		MOV AL, 48D
		MOV mensajeBubble[0023], AL
		MOV mensajeBubble[0024], AL

	
	SALIR:
		poppear
ENDM

delayShell MACRO
  LOCAL LOOP1, LOOP2,LOOP3
	pushear
	MOV AH, 10D
	SUB AH, velocidad
	MOV AL, AH
	LOOP1:
    	MOV SI, 10000
		LOOP2:
    		PUSH SI
    		MOV SI, 10
    		LOOP3:
      			DEC SI
      			JNZ LOOP3
    		POP SI  
    		DEC SI
    		JNZ LOOP2
    	DEC AL
		JNZ LOOP1
	MOV AH, contadorCiclos
	INC AH
	MOV contadorCiclos, AH

	poppear
	relojShell
ENDM

relojShell MACRO
	LOCAL V0, V1, V2, V3, V4, V5, V6, V7, V8, V9, SALIR
	pushear

	MOV AL, velocidad
	CMP AL, 0000
	JE V0
	CMP AL, 0001
	JE V1
	CMP AL, 0002
	JE V2
	CMP AL, 0003
	JE V3
	CMP AL, 0004
	JE V4
	CMP AL, 0005
	JE V5
	CMP AL, 0006
	JE V6
	CMP AL, 0007
	JE V7
	CMP AL, 0008
	JE V8
	CMP AL, 0009
	JE V9

	V0:
		aumentarTiempoShell
		JMP SALIR

	V1:
		MOV AL, contadorCiclos
		CMP AL, 0001
		JNE SALIR
		MOV AL, 0000
		MOV contadorCiclos, AL
		aumentarTiempoShell
		JMP SALIR

	V2:
		MOV AL, contadorCiclos
		CMP AL, 0002
		JNE SALIR
		MOV AL, 0000
		MOV contadorCiclos, AL
		aumentarTiempoShell
		JMP SALIR

	V3:
		MOV AL, contadorCiclos
		CMP AL, 0003
		JNE SALIR
		MOV AL, 0000
		MOV contadorCiclos, AL
		aumentarTiempoShell
		JMP SALIR

	V4:
		MOV AL, contadorCiclos
		CMP AL, 0004
		JNE SALIR
		MOV AL, 0000
		MOV contadorCiclos, AL
		aumentarTiempoShell
		JMP SALIR

	V5:
		MOV AL, contadorCiclos
		CMP AL, 0005
		JNE SALIR
		MOV AL, 0000
		MOV contadorCiclos, AL
		aumentarTiempoShell
		JMP SALIR

	V6:
		MOV AL, contadorCiclos
		CMP AL, 0006
		JNE SALIR
		MOV AL, 0000
		MOV contadorCiclos, AL
		aumentarTiempoShell
		JMP SALIR

	V7:
		MOV AL, contadorCiclos
		CMP AL, 0007
		JNE SALIR
		MOV AL, 0000
		MOV contadorCiclos, AL
		aumentarTiempoShell
		JMP SALIR

	V8:
		MOV AL, contadorCiclos
		CMP AL, 0008
		JNE SALIR
		MOV AL, 0000
		MOV contadorCiclos, AL
		aumentarTiempoShell
		JMP SALIR

	V9:
		MOV AL, contadorCiclos
		CMP AL, 0009
		JNE SALIR
		MOV AL, 0000
		MOV contadorCiclos, AL
		aumentarTiempoShell
		JMP SALIR

	SALIR:
		poppear
ENDM

aumentarTiempoShell MACRO
	LOCAL DECENA, CENTENA, SALIR
	pushear
	MOV AL, mensajeShell[0023]
	INC AL
	CMP AL, 58D
	JE DECENA

	MOV mensajeShell[0023], AL
	JMP SALIR

	DECENA:
		MOV AL, mensajeShell[0022]
		INC AL
		CMP AL, 54D
		JE  CENTENA

		MOV mensajeShell[0022], AL
		MOV AL, 48D
		MOV mensajeShell[0023], AL
		JMP SALIR

	CENTENA:
		MOV AL, mensajeShell[0020]
		INC AL
		MOV mensajeShell[0020], AL
		MOV AL, 48D
		MOV mensajeShell[0022], AL
		MOV mensajeShell[0023], AL

	
	SALIR:
		poppear
ENDM

delayQuick MACRO
  LOCAL LOOP1, LOOP2,LOOP3
	pushear
	MOV AH, 10D
	SUB AH, velocidad
	MOV AL, AH
	LOOP1:
    	MOV SI, 5000
		LOOP2:
    		PUSH SI
    		MOV SI, 10
    		LOOP3:
      			DEC SI
      			JNZ LOOP3
    		POP SI  
    		DEC SI
    		JNZ LOOP2
    	DEC AL
		JNZ LOOP1

	MOV AH, contadorCiclos
	INC AH
	MOV contadorCiclos, AH

	poppear
	relojQuick
ENDM

relojQuick MACRO
	LOCAL V0, V1, V2, V3, V4, V5, V6, V7, V8, V9, SALIR
	pushear

	MOV AL, velocidad
	CMP AL, 0000
	JE V0
	CMP AL, 0001
	JE V1
	CMP AL, 0002
	JE V2
	CMP AL, 0003
	JE V3
	CMP AL, 0004
	JE V4
	CMP AL, 0005
	JE V5
	CMP AL, 0006
	JE V6
	CMP AL, 0007
	JE V7
	CMP AL, 0008
	JE V8
	CMP AL, 0009
	JE V9

	V0:
		MOV AL, contadorCiclos
		CMP AL, 0002
		JNE SALIR
		MOV AL, 0000
		MOV contadorCiclos, AL
		aumentarTiempoQuick
		JMP SALIR

	V1:
		MOV AL, contadorCiclos
		CMP AL, 0003
		JNE SALIR
		MOV AL, 0000
		MOV contadorCiclos, AL
		aumentarTiempoQuick
		JMP SALIR

	V2:
		MOV AL, contadorCiclos
		CMP AL, 0004
		JNE SALIR
		MOV AL, 0000
		MOV contadorCiclos, AL
		aumentarTiempoQuick
		JMP SALIR

	V3:
		MOV AL, contadorCiclos
		CMP AL, 0005
		JNE SALIR
		MOV AL, 0000
		MOV contadorCiclos, AL
		aumentarTiempoQuick
		JMP SALIR

	V4:
		MOV AL, contadorCiclos
		CMP AL, 0005
		JNE SALIR
		MOV AL, 0000
		MOV contadorCiclos, AL
		aumentarTiempoQuick
		JMP SALIR

	V5:
		MOV AL, contadorCiclos
		CMP AL, 0006
		JNE SALIR
		MOV AL, 0000
		MOV contadorCiclos, AL
		aumentarTiempoQuick
		JMP SALIR

	V6:
		MOV AL, contadorCiclos
		CMP AL, 0007
		JNE SALIR
		MOV AL, 0000
		MOV contadorCiclos, AL
		aumentarTiempoQuick
		JMP SALIR

	V7:
		MOV AL, contadorCiclos
		CMP AL, 0008
		JNE SALIR
		MOV AL, 0000
		MOV contadorCiclos, AL
		aumentarTiempoQuick
		JMP SALIR

	V8:
		MOV AL, contadorCiclos
		CMP AL, 0011
		JNE SALIR
		MOV AL, 0000
		MOV contadorCiclos, AL
		aumentarTiempoQuick
		JMP SALIR

	V9:
		MOV AL, contadorCiclos
		CMP AL, 0041
		JNE SALIR
		MOV AL, 0000
		MOV contadorCiclos, AL
		aumentarTiempoQuick
		JMP SALIR

	SALIR:
		poppear
ENDM

aumentarTiempoQuick MACRO
	LOCAL DECENA, CENTENA, SALIR
	pushear
	MOV AL, mensajeQuick[0023]
	INC AL
	CMP AL, 58D
	JE DECENA

	MOV mensajeQuick[0023], AL
	JMP SALIR

	DECENA:
		MOV AL, mensajeQuick[0022]
		INC AL
		CMP AL, 54D
		JE  CENTENA

		MOV mensajeQuick[0022], AL
		MOV AL, 48D
		MOV mensajeQuick[0023], AL
		JMP SALIR

	CENTENA:
		MOV AL, mensajeQuick[0020]
		INC AL
		MOV mensajeQuick[0020], AL
		MOV AL, 48D
		MOV mensajeQuick[0022], AL
		MOV mensajeQuick[0023], AL

	
	SALIR:
		poppear
ENDM

obtenerSize MACRO decena
	LOCAL L0, L1, L2, L3, L4, L5, L6, L7, L8, L9, SALIR
	PUSH AX
	MOV AH, decena

	CMP AH, 48D
	JE L0
	CMP AH, 49D
	JE L1
	CMP AH, 50D
	JE L2
	CMP AH, 51D
	JE L3
	CMP AH, 52D
	JE L4
	CMP AH, 53D
	JE L5
	CMP AH, 54D
	JE L6
	CMP AH, 55D
	JE L7
	CMP AH, 56D
	JE L8
	CMP AH, 57D
	JE L9

	L0:
		MOV AH, 0022
		SUB AH, 0002
		MOV alturaColumna, AH
		MOV colorColumna, 0100B
		JMP SALIR
	L1:
		MOV AH, 0022
		SUB AH, 0004
		MOV alturaColumna, AH
		MOV colorColumna, 0100B
		JMP SALIR
	L2:
		MOV AH, 0022
		SUB AH, 0006
		MOV alturaColumna, AH
		MOV colorColumna, 0001B
		JMP SALIR
	L3:
		MOV AH, 0022
		SUB AH, 0008
		MOV alturaColumna, AH
		MOV colorColumna, 0001B
		JMP SALIR
	L4:
		MOV AH, 0022
		SUB AH, 0010
		MOV alturaColumna, AH
		MOV colorColumna, 1110B
		JMP SALIR
	L5:
		MOV AH, 0022
		SUB AH, 0012
		MOV alturaColumna, AH
		MOV colorColumna, 1110B
		JMP SALIR
	L6:
		MOV AH, 0022
		SUB AH, 0014
		MOV alturaColumna, AH
		MOV colorColumna, 0010B
		JMP SALIR
	L7:
		MOV AH, 0022
		SUB AH, 0016
		MOV alturaColumna, AH
		MOV colorColumna, 0010B
		JMP SALIR
	L8:
		MOV AH, 0022
		SUB AH, 0018
		MOV alturaColumna, AH
		MOV colorColumna, 1111B
		JMP SALIR
	L9:
		MOV AH, 0022
		SUB AH, 0020
		MOV alturaColumna, AH
		MOV colorColumna, 1111B
		JMP SALIR

	SALIR:
		POP AX
ENDM


;void shell_sort (int *a, int n) {
;    int h, i, j, t;
;    for (h = n; h >= 1; h /= 2) {
;        for (i = h; i < n; i++) {
;            t = a[i];
;            for (j = i; j >= h && t < a[j - h]; j -= h) {
;                a[j] = a[j - h];
;            }
;            a[j] = t;
;        }
;    }
;}
ShellSort MACRO	arreglo, n, tipo		; void ShellSort(int *a, int n){
	LOCAL CICLO1, CICLO2, CICLO3, SALIRCICLO1, SALIRCICLO2, SALIRCICLO3, ASCENDENTE, DESCENDENTE, REGRESAR
	pushear
	MOV AX, n
	MOV h, AX
	CICLO1:
		MOV AX, h						;
		CMP AX, 0000					;	for(h = n; h >= 1; h /= 2){
		JE SALIRCICLO1					;
		MOV i, AX
		CICLO2:
			MOV AX, i					;
			CMP AX, n					;
			JE SALIRCICLO2				;		for(i = h; i < n; i++){

			PUSH BX
			PUSH AX
			MOV BX, AX
			MOV AL, arreglo[BX] 
			MOV t, AL					;			t = a[i];
			MOV AL, indexJugadoresTopOrdenados[BX]
			MOV t1, AL
			POP AX
			POP BX

			MOV j, AX					;
			CICLO3:
				MOV AX, j				;
				CMP AX, h				;
				JL SALIRCICLO3			;
				XOR BX, BX				;
				MOV BX, j				;
				SUB BX, h				;			for(j = i; j >= h && t < a[j -h]; j -= h){
				XOR CX, CX				;
				MOV CL, arreglo[BX]		;
				MOV SI, CX				;
				XOR CX, CX				;
				MOV CL, t				;
				CMP CX, SI				;
				JNL SALIRCICLO3			;
				MOV DL, arreglo[BX]		;
				MOV DH, indexJugadoresTopOrdenados[BX]
				PUSH BX
				MOV BX, AX
				MOV arreglo[BX], DL		;				a[j] = a[j - h];

				;Area de sonido
				PUSH AX
				MOV AL, decenaJugadoresTop[BX]
				SUB AL, 48D
				reproducirSonido AL
				POP AX


				MOV indexJugadoresTopOrdenados[BX], DH
				MOV BL, tipo
				CMP BL, 0000
				JE ASCENDENTE
				JMP DESCENDENTE

				ASCENDENTE:
					dibujarAscendente mensajeShell
					JMP REGRESAR
				DESCENDENTE:
					dibujarDescendente mensajeShell
					JMP REGRESAR

			REGRESAR:
				delayShell
				POP BX
				MOV AX, j				;
				SUB AX, h				;
				MOV j, AX				;
				JMP CICLO3				;			}
			SALIRCICLO3:
				MOV AX, j 				;
				PUSH BX
				PUSH AX
				MOV BX, AX
				MOV AL, t
				MOV arreglo[BX], AL		;			a[j] = t;

				;Area de sonido
				PUSH AX
				MOV AL, decenaJugadoresTop[BX]
				SUB AL, 48D
				reproducirSonido AL
				POP AX


				MOV AL, t1
				MOV indexJugadoresTopOrdenados[BX], AL
				POP AX
				POP BX
				MOV AX, i 				;
				INC AX					;
				MOV i, AX				;
				JMP CICLO2				;		}
		SALIRCICLO2:
			MOV AX, h					;
			MOV CL, 0002
			DIV CL						;
			XOR AH, AH					;
			MOV h, AX					;	}
			JMP CICLO1
	SALIRCICLO1:
		poppear							;}
ENDM

obtenerUnidadesDecenas MACRO numero
	pushear
		XOR AX, AX
		XOR BX, BX
		MOV BX, numero
		MOV AL, BL
		MOV CL, 10D
		DIV CL

		ADD AH, 48D
		ADD AL, 48D 

		MOV mandarDecena, AL
		MOV mandarUnidad, AH
	poppear
ENDM

dibujarDescendenteQuick MACRO mensaje
	LOCAL CICLO
	pushear
	MOV AX, 0013H
	INT 0010H
	MOV CX, 013EH

	XOR BX, BX
	XOR AX, AX
	XOR CX, CX
	XOR DX, DX

	MOV SI, totalUsuarios[0002]
	DEC SI
	MOV AH, inicioColumna[SI]
	MOV DH, sumaColumna[SI]
	MOV AL, anchoColumna[SI]

	MOV BX, totalUsuarios[0002]
	ADD BX, BX
	ADD BX, 0002

	XOR SI, SI
	CICLO:
		MOV mandarPosicion, AH
		MOV mandarAncho, AL
		MOV mandarAlto, 0022

		obtenerUnidadesDecenas arr[SI + 1]

		MOV mandarColor, 0001B

		dibujarColumna mandarPosicion, mandarAncho, mandarAlto, mandarDecena, mandarUnidad, mandarColor, mensaje
		ADD AH, DH
		INC SI
		INC SI
		CMP SI, BX
		JL CICLO

	poppear
ENDM

dibujarAscendenteQuick MACRO mensaje
	LOCAL CICLO
	pushear
	MOV AX, 0013H
	INT 0010H
	MOV CX, 013EH

	XOR BX, BX
	XOR AX, AX
	XOR CX, CX
	XOR DX, DX

	MOV SI, totalUsuarios[0002]
	DEC SI
	MOV AH, inicioColumna[SI]
	MOV DH, sumaColumna[SI]
	MOV AL, anchoColumna[SI]
	MOV DI, SI
	ADD DI, DI
	ADD DI, 0002

	XOR SI, SI
	CICLO:
		MOV mandarPosicion, AH
		MOV mandarAncho, AL
		MOV mandarAlto, 0022

		obtenerUnidadesDecenas arr[DI - 1]

		MOV mandarColor, 0001B

		dibujarColumna mandarPosicion, mandarAncho, mandarAlto, mandarDecena, mandarUnidad, mandarColor, mensaje
		ADD AH, DH
		INC SI
		DEC DI
		DEC DI
		CMP SI, totalUsuarios[0002]
		JL CICLO

	poppear
ENDM

reproducirSonido MACRO decena
	LOCAL S1, S3, S5, S7, S9, SALIR
	pushear
	MOV AL, decena
	CMP AL, 0000
	JE S1
	CMP AL, 0001
	JE S1
	CMP AL, 0002
	JE S3
	CMP AL, 0003
	JE S3
	CMP AL, 0004
	JE S5
	CMP AL, 0005
	JE S5
	CMP AL, 0006
	JE S7
	CMP AL, 0007
	JE S7
	CMP AL, 0008
	JE S9
	CMP AL, 0009
	JE S9

	S1:
		MOV AL, 86H
		OUT 43H, AL
		MOV AX, 11931
		JMP SALIR
	S3:
		MOV AL, 86H
		OUT 43H, AL
		MOV AX, 3977
		JMP SALIR
	S5:
		MOV AL, 86H
		OUT 43H, AL
		MOV AX, 2386
		JMP SALIR
	S7:
		MOV AL, 86H
		OUT 43H, AL
		MOV AX, 1704
		JMP SALIR
	S9:
		MOV AL, 86H
		OUT 43H, AL
		MOV AX, 1325
		JMP SALIR

	SALIR:
		OUT 42H, AL
		MOV AL, AH
		OUT 42H, AL
		IN AL, 61H
		OR AL, 00000011B
		OUT 61H, AL
		delaySonido
		IN AL, 61H
		AND AL, 11111100B
		OUT 61H, AL
		poppear
ENDM

delaySonido MACRO
	LOCAL LOOP1, LOOP2,LOOP3
	pushear
	MOV AL, 25D
	LOOP1:
    	MOV SI, 100
		LOOP2:
    		PUSH SI
    		MOV SI, 10
    		LOOP3:
      			DEC SI
      			JNZ LOOP3
    		POP SI  
    		DEC SI
    		JNZ LOOP2
    	DEC AL
		JNZ LOOP1
	poppear
ENDM

delayX MACRO
	LOCAL LOOP1, LOOP2,LOOP3
	pushear
	MOV AL, 25D
	LOOP1:
    	MOV SI, 1000
		LOOP2:
    		PUSH SI
    		MOV SI, 10
    		LOOP3:
      			DEC SI
      			JNZ LOOP3
    		POP SI  
    		DEC SI
    		JNZ LOOP2
    	DEC AL
		JNZ LOOP1
	poppear
ENDM

llamarUsuario MACRO
	LOCAL CICLO, SALIR
	pushear
	XOR SI, SI

	CICLO:
		MOV AL, datoUsuario[SI]
		CMP AL, 36D
		JE SALIR
		MOV mensajeJuego[SI + 0004], AL
		INC SI
		CMP SI, 07
		JL CICLO
	SALIR:
		poppear
ENDM

pintarJuego MACRO color
	LOCAL IZQUIERDA, DERECHA, CICLO, SALIR
	pushear

	CICLO:
		MOV AX, 0013H
		INT 0010H
		MOV CX, 013EH
		dibujarMensaje mensajeJuego
		pintarFondo
		pintarCarro
	
		getChar
		CMP AL, 0075D
		JE IZQUIERDA
		CMP AL, 0080D
		JE DERECHA
		CMP AL, 0032D
		JE SALIR
		JMP CICLO
	
		IZQUIERDA:
			MOV CL, posicionCarro
			DEC CL
			JMP VERIFICARMOV
	
		DERECHA:
			MOV CL, posicionCarro
			INC CL
			JMP VERIFICARMOV
	
		VERIFICARMOV:
			CMP CL, 02
			JB CICLO
			CMP CL, 34
			JA CICLO
			MOV posicionCarro, CL
			pintarFondo
			JMP CICLO

	SALIR:
		poppear
ENDM

pintarFondo MACRO
	pushear
	;Area de fondo
		MOV AH, 06H
		MOV AL, 00
		MOV BH, 0111B
		MOV CH, 02
		MOV CL, 02
		MOV DH, 23
		MOV DL, 36
		INT 10H
	poppear
ENDM

pintarCarro MACRO
	pushear
	;Area de carro
		MOV AH, 06H
		MOV AL, 00
		MOV BH, colorCarro
		MOV CH, 21
		MOV CL, posicionCarro
		MOV DH, 23
		MOV DL, CL
		ADD DL, 02
		INT 10H
	poppear
ENDM
