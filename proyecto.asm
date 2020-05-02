INCLUDE macros.asm ; Incluye el archivo donde se encuentran todos los macros almacenados

.MODEL large ; Utiliza un espacio 'medium' de almacenamiento

;=================
;==AREA DE STACK==
;=================
.STACK 100H
;=================
;==AREA DE STACK==
;=================

;================
;==AREA DE DATA==
;================
.DATA
	;======================
	;==MENSAJES A MOSTRAR==
	;======================
		mensajeEncabezado DB 0AH, 0DH, '	UNIVERSIDAD DE SAN CARLOS DE GUATEMALA', 0AH, 0DH, '	FACULTAD DE INGENIERIA', 0AH, 0DH, '	CIENCIAS Y SISTEMAS', 0AH, 0DH, '	ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1', 0AH, 0DH, '	NOMBRE: ELEAZAR JARED LOPEZ OSUNA', 0AH, 0DH, '	CARNET: 201700893', 0AH, 0DH, '	SECCION: A', '$'
		mensajeMenuUsuario DB 0AH, 0DH, '	Seleccione una opcion', 0AH, 0DH, '	1) Iniciar Juego', 0AH, 0DH, '	2) Cargar Juego', 0AH, 0DH, '	3) Salir', 0AH, 0DH, '	',  '$' ; Menu Usuario
		mensajeMenuIngreso DB 0AH, 0DH, '	Seleccione una opcion', 0AH, 0DH, '	1) Ingresar', 0AH, 0DH, '	2) Registrar', 0AH, 0DH, '	3) Salir', 0AH, 0DH, '	',  '$' ; Menu Ingreso
		mensajeMenuAdmin DB 0AH, 0DH, '	Seleccione una opcion', 0AH, 0DH, '	1) Top 10 Puntos', 0AH, 0DH, '	2) Top 10 Tiempo', 0AH, 0DH, '	3) Salir', 0AH, 0DH, '	',  '$' ; Menu Ingreso
		mensajeIngreseUsuario DB 0AH, 0DH, '	Ingrese un usuario: ', '$'
		mensajeIngresePassword DB 0AH, 0DH, '	Ingrese un password: ', '$'
		mensajeVacio DB 0AH, 0DH, '$'
		mensajeExtra DB '$'
		mensajeVelocidad DB 0AH, 0DH, '	Ingrese una velocidad (0-9)', 0AH, 0DH, '$'
		mensajeSentidoOrdenamiento DB 0AH, 0DH, '	Seleccione una opcion', 0AH, 0DH, '	1) Descendente', 0AH, 0DH, '	2) Ascendente', 0AH, 0DH, '$'
		mensajeEncabezadoTop DB ' posicion     usuario   puntaje   nivel', 0AH, 0DH, '$'
		mensajeOrdenamiento DB 0AH, 0DH, '	Seleccione una opcion', 0AH, 0DH, '	1) BubbleSort', 0AH, 0DH, '	2) QuickSort', 0AH, 0DH, '	3) ShellSort', 0AH, 0DH, '	',  '$' ; Menu Ingreso
		mensajeBubble DB '    BubbleSort - T: 00:00 - V: 0', '$' ; 20,21:23,24 31
		mensajeQuick  DB '    QuickSort - T: 00:00 - V: 0', '$'  ; 19,20:22,23 30
		mensajeShell  DB '    ShellSort - T: 00:00 - V: 0', '$'  ; 19,20:22,23 30
	;======================
	;==MENSAJES A MOSTRAR==
	;======================

	;=====================
	;==MENSAJES DE ERROR==
	;=====================
		errorUsuarioYaExiste DB 0AH, 0DH, '	Error: El usuario ya existe, intente de nuevo', '$'
		errorLoginIncorrecto DB 0AH, 0DH, '	Error: Password o usuario incorrectos', '$'
		errorPassword DB 0AH, 0DH, '	Error: La password debe ser numerica, intente de nuevo', '$'
		errorUsuario DB 0AH, 0DH, '	Error: El usuario debe de ser de maximo 7 caracteres, intente de nuevo', '$'
		errorArchivo DB 0AH, 0DH, '	Error: Hubo un problema al abrir el archivo', '$'
		errorExtension DB 0AH, 0DH, '	Error: Extension recomendada .ply', '$'
		errorVelocidad DB 0AH, 0DH, '	Error: Velocidad no permitida, valida en rango (0-9)', '$'
	;=====================
	;==MENSAJES DE ERROR==
	;=====================

	;===============
	;==DATOS EXTRA==
	;===============
		datoUsuario DB 8 dup('$')
		datoPassword DB 5 dup('$')
		usuarioAdmin DB 'admin', '$'
		comparation DB 0000
		contadorCaracteres DW 0000
		archivoUsuarios DB 'users.us', 0
		archivoPuntajes DB 'score.ust', 0
 		textoUs DB 9999 dup('$')
 		textoUst DB 9999 dup('$')
		filehandle DW ?
 		tmpUsuario DB 8 dup('$')
 		tmpPassword DB 5 dup('$')
 		matchUsuario DB 0000
 		matchPassword DB 0000
 		existeError DB 0001
 		indexFinal DW 0000
 		puntajeFinal DB 0000, 0000 ; Decenas, Unidades
 		tiempoFinal DB 0000, 0000 ; Decenas, Unidades
 		nivelFinal DB 0000

 		indexJugadoresTopOrdenados DB 99 dup('$')

 		indexJugadoresTopDesOrdenados DB 99 dup(0)

 		punteosJugadoresTopDesOrdenados DB 99 dup(0)
 		punteosJugadoresTopOrdenados DB 99 dup(0)


 		caracterPosicion0 DB 99 dup(32D)
 		caracterPosicion1 DB 99 dup(32D)
 		caracterPosicion2 DB 99 dup(32D)
 		caracterPosicion3 DB 99 dup(32D)
 		caracterPosicion4 DB 99 dup(32D)
 		caracterPosicion5 DB 99 dup(32D)
 		caracterPosicion6 DB 99 dup(32D)
 		caracterPosicion7 DB 99 dup(32D)

 		unidadJugadoresTop DB 99 dup('$')
 		decenaJugadoresTop DB 99 dup('$')

 		; Toma como maximo 20 usuarios
 		anchoColumna DB 36, 18, 12, 9, 7, 6, 6, 5, 4, 4, 4, 3, 3, 3, 3, 3, 3, 3, 2, 2
 		inicioColumna DB 2, 2, 3, 3, 3, 2, 0, 0, 2, 0, 3, 2, 1, 0, 5, 4, 3, 2, 1, 0
 		finColumna DB 36, 21, 27, 27, 31, 32, 36, 35, 34, 36, 33, 35, 37, 39, 33, 34, 35, 36, 37, 38
 		sumaColumna DB 30, 19, 12, 8, 7, 6, 6, 5, 4, 4, 3, 3, 3, 3, 2, 2, 2, 2, 2, 2

 		numeroActual DB 40 dup(32D)

 		numeroPrueba DB 0000, 0000, 0AH, 0DH, '$'

 		hayError DB 0000

 		totalUsuarios DW 0AH, 0DH, 0000, '$'

 		velocidad DB 0000

 		mandarPosicion DB 0000, '$'
 		mandarAncho DB 0000
 		mandarAlto DB 0000
 		mandarDecena DB 0000
 		axd DB '$'
 		mandarUnidad DB 0000
 		axd2 DB '$'
 		mandarColor DB 0000

 		alturaColumna DB 0000
 		colorColumna DB 0000

 		contadorCiclos DB 0000


 		arr DW 99 dup(0)
 		ad DW '$'

 		i DW ?
 		j DW ?
 		p DW 0
 		r DW 0
 		q DW ?
 		x DW ?
 		h DW ?

 		t DB ?
 		t1 DB ?

 		tipoQuick DB 0000
 		
	;==DATOS EXTRA==
	;===============


