;=====================================================
; Desarrollar un programa que permita ingresar un arreglo
; de números enteros y determinar cuál es el valor mayor.
; Autor: Brayan Ramirez Alvarado
; Fecha: 18/05/2026
; Entrada:
;   - Cantidad de elementos del arreglo.
;   - Valores enteros ingresados por el usuario.
; Salida:
;   - El número mayor encontrado en el arreglo.
;=====================================================

bits 64
default rel

section .data
    ;=====================================================
    ; Constantes simbólicas
    ;=====================================================
    TAM_SHADOW_SPACE      equ 40
    MAX_ELEMENTOS         equ 20
    TAM_ELEMENTO_QWORD    equ 8
    VALOR_CERO            equ 0
    VALOR_UNO             equ 1

    ;=====================================================
    ; Mensajes y formatos
    ;=====================================================
    msg_cantidad db "Ingresa la cantidad de elementos del arreglo (1-20): ", 0
    msg_elemento db "Ingresa un numero del arreglo: ", 0

    msg_resultado db 10, "El numero mayor del arreglo es: %lld", 10, 10, 0

    msg_error db "Cantidad invalida.", 10, 0

    msg_repetir db "Deseas ejecutar nuevamente? (1 = si / 0 = no): ", 0
    msg_salida db "Programa finalizado.", 10, 0

    fmt_entero db "%lld", 0

section .bss
    arreglo resq MAX_ELEMENTOS

    cantidad_elementos resq 1
    indice_actual resq 1
    mayor resq 1
    opcion_usuario resq 1

section .text
    global main
    extern printf
    extern scanf

;=========================================================
; Procedimiento principal
; Propósito:
;   Permitir ingresar un arreglo de números enteros
;   y encontrar el número mayor almacenado.
;=========================================================
main:
    sub rsp, TAM_SHADOW_SPACE

reiniciar_programa:

    ;=====================================================
    ; Solicitar cantidad de elementos
    ;=====================================================
    lea rcx, [msg_cantidad]
    call printf

    lea rcx, [fmt_entero]
    lea rdx, [cantidad_elementos]
    call scanf

    ;=====================================================
    ; Validar cantidad:
    ; 1 <= cantidad_elementos <= 20
    ;=====================================================
    mov rax, [cantidad_elementos]

    cmp rax, VALOR_UNO
    jl mostrar_error

    cmp rax, MAX_ELEMENTOS
    jg mostrar_error

    ;=====================================================
    ; Inicializar índice del arreglo
    ;=====================================================
    mov qword [indice_actual], VALOR_CERO

llenar_arreglo:

    ; Mientras indice_actual < cantidad_elementos,
    ; continuar solicitando números.
    mov rax, [indice_actual]
    cmp rax, [cantidad_elementos]
    jge inicializar_busqueda_mayor

    ; Solicitar elemento del arreglo
    lea rcx, [msg_elemento]
    call printf

    ;=====================================================
    ; Calcular desplazamiento:
    ; indice_actual * tamaño del elemento
    ;=====================================================
    mov rax, [indice_actual]

    ; Multiplicar índice por 8 bytes
    imul rax, TAM_ELEMENTO_QWORD

    ; Obtener dirección base del arreglo
    lea r8, [arreglo]

    ; Leer valor en arreglo[indice_actual]
    lea rdx, [r8 + rax]

    lea rcx, [fmt_entero]
    call scanf

    ; Incrementar índice
    inc qword [indice_actual]

    jmp llenar_arreglo

inicializar_busqueda_mayor:

    ;=====================================================
    ; Inicializar valor mayor con arreglo[0]
    ;=====================================================
    mov rax, [arreglo]
    mov [mayor], rax

    ; Comenzar búsqueda desde el segundo elemento
    mov qword [indice_actual], VALOR_UNO

buscar_mayor:

    ; Mientras indice_actual < cantidad_elementos,
    ; continuar buscando el mayor.
    mov rax, [indice_actual]
    cmp rax, [cantidad_elementos]
    jge mostrar_resultado

    ;=====================================================
    ; Calcular desplazamiento del elemento actual
    ;=====================================================
    mov rax, [indice_actual]

    ; Multiplicar índice por tamaño del elemento
    imul rax, TAM_ELEMENTO_QWORD

    ; Obtener dirección base del arreglo
    lea r8, [arreglo]

    ; Cargar elemento actual
    mov rbx, [r8 + rax]

    ;=====================================================
    ; Comparar elemento actual con el mayor
    ;=====================================================
    cmp rbx, [mayor]
    jle avanzar_siguiente_elemento

    ; Actualizar valor mayor
    mov [mayor], rbx

avanzar_siguiente_elemento:

    ; Incrementar índice
    inc qword [indice_actual]

    jmp buscar_mayor

mostrar_resultado:

    ; Mostrar número mayor encontrado
    lea rcx, [msg_resultado]
    mov rdx, [mayor]
    call printf

preguntar_repeticion:

    ; Preguntar si desea repetir el programa
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

    ; Mostrar mensaje de error
    lea rcx, [msg_error]
    call printf

    ; Reiniciar programa
    jmp reiniciar_programa

finalizar_programa:

    ; Mostrar mensaje final
    lea rcx, [msg_salida]
    call printf

    add rsp, TAM_SHADOW_SPACE
    ret