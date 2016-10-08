; masm.exe show_str.asm
assume cs:code
data segment
    db 'Welcome to masm!', 0
data ends

code segment
start:
    mov dh, 8
    mov dl, 3
    mov cl, 2
    mov ax, data
    mov ds, ax
    mov si, 0
    call show_str

    mov ax, 4c00H
    int 21H

; function: to show string start from ds:[si] to end of zero on row m, column n with color c
; row m: 0 <= m <= 24, store in dh
; column n: 0 <= n <= 79, store in dl
; color c: 0 for blue, 2 for green, 4 for red, store in cl
show_str:
    push ax
    push bx
    push cx

    mov ax, 0b800H ; destination segment to print on screen
    mov es, ax

    mov ax, 160 ; one line 160 bytes
    mul dh
    mov bx, ax ; base row offset
    mov dh, 0
    add dx, dx ; base column offset
    add bx, dx ; bx = m * 160 + n * 2
    mov di, 0

    mov al, cl
    mov cx, 0

    s:
    mov cl, ds:[si]
    jcxz finish
    mov es:[bx+di], cl
    mov es:[bx+di+1], al
    inc si
    add di, 2
    jmp s

    finish:
    pop cx
    pop bx
    pop ax
    ret

code ends

end start