;==================
;==AREA DE CODIGO==
;==================
.CODE 
	
	main  PROC
		;================
		;==MENU INICIAL==
		;================
			MENU:
				clearScreen ; Limpia la pantalla
				print mensajeMenuIngreso ; Muestra el menu
				getChar ; Captura el caracter
				CMP AL, 49D ; caracter == 1
				JE INGRESAR  ; Ingresar
				CMP AL, 50D ; caracter == 2
				JE REGISTRAR ; Registrar
				CMP AL, 51D ; caracter == 3
				JE SALIR  ; Salir
				JMP MENU ; Si el caracter no es un numero entre [1,8] regresa al menu
		;================
		;==MENU INICIAL==
		;================

		;============
		;==INGRESAR==
		;============
			INGRESAR:
				clearScreen ; Limpia la pantalla
				print mensajeIngreseUsuario ; Solicita el usuario
				stringRead  datoUsuario ; Lee el usuario
				print mensajeIngresePassword ; Solicita la contraseña
				stringRead  datoPassword ; Lee la password
				CALL comprobarLogin
				CMP matchUsuario, 0000
				JE ERRORLOGIN

				stringCompare datoUsuario, usuarioAdmin
				CMP comparation, 0001
				JE AREAADMINISTRADOR ; Es administrador
				JMP AREAUSUARIO ; Entra al area

			ERRORLOGIN:
				clearScreen
				print errorLoginIncorrecto
				resetTmp
				resetOriginales
				getChar
				JMP INGRESAR
		;============
		;==INGRESAR==
		;============

		;=================
		;==ADMINISTRADOR==
		;=================
			AREAADMINISTRADOR:
				clearScreen ; Limpia la pantalla
				print mensajeEncabezado
				print mensajeMenuAdmin ; Muestra el menu
				getChar ; Captura el caracter
				CMP AL, 49D ; caracter == 1
				JE TOP10PUNTOS; Ingresar
				CMP AL, 50D ; caracter == 2
				JE TOP10TIEMPO ; Registrar
				CMP AL, 51D ; caracter == 3
				JE MENU  ; Salir
				JMP AREAADMINISTRADOR
		;=================
		;==ADMINISTRADOR==
		;=================

		;=================
		;==TOP 10 PUNTOS==
		;=================
			TOP10PUNTOS:
				fileReader archivoPuntajes, textoUst
				CALL buscarTopPuntos
				buscarNombreUsuario
				ordenarTop
				mostrarTop
				getChar
				CMP AL, 32D ; 32 == Espacio
				JE GRAFICARTOP  ; Ingresar
				JMP AREAADMINISTRADOR
		;=================
		;==TOP 10 PUNTOS==
		;=================

		;=================
		;==TOP 10 TIEMPO==
		;=================
			TOP10TIEMPO:
				fileReader archivoPuntajes, textoUst
				CALL buscarTopTiempo
				buscarNombreUsuario
				ordenarTop
				mostrarTop
				getChar
				CMP AL, 32D ; 32 == Espacio
				JE GRAFICARTOP  ; Ingresar
				JMP AREAADMINISTRADOR
				;dibujarPlano
		;=================
		;==TOP 10 TIEMPO==
		;=================

		;================
		;==GRAFICAR TOP==
		;================
			GRAFICARTOP:
				desOrdenar
				clearScreen
				print mensajeOrdenamiento
				getChar
				CMP AL, 49D ; 49 == 1
				JE BUBBLE
				CMP AL, 50D ; 50 == 2
				JE QUICK
				CMP AL, 51D ; 51 == 3
				JE SHELL
				JMP GRAFICARTOP
		;================
		;==GRAFICAR TOP==
		;================

		;==========
		;==BUBBLE==
		;==========
			BUBBLE:
				clearScreen
				print mensajeVelocidad
				getChar
				MOV velocidad, AL
				comprobarVelocidad
				CMP hayError, 0001
				JE ERROR_B

				MOV AL, velocidad
				ADD AL, 48D
				MOV mensajeBubble[0031], AL
				print mensajeSentidoOrdenamiento
				getChar
				CMP AL, 49D ; 49 == 1
				JE DESCENDENTE_B
				CMP AL, 50D ; 50 == 2
				JE ASCENDENTE_B

				ASCENDENTE_B:
					dibujarPlano
					dibujarMensaje mensajeBubble
					getChar
					clearScreen

					burbujaDescendente 0000, mensajeBubble
					getChar
					JMP AREAADMINISTRADOR

				DESCENDENTE_B:
					dibujarPlano
					dibujarMensaje mensajeBubble
					getChar
					clearScreen

					burbujaDescendente 0001, mensajeBubble
					getChar
					JMP AREAADMINISTRADOR

				ERROR_B:
					print errorVelocidad
					getChar
					JMP BUBBLE
		;==========
		;==BUBBLE==
		;==========

		;=========
		;==QUICK==
		;=========
			QUICK:
				clearScreen
				print mensajeVelocidad
				getChar
				MOV velocidad, AL
				comprobarVelocidad
				CMP hayError, 0001
				JE ERROR_Q

				MOV AX, totalUsuarios[0002]
				DEC AX
				MOV r, AX

				MOV AL, velocidad
				ADD AL, 48D
				MOV mensajeQuick[0030], AL
				print mensajeSentidoOrdenamiento
				getChar
				CMP AL, 49D ; 49 == 1
				JE DESCENDENTE_Q
				CMP AL, 50D ; 50 == 2
				JE ASCENDENTE_Q

				ASCENDENTE_Q:
					dibujarPlano
					dibujarMensaje mensajeQuick
					getChar
					clearScreen

					MOV tipoQuick, 0000
					CALL quickSort
					dibujarAscendenteQuick mensajeQuick
					getChar
					JMP AREAADMINISTRADOR

				DESCENDENTE_Q:
					dibujarPlano
					dibujarMensaje mensajeQuick
					getChar
					clearScreen

					MOV tipoQuick, 0001
					CALL quickSort
					dibujarDescendenteQuick mensajeQuick
					getChar
					JMP AREAADMINISTRADOR

				ERROR_Q:
					print errorVelocidad
					getChar
					JMP QUICK
		;=========
		;==QUICK==
		;=========

		;=========
		;==SHELL==
		;=========
			SHELL:
				clearScreen
				print mensajeVelocidad
				getChar
				MOV velocidad, AL
				comprobarVelocidad
				CMP hayError, 0001
				JE ERROR_B

				MOV AL, velocidad
				ADD AL, 48D
				MOV mensajeShell[0030], AL
				print mensajeSentidoOrdenamiento
				getChar
				CMP AL, 49D ; 49 == 1
				JE DESCENDENTE_SHE
				CMP AL, 50D ; 50 == 2
				JE ASCENDENTE_SHE

				ASCENDENTE_SHE:
					dibujarPlano
					dibujarMensaje mensajeShell
					getChar
					clearScreen

					ShellSort punteosJugadoresTopOrdenados, totalUsuarios[0002], 0000
					dibujarAscendente mensajeShell
					getChar
					JMP AREAADMINISTRADOR

				DESCENDENTE_SHE:
					dibujarPlano
					dibujarMensaje mensajeShell
					getChar
					clearScreen

					ShellSort punteosJugadoresTopOrdenados, totalUsuarios[0002], 0001
					dibujarDescendente mensajeShell
					getChar
					JMP AREAADMINISTRADOR

				ERROR_S:
					print errorVelocidad
					getChar
					JMP SHELL
		;=========
		;==SHELL==
		;=========

		;===========
		;==USUARIO==
		;===========
			AREAUSUARIO:
				clearScreen ; Limpia la pantalla
				print mensajeEncabezado
				print mensajeMenuUsuario ; Muestra el menu
				getChar ; Captura el caracter
				CMP AL, 49D ; caracter == 1
				JE INGRESAR  ; Ingresar
				CMP AL, 50D ; caracter == 2
				JE REGISTRAR ; Registrar
				CMP AL, 51D ; caracter == 3
				JE MENU  ; Salir
				JMP AREAUSUARIO ; Si el caracter no es un numero entre [1,8] regresa al menu
		;===========
		;==USUARIO==
		;===========

		;==============
		;==REGISTRAR===
		;==============
			REGISTRAR:
				clearScreen ; Limpia la pantalla
				print mensajeIngreseUsuario ; Solicita el usuario
				stringReadU datoUsuario ; Lee el usuario
				CALL usuarioExiste ; Verifica si el usuario ya existe
				CMP matchUsuario, 0001
				JE ERRORUSUARIOEXISTE
				print mensajeIngresePassword ; Solicita la contraseña
				stringReadP datoPassword ; Lee la password
				CALL verificarPassword ; Comprueba que la contraseña sea numerica
				CMP existeError, 0001
				JE ERRORREGISTRARPASSWORD
				insertarNuevoUsuario textoUs
				fileCreate textoUs, archivoUsuarios
				fileReader archivoPuntajes, textoUst ; El texto esta almacenado en texto
				;insertarNuevoPuntaje textoUst, datoUsuario, puntajeFinal, tiempoFinal, nivelFinal
				;fileCreate textoUst, archivoPuntajes
				resetOriginales
				JMP MENU ; Pasa al area de ingreso a solicitar los datos

			ERRORREGISTRARPASSWORD:
				clearScreen
				print errorPassword
				CALL PAUSA
				JMP REGISTRAR

			ERRORUSUARIOEXISTE:
				clearScreen
				print errorUsuarioYaExiste
				CALL PAUSA
				JMP REGISTRAR
		;================
		;===REGISTRAR====
		;================

		;=========
		;==SALIR==
		;=========
			SALIR:
				MOV AX, 4C00H ; Interrupcion para finalizar el programa
				INT 21H ; Llama a la interrupcion
		;=========
		;==SALIR==
		;=========

		;===================
		;==PROCEDIMIENTOS===
		;===================
			PAUSA PROC 
				MOV AH, 00H ; Leer pulsaci¢n
			    INT 16H
			    RET
			PAUSA ENDP

			comprobarLogin PROC
				PUSH SI
				PUSH BX
				PUSH AX
				XOR SI, SI
				MOV matchUsuario, 0000 ; Resetea el match del usuario
				fileReader archivoUsuarios, textoUs ; El texto esta almacenado en texto
				CICLO:
					XOR BX, BX
					resetTmp
					GUARDARUSUARIO:
						CMP textoUs[SI], 36D ; 36 = $
						JE SALIR ; Termino el texto
						CMP textoUs[SI], 59D ; 59 = ;
						JE COMPROBARUSUARIO ; Termino el usuario, sigue la contraseña
						MOV AH, textoUs[SI]
						MOV tmpUsuario[BX], AH ; Guarda el caracter
						INC SI
						INC BX
						JMP GUARDARUSUARIO

					COMPROBARUSUARIO:
						stringCompare datoUsuario, tmpUsuario
						CMP comparation, 0001
						JE IRPASSWORD
						INC SI
						JMP IGNORAR

					IRPASSWORD:
						INC SI
						XOR BX, BX
						JMP GUARDARPASSWORD

					GUARDARPASSWORD:
						CMP textoUs[SI], 13D ; 10 = nueva linea
						JE COMPROBARPASSWORD ; Termino el usuario y contraseña, espera nueva linea
						CMP textoUs[SI], 36D ; 36 = $
						JE COMPROBARPASSWORD ; Termino el usuario y contraseña, espera nueva linea
						MOV AH, textoUs[SI]
						MOV tmpPassword[BX], AH ; Guarda el caracter
						;print tmpPassword
						;getChar
						INC SI
						INC BX
						CMP BX, 0004
						JE COMPROBARPASSWORD
						JMP GUARDARPASSWORD

					COMPROBARPASSWORD:
						stringCompare datoPassword, tmpPassword
						CMP comparation, 0001
						JE IGUAL
						JMP SALIR

					IGNORAR:
						CMP textoUs[SI], 10D ; 10 = nueva linea
						JE INCR ; Termino el usuario y contraseña, espera nueva linea
						CMP textoUs[SI], 36D ; 36 = $
						JE SALIR ; Termino el archivo
						INC SI
						JMP IGNORAR

					IGUAL:
						MOV matchUsuario, 0001
						POP AX
						POP BX
						POP SI
						RET

					INCR:
						INC SI
						CMP textoUs[SI], 36D ; 36 = $
						JE SALIR ; Termino el texto
						JMP CICLO

				SALIR:
					MOV matchUsuario, 0000
					POP AX
					POP BX
					POP SI
					RET
			comprobarLogin ENDP

			usuarioExiste PROC
				PUSH SI
				PUSH BX
				PUSH AX
				XOR SI, SI
				MOV matchUsuario, 0000 ; Resetea el match del usuario
				fileReader archivoUsuarios, textoUs ; El texto esta almacenado en texto
				CICLO:
					XOR BX, BX
					resetTmp
					GUARDARUSUARIO:
						CMP textoUs[SI], 36D ; 36 = $
						JE SALIR ; Termino el texto
						CMP textoUs[SI], 59D ; 59 = ;
						JE COMPROBAR ; Termino el usuario, sigue la contraseña
						MOV AH, textoUs[SI]
						MOV tmpUsuario[BX], AH ; Guarda el caracter
						INC SI
						INC BX
						JMP GUARDARUSUARIO

					COMPROBAR:
						stringCompare datoUsuario, tmpUsuario
						CMP comparation, 0001
						JE IGUAL
						INC SI
						JMP IGNORAR

					IGNORAR:
						CMP textoUs[SI], 10D ; 10 = nueva linea
						JE INCR ; Termino el usuario y contraseña, espera nueva linea
						CMP textoUs[SI], 36D ; 36 = $
						JE SALIR ; Termino el texto
						INC SI
						JMP IGNORAR

					IGUAL:
						MOV matchUsuario, 0001
						POP AX
						POP BX
						POP SI
						RET

					INCR:
						INC SI
						CMP textoUs[SI], 36D ; 36 = $
						JE SALIR ; Termino el texto
						JMP CICLO

				SALIR:
					MOV matchUsuario, 0000
					POP AX
					POP BX
					POP SI
					RET
			usuarioExiste ENDP

			verificarPassword PROC
				MOV existeError, 0000
				PUSH SI
				XOR SI, SI
				CICLO:
					CMP datoPassword[SI], 48D ; 48 = 0
					JE ERROR
					CMP datoPassword[SI], 57D ; 57 = 9
					JA ERROR
					INC SI
					CMP SI, 0004
					JL CICLO
					JMP SALIR

				ERROR:
					MOV existeError, 0001

				SALIR:
					POP SI
					RET
			verificarPassword ENDP

			buscarTopPuntos PROC
				PUSH SI
				PUSH BX
				PUSH AX
				PUSH CX
				XOR SI, SI
				XOR AX, AX
				XOR CX, CX
				CICLO:

					IGNORAR:
						CMP textoUst[SI], 59D ; 59 = ; -> Empieza Score
						JE COMPROBARSCORE
						CMP textoUst[SI], 36D ; 36 = Fin
						JE SALIR
						CMP textoUst[SI], 13D ; 13 = Nueva linea
						JE NUEVALINEA
						INC SI
						JMP IGNORAR

					COMPROBARSCORE:
						INC SI
						MOV BL, textoUst[SI]
						MUL BH
						INC SI
						MOV BH, textoUst[SI]

						MOV numeroPrueba[0000], BL
						MOV numeroPrueba[0001], BH

						MOV AL, BL
						SUB AL, 48D
						MOV BL, 0AH
						MUL BL
						SUB BH, 48D

						ADD AL, BH

						insertarTop AL, CL
						insertarArr AL
						JMP IGNORAR

					NUEVALINEA:
						INC CL
						INC SI
						JMP IGNORAR

				SALIR:
					INC CX
					MOV totalUsuarios[0002], CX
					POP CX
					POP AX
					POP BX
					POP SI
					RET
			buscarTopPuntos ENDP

			buscarTopTiempo PROC
				PUSH SI
				PUSH BX
				PUSH AX
				PUSH CX
				XOR SI, SI
				XOR AX, AX
				XOR CX, CX
				CICLO:

					IGNORAR:
						CMP textoUst[SI], 95D ; 95 = _ -> Empieza Time
						JE COMPROBARSCORE
						CMP textoUst[SI], 36D ; 36 = Fin
						JE SALIR
						CMP textoUst[SI], 13D ; 13 = Nueva linea
						JE NUEVALINEA
						INC SI
						JMP IGNORAR

					COMPROBARSCORE:
						INC SI
						MOV BL, textoUst[SI]
						MUL BH
						INC SI
						MOV BH, textoUst[SI]

						MOV numeroPrueba[0000], BL
						MOV numeroPrueba[0001], BH

						MOV AL, BL
						SUB AL, 48D
						MOV BL, 0AH
						MUL BL
						SUB BH, 48D

						ADD AL, BH

						insertarTop AL, CL
						insertarArr AL
						JMP IGNORAR

					NUEVALINEA:
						INC CL
						INC SI
						JMP IGNORAR

				SALIR:
					POP CX
					POP AX
					POP BX
					POP SI
					RET
			buscarTopTiempo ENDP

			quickSort PROC
				MOV AX, p
				CMP AX, r
				JGE BIGGER1

				CALL partition

				MOV q, AX

				INC AX
				PUSH AX
				PUSH r

				MOV AX, q
				MOV r, AX
				DEC r
				CALL quickSort

				POP r
				POP p
				CALL quickSort

				BIGGER1:
					RET
			quickSort ENDP

			partition PROC
				MOV SI, offset arr
				MOV AX, r
				SHL AX, 1
				ADD SI, AX
				MOV AX, [SI]
				MOV x, AX

				MOV AX, p
				MOV i, AX
				DEC i

				MOV AX, p
				MOV j, AX

				FOR_J:
					MOV SI, offset arr
					MOV AX, j
					SHL AX, 1
					ADD SI, AX
					MOV AX, [SI]

					CMP tipoQuick, 0000
					JE pintarAS
					JMP pintarDe

					pintarAS:
						dibujarAscendenteQuick mensajeQuick
						JMP CONT

					pintarDe:
						dibujarDescendenteQuick mensajeQuick
						JMP CONT

					CONT:
						delayQuick
						CMP AX, x
						JG BIGGER

					INC i

					MOV DI, offset arr
					MOV CX, i
					SHL CX, 1
					ADD DI, CX
					MOV CX, [DI]

					MOV [DI], AX
					MOV [SI], CX



					BIGGER:
						INC j
						MOV AX, r
						CMP j, AX
						JL FOR_J

				INC i
				MOV SI, offset arr
				MOV AX, i
				SHL AX, 1
				ADD SI, AX
				MOV AX, [SI]

				MOV DI, offset arr
				MOV CX, r
				SHL CX, 1
				ADD DI, CX
				MOV CX, [DI]

				MOV [DI], AX
				MOV [SI], CX

				MOV AX, i
				RET
			partition ENDP
		;===================
		;==PROCEDIMIENTOS===
		;===================
		
	main  ENDP

END	main