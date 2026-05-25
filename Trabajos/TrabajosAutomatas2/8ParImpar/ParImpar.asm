;=====================================================
; Desarrollar un programa que determine si un número
; de un solo dígito es par o impar utilizando
; la instrucción AND.
; Autor: Brayan Ramirez Alvarado
; Fecha: 18/05/2026
; Entrada:
;   - Número entero entre 0 y 9.
; Salida:
;   - Mensaje indicando si el número es par o impar.
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
    LIMITE_MAXIMO         equ 9

    ;=====================================================
    ; Mensajes y formatos
    ;=====================================================
    msg_pedir_numero db "Ingresa un numero de un solo digito (0-9): ", 0

    msg_par db "El numero es par", 10, 10, 0

    msg_impar db "El numero es impar", 10, 10, 0

    msg_error db "Entrada invalida. Ingresa un numero entre 0 y 9.", 10, 0

    msg_repetir db "Deseas verificar otro numero? (1 = si / 0 = no): ", 0

    msg_salida db "Programa finalizado.", 10, 0

    fmt_entero db "%lld", 0

section .bss
    numero resq 1
    opcion_usuario resq 1

section .text
    global main
    extern printf
    extern scanf

;=========================================================
; Procedimiento principal
; Propósito:
;   Verificar si un número es par o impar
;   utilizando la operación lógica AND.
;=========================================================
main:
    sub rsp, TAM_SHADOW_SPACE

reiniciar_programa:

    ;=====================================================
    ; Solicitar número al usuario
    ;=====================================================
    lea rcx, [msg_pedir_numero]
    call printf

    ; Leer número entero
    lea rcx, [fmt_entero]
    lea rdx, [numero]
    call scanf

    ;=====================================================
    ; Validar rango:
    ; 0 <= numero <= 9
    ;=====================================================
    mov rax, [numero]

    cmp rax, VALOR_CERO
    jl mostrar_error

    cmp rax, LIMITE_MAXIMO
    jg mostrar_error

    ;=====================================================
    ; Verificar paridad usando AND
    ;
    ; numero AND 1
    ;
    ; Resultado:
    ; 0 = número par
    ; 1 = número impar
    ;=====================================================
    mov rax, [numero]
    and rax, VALOR_UNO

    ;=====================================================
    ; Evaluar resultado de la operación
    ;=====================================================
    cmp rax, VALOR_CERO
    je mostrar_numero_par

mostrar_numero_impar:

    ; Mostrar mensaje de número impar
    lea rcx, [msg_impar]
    call printf

    jmp preguntar_repeticion

mostrar_numero_par:

    ; Mostrar mensaje de número par
    lea rcx, [msg_par]
    call printf

preguntar_repeticion:

    ;=====================================================
    ; Preguntar si desea repetir el programa
    ;=====================================================
    lea rcx, [msg_repetir]
    call printf

    ; Leer opción del usuario
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
    je reiniciar_programa

    ; Si la opción es inválida, volver a preguntar
    jmp preguntar_repeticion

mostrar_error:

    ;=====================================================
    ; Mostrar mensaje de error
    ;=====================================================
    lea rcx, [msg_error]
    call printf

    ; Reiniciar programa
    jmp reiniciar_programa

finalizar_programa:

    ;=====================================================
    ; Mostrar mensaje final
    ;=====================================================
    lea rcx, [msg_salida]
    call printf

    add rsp, TAM_SHADOW_SPACE
    ret