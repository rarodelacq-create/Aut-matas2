;=====================================================
; Desarrollar un programa que calcule y muestre los primeros
; términos de la famosa serie matemática de Fibonacci.
; Autor: Brayan Ramirez Alvarado
; Fecha: 18/05/2026
; Entrada: Un número entero (mayor a 0) ingresado por el usuario
;           que define cuántos términos generar.
; Salida: La secuencia de números separados por comas.
;          Ejemplo: 0, 1, 1, 2, 3, 5
;=====================================================

bits 64
default rel

section .data
    ;=====================================================
    ; Constantes simbólicas
    ;=====================================================
    TAM_SHADOW_SPACE   equ 40
    VALOR_CERO         equ 0
    VALOR_UNO          equ 1
    LIMITE_MAXIMO      equ 9

    ;=====================================================
    ; Mensajes y formatos
    ;=====================================================
    msg_pedir_terminos db "Ingresa el numero de terminos Fibonacci (1-9) o 0 para salir: ", 0
    msg_error db "Entrada invalida. Ingresa un numero entre 1 y 9.", 10, 0
    msg_salida db "Programa finalizado.", 10, 0

    fmt_entrada_entero db "%d", 0
    fmt_numero db "%d", 0
    fmt_coma db ", ", 0
    fmt_salto_linea db 10, 0

section .bss
    numero_terminos resq 1
    contador_termino resq 1

    fibonacci_anterior resq 1
    fibonacci_actual resq 1
    fibonacci_siguiente resq 1

section .text
    global main
    extern printf
    extern scanf

;=========================================================
; Procedimiento principal
; Propósito:
;   Solicitar la cantidad de términos, generar la serie
;   Fibonacci y permitir repetir el proceso hasta que
;   el usuario decida finalizar el programa.
;=========================================================
main:
    sub rsp, TAM_SHADOW_SPACE

solicitar_numero_terminos:

    ; Mostrar mensaje para solicitar el número de términos
    lea rcx, [msg_pedir_terminos]
    call printf

    ; Leer número ingresado por el usuario
    lea rcx, [fmt_entrada_entero]
    lea rdx, [numero_terminos]
    call scanf

    ; Verificar si el usuario desea salir
    mov rax, [numero_terminos]
    cmp rax, VALOR_CERO
    je finalizar_programa

    ; Validar que el número sea mayor o igual a 1
    cmp rax, VALOR_UNO
    jl mostrar_error_entrada

    ; Validar que el número no exceda el límite permitido
    cmp rax, LIMITE_MAXIMO
    jg mostrar_error_entrada

    ; Inicializar valores base de Fibonacci
    mov qword [fibonacci_anterior], VALOR_CERO
    mov qword [fibonacci_actual], VALOR_UNO
    mov qword [contador_termino], VALOR_UNO

imprimir_serie_fibonacci:

    ; Mientras contador_termino <= numero_terminos,
    ; se imprime un término de la serie
    mov rax, [contador_termino]
    cmp rax, [numero_terminos]
    jg terminar_serie

    ; Imprimir el valor actual
    lea rcx, [fmt_numero]
    mov rdx, [fibonacci_anterior]
    call printf

    ; Verificar si es el último término
    mov rax, [contador_termino]
    cmp rax, [numero_terminos]
    je calcular_siguiente_fibonacci

    ; Imprimir separador entre términos
    lea rcx, [fmt_coma]
    call printf

calcular_siguiente_fibonacci:

    ; Calcular siguiente número Fibonacci
    ; Fórmula: siguiente = anterior + actual
    mov rax, [fibonacci_anterior]
    add rax, [fibonacci_actual]
    mov [fibonacci_siguiente], rax

    ; Actualizar valores para continuar la secuencia
    mov rax, [fibonacci_actual]
    mov [fibonacci_anterior], rax

    mov rax, [fibonacci_siguiente]
    mov [fibonacci_actual], rax

    ; Incrementar contador
    inc qword [contador_termino]

    jmp imprimir_serie_fibonacci

terminar_serie:

    ; Imprimir salto de línea al finalizar la serie
    lea rcx, [fmt_salto_linea]
    call printf

    ; Espacio visual entre ejecuciones
    lea rcx, [fmt_salto_linea]
    call printf

    ; Solicitar nuevamente un dato
    jmp solicitar_numero_terminos

mostrar_error_entrada:

    ; Mostrar mensaje de error
    lea rcx, [msg_error]
    call printf

    ; Regresar al inicio
    jmp solicitar_numero_terminos

finalizar_programa:

    ; Mostrar mensaje de despedida
    lea rcx, [msg_salida]
    call printf

    add rsp, TAM_SHADOW_SPACE
    ret