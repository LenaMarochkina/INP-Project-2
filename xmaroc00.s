; Autor reseni: Elena Marochkina xmaroc00

; Projekt 2 - INP 2022
; Vernamova sifra na architekture MIPS64

; DATA SEGMENT
                .data
login:          .asciiz "xmaroc00"  ; sem doplnte vas login 
cipher:         .space  17  ; misto pro zapis sifrovaneho loginu

params_sys5:    .space  8   ; misto pro ulozeni adresy pocatku
                            ; retezce pro vypis pomoci syscall 5
                            ; (viz nize "funkce" print_string)

; CODE SEGMENT
                .text

                ; ZDE NAHRADTE KOD VASIM RESENIM
main:
                daddi   r4, r0, login   ; vozrovy vypis: adresa login: do r4
	
	            addi r6,r0,0  
                addi r17,r0,1

        loop:
                lb r12,login(r6)	;first value

                slti r21, r12, 97   ;if value is letter
                bnez r21, end       ;end if value is not letter
                slti r21, r12, 121   ;if value is letter
                beqz r21, end       ;end if value is not letter

                bnez r17, odd_step  ;if step is odd
                beqz r17, even_step ;if step is even
 
        odd_step:               
                and r17, r17, r0
                daddi r12, r12, 13  ; +13 
                slti r21, r12, 121  ; if goes beyond the letters
                beqz r21, correction_greater
                
                j cipher_record

        even_step:      
                daddi r17, r17, 1
                daddi r12, r12, -1	; -1
                slti r21, r12, 97   ; if goes beyond the letters
                bnez r21, correction_less
                
                j cipher_record

        correction_greater:     
                daddi r12, r12, -26
                j cipher_record

        correction_less:     
                daddi r12, r12, 26
                j cipher_record

        cipher_record:  
                sb r12, cipher(r6)  ;save value   
                addi r6, r6, 1      ;increase counter
                j loop

        end:
                daddi   r4, r0, cipher
                jal     print_string  ; vypis pomoci print_string - viz nize

                syscall 0   ; halt

print_string:   ; adresa retezce se ocekava v r4
                sw      r4, params_sys5(r0)
                daddi   r14, r0, params_sys5    ; adr pro syscall 5 musi do r14
                syscall 5   ; systemova procedura - vypis retezce na terminal
                jr      r31 ; return - r31 je urcen na return address
