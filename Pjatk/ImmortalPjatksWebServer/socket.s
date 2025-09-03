.section .data

sin_family: .word 2
sin_port:
	.word 0x901F
sin_addr:
	.byte 0
	.byte 0
	.byte 0
	.byte 0
__pad:
	.byte 0,0,0,0,0,0,0,0
response: 
	.ascii "HTTP/1.0 200 OK\r\n\r\n"
response_size:
	.quad 19
flag_path:
	.asciz "flag.txt"
flag_path_size:
	.quad 8
request_buffer_size:
	.quad 4096
flag_size:
	.quad 12
header_key:
	.long 0x12345678
host_header:
	#.asciz "Host: "
	#.long 0x74736f48
	#.long 0x0000003a
	.long 0x66473930
	.long 0x12345642
user_agent_header:
	#.asciz "User-Agent: "
	#.long 0x72657355
	#.long 0x6567412d
	#.long 0x003a746e
	.long 0x6051252d
	.long 0x77531755
	.long 0x120e2216
accept_header:
accept_header:
	#.asciz "Accept: "
	.long 0x77573539
	.long 0x120e2208
	#.long 0x65636341
	#.long 0x003a7470
custom_header:
	#.asciz "Niesmiertelna-nawijka-pjatk-skladowa: "
	#.long 0x7365694e
	#.long 0x7265696d
	#.long 0x6e6c6574
	#.long 0x616e2d61
	#.long 0x6b6a6977
	#.long 0x6a702d61
	#.long 0x2d6b7461
	#.long 0x616c6b73
	#.long 0x61776f64
	#.long 0x0000003a
	.long 0x61513f36
	.long 0x60513f15
	.long 0x7c58330c
	.long 0x735a7b19
	.long 0x795e3f0f
	.long 0x78447b19
	.long 0x3f5f2219
	.long 0x73583d0b
	.long 0x7343391c
	.long 0x12345642

flag_checker:
	.word 0
html_page_file:
	.asciz "hello.html"


.section .bss
content_of_flag: 
	.skip 12
html_page:
	.skip 4096# must be same as request_buffer_size

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
	mov rbx, request_buffer_size
	cmp rax, rbx
	jne skip_drain



	push rbp
	mov rbp, rsp
	sub rsp, 1024

drain_rest_of_request:
	mov rdi, [rbp]
	mov rdi, [rdi]
	mov rsi, rsp
	mov rdx, 1024
	mov rax, 0
	syscall 
	cmp rax, 1024
	je drain_rest_of_request

	mov rsp, rbp
	pop rbp

skip_drain:
		#add null ptr at the on of the read request 
	#mov rbx, rsp
	#add rbx, [rsp]
	#add rbx, 9
	#mov BYTE PTR [rbx], 0

		#log request to console
	mov rdi, 1
	mov rsi, rsp
	add rsi, 8
	mov rdx, [rsp]
	mov rax, 1
	syscall
	
	
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

get:
		#read path string 
		# 	rbx - start of path	
		# 	rcx - end of path	
	
	xor rcx, rcx
	xor rbx, rbx
	mov rax, rsp
get_path_string_loop:
	add rax, 0x1
	mov bl, [rax]
	cmp rbx, 32
	jne get_path_string_loop
	add rcx, 1
	push rax
	cmp rcx, 1
	je get_path_string_loop
	
	pop rcx
	pop rbx

		#check if requested file is "/"
	mov r12, rcx
	sub r12, rbx
	mov r13, rbx
	sub r12, 1
	add r13, r12 
	xor rax, rax 
	mov al, [r13]
	cmp al, 0x2F
	jne skip_reading_requested_file

	add rbx, 2
	
	mov BYTE PTR [rcx], 0x0 

		#open requested file
	lea rdi, html_page_file
	mov rsi, 0
	mov rax, 2
	syscall	

	push rax

		#read requested file
	mov rdi, [rsp]
	lea rsi, html_page
	mov rdx, request_buffer_size
	mov rax, 0
	syscall

	push rax

	
		#close reaquested file
	mov rdi, [rsp+8]
	mov rax, 3
	syscall

skip_reading_requested_file:

		#decrypt heaeders
	mov eax, header_key
	lea ebx, host_header
	mov rcx, 0
decrypt_next:
	xor [ebx], eax
	add ebx, 4
	add rcx, 1
	cmp rcx, 17
	jne decrypt_next
	
		#repeat 17 times


		#check for user agent header
	mov rax, rbp
	sub rax, request_buffer_size
	lea rdx, user_agent_header
	call check_for_header

	cmp rcx, 0
	je agent_header_checked
	mov bx, flag_checker
	add bx, 1
	mov WORD PTR flag_checker, bx

agent_header_checked:
		#check for host header
	mov rax, rbp
	sub rax, request_buffer_size
	lea rdx, host_header
	call check_for_header

	cmp rcx, 0
	je host_header_checked
	mov bx, flag_checker
	add bx, 1
	mov WORD PTR flag_checker, bx

host_header_checked:

		#check for accept header
	mov rax, rbp
	sub rax, request_buffer_size
	lea rdx, accept_header
	call check_for_header

	cmp rcx, 0
	je accept_header_checked
	mov bx, flag_checker
	add bx, 1
	mov WORD PTR flag_checker, bx

accept_header_checked:


		#check for accept header
	mov rax, rbp
	sub rax, request_buffer_size
	lea rdx, custom_header
	call check_for_header

	cmp rcx, 0
	je niesmiertelna_nawijka_szczera_checked
	mov bx, flag_checker
	add bx, 1
	mov WORD PTR flag_checker, bx

niesmiertelna_nawijka_szczera_checked:
	

	mov cx, [rbp-2]
	shr cx, 14
	cmp cx, 0
	je is_buffer_full_checked
	add bx, 1
	mov WORD PTR flag_checker, bx

is_buffer_full_checked:

		#write() response
	mov rdi, [rbp]
	lea rsi, response
	xor rdx, rdx
	mov rdx, response_size
	mov rax, 1 
	syscall

		#checking if html_page variable stores any content 
	lea rbx, html_page
	mov bl, [rbx]
	cmp bl, 0
	je skip_writing_file

		#write() response file content
				#MUSZE SPRAWDZIC CZY GET PROSI TYLKO O STRoNE HTTP
	mov rdi, [rbp]
	lea rsi, html_page
	pop rdx
	mov rax, 1 
	syscall
skip_writing_file:
	
	pop rax
	jmp return_flag

post:
	mov rdi, [rbp]
	lea rsi, response
	xor rdx, rdx
	mov rdx, response_size
	mov rax, 1 
	syscall


	jmp return_flag

check_for_header:
	xor rcx, rcx
		# this function will skip first character
		# rax -> address of request string
		# rdx -> address of header 
		# rcx -> will hold return value 0 if no header and addres if there is this header 
	mov bl, BYTE PTR[rdx]
	cmp BYTE PTR[rax], bl
	jne check_for_header_continue
	mov r10, rax
	mov r11, rdx 
check_for_header_loop:
	cmp BYTE PTR [r11], 0
	je check_for_header_positive

	mov bl, BYTE PTR [r11]
	cmp BYTE PTR[r10], bl
	jne check_for_header_continue

	add r10, 1
	add r11, 1
	jmp check_for_header_loop
	
check_for_header_continue:
	add rax, 1
	cmp rax, rbp
	jne check_for_header
	je check_for_header_return
check_for_header_positive:
	mov rcx, rax
check_for_header_return:
	ret

	
return_flag:

	mov bx, flag_checker
	cmp bx,	5
	jne exit 

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

	mov rdi, [rbp]
	lea rsi, content_of_flag
	mov rdx, flag_size
	mov rax, 1
	syscall 

	
	jmp exit
	
exit:
	mov rdi, [rbp]
	mov rax, 3
	syscall

	mov rax, 60
	mov rdi, 0
	syscall
