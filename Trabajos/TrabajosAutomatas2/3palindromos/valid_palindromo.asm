;=====================================================
; Crear un programa que determine si una palabra o número
; se lee exactamente igual de izquierda a derecha que
; de derecha a izquierda.
; Autor: Brayan Ramirez Alvarado
; Fecha: 18/05/2026
; Entrada: Una cadena de caracteres introducida por teclado.
; Salida: Un mensaje indicando si la cadena es
;          "Es palindromo" o "No es palindromo".
;=====================================================

bits 64
default rel

section .data
    ;=====================================================
    ; Constantes simbólicas
    ;=====================================================
    TAM_SHADOW_SPACE      equ 40
    TAM_MAX_CADENA        equ 100
    INDICE_INICIAL        equ 0
    AJUSTE_ULTIMO_INDICE  equ 1
    VALOR_CERO            equ 0

    ;=====================================================
    ; Mensajes y formatos
    ;=====================================================
    msg_pedir_cadena db "Ingresa una palabra o numero, o escribe salir para terminar: ", 0

    msg_es_palindromo db "Es palindromo", 10, 0
    msg_no_palindromo db "No es palindromo", 10, 0
    msg_salida db "Programa finalizado.", 10, 0

    fmt_entrada db "%99s", 0
    fmt_salto_linea db 10, 0

    palabra_salida db "salir", 0

section .bss
    cadena resb TAM_MAX_CADENA
    longitud resq 1
    indice_inicio resq 1
    indice_final resq 1

section .text
    global main
    extern printf
    extern scanf
    extern strlen
    extern strcmp

;=========================================================
; Procedimiento principal
; Propósito:
;   Solicitar una palabra o número, verificar si es
;   palíndromo y permitir repetir el proceso hasta que
;   el usuario decida salir del programa.
;=========================================================
main:
    sub rsp, TAM_SHADOW_SPACE

solicitar_cadena:

    ; Mostrar mensaje para solicitar la cadena
    lea rcx, [msg_pedir_cadena]
    call printf

    ; Leer texto ingresado por el usuario
    lea rcx, [fmt_entrada]
    lea rdx, [cadena]
    call scanf

    ; Verificar si el usuario escribió "salir"
    lea rcx, [cadena]
    lea rdx, [palabra_salida]
    call strcmp

    cmp eax, VALOR_CERO
    je finalizar_programa

    ; Obtener la longitud de la cadena
    lea rcx, [cadena]
    call strlen
    mov [longitud], rax

    ; Validar que la cadena no esté vacía
    cmp rax, VALOR_CERO
    je solicitar_cadena

    ; Inicializar índice inicial
    mov qword [indice_inicio], INDICE_INICIAL

    ; Calcular índice final = longitud - 1
    mov rax, [longitud]
    sub rax, AJUSTE_ULTIMO_INDICE
    mov [indice_final], rax

comparar_caracteres:

    ; Mientras indice_inicio < indice_final,
    ; se comparan los caracteres extremos.
    mov rax, [indice_inicio]
    cmp rax, [indice_final]
    jae mostrar_es_palindromo

    ; Cargar dirección base de la cadena
    lea rdx, [cadena]

    ; Obtener carácter inicial
    mov rax, [indice_inicio]
    mov al, [rdx + rax]

    ; Obtener carácter final
    mov rbx, [indice_final]
    mov bl, [rdx + rbx]

    ; Comparar caracteres
    ; Si son diferentes, no es palíndromo
    cmp al, bl
    jne mostrar_no_palindromo

    ; Avanzar índices hacia el centro
    inc qword [indice_inicio]
    dec qword [indice_final]

    jmp comparar_caracteres

mostrar_es_palindromo:

    ; Mostrar mensaje positivo
    lea rcx, [msg_es_palindromo]
    call printf

    ; Imprimir salto de línea
    lea rcx, [fmt_salto_linea]
    call printf

    ; Solicitar otra cadena
    jmp solicitar_cadena

mostrar_no_palindromo:

    ; Mostrar mensaje negativo
    lea rcx, [msg_no_palindromo]
    call printf

    ; Imprimir salto de línea
    lea rcx, [fmt_salto_linea]
    call printf

    ; Solicitar otra cadena
    jmp solicitar_cadena

finalizar_programa:

    ; Mostrar mensaje de despedida
    lea rcx, [msg_salida]
    call printf

    add rsp, TAM_SHADOW_SPACE
    ret