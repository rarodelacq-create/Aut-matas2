;=====================================================
; Desarrollar un programa que analice una frase
; ingresada por el usuario y contabilice:
;   - Vocales
;   - Consonantes
;   - Dígitos
; Autor: Brayan Ramirez Alvarado
; Fecha: 18/05/2026
; Entrada:
;   - Una frase ingresada por teclado.
; Salida:
;   - Cantidad de vocales.
;   - Cantidad de consonantes.
;   - Cantidad de dígitos.
;=====================================================

bits 64
default rel

section .data
    ;=====================================================
    ; Constantes simbólicas
    ;=====================================================
    TAM_SHADOW_SPACE      equ 40
    TAM_MAX_CADENA        equ 200

    VALOR_CERO            equ 0
    VALOR_UNO             equ 1

    ASCII_A_MAYUS         equ 'A'
    ASCII_Z_MAYUS         equ 'Z'

    ASCII_A_MINUS         equ 'a'
    ASCII_Z_MINUS         equ 'z'

    ASCII_0               equ '0'
    ASCII_9               equ '9'

    DIFERENCIA_ASCII      equ 32

    ;=====================================================
    ; Mensajes
    ;=====================================================
    msg_ingresar_frase db "Ingresa una frase: ", 0

    msg_vocales db 10, "Cantidad de vocales: %lld", 10, 0

    msg_consonantes db "Cantidad de consonantes: %lld", 10, 0

    msg_digitos db "Cantidad de digitos: %lld", 10, 10, 0

    msg_repetir db "Deseas analizar otra frase? (1 = si / 0 = no): ", 0

    msg_error db "Opcion invalida.", 10, 0

    msg_salida db "Programa finalizado.", 10, 0

    fmt_entero db "%lld", 0

section .bss
    cadena resb TAM_MAX_CADENA

    vocales resq 1
    consonantes resq 1
    digitos resq 1

    opcion_usuario resq 1

section .text
    global main

    extern printf
    extern scanf
    extern gets

;=========================================================
; Procedimiento principal
; Propósito:
;   Analizar una frase y contar:
;   - Vocales
;   - Consonantes
;   - Dígitos
;=========================================================
main:
    sub rsp, TAM_SHADOW_SPACE

reiniciar_programa:

    ;=====================================================
    ; Inicializar contadores
    ;=====================================================
    mov qword [vocales], VALOR_CERO
    mov qword [consonantes], VALOR_CERO
    mov qword [digitos], VALOR_CERO

    ;=====================================================
    ; Mostrar mensaje principal
    ;=====================================================
    lea rcx, [msg_ingresar_frase]
    call printf

    ;=====================================================
    ; Leer cadena completa
    ;=====================================================
    lea rcx, [cadena]
    call gets

    ; RSI apunta al inicio de la cadena
    lea rsi, [cadena]

analizar_cadena:

    ;=====================================================
    ; Obtener carácter actual
    ;=====================================================
    mov al, [rsi]

    ;=====================================================
    ; Si encuentra NULL,
    ; finalizar análisis.
    ;=====================================================
    cmp al, VALOR_CERO
    je mostrar_resultados

    ;=====================================================
    ; Verificar si es dígito:
    ; '0' <= caracter <= '9'
    ;=====================================================
    cmp al, ASCII_0
    jb verificar_letras

    cmp al, ASCII_9
    ja verificar_letras

    ; Incrementar contador de dígitos
    inc qword [digitos]

    jmp siguiente_caracter

verificar_letras:

    ;=====================================================
    ; Verificar letra mayúscula
    ;=====================================================
    cmp al, ASCII_A_MAYUS
    jb siguiente_caracter

    cmp al, ASCII_Z_MAYUS
    jbe convertir_a_minuscula

    ;=====================================================
    ; Verificar letra minúscula
    ;=====================================================
    cmp al, ASCII_A_MINUS
    jb siguiente_caracter

    cmp al, ASCII_Z_MINUS
    ja siguiente_caracter

    jmp verificar_vocal

convertir_a_minuscula:

    ;=====================================================
    ; Convertir mayúscula a minúscula
    ;=====================================================
    add al, DIFERENCIA_ASCII

verificar_vocal:

    ;=====================================================
    ; Comparar con vocales
    ;=====================================================
    cmp al, 'a'
    je incrementar_vocal

    cmp al, 'e'
    je incrementar_vocal

    cmp al, 'i'
    je incrementar_vocal

    cmp al, 'o'
    je incrementar_vocal

    cmp al, 'u'
    je incrementar_vocal

    ;=====================================================
    ; Si es letra y no es vocal,
    ; entonces es consonante.
    ;=====================================================
    inc qword [consonantes]

    jmp siguiente_caracter

incrementar_vocal:

    ; Incrementar contador de vocales
    inc qword [vocales]

siguiente_caracter:

    ;=====================================================
    ; Avanzar al siguiente carácter
    ;=====================================================
    inc rsi

    jmp analizar_cadena

mostrar_resultados:

    ;=====================================================
    ; Mostrar cantidad de vocales
    ;=====================================================
    lea rcx, [msg_vocales]
    mov rdx, [vocales]
    call printf

    ;=====================================================
    ; Mostrar cantidad de consonantes
    ;=====================================================
    lea rcx, [msg_consonantes]
    mov rdx, [consonantes]
    call printf

    ;=====================================================
    ; Mostrar cantidad de dígitos
    ;=====================================================
    lea rcx, [msg_digitos]
    mov rdx, [digitos]
    call printf

preguntar_repeticion:

    ;=====================================================
    ; Preguntar si desea repetir
    ;=====================================================
    lea rcx, [msg_repetir]
    call printf

    lea rcx, [fmt_entero]
    lea rdx, [opcion_usuario]
    call scanf

    ;=====================================================
    ; Evaluar opción ingresada
    ;=====================================================
    mov rax, [opcion_usuario]

    cmp rax, VALOR_CERO
    je finalizar_programa

    cmp rax, VALOR_UNO
    je limpiar_buffer

    ; Opción inválida
    lea rcx, [msg_error]
    call printf

    jmp preguntar_repeticion

limpiar_buffer:

    ;=====================================================
    ; Consumir ENTER pendiente
    ;=====================================================
    lea rcx, [cadena]
    call gets

    jmp reiniciar_programa

finalizar_programa:

    ;=====================================================
    ; Mostrar mensaje final
    ;=====================================================
    lea rcx, [msg_salida]
    call printf

    add rsp, TAM_SHADOW_SPACE
    ret