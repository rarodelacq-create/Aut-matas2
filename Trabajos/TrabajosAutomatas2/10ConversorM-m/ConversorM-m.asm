;=====================================================
; Desarrollar un programa que convierta un texto en
; MAYÚSCULAS a minúsculas utilizando ASCII.
; Autor: Brayan Ramirez Alvarado
; Fecha: 18/05/2026
; Entrada:
;   - Texto ingresado por el usuario.
; Salida:
;   - Texto convertido a minúsculas.
;=====================================================

bits 64
default rel

section .data
    ;=====================================================
    ; Constantes simbólicas
    ;=====================================================
    TAM_SHADOW_SPACE      equ 40
    TAM_MAX_TEXTO         equ 100

    VALOR_CERO            equ 0
    VALOR_UNO             equ 1

    ASCII_A_MAYUS         equ 'A'
    ASCII_Z_MAYUS         equ 'Z'

    DIFERENCIA_ASCII      equ 32

    ;=====================================================
    ; Mensajes
    ;=====================================================
    msg_ingresar_texto db "Ingresa un texto en MAYUSCULAS: ", 10, 0

    msg_resultado db 10, "Texto convertido:", 10, 0

    msg_repetir db 10, "Deseas convertir otro texto? (1 = si / 0 = no): ", 0

    msg_error db "Opcion invalida.", 10, 0

    msg_salida db "Programa finalizado.", 10, 0

    fmt_entero db "%lld", 0

section .bss
    texto resb TAM_MAX_TEXTO
    opcion_usuario resq 1

section .text
    global main

    extern printf
    extern scanf
    extern gets
    extern putchar

;=========================================================
; Procedimiento principal
;
; Propósito:
;   Convertir un texto en MAYÚSCULAS a minúsculas
;   usando la tabla ASCII.
;=========================================================
main:
    sub rsp, TAM_SHADOW_SPACE

reiniciar_programa:

    ;=====================================================
    ; Mostrar mensaje de entrada
    ;=====================================================
    lea rcx, [msg_ingresar_texto]
    call printf

    ;=====================================================
    ; Leer texto completo
    ;=====================================================
    lea rcx, [texto]
    call gets

    ; RSI apunta al inicio del texto
    lea rsi, [texto]

recorrer_cadena:

    ;=====================================================
    ; Obtener carácter actual
    ;=====================================================
    mov al, [rsi]

    ;=====================================================
    ; Fin de cadena (NULL)
    ;=====================================================
    cmp al, VALOR_CERO
    je mostrar_resultado

    ;=====================================================
    ; Verificar si es mayúscula A-Z
    ;=====================================================
    cmp al, ASCII_A_MAYUS
    jb siguiente_caracter

    cmp al, ASCII_Z_MAYUS
    ja siguiente_caracter

    ;=====================================================
    ; Convertir a minúscula
    ;=====================================================
    add al, DIFERENCIA_ASCII
    mov [rsi], al

siguiente_caracter:

    ; Avanzar puntero
    inc rsi
    jmp recorrer_cadena

mostrar_resultado:

    ;=====================================================
    ; Mostrar encabezado
    ;=====================================================
    lea rcx, [msg_resultado]
    call printf

    ; Mostrar texto convertido
    lea rcx, [texto]
    call printf

    ; Salto de línea
    mov rcx, 10
    call putchar

preguntar_repeticion:

    ;=====================================================
    ; Preguntar repetición
    ;=====================================================
    lea rcx, [msg_repetir]
    call printf

    lea rcx, [fmt_entero]
    lea rdx, [opcion_usuario]
    call scanf

    ;=====================================================
    ; Evaluar opción
    ;=====================================================
    mov rax, [opcion_usuario]

    cmp rax, VALOR_CERO
    je finalizar_programa

    cmp rax, VALOR_UNO
    je reiniciar_programa

    ; Opción inválida
    lea rcx, [msg_error]
    call printf

    jmp preguntar_repeticion

finalizar_programa:

    ;=====================================================
    ; Mensaje final
    ;=====================================================
    lea rcx, [msg_salida]
    call printf

    add rsp, TAM_SHADOW_SPACE
    ret