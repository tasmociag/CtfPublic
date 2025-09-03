.section .data

sin_family: .word 2
sin_port:
	.word 0x901F
sin_addr:
	.byte 127
	.byte 0
	.byte 0
	.byte 1
__pad:
	.byte 0,0,0,0,0,0,0,0
response: 
	.ascii "HTTP/1.0 200 OK\r\n\r\n"
response_size:
	.byte 19
flag_path:
	.asciz "/home/homer/Ctf/Pjatk/RevWebServer/flag.txt"
flag_path_size:
	.quad 43
request_buffer_size:
	.quad 1024
flag_size:
	.quad 12

.section .bss
content_of_flag: 
	.skip 12

.section .text

.intel_syntax noprefix
.global _start

_start:
		#socket init
	mov rdi, 2
	mov rsi, 1
	mov rdx, 0
	mov rax, 41
	syscall

	push rax

	mov DWORD PTR [rsp-4], 1

		#set socket option SO_REUSEADDR
	mov rdi, [rsp]
	mov rsi, 1
	mov rdx, 2
	mov r10, rsp
	sub r10, 4
	mov r8, 4
	mov rax, 54
	syscall

		#bind
	mov rdi, [rsp]
	lea rsi, sin_family
	mov rdx, 16	
	mov rax, 49
	syscall

		#listen
	mov rdi, [rsp]
	mov rsi, 0
	mov rax, 50
	syscall

accept:
		#accept
	mov rdi, [rsp]
	mov rsi, 0
	mov rdx, 0
	mov rax, 43
	syscall

	push rax

		#fork
	mov rax, 57
	syscall
	
	cmp rax, 0

	je continue_accept

	pop rdi
	mov rax, 3
	syscall
	jmp accept

continue_accept:
		#close socket fd
	mov rdi, [rsp+8]
	mov rax, 3 
	syscall

	mov rbp, rsp
	sub rsp, request_buffer_size

		#read request
	mov rdi, [rbp]
	mov rsi, rsp
	mov rdx, request_buffer_size
	mov rax, 0
	syscall
	
	push rax
	
		#read method	
		# r11d = 0 -> GET
		# r11d = 1 -> POST
	xor rax, rax 
	xor rbx, rbx
	xor r11d, r11d
	mov rax, rbp
	sub rax, request_buffer_size
	mov eax, DWORD PTR[rax]
	mov ebx, 0x54534f50
	cmp ebx, eax
	je post

read_path_string:
		#read path string 
		# 	rbx - start of path	
		# 	rcx - end of path	
	
	xor rcx, rcx
	xor rbx, rbx
	mov rax, rsp
loop:
	add rax, 0x1
	mov bl, [rax]
	cmp rbx, 32
	jne loop
	add rcx, 1
	push rax
	cmp rcx, 1
	je loop
	
	cmp r11d, 1
	je post_open_file_to_write
	
	pop rcx
	pop rbx
	add rbx, 1

	mov rsp, rbp
	
	mov BYTE PTR [rcx], 0x0 

		#open requested file
	mov rdi, rbx
	mov rsi, 0
	mov rax, 2
	syscall	

	push rax
	mov rbp, rsp
	sub rsp, request_buffer_size

		#read requested file
	mov rdi, [rbp]
	mov rsi, rsp
	mov rdx, request_buffer_size
	mov rax, 0
	syscall

	push rax
	
		#close reaquested file
	mov rdi, [rbp]
	mov rax, 3
	syscall


		#write() response
	mov rdi, [rbp+8]
	lea rsi, response
	mov dl, response_size
	mov rax, 1 
	syscall
		#write() response file content
	pop rdx
	mov rdi, [rbp+8]
	mov rsi, rsp
	mov rax, 1 
	syscall
	jmp return_flag

post:
	mov r11d, 1	
	jmp read_path_string

post_open_file_to_write:
	pop rcx
	pop rbx
	add rbx, 1

	#mov rsp, rbp
	
	mov BYTE PTR [rcx], 0x0 

		#open requested file to read 
	mov rdi, rbx
	mov rsi, 1
	xor rsi, 0x40
	mov rdx, 0777
	mov rax, 2
	syscall	

	push rax

		#find POST data location string
	mov rax, rbp
	sub rax, request_buffer_size
	sub rax, 1
	mov ebx, 0x0a0d0a0d
find:
	add rax, 1
	mov ecx, DWORD PTR [rax]
	cmp ebx, ecx
	jne find
	add rax, 4
	push rax
	
		#write file

	pop rbx
	mov rsi, rbx

	sub rbx, rbp
	add rbx, request_buffer_size

	mov rdx, [rsp+8]
	sub rdx, rbx
	
	mov rdi, [rsp]
	mov rax, 1
	syscall

	pop rdi
	mov rax, 3
	syscall

	mov rdi, [rbp]
	lea rsi, response
	xor rdx, rdx
	mov dl, response_size
	mov rax, 1 
	syscall

	mov rdi, [rbp]
	mov rax, 3
	syscall
	jmp exit 


return_flag:
	lea rdi, flag_path
	mov rsi, 0 
	mov rax, 2
	syscall
	
	push rax
		
	mov rdi, [rsp]
	lea rsi, content_of_flag
	mov rdx, flag_size
	mov rax, 0
	syscall

	pop rdi
	mov rax, 3 
	syscall

	mov rdi, 1
	lea rsi, content_of_flag
	mov rdx, flag_size
	mov rax, 1
	syscall
	
	jmp exit
	
exit:
	mov rax, 60
	mov rdi, 0
	syscall
