/*  process_image_asm.S
 
    MI01 - TP Assembleur 2 à 5

    Réalise le traitement d'une image bitmap 32 bits par pixel.
*/

.file "process_image_asm.S"
.intel_syntax noprefix

.text

/***********************************************************************
  Sous-programme process_image_asm 
    
  Réalise le traitement d'une image 32 bits.
  
  Le passage des paramètres respecte les conventions x64 sous Linux
  
  Par registres :

            Largeur de l'image : 			rdi
            Hauteur de l'image : 			rsi
            Pointeur sur l'image source : 	rdx
            Pointeur sur l'image tampon 1 : rcx
            Pointeur sur l'image tampon 2 : r8
            Pointeur sur l'image finale : 	r9
  			n nombre de pixels :			r12

  Les registes rbx, rbp, r12, r13, r14, et r15 doivent être sauvegardés
  si vous les utilisez (sauvegarde par l'appelé). Les autres registres 
  peuvent être modifiés sans risque (sauvegardés par l'appelant).
***********************************************************************/

.global process_image_asm
process_image_asm:

            push rbp
			mov     rbp, rsp
            push rbx
            push r12
            push r13
            push r14
            push r15

			#on calcule la taille en memoire de limage
			mov 	r12, rdi
			imul 	r12, rsi
			#imul	r12, 4

			#on ecrit un truc
			mov 	dword ptr [rcx], 0xffffffff
			mov 	dword ptr [rcx + 10000*4], 0xffffffff
			mov 	dword ptr [rcx + r12*4 -4], 0xffffffff

            pop r15

            pop r14
            pop r13
            pop r12
			pop rbx
			pop rbp

            ret
