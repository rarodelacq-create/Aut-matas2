;=====================================================
; Implementar un algoritmo matemático que convierta un
; número entero positivo de base decimal a su
; representación binaria.
; Autor: Brayan Ramirez Alvarado
; Fecha: 18/05/2026
; Entrada: Un número entero positivo.
; Salida: Una cadena de unos (1) y ceros (0)
;          representando el valor en binario.
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
    VALOR_SALIDA          equ -1
    BASE_BINARIA          equ 2
    TAM_BUFFER_BINARIO    equ 65
    ULTIMA_POSICION       equ 64

    ;=====================================================
    ; Mensajes y formatos
    ;=====================================================
    msg_pedir_numero db "Ingresa un numero decimal positivo o -1 para salir: ", 0
    msg_resultado db "Numero en binario: %s", 10, 10, 0
    msg_error db "Entrada invalida. Ingresa un numero positivo.", 10, 0
    msg_salida db "Programa finalizado.", 10, 0

    fmt_entrada db "%lld", 0

section .bss
    numero_decimal resq 1
    buffer_binario resb TAM_BUFFER_BINARIO

section .text
    global main
    extern printf
    extern scanf

;=========================================================
; Procedimiento principal
; Propósito:
;   Solicitar un número decimal, convertirlo a binario,
;   mostrar el resultado y permitir repetir el proceso.
;=========================================================
main:
    sub rsp, TAM_SHADOW_SPACE

solicitar_numero:

    ; Mostrar mensaje para solicitar el número decimal
    lea rcx, [msg_pedir_numero]
    call printf

    ; Leer número entero ingresado por el usuario
    lea rcx, [fmt_entrada]
    lea rdx, [numero_decimal]
    call scanf

    ; Verificar si el usuario desea finalizar
    mov rax, [numero_decimal]
    cmp rax, VALOR_SALIDA
    je finalizar_programa

    ; Validar que el número no sea negativo
    cmp rax, VALOR_CERO
    jl mostrar_error_entrada

    ; Convertir número decimal a binario
    call convertir_decimal_a_binario

    ; Mostrar resultado en pantalla
    lea rcx, [msg_resultado]
    lea rdx, [buffer_binario]
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

;=========================================================
; Subrutina: convertir_decimal_a_binario
; Propósito:
;   Convertir el número almacenado en numero_decimal
;   a una cadena binaria guardada en buffer_binario.
;
; Entrada:
;   - [numero_decimal] = número decimal positivo.
;
; Salida:
;   - [buffer_binario] = cadena terminada en 0 con
;     el número convertido a binario.
;
; Registros modificados:
;   - rax, rdx, r8, r9, r10, r11.
;
; Registros preservados:
;   - No modifica registros no volátiles.
;=========================================================
convertir_decimal_a_binario:

    ; Cargar el número decimal
    mov rax, [numero_decimal]

    ; Caso especial:
    ; Si el número es 0, el resultado binario es "0"
    cmp rax, VALOR_CERO
    jne preparar_conversion_binaria

    mov byte [buffer_binario], '0'
    mov byte [buffer_binario + VALOR_UNO], 0
    ret

preparar_conversion_binaria:

    ; Colocar terminador nulo al final del buffer
    mov byte [buffer_binario + ULTIMA_POSICION], 0

    ; r8 apunta a la última posición válida
    lea r8, [buffer_binario + ULTIMA_POSICION - VALOR_UNO]

convertir_por_divisiones:

    ; División sucesiva entre 2
    ; RAX = cociente
    ; RDX = residuo
    xor rdx, rdx
    mov r10, BASE_BINARIA
    div r10

    ; Convertir residuo en carácter ASCII
    add dl, '0'
    mov [r8], dl

    ; Retroceder posición en el buffer
    dec r8

    ; Continuar mientras el cociente sea diferente de 0
    cmp rax, VALOR_CERO
    jne convertir_por_divisiones

    ; Ajustar posición al inicio del resultado válido
    inc r8

    ; Copiar resultado al inicio del buffer
    lea r9, [buffer_binario]

copiar_resultado_al_inicio:

    ; Copiar caracteres hasta encontrar el terminador nulo
    mov r11b, [r8]
    mov [r9], r11b

    cmp r11b, VALOR_CERO
    je terminar_conversion

    inc r8
    inc r9
    jmp copiar_resultado_al_inicio

terminar_conversion:
    ret