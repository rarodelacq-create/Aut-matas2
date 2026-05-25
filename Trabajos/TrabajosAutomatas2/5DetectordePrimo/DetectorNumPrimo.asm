;=====================================================
; Diseñar un programa que evalúe lógicamente si un número
; dado tiene únicamente dos divisores exactos:
; el 1 y sí mismo.
; Autor: Brayan Ramirez Alvarado
; Fecha: 18/05/2026
; Entrada: Un número entero positivo mayor a 1.
; Salida: Un mensaje indicando:
;          "El numero es primo"
;          o
;          "El numero es compuesto".
;=====================================================

bits 64
default rel

section .data
    ;=====================================================
    ; Constantes simbólicas
    ;=====================================================
    TAM_SHADOW_SPACE      equ 40
    VALOR_CERO            equ 0
    VALOR_UNO             equ 1
    PRIMER_DIVISOR        equ 2
    VALOR_SALIDA          equ 0

    ;=====================================================
    ; Mensajes y formatos
    ;=====================================================
    msg_pedir_numero db "Ingresa un numero entero mayor a 1 o 0 para salir: ", 0

    msg_primo db "El numero es primo", 10, 10, 0
    msg_compuesto db "El numero es compuesto", 10, 10, 0
    msg_error db "Entrada invalida. Ingresa un numero entero mayor a 1.", 10, 0
    msg_salida db "Programa finalizado.", 10, 0

    fmt_entrada_entero db "%lld", 0

section .bss
    numero resq 1
    divisor resq 1

section .text
    global main
    extern printf
    extern scanf

;=========================================================
; Procedimiento principal
; Propósito:
;   Solicitar un número entero, determinar si es
;   primo o compuesto y permitir repetir el proceso.
;=========================================================
main:
    sub rsp, TAM_SHADOW_SPACE

solicitar_numero:

    ; Mostrar mensaje para solicitar el número
    lea rcx, [msg_pedir_numero]
    call printf

    ; Leer número entero de 64 bits
    lea rcx, [fmt_entrada_entero]
    lea rdx, [numero]
    call scanf

    ; Verificar si el usuario desea finalizar
    mov rax, [numero]
    cmp rax, VALOR_SALIDA
    je finalizar_programa

    ; Validar que el número sea mayor a 1
    cmp rax, VALOR_UNO
    jle mostrar_error_entrada

    ; Inicializar divisor en 2
    mov qword [divisor], PRIMER_DIVISOR

verificar_divisores:

    ; Verificar si divisor * divisor > numero
    ; Si se cumple, el número es primo
    mov rax, [divisor]

    ; Multiplicar divisor por sí mismo
    imul rax, rax

    cmp rax, [numero]
    jg mostrar_numero_primo

    ; Realizar división:
    ; numero / divisor
    ; RDX almacena el residuo
    mov rax, [numero]
    xor rdx, rdx
    div qword [divisor]

    ; Si el residuo es 0,
    ; el número tiene un divisor exacto
    cmp rdx, VALOR_CERO
    je mostrar_numero_compuesto

    ; Incrementar divisor
    inc qword [divisor]

    ; Continuar verificando divisores
    jmp verificar_divisores

mostrar_numero_primo:

    ; Mostrar resultado positivo
    lea rcx, [msg_primo]
    call printf

    ; Solicitar otro número
    jmp solicitar_numero

mostrar_numero_compuesto:

    ; Mostrar resultado negativo
    lea rcx, [msg_compuesto]
    call printf

    ; Solicitar otro número
    jmp solicitar_numero

mostrar_error_entrada:

    ; Mostrar mensaje de error
    lea rcx, [msg_error]
    call printf

    ; Regresar al inicio
    jmp solicitar_numero

finalizar_programa:

    ; Mostrar mensaje de despedida
    lea rcx, [msg_salida]
    call printf

    add rsp, TAM_SHADOW_SPACE
    ret