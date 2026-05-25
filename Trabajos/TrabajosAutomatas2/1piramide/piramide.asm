    ;=====================================================
; Desarrollar un programa que solicite al usuario el número de filas (altura)
; y dibuje una pirámide centrada compuesta por caracteres asterisco (*).
; Autor: Brayan Ramirez Alvarado
; Fecha: 18/05/2026
; Entrada: El programa debe pedir al usuario un número entero (ej. 1-9)
;           mediante la consola.
; Salida: Mostrar en pantalla una pirámide de filas.
;=====================================================

bits 64
default rel

section .data
    ;=====================================================
    ; Constantes simbólicas
    ;=====================================================
    FILA_INICIAL        equ 1
    VALOR_CERO          equ 0
    LIMITE_MAXIMO       equ 9
    TAM_SHADOW_SPACE    equ 40

    ;=====================================================
    ; Mensajes y formatos
    ;=====================================================
    msg_pedir_filas db "Ingresa el numero de filas (1-9) o 0 para salir: ", 0
    msg_error db "Entrada invalida. Ingresa un numero entre 1 y 9.", 10, 0
    msg_salida db "Programa finalizado.", 10, 0

    fmt_entrada_entero db "%d", 0
    fmt_salto_linea db 10, 0

    espacio db " ", 0
    asterisco db "*", 0

section .bss
    filas resq 1
    contador_fila resq 1
    contador_espacios resq 1
    contador_asteriscos resq 1

section .text
    global main
    extern printf
    extern scanf

;=========================================================
; Procedimiento principal
; Propósito:
;   Solicita un número al usuario, genera una pirámide
;   con asteriscos y permite repetir el proceso hasta
;   que el usuario decida salir.
;=========================================================
main:
    sub rsp, TAM_SHADOW_SPACE

solicitar_filas:

    ; Mostrar mensaje para solicitar el número de filas
    lea rcx, [msg_pedir_filas]
    call printf

    ; Leer el número ingresado por el usuario
    lea rcx, [fmt_entrada_entero]
    lea rdx, [filas]
    call scanf

    ; Verificar si el usuario desea finalizar
    mov rax, [filas]
    cmp rax, VALOR_CERO
    je finalizar_programa

    ; Validar que el número sea mayor o igual a 1
    cmp rax, FILA_INICIAL
    jl mostrar_error

    ; Validar que el número no exceda el límite permitido
    cmp rax, LIMITE_MAXIMO
    jg mostrar_error

    ; Inicializar contador de filas
    mov qword [contador_fila], FILA_INICIAL

generar_filas:

    ; Mientras contador_fila <= filas, continuar generando
    mov rax, [contador_fila]
    cmp rax, [filas]
    jg terminar_piramide

    ; Calcular espacios iniciales
    mov rax, [filas]
    sub rax, [contador_fila]
    mov [contador_espacios], rax

imprimir_espacios:

    ; Imprimir espacios mientras contador_espacios > 0
    mov rax, [contador_espacios]
    cmp rax, VALOR_CERO
    jle calcular_asteriscos

    lea rcx, [espacio]
    call printf

    dec qword [contador_espacios]
    jmp imprimir_espacios

calcular_asteriscos:

    ; Calcular cantidad de asteriscos por fila
    ; Fórmula: (2 * fila) - 1
    mov rax, [contador_fila]
    shl rax, 1
    dec rax
    mov [contador_asteriscos], rax

imprimir_asteriscos:

    ; Imprimir asteriscos mientras contador_asteriscos > 0
    mov rax, [contador_asteriscos]
    cmp rax, VALOR_CERO
    jle imprimir_salto_linea

    lea rcx, [asterisco]
    call printf

    dec qword [contador_asteriscos]
    jmp imprimir_asteriscos

imprimir_salto_linea:

    ; Imprimir salto de línea al finalizar cada fila
    lea rcx, [fmt_salto_linea]
    call printf

    ; Incrementar contador de filas
    inc qword [contador_fila]
    jmp generar_filas

terminar_piramide:

    ; Separación visual entre ejecuciones
    lea rcx, [fmt_salto_linea]
    call printf

    ; Solicitar nuevamente un número
    jmp solicitar_filas

mostrar_error:

    ; Mostrar mensaje de error
    lea rcx, [msg_error]
    call printf

    ; Regresar al inicio
    jmp solicitar_filas

finalizar_programa:

    ; Mostrar mensaje de despedida
    lea rcx, [msg_salida]
    call printf

    add rsp, TAM_SHADOW_SPACE
    ret