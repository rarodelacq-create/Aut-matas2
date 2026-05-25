;=====================================================
; Desarrollar un programa que realice una multiplicación
; utilizando únicamente sumas sucesivas, sin emplear
; la instrucción MUL.
; Autor: Brayan Ramirez Alvarado
; Fecha: 18/05/2026
; Entrada:
;   - Multiplicando entre 0 y 9.
;   - Multiplicador entre 0 y 9.
; Salida:
;   - Resultado de la multiplicación.
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
    msg_multiplicando db "Ingresa el multiplicando (0-9): ", 0

    msg_multiplicador db "Ingresa el multiplicador (0-9): ", 0

    msg_resultado db 10, "Resultado: %lld", 10, 10, 0

    msg_error db "Entrada invalida. Ingresa valores entre 0 y 9.", 10, 0

    msg_repetir db "Deseas realizar otra multiplicacion? (1 = si / 0 = no): ", 0

    msg_salida db "Programa finalizado.", 10, 0

    fmt_entero db "%lld", 0

section .bss
    multiplicando resq 1
    multiplicador resq 1
    multiplicador_original resq 1
    resultado resq 1
    opcion_usuario resq 1

section .text
    global main
    extern printf
    extern scanf

;=========================================================
; Procedimiento principal
; Propósito:
;   Realizar multiplicaciones mediante sumas sucesivas
;   y permitir repetir el proceso.
;=========================================================
main:
    sub rsp, TAM_SHADOW_SPACE

reiniciar_programa:

    ;=====================================================
    ; Solicitar multiplicando
    ;=====================================================
    lea rcx, [msg_multiplicando]
    call printf

    lea rcx, [fmt_entero]
    lea rdx, [multiplicando]
    call scanf

    ;=====================================================
    ; Validar multiplicando:
    ; 0 <= multiplicando <= 9
    ;=====================================================
    mov rax, [multiplicando]

    cmp rax, VALOR_CERO
    jl mostrar_error

    cmp rax, LIMITE_MAXIMO
    jg mostrar_error

    ;=====================================================
    ; Solicitar multiplicador
    ;=====================================================
    lea rcx, [msg_multiplicador]
    call printf

    lea rcx, [fmt_entero]
    lea rdx, [multiplicador]
    call scanf

    ;=====================================================
    ; Validar multiplicador:
    ; 0 <= multiplicador <= 9
    ;=====================================================
    mov rax, [multiplicador]

    cmp rax, VALOR_CERO
    jl mostrar_error

    cmp rax, LIMITE_MAXIMO
    jg mostrar_error

    ;=====================================================
    ; Guardar copia original del multiplicador
    ;=====================================================
    mov rax, [multiplicador]
    mov [multiplicador_original], rax

    ;=====================================================
    ; Inicializar resultado en 0
    ;=====================================================
    mov qword [resultado], VALOR_CERO

realizar_multiplicacion:

    ;=====================================================
    ; Mientras multiplicador > 0,
    ; continuar realizando sumas sucesivas.
    ;=====================================================
    cmp qword [multiplicador], VALOR_CERO
    je mostrar_resultado

    ;=====================================================
    ; resultado = resultado + multiplicando
    ;=====================================================
    mov rax, [resultado]
    add rax, [multiplicando]
    mov [resultado], rax

    ;=====================================================
    ; Decrementar multiplicador
    ;=====================================================
    dec qword [multiplicador]

    jmp realizar_multiplicacion

mostrar_resultado:

    ;=====================================================
    ; Mostrar resultado final
    ;=====================================================
    lea rcx, [msg_resultado]
    mov rdx, [resultado]
    call printf

preguntar_repeticion:

    ;=====================================================
    ; Preguntar si desea repetir el programa
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