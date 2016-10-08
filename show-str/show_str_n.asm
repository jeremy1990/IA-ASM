; nasm.exe -f bin show_str_n.asm -o show_str_n.bin
    mov dh, 8
    mov dl, 3
    mov cl, 2
    mov ax, cs
    mov ds, ax
    mov si, 0x7c00 ; load to cs=0, ip=0x7c00
    call show_str

    infi:
    jmp near infi

; function: to show string start from ds:[si] to end of zero on row m, column n with color c
; row m: 0 <= m <= 24, store in dh
; column n: 0 <= n <= 79, store in dl
; color c: 0 for blue, 2 for green, 4 for red, store in cl
show_str:
    push ax
    push bx
    push cx

    mov ax, 0xb800 ; destination segment to print on screen
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
    mov cl, [ds:data+si]
    jcxz finish
    mov [es:bx+di], cl
    mov [es:bx+di+1], al
    inc si
    add di, 2
    jmp s

    finish:
    pop cx
    pop bx
    pop ax
    ret

    data db 'Welcome to masm!', 0

    times 421 db 0
    db 0x55,0xaa ; boot required
