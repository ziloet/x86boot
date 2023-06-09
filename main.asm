[org 0x7c00]

[bits 16]
		jmp 0x0: start16

start16:
		xor ax, ax
		mov ds, ax
		mov es, ax

disk_read:
		mov ah, 0x2	; read sector routine
		mov al, 0x1	; num sectors to read
		mov ch, 0x0	; select track 0
		mov dh, 0x0	; select head 0
		mov cl, 0x2	; start from sector 2 (1 is us)
		mov bx, 0x7e00	; read destination
		int 0x13

enable_protected_mode:
		cli
		lgdt [GDT_DESC]
		mov eax, cr0
		or eax, 1
		mov cr0, eax
		jmp CODE_SEG_OFFSET: start32	; clear i-cache

[bits 32]
start32:
		mov ax, DATA_SEG_OFFSET
		mov ds, ax
		mov es, ax
		mov ss, ax
		jmp main

GDT_BEGIN:
	dq 0x0
GDT_CODE:
	dq 0x00cf9a000000ffff
GDT_DATA:
	dq 0x00cf92000000ffff
GDT_END:

GDT_DESC:
	dw ((GDT_END - GDT_BEGIN) - 1)	; sizeof GDT
	dd GDT_BEGIN	; GDT base address

; macros
CODE_SEG_OFFSET equ (GDT_CODE - GDT_BEGIN)
DATA_SEG_OFFSET equ (GDT_DATA - GDT_BEGIN)

; MBR signature
times (510 - ($ - $$)) db 0
dw 0xaa55

main:
		jmp $
