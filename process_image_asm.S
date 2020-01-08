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
			iterateur de pixels :			r13
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

			#on ecrit du blanc en coins et au 10 000
			mov 	dword ptr [rcx], 0xffffffff
			mov 	dword ptr [rcx + 10000*4], 0xffffffff
			mov 	dword ptr [rcx + r12*4-4], 0xffffffff

			#on initialise notre compteur de boucle pour parcourir les pixels
			mov r13, r12

#on mets l'imqge temporaire 2 tout en rouge
debut_boucle:
			mov 	dword ptr [r8 + r13*4-4], 0xff0000ff
			dec r13
			jnz debut_boucle
fin_boucle:

			#on initialise notre compteur de boucle pour parcourir les pixels
			mov r13, r12

			#I=R×0,2126+V×0,7152+B×0,0722

			#0.2126 *256 = 54 = 0x36
			#0.7152 *256 = 183 = 0xB7
			#0.0722 *256 = 18 = 0x12

			#on va multiplier par ce qu on vient de trouver puis shift pour mettre la virgule au bon endroit


debut_boucle2:
			#zx signifie que les bits non utilises seront mis a 0, c'est comme move un 0x00000000 avant
			movzx 	r14, byte ptr [rdx + r13*4 - 4 ]  // on lit la composante rouge et stock dans r14
			#on multiplie par le coef multiplicateur qui vq bien
			imul 	r14, 0x36

			#idem
			movzx	r15, byte ptr [rdx + r13*4 -4 + 1 ]  // composante verte
			imul 	r15, 0xB7

			#on somme les composantes
			add 	r14, r15

			movzx 	r15, byte ptr [rdx + r13*4 -4 + 2]  // composante bleue
			imul 	r15, 0x12

			add 	r14,r15

			#vu qu on a multiplie par des entier bien plus grands que nos coefs multiplicqteurs, on shift pour remettre la
			#vigule au bon endroit:
			shr 	r14, 8

			#on ecrtit l'intensite dans l'image
			mov 	byte ptr [rcx + r13 * 4 - 4], r14b
			mov 	byte ptr [rcx + r13 * 4 - 3], r14b
			mov 	byte ptr [rcx + r13 * 4 - 2], r14b
			#on mets le canal alpha au max
			mov 	byte ptr [rcx + r13 * 4 - 1], 0xff

			dec r13
			jnz debut_boucle2
fin_boucle2:

            pop r15
            pop r14
            pop r13
            pop r12
			pop rbx
			pop rbp

            ret
