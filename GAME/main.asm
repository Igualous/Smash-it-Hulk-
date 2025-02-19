#########################################################################
#									#
#	Universidade de Brasilia - Instituto de Ciencias Exatas		#
#		  Departamento de Ciencia da Computacao  		#
#									#
#	     Introducao aos Sistemas Computacionais - 2024.2		#
#		    Professor: Marcus Vinicius Lamar			#
#									#
#	 	Alunos: Igor, Guilherme e Joao Paulo			#
#								        #
#		       	    SMASH IT, HULK!		     		#
#			 						#
#########################################################################
.data
# inclusao da soundtrack


# lista de nota, duracao, nota2, duracao2, ..
NOTAS:	#68 notas
	#Tema 2(11 notas por linha = 44)
	60,2200,67,550,65,500,63,600,65,500,67,700,60,1700,67,550,65,500,63,700,62,700,
	60,2200,67,550,65,500,63,600,65,500,67,700,60,1700,67,550,65,500,63,700,62,700,
	72,2200,79,550,77,500,75,600,77,500,79,700,72,1700,79,550,77,500,75,700,74,700,
	72,2200,79,550,77,500,75,600,77,500,79,700,72,1700,79,550,77,500,75,700,74,700,
	#Ponte (8 notas por linha = 24)
	63,300,60,300,60,300,63,300,63,300,60,300,60,300,63,300,
	63,300,60,300,60,300,63,300,63,300,60,300,60,300,63,300,
	46,300,48,800,48,300,50,800,58,300,60,800,60,300,62,800,
NOTAS_FINAL:	#28 notas
	72,2500,72,500,72,750,79,250,77,2010,75,1000,74,1000,72,2500,72,500,72,750,79,250,81,1000,77,1000,79,2010,
	84,2500,84,500,84,750,91,250,89,2010,87,1000,86,1000,84,2500,84,500,84,750,91,250,93,1000,89,1000,91,4000,
NOTAS_VITORIA:
	84,50,88,50,91,50,96,850
NOTAS_DERROTA:
	61,2000,59,2000,63,2000,61,2000,59,500,61,500,63,500,66,500,64,500,71,500,64,500,62,1500,61,1500,69,400,68,500,66,400,65,500,66,400,68,500,63,500,66,1500,64,2500

#inclusao das imagens
.include"../DATA/fundo1_brokee.data"
.include "../DATA/fundo1.data"
.include "../DATA/fundo2.data"
.include "../DATA/hulk_ativo.data"
.include "../DATA/hulk_parado.data"
.include "../DATA/laser1.data"
.include "../DATA/laser2.data"
.include "../DATA/loki_ativo.data"
.include "../DATA/loki_parado.data"
.include "../DATA/loki_fundo.data"
.include "../DATA/chitauri.data"
.include "../DATA/projetil.data"
.include "../DATA/portal1.data"
.include "../DATA/portal2.data"
.include "../DATA/janela.data"
.include "../DATA/janela_quebrada.data"
.include "../DATA/porta.data"
.include "../DATA/porta_quebrada.data"
.include "../DATA/tela_inicio.data"
.include "../DATA/tela_vit.data"
.include "../DATA/tela_derrota_at.data"
.include "../DATA/hulk_cabeca.data"
.include "../DATA/hulk_morte.data"
.include "../DATA/score.data"
.include "../DATA/tabela_hud.data"
.include "../DATA/taco.data"
.include "../DATA/hulk_ver_parado.data"
.include "../DATA/hulk_ver_ativo.data"
.include "../DATA/capitao_hulk.data"
.include "../DATA/capitao_smash.data"
.include "../DATA/atk.data"

# NUMEROS DE SCORE
.include "../DATA/um.data"
.include "../DATA/dois.data"
.include "../DATA/tres.data"
.include "../DATA/quatro.data"
.include "../DATA/cinco.data"
.include "../DATA/seis.data"
.include "../DATA/sete.data"
.include "../DATA/oito.data"
.include "../DATA/nove.data"
.include "../DATA/dez.data"
.include "../DATA/onze.data"
.include "../DATA/doze.data"
.include "../DATA/treze.data"
.include "../DATA/quatorze.data"
.include "../DATA/quinze.data"
.include "../DATA/dezesseis.data"
.include "../DATA/dezessete.data"
.include "../DATA/dezoito.data"


#############  SETUP INICIAL
# posicoes iniciais

HULK_POS:            .word 85,200
OLD_HULK_POS:    .word 85,200

LOKI_POS:	.word 130,18
OLD_LOKI_POS:	.word 130,18
LOKI_CONT: 	.word 0
PROJETIL_MOVE:   .word 0

LASER_CONT: .word 0

PROJETIL_POS: .word 120, 23
PROJETIL_CONT: .word 0
projetil_ativo_cont: .word 0


VERIFICA_FASE: .word 0

CHITAURI_POS:	.word 280,140
CHITAURI_ATIVO: .word 0	# 0 - padrao; 1 - ativo
CHITAURI_MOVE: .word 0 # verificador que fara com que o chitauri continue se movendo
CHIT_CONT: .word 0

# endereco da janela[0][0]
janelaX: 	.word 90
janelaY:	.word 70

J1_BROKE: .word 0
J2_BROKE: .word 0
J3_BROKE: .word 0


JANELAS_QUEBRADAS: .word 0,0,0,0,0,0,0,0,0 # 0 = inteira; 1 = quebrada
contagem: .word 0
pontos: .word 0,0 #A segunda parte dos pontos avalia se o taco foi usado
vidas: .word 3	# vidas iniciais: 3
fase: .word 0

invencivel:		 .word 0	# padrao = 0; invencivel = 1
invencivel_cont: .word 0	# 0 a 30000000
tacos:			 .word 0	# max: 1
##############
.text
INICIO: # endereco para reiniciar o jogo
#### START
# Carrega tela de menu
la a4,fase			# define a4 como numero da fase
li t1,0xFF000000    # endereco inicial da Memoria VGA - Frame 0
li t2,0xFF012C00    # endereco final 
la t4, tela_inicio          # endere?o dos dados da tela na memoria
addi t4,t4,8        # primeiro pixels depois das informacoes de nlin ncol
LOOP5:     beq t1,t2, mainMenuSelect        # Se for o ultimo endereco entao sai do loop
lw t3,0(t4)        # le um conjunto de 4 pixels : word
sw t3,0(t1)        # escreve a word na mem?ria VGA
addi t1,t1,4        # soma 4 ao endere?o
addi t4,t4,4
j LOOP5
mainMenuSelect:
MUSIC:
    
    li s1,68        # le o numero de notas em s1
    la s0,NOTAS        # define o endere?o das notas
    li a2,48        # define o instrumento
    li a3,127        # define o volume
    li t0, 0

LOOP_NOTAS:    
	bge t0,s1, DONE_MUSIC        # contador chegou no final? ent?o  v? para FIM
    lw a0,0(s0)        # le o valor da nota
    lw a1,4(s0)        # le a duracao da nota

	li t3, 0xFF200000    # carrega em t3 o endereco do status do teclado.
    lb t1, 0(t3)         #carrega o status do teclado em t1
    andi t1, t1, 1       #verificar apenas o bit 0 (tecla pressionada)
    bne t1, zero, VERIFICAR_TECLA #se uma tecla foi pressionada, verifica qual foi
    
    li a7,31        # define a chamada de syscall
    ecall            # toca a nota
    
    mv a0,a1        # passa a dura??o da nota para a pausa
    li a7,32        # define a chamada de syscal 
    ecall            # realiza uma pausa de a0 ms
    
    addi s0,s0,8        # incrementa para o endere?o da pr?xima nota
    
    addi t0,t0,1        # incrementa o contador de notas
	j LOOP_NOTAS

VERIFICAR_TECLA:
    lb t1, 4(t3)        		 # carrega o status do teclado em t1

    li t2, 0x031         		#valor do 1 na tabela ASCII
    beq t1, t2, CARREGA_FUNDO #se 1 foi pressionado, interrompe a musica e carrega a fase

    j LOOP_NOTAS          #se nao, continua tocando as notas

DONE_MUSIC:
        # Codigo abaixo obtem a entrada
        li    t3, 0xFF200000 # carrega em t3 o endere?o do status do teclado.
        lb     t1, 0(t3) # carrega o status do teclado em t1.

        andi    t1, t1, 1 # isso eh um processo de mascaramento. Apenas queremos saber sobre o primeiro bit de t1, que indica se alguma tecla foi pressionada.

        beq    t1, zero, mainMenuSelect #se a tecla 1 n?o foi pressionada, volta a verificar at? que a mesma seja acionada

        lb    t1, 4(t3) #ao ser pressionado, carrega 1 em t1 para fins de compara??o

        li    t2, 0x031 #valor do 1 na tabela ASCII
        beq    t1, t2, CARREGA_FUNDO #se o que tiver sido registrado no teclado foi 1, carrega a fase

        li    t2, 0x032 #valor do 2 na tabela ASCII
        bne    t1, t2, continueMMSelect #Se o numero digitado n?o foi 2 nem 1, volta a esperar um input valido 
        j    END #se o input tiver sido 2, encerra o programa 
    continueMMSelect:
        j    LOOP_NOTAS
        
        
# Carrega a fase 1 em ambos os frames
CARREGA_FUNDO:
	la t0, fase
	lw t1, 0(t0)
	bnez t1, PULA_CAP
	la a0, capitao_hulk
	li a1, 0
	li a2, 0
	jal renderImage

	li a7, 32
	li a0, 2000
	ecall

	la a0, capitao_smash
	li a1, 0
	li a2, 0
	jal renderImage

	li a7, 32
	li a0, 2000
	ecall
	PULA_CAP:

	li t1,0xFF000000	# endereco inicial da Memoria VGA - Frame 0
	li t2,0xFF012C00	# endereco final 
	lw t0,0(a4)			
	beqz t0,FUNDO1		# verifica a fase
	la t4,fundo2
	j CONTINUAR_FUNDO
	FUNDO1: la t4,fundo1		# endere?o dos dados da tela na memoria
	CONTINUAR_FUNDO: addi t4,t4,8		# primeiro pixels depois das informa??es de nlin ncol
LOOP1: 	beq t1,t2,DONE		# Se for o ultimo endereco ent?o sai do loop
	lw t3,0(t4)		# le um conjunto de 4 pixels : word
	sw t3,0(t1)		# escreve a word na mem?ria VGA
	addi t1,t1,4		# soma 4 ao endereco
	addi t4,t4,4
	j LOOP1			# volta a verificar

DONE:
	lw t0,0(a4)
	beqz t0,PRINT_JANELAS		# se a fase for 0 (1), printa as janelas nos status da fase 1
	la t1,JANELAS_QUEBRADAS
	sw zero,0(t1)				# zera todas as janelas para a fase 2
	sw zero,4(t1)
	sw zero,8(t1)
	sw zero,12(t1)
	sw zero,16(t1)
	sw zero,20(t1)
	sw zero,24(t1)
	sw zero,28(t1)
	sw zero,32(t1)
	j PRINT_PORTAIS
	
# Renderiza as janelas
PRINT_JANELAS:

	# janela 1
	la t0, JANELAS_QUEBRADAS
	lw t1, 0(t0)
	bnez t1, QUEBRADA1
	la a0, janela
	j DONE_JAN1
	QUEBRADA1:
	la a0, janela_quebrada
	DONE_JAN1:
	lw a1, janelaX	# x = 90
	lw a2, janelaY	# y = 70
	jal renderImage
	
	# janela 2
	la t0, JANELAS_QUEBRADAS
	lw t1, 4(t0)
	bnez t1, QUEBRADA2
	la a0, janela
	j DONE_JAN2
	QUEBRADA2:
	la a0, janela_quebrada
	DONE_JAN2:
	addi a1, a1, 50
	jal renderImage
	
	
	# janela 3
	la t0, JANELAS_QUEBRADAS
	lw t1, 8(t0)
	bnez t1, QUEBRADA3
	la a0, janela
	j DONE_JAN3
	QUEBRADA3:
	la a0, janela_quebrada
	DONE_JAN3:
	addi a1, a1, 50
	jal renderImage
	
	# janela 4
	la t0, JANELAS_QUEBRADAS
	lw t1, 12(t0)
	bnez t1, QUEBRADA4
	la a0, janela
	j DONE_JAN4
	QUEBRADA4:
	la a0, janela_quebrada
	DONE_JAN4:
	addi a2, a2, 60
	addi a1, a1, -100
	jal renderImage
	
	# janela 5
	la t0, JANELAS_QUEBRADAS
	lw t1, 16(t0)
	bnez t1, QUEBRADA5
	la a0, janela
	j DONE_JAN5
	QUEBRADA5:
	la a0, janela_quebrada
	DONE_JAN5:
	addi a1, a1, 50
	jal renderImage
	
	# janela 6
	la t0, JANELAS_QUEBRADAS
	lw t1, 20(t0)
	bnez t1, QUEBRADA6
	la a0, janela
	j DONE_JAN6
	QUEBRADA6:
	la a0, janela_quebrada
	DONE_JAN6:
	addi a1, a1, 50
	jal renderImage
	
	# janela 7
	la t0, JANELAS_QUEBRADAS
	lw t1, 24(t0)
	bnez t1, QUEBRADA7
	la a0, janela
	j DONE_JAN7
	QUEBRADA7:
	la a0, janela_quebrada
	DONE_JAN7:
	addi a2, a2, 60
	addi a1, a1, -100
	jal renderImage
	
	# janela 8
	la t0, JANELAS_QUEBRADAS
	lw t1, 28(t0)
	bnez t1, QUEBRADA8
	la a0, janela
	j DONE_JAN8
	QUEBRADA8:
	la a0, janela_quebrada
	DONE_JAN8:
	addi a1, a1, 100
	jal renderImage
	
	# porta / janela 9
	lw t3, 0(a4)				
	bnez t3,FASE2_JANELA9		
	la t0, JANELAS_QUEBRADAS		
	lw t1, 32(t0)				
	bnez t1, QUEBRADA9			
	la a0, porta
	j DONE_JAN9
	QUEBRADA9:
	la a0, porta_quebrada
	DONE_JAN9:
	lw a1, janelaX
	addi a1, a1, 50
	lw a2, janelaY
	addi a2, a2, 115
	j FIM_JANELA9

	FASE2_JANELA9:
	la t0, JANELAS_QUEBRADAS		
	lw t1, 32(t0)				
	bnez t1, QUEBRADA9_FASE2			
	la a0, janela
	j DONE_JAN9_FASE2
	QUEBRADA9_FASE2:
	la a0, janela_quebrada
	DONE_JAN9_FASE2:
	lw a1, janelaX
	addi a1, a1, 50
	lw a2, janelaY
	addi a2, a2, 120
	FIM_JANELA9:

	jal renderImage
	
# Renderiza Loki no Bitmap
PRINT_LOKI:
        addi s11,s11,1
       
	la a0, loki_parado 
	la t0, LOKI_POS
	lw a1, 0(t0)
	lw a2, 4(t0)
	
	jal renderImage
# Renderiza Hulk no Bitmap
PRINT_HULK:
	jal SET_SPRITE_HULK #carrega o tamanho da imagem em a0
	la t0, HULK_POS  #carrega em t0 a word que contem as posicoes xy do hulk
	lw a1, 0(t0)  #carrega em t0 o numero que esta na primeira word de HULK_POS(esse numero e a posicao x)
	lw a2, 4(t0)  #carrega em t0 o numero que esta na segunda word(offset da word = 4) de HULK_POS(esse numero e a posicao y)
	
	jal renderImage

# INICIALIZA O HUD
    j PRINTA_SCORE
    FIM_SCORE:
	j PRINTA_VIDAS
	# contagem para a movimentacao do chitauri
        la t0, CHIT_CONT
        lw t1, 0(t0)
        addi t1, t1, 1	#  CHIT_CONT += 1
        sw t1, 0(t0)	# registra a contagem
###### GAME LOOP PRINCIPAL ######### 
GAME_LOOP:  

	#IMPORTANTE!!!!!!!
		#Ainda nao implementado[
		#A alteracao dos valores contidos nos registradores s4 e s5 deve ser evitada.
		#Esses dois registradores agirao como argumentos de comparacao para saber se 
		#o hulk esta ou nao em alguma das bordas dos mapas. Vamos tentar achar uma solucao pra isso
	#]

            
       li s4, 85 #posicao X da borda esquerda, ou seja, se ele estiver na coluna 85, movimentos para a esquerda sao bloqueados
       li s5, 200 #posicao y da borda inferior, ou seja, se ele estiver na linha 200, movimentos para baixo sao bloqueados
       li s8, 185
       li s9, 80
	# 1: acoes do player
	jal KEY
	
	# 2: verifica colisoes
	j VER_INVENCIVEL
	INV_CHECK:

	jal VER_COLISAO
	# 3: movimentacao inimigos
	#garante que Loki nao atire enquanto chitauri esta ativo
	lw t0,CHITAURI_MOVE
	li t1,0
	li t2,1
	beq t1,t0,LASERSZ
	beq t2,t0,LASERSZ

	j LOKI_CHECK
	
	
	LOKI_PRINT:
	
	RESTAURA_FUNDO_PROJETIL:

   la t0,PROJETIL_POS
   lw a1,0(t0)
   lw a2,4(t0)
    # Carregar endereco do fundo
    lw t3,VERIFICA_FASE #verifica se esta na fase 1 ou 2
    li t4,1
    beq t4,t3,LVL_2
    la t0, fundo1_brokee  # Endereco do fundo
    addi t0, t0, 8
    j LVL_1
    
    LVL_2:
    la t0,fundo2
    addi t0,t0,8
    
LVL_1:

    # Calcular o endereco inicial no fundo
    li t2, 320  # Largura do fundo
    mul t3, a2, t2  # Y * largura do fundo
    add t3, t3, a1  # Y * largura + X
    add t0, t0, t3  # Endereco inicial no fundo

 # Endereço inicial na VGA
    li t1, 0xFF000000
    add t1, t1, t3  # Mesmo cálculo sem header
   
    
    # Loop para copiar a regiao do fundo para a VGA
    li t4, 8  # Altura do Chitauri
     li t5, 8  # Largura do Chitauri

RESTAURA_LINHAZ:

    beqz t4, FIM_RESTAURAZ  # Se terminou todas as linhas, encerrar

    

RESTAURA_COLUNAZ:

    beqz t5, PROXIMA_LINHAZ  # Se terminou todas as colunas ir para a proxima linha

    lb t3, 0(t0)  # Carrega o pixel do fundo(por conta da word de altura e largura, deve-se adiantar 8 pixels)
    #o numero do tamanho da tela esta dobrado para evitar bugs do print
    sb t3, 0(t1)  # Escreve o pixel na VGA
    
 
	
    addi t0, t0, 1  # Proximo pixel no fundo
    addi t1, t1, 1  # Proximo pixel na VGA
    
    addi t5, t5, -1  # Decrementa largura restante
    
    j RESTAURA_COLUNAZ

PROXIMA_LINHAZ:
    addi t4, t4, -1  # Decrementa altura restante
    addi t0, t0, 312  # Avanca para a proxima linha no fundo (320 - 34)
    addi t1, t1, 312  # Avanca para a proxima linha na VGA (320 - 34)
    li t5, 8  # Reseta a largura
    j RESTAURA_LINHAZ
    
FIM_RESTAURAZ:
  
  
       la t0,PROJETIL_POS #posicao atual do chitauri
       lw t1,4(t0)  #carrega em a1 a posicao do chitauri (argumento para print)
       li t2,239   #verificara se ja chegou na ultima posicao do mapa
  
        beq t2,t1,PROJETIL_ERASE #se ele chegou no final, apaga
           lw t1, 4(t0)           # Pega coordenada Y    
          addi t1,t1,1 # move uma coluna da animacao
          sw t1,4(t0) #atualiza a posicao do chitauri
 
	la a0, atk #carrega o tamanho da imagem em a5
	la t0, PROJETIL_POS  #carrega em t0 a word que contem as posicoes xy do chitauri
	lw a1, 0(t0)  #carrega em t0 o numero que esta na primeira word de CHITAURI_POS(esse numero e a posicao x)
	lw a2, 4(t0)  #carrega em t0 o numero que esta na segunda word(offset da word = 4) de CHITAURI_POS(esse numero e a posicao y)
	
	jal renderImage #apos colocar todos os argumentos necessarios
	
        li a7,32 #ecall de pausa
        li a0,1 #1 milesimo por pixel
        ecall
        
      

  # reafirma posicao hulk
	la t0, HULK_POS
	lw a1, 0(t0)
	lw a2, 4(t0)
	
	LOKI_END:
	
	
	
	LASERSZ:
	j PRINT_LASER
	LASER_CHECK:

	j CHIT_CHECK
	CHITAURI_PRINT:
         # Funcaoo para restaurar o fundo na regiao ocupada pelo Chitauri
# Argumentos:
# a0: endereco do fundo
# a1: posicao X do Chitauri
# a2: posicao Y do Chitauri


RESTAURA_FUNDO_CHITAURI:

   la t0,CHITAURI_POS
   lw a1,0(t0)
   lw a2,4(t0)
    # Carregar endereco do fundo
    lw t3,VERIFICA_FASE #verifica se esta na fase 1 ou 2
    li t4,1
    beq t4,t3,LVL_2z
    la t0, fundo1_brokee  # Endereco do fundo
    addi t0, t0, 8
    j LVL_1z
    
    LVL_2z:
    la t0,fundo2
    addi t0,t0,8
    
LVL_1z:
    # Carregar endereco do fundo
    la t0, fundo1_brokee  # Endereco do fundo
    li t1, 0xFF000000  # Endereco inicial da Memoria VGA - Frame 0

    # Calcular o endereco inicial no fundo
    li t2, 320  # Largura do fundo
    mul t3, a2, t2  # Y * largura do fundo
    add t3, t3, a1  # Y * largura + X
    add t0, t0, t3  # Endereco inicial no fundo


   
    # Calcular o endereco inicial na VGA
    mul t3, a2, t2  # Y * largura do fundo
    add t3, t3, a1  # Y * largura + X
    add t1, t1, t3  # Endereco inicial na VGA

    # Loop para copiar a regiao do fundo para a VGA
    li t4, 34  # Altura do Chitauri
     li t5, 34  # Largura do Chitauri

RESTAURA_LINHA:

    beqz t4, FIM_RESTAURA  # Se terminou todas as linhas, encerrar

    

RESTAURA_COLUNA:

    beqz t5, PROXIMA_LINHA  # Se terminou todas as colunas ir para a proxima linha

    lb t3, 648(t0)  # Carrega o pixel do fundo(por conta da word de altura e largura, deve-se adiantar 8 pixels)
    #o numero do tamanho da tela esta dobrado para evitar bugs do print
    sb t3, 0(t1)  # Escreve o pixel na VGA
    
 
	
    addi t0, t0, 1  # Proximo pixel no fundo
    addi t1, t1, 1  # Proximo pixel na VGA
    
    addi t5, t5, -1  # Decrementa largura restante
    
    j RESTAURA_COLUNA

PROXIMA_LINHA:
    addi t4, t4, -1  # Decrementa altura restante
    addi t0, t0, 286  # Avanca para a proxima linha no fundo (320 - 34)
    addi t1, t1, 286  # Avanca para a proxima linha na VGA (320 - 34)
    li t5, 34  # Reseta a largura
    j RESTAURA_LINHA
    
FIM_RESTAURA:

	la a0, chitauri #carrega o tamanho da imagem em a5
	la t0, CHITAURI_POS  #carrega em t0 a word que contem as posicoes xy do chitauri
	lw a1, 0(t0)  #carrega em t0 o numero que esta na primeira word de CHITAURI_POS(esse numero e a posicao x)
	lw a2, 4(t0)  #carrega em t0 o numero que esta na segunda word(offset da word = 4) de CHITAURI_POS(esse numero e a posicao y)
	
	jal renderImage #apos colocar todos os argumentos necessarios
	
        li a7,32 #ecall de pausa
        li a0,1 #1 milesimo por pixel
        ecall
        
        MOV_CHITAURI:
  
       la t0,CHITAURI_POS #posicao atual do chitauri
       lw t1,0(t0)  #carrega em a1 a posicao do chitauri (argumento para print)
       li t2,-1   #verificara se ja chegou na ultima posicao do mapa
  
 beq t2,t1,CHITAURI_ERASE #se ele chegou no final, apaga
     
 addi t1,t1,-1 # move uma coluna da animacao
 sw t1,0(t0) #atualiza a posicao do chitauri

  # reafirma posicao hulk
	la t0, HULK_POS
	lw a1, 0(t0)
	lw a2, 4(t0)
	
	CHIT_END:
	# 4: verifica vitoria ou derrota
	jal VER_VITORIA
	jal VER_DERROTA

	j GAME_LOOP
###### ################### #########	
END:
	li a7, 10
	ecall
		
#### RENDERIZACAO DE IMAGENS 
renderImage:
	# Argumentos da fun??o:
	# a0 cont?m o endere?o inicial da imagem
	# a1 cont?m a posi??o X da imagem
	# a2 cont?m a posi??o Y da imagem
	
	
	lw		s0, 0(a0) # Guarda em s0 a largura da imagem
	lw		s1, 4(a0) # Guarda em s1 a altura da imagem
	
	mv		s2, a0 # Copia o endere?o da imagem para s2
	addi	s2, s2, 8 # Pula 2 words - s2 agora aponta para o primeiro pixel da imagem
	
	li		s3, 0xff000000 # carrega em s3 o endere?o do bitmap display frame 0
	
	li		t1, 320 # t1 ? o tamanho de uma linha no bitmap display
	mul		t1, t1, a2 # multiplica t1 pela posi??o Y desejada no bitmap display.
	# Multiplicamos 320 pela posi??o desejada para obter um offset em rela??o ao endere?o inicial do bimap display correspondente ? linha na qual queremos desenhar a imagem. Basta agora obter mais um offset para chegar at? a coluna que queremos. Isso ? mais simples, basta adicionar a posi??o X.
	add		t1, t1, a1
	# t1 agora tem o offset completo, basta adicion?-lo ao endere?o do bitmap.
	add		s3, s3, t1
	# O endere?o em s3 agora representa exatamente a posi??o em que o primeiro pixel da nossa imagem deve ser renderizado.

	blt		a1, zero, endRender # se X < 0, n?o renderizar
	blt		a2, zero, endRender # se Y < 0, n?o renderizar
	
	li		t1, 320
	add		t0, s0, a1
	bgt		t0, t1, endRender # se X + larg > 320, n?o renderizar
	
	li		t1, 240
	add		t0, s1, a2
	bgt		t0, t1, endRender # se Y + alt > 240, n?o renderizar
	
	li		t1, 0 # t1 = Y (linha) atual
	lineLoop:
		bge		t1, s1, endRender # Se terminamos a ?ltima linha da imagem, encerrar
		li		t0, 0 # t0 = X (coluna) atual
		
		columnLoop:
			bge		t0, s0, columnEnd # Se terminamos a linha atual, ir pra pr?xima
			
			lb		t2, 0(s2) # Pega o pixel da imagem
			sb		t2, 0(s3) # P?e o pixel no display
			
			# Incrementa os endere?os e o contador de coluna
			addi	s2, s2, 1
			addi	s3, s3, 1
			addi	t0, t0, 1
			j		columnLoop
			
		columnEnd:
		
		addi	s3, s3, 320 # pr?xima linha no bitmap display
		sub		s3, s3, s0 # reposiciona o endere?o de coluna no bitmap display (subtraindo a largura da imagem). Note que essa subtra??o ? necess?ria - verifique os efeitos da aus?ncia dela voc? mesmo, montando esse c?digo.
		
		addi	t1, t1, 1 # incrementar o contador de altura
		j		lineLoop
		
	endRender:
	
	ret
	
### Apenas verifica se h? tecla pressionada (ideal para jogo dinamico)
KEY:	li t1,0xFF200000		# carrega o endere?o de controle do KDMMIO
	lw t0,0(t1)			# Le bit de Controle Teclado
	andi t0,t0,0x0001		# mascara o bit menos significativo
   	beq t0,zero,FIM_KEY   	   	# Se n?o h? tecla pressionada ent?o vai para FIM
  	lw t2,4(t1)  			# le o valor da tecla tecla
	sw t2,12(t1)  			# escreve a tecla pressionada no display (controle)
	
	li t0,'w'
	
	beq t2,t0,CHAR_CIMA		# se tecla pressionada for 'w', chama CHAR_CIMA
	
	li t0,'a'
	beq t2,t0,CHAR_ESQ		# se tecla pressionada for 'a', chama CHAR_ESQ
	
	li t0,'s'
	beq t2,t0,CHAR_BAIXO		# se tecla pressionada for 's', chama CHAR_BAIXO
	
	li t0,'d'
	beq t2,t0,CHAR_DIR		# se tecla pressionada for 'd', chama CHAR_DIR
	
	
         
	li t0, 'e'
	beq t2, t0, QUEBRA_JAN

	li t0, 'v'
	beq, t2, t0, PERDE_PONTO

	li t0, 'i'
	beq, t2, t0, SET_INVENCIVEL

	li t0, 'z'
	beq t2, t0, CHEAT_FASE2

	li t0, 'x'
	beq t2, t0, CHEAT_GAMEOVER_SCREEN

	li t0, 'c'
	beq t2, t0, ZEROU

	li t0, 't'
	beq t2, t0, CHEAT_POWERUP



FIM_KEY:	ret				# retorna

# FUNCOES DE MOVIMENTACAO


#NOTAS:
#a partir de agora, a posicao atualizada do hulk esta guardada em s6 
#Os registradores a0,a1 e a2 sao os argumentos passados para a funcao print

CHAR_CIMA:
  # reafirma posicao hulk
	la t0, HULK_POS
	lw a1, 0(t0)
	lw a2, 4(t0)

    jal SET_SPRITE_HULK #carrega as dimensoes do hulk em a0
	la s6,HULK_POS #posicao atual
	lw t2,0(s6) #passa a posicao antes do movimento para a antiga
	lw a2, 4(s6)  #carrega em a2 a posicao y atual do personagem
	addi a2, a2, -60 #move o hulk 
	blt a2,s9,PARA #limite do mapa
	lw t0,0(a4)	#verifica a fase
	beqz t0,CIMA_FASE1	#se for a fase1 pula essa parte

	#Impedindo o hulk de subir pelo obst?culo
	lw t0,4(s6) #guarda em t0 o y atual do hulk
	li t1,140 #guarda 140 em t1
	beq t0,t1,PARA #se for 140, impede de subir

	CIMA_FASE1:
	jal renderImage #renderiza o sprite na nova posicao
	sw a2, 4(s6) # atualiza a posicao y do personagem
	j PRINT_JANELAS
	j GAME_LOOP #volta para o gameloop
	#ret
	PARA:
	addi a2,a2,60
	j GAME_LOOP
	
CHAR_ESQ:
  # reafirma posicao hulk
	la t0, HULK_POS
	lw a1, 0(t0)
	lw a2, 4(t0)

	jal SET_SPRITE_HULK #carrega as dimensoes do hulk em a0
	la s6,HULK_POS
	lw a1,0(s6)        #carrega em a1 a posicao x atual do personagem
    addi a1, a1, -50   #move o hulk para esquerda
    blt a1,s4,PARA2     #limite do mapa
	ESQ_FASE1:
	jal renderImage    #renderiza o sprite na nova posicao
	sw a1, 0(s6)       # atualiza a posicao x do personagem
	j PRINT_JANELAS
	j GAME_LOOP
	#ret
	PARA2:
	addi a1,a1,50
	lw t0,0(a4)	#verifica a fase
	beqz t0,ESQ_FASE1	#se for a fase1 pula essa parte

	#Verificando y do hulk para o portal
	lw t0,4(s6)	#guarda em t0 o y atual do hulk
	li t1,80 #y=80 requisito 1 para que o hulk entre no portal
	bne t0,t1,ESQ_FASE1 #se n?o cumprir o requisito, ? como se estivesse na fase 1

	#Teleportando o hulk
	addi a1,a1,100
	li a2,200
	sw a2, 4(s6)	   # atualiza a posicao y do personagem 

	j ESQ_FASE1
	
CHAR_BAIXO:
  # reafirma posicao hulk
	la t0, HULK_POS
	lw a1, 0(t0)
	lw a2, 4(t0)

    jal SET_SPRITE_HULK #carrega as dimensoes do hulk em a0
    la s6,HULK_POS
	lw a2, 4(s6)       #carrega em a2 a posicao y atual do personagem
	addi a2, a2, 60   #move o hulk para baixo
	bgt a2,s5,PARA3   #limite do mapa
	lw t0,0(a4)	#verifica a fase
	beqz t0,BAIXO_FASE1	#se for a fase1 pula essa parte

	#Impedindo o hulk de descer pelo obst?culo
	lw t0,4(s6) #guarda em t0 o y atual do hulk
	li t1,80 #guarda 80 em t1
	beq t0,t1,PARA3 #se for 80, impede de descer

	BAIXO_FASE1:
	jal renderImage    #renderiza o sprite na nova posicao
	sw a2, 4(s6)       # atualiza a posicao y do personagem
	j PRINT_JANELAS
	j GAME_LOOP        #volta para o gameloop
	#ret
	PARA3:
	addi a2,a2,-60
	j GAME_LOOP

CHAR_DIR:
  # reafirma posicao hulk
	la t0, HULK_POS
	lw a1, 0(t0)
	lw a2, 4(t0)

	jal SET_SPRITE_HULK #carrega as dimensoes do hulk em a0
	la s6,HULK_POS
	lw a1,0(s6)        #carrega em a1 a posicao x atual do personagem
    addi a1, a1, 50    #move o hulk para direita
	bgt a1,s8,PARA4     #limite do mapa
	DIR_FASE1:
	jal renderImage    #renderiza o sprite na nova posicao
	sw a1, 0(s6)       # atualiza a posicao x do personagem
	
	j PRINT_JANELAS
	j GAME_LOOP
	#ret
	PARA4:
	addi a1,a1,-50
	lw t0,0(a4)	#verifica a fase
	beqz t0,DIR_FASE1	#se for a fase1 pula essa parte

	#Verificando y do hulk para o portal
	lw t0,4(s6)	#guarda em t0 o y atual do hulk
	li t1,200 #y=200 requisito 1 para que o hulk entre no portal
	bne t0,t1,DIR_FASE1 #se n?o cumprir o requisito, ? como se estivesse na fase 1

	#Teleportando o hulk
	addi a1,a1,-100
	li a2,80
	sw a2, 4(s6)	   # atualiza a posicao y do personagem 
	
	j DIR_FASE1
	

QUEBRA_JAN:
       
      
	jal SET_HULK_ATIVO #carrega o tamanho da imagem em a0
	la t0, HULK_POS  #carrega em t0 a word que contem as posicoes xy do hulk
	lw a1, 0(t0)  #carrega em t0 o numero que esta na primeira word de HULK_POS(esse numero e a posicao x)
	lw a2, 4(t0)  #carrega em t0 o numero que esta na segunda word(offset da word = 4) de HULK_POS(esse numero e a posicao y)
	
	jal renderImage
       li a7,32
       li a0,100
       ecall
       
       # efeito sonoro
	    li a0, 40    # define a nota
	    li a1,800        # define a dura??o da nota em ms
	    li a2,127        # define o instrumento
	    li a3,127        # define o volume
	    li a7,31        # define o syscall
	    ecall            # toca a nota
       
	la s0, contagem
	lw s2, 0(s0)	# s2 = contagem geral

	la t0, HULK_POS
	li s1, 1
	lw, t1, 0(t0)	# t1 = coordenada x do hulk
	lw t2, 4(t0)	# t2 = coordenada y do hulk
	
	# verifica se eh janela 1
	mv t3, t1
	mv t4, t2
	addi t3, t3, -85
	addi t4, t4, -80
	bnez t3, PROX1
	bnez t4, PROX1
	la t5, JANELAS_QUEBRADAS
	lw s1, 0(t5)	# s1 = janela atual
	bnez s1, PROX1	# se ja esta quebrada, pula
	addi s2, s2, 1	# contagem geral++
	li s1, 1	# 
	sw s1, 0(t5)	# janela 0 -> 1
	PROX1:
	
	# verifica se eh janela 2
	mv t3, t1
	mv t4, t2
	addi t3, t3, -135
	addi t4, t4, -80
	bnez t3, PROX2
	bnez t4, PROX2
	la t5, JANELAS_QUEBRADAS
	lw s1, 4(t5)	# s1 = janela atual
	bnez s1, PROX2	# se ja esta quebrada, pula
	addi s2, s2, 1	# contagem geral++
	li s1, 1	# 
	sw s1, 4(t5)	# janela 0 -> 1
	PROX2:
	
	# verifica se eh janela 3
	mv t3, t1
	mv t4, t2
	addi t3, t3, -185
	addi t4, t4, -80
	bnez t3, PROX3
	bnez t4, PROX3
	la t5, JANELAS_QUEBRADAS
	lw s1, 8(t5)	# s1 = janela atual
	bnez s1, PROX3	# se ja esta quebrada, pula
	addi s2, s2, 1	# contagem geral++
	li s1, 1	# 
	sw s1, 8(t5)	# janela 0 -> 1
	PROX3:
	
	# verifica se eh janela 4
	mv t3, t1
	mv t4, t2
	addi t3, t3, -85
	addi t4, t4, -140
	bnez t3, PROX4
	bnez t4, PROX4
	la t5, JANELAS_QUEBRADAS
	lw s1, 12(t5)	# s1 = janela atual
	bnez s1, PROX4	# se ja esta quebrada, pula
	addi s2, s2, 1	# contagem geral++
	li s1, 1	# 
	sw s1, 12(t5)	# janela 0 -> 1
	PROX4:
	
	# verifica se eh janela 5
	mv t3, t1
	mv t4, t2
	addi t3, t3, -135
	addi t4, t4, -140
	bnez t3, PROX5
	bnez t4, PROX5
	la t5, JANELAS_QUEBRADAS
	lw s1, 16(t5)	# s1 = janela atual
	bnez s1, PROX5	# se ja esta quebrada, pula
	addi s2, s2, 1	# contagem geral++
	li s1, 1	# 
	sw s1, 16(t5)	# janela 0 -> 1
	PROX5:
	
	# verifica se eh janela 6
	mv t3, t1
	mv t4, t2
	addi t3, t3, -185
	addi t4, t4, -140
	bnez t3, PROX6
	bnez t4, PROX6
	la t5, JANELAS_QUEBRADAS
	lw s1, 20(t5)	# s1 = janela atual
	bnez s1, PROX6	# se ja esta quebrada, pula
	addi s2, s2, 1	# contagem geral++
	li s1, 1	# 
	sw s1, 20(t5)	# janela 0 -> 1
	PROX6:
	
	# verifica se eh janela 7
	mv t3, t1
	mv t4, t2
	addi t3, t3, -85
	addi t4, t4, -200
	bnez t3, PROX7
	bnez t4, PROX7
	la t5, JANELAS_QUEBRADAS
	lw s1, 24(t5)	# s1 = janela atual
	bnez s1, PROX7	# se ja esta quebrada, pula
	addi s2, s2, 1	# contagem geral++
	li s1, 1	# 
	sw s1, 24(t5)	# janela 0 -> 1
	PROX7:
	
	# verifica se eh janela 8
	mv t3, t1
	mv t4, t2
	addi t3, t3, -185
	addi t4, t4, -200
	bnez t3, PROX8
	bnez t4, PROX8
	la t5, JANELAS_QUEBRADAS
	lw s1, 28(t5)	# s1 = janela atual
	bnez s1, PROX8	# se ja esta quebrada, pula
	addi s2, s2, 1	# contagem geral++
	li s1, 1	# 
	sw s1, 28(t5)	# janela 0 -> 1
	PROX8:
	
	# verifica se eh janela 9
	mv t3, t1
	mv t4, t2
	addi t3, t3, -135
	addi t4, t4, -200
	bnez t3, PROX9
	bnez t4, PROX9
	la t5, JANELAS_QUEBRADAS
	lw s1, 32(t5)	# s1 = janela atual
	bnez s1, PROX9	# se ja esta quebrada, pula
	addi s2, s2, 1	# contagem geral++
	li s1, 1	# 
	sw s1, 32(t5)	# janela 0 -> 1
	PROX9:
	
	sw s2, 0(s0)	# registra a contagem na memoria
	
	#print contagem no console para controle
	li a7, 1
	mv a0, s2
	ecall
	
	j PRINT_JANELAS
		

VER_VITORIA:
	la s0, contagem
	lw s2, 0(s0)	# s2 = contagem geral
	
	li t0, 18
	beq s2, t0, ZEROU
	li t0, 9
	bne s2, t0, NAO_VENCEU # se contagem < 9, nao venceu
	lw t1,0(a4)
	bnez t1, NAO_VENCEU
	jal MUSICA_VITORIA
	j CARREGA_FASE2
	
	NAO_VENCEU:
	ret

# FUNCAO PARA TESTE DE DERROTA
PERDE_PONTO:	
	la t0, vidas
	lw t1, 0(t0)
	addi t1, t1, -1 	# diminui 1 ponto de vida arbitrariamente
	sw t1, 0(t0)

	# efeito sonoro
	    li a0, 50    # define a nota
	    li a1,800        # define a dura??o da nota em ms
	    li a2,120        # define o instrumento
	    li a3,127        # define o volume
	    li a7,31        # define o syscall
	    ecall            # toca a nota

		j PRINTA_VIDAS
VER_DERROTA:
	la t0, vidas
	lw t1, 0(t0)
	bnez t1, PULA_DER
	la a0, tela_derrota_at	# tela GAMEOVER
	li a1, 0
	li a2, 0
	jal renderImage 

	# Codigo abaixo obtem a entrada
	TELA_FIM:
		MUSIC_DERROTA:
			li s1,22        # le o numero de notas em s1
			la s0,NOTAS_DERROTA        # define o endere?o das notas
			li a2,26        # define o instrumento
			li a3,127        # define o volume
			li t0, 0

		LOOP_NOTAS_DERROTA:    
			bge t0,s1, DONE_MUSIC_DERROTA        # contador chegou no final? ent?o  v? para FIM
			lw a0,0(s0)        # le o valor da nota
			lw a1,4(s0)        # le a duracao da nota

			li    t3, 0xFF200000 # carrega em t3 o endere?o do status do teclado.
			lb     t1, 0(t3) # carrega o status do teclado em t1.

			andi    t1, t1, 1 # isso eh um processo de mascaramento. Apenas queremos saber sobre o primeiro bit de t1, que indica se alguma tecla foi pressionada.

			beq    t1, zero, CONTINUAR_MUSICA_DERROTA #se a tecla 1 n?o foi pressionada, volta a verificar at? que a mesma seja acionada

			lb    t1, 4(t3) #ao ser pressionado, carrega 1 em t1 para fins de compara??o

			li    t2, 0x031 #valor do 1 na tabela ASCII
			beq    t1, t2, REINICIA_JOGO #se o que tiver sido registrado no teclado foi 1, reinicia o jogo

        	li    t2, 0x032 #valor do 2 na tabela ASCII
        	bne    t1, t2, loop_fim #Se o numero digitado n?o foi 2 nem 1, volta a esperar um input valido 
        	j    END #se o input tiver sido 2, encerra o programa 
			loop_fim:
			CONTINUAR_MUSICA_DERROTA:
			li a7,31        # define a chamada de syscall
			ecall            # toca a nota
			
			mv a0,a1        # passa a dura??o da nota para a pausa
			li a7,32        # define a chamada de syscal 
			ecall            # realiza uma pausa de a0 ms
			
			addi s0,s0,8        # incrementa para o endere?o da pr?xima nota
			
			addi t0,t0,1        # incrementa o contador de notas
			j LOOP_NOTAS_DERROTA
			DONE_MUSIC_DERROTA:
			j TELA_FIM

	PULA_DER:
	ret

REINICIA_JOGO:	# volta tudo para as posicoes iniciais
	la t0, HULK_POS
	li t1, 85
	li t2, 200
	sw t1, 0(t0)
	sw t2, 4(t0)

	la t0, LOKI_POS
	li t1, 130
	li t2, 18
	sw t1, 0(t0)
	sw t2, 4(t0)

	la t0, LOKI_CONT
	sw zero, 0(t0)
	la t0,VERIFICA_FASE
	sw zero, 0(t0)
	la t0,CHITAURI_MOVE
	sw zero, 0(t0)
	

	la t0, LASER_CONT
	sw zero, 0(t0)

	la t0, CHITAURI_POS
	li t1, 280
	li t2, 140
	sw t1, 0(t0)
	sw t2, 4(t0)
        
	la t0, CHITAURI_ATIVO
	sw zero, 0(t0)

	la t0, JANELAS_QUEBRADAS
	sw zero, 0(t0)
	sw zero, 4(t0)
	sw zero, 8(t0)
	sw zero, 12(t0)
	sw zero, 16(t0)
	sw zero, 20(t0)
	sw zero, 24(t0)
	sw zero, 28(t0)
	sw zero, 32(t0)

	la t0, contagem
	sw zero, 0(t0)

	la t0, pontos
	sw zero, 0(t0)
        sw zero, 4(t0)
        
	la t0, vidas
	li t1, 3
	sw t1, 0(t0)

	la t0, fase
	sw zero, 0(t0)

        la t0,tacos
	sw zero,0(t0)
	
	j INICIO


	
	#funcao que verifica se o chitauri ja apareceu	
CHIT_CHECK:
        li t1,2 #comparacao para ver se o chitauri deve sumir
	la t0,CHITAURI_MOVE # move o verificador para t0
	lw t6,0(t0)  #coloca em t6 o verificador
	beq t1,t6,CHIT_END #se ele ja percorreu toda a tela, finaliza as operacoes do chitauri por definitivo
	
	
	li t1,1 #comparacao para ver se o chitauri ja foi printado na posicao inicial
	la t0,CHITAURI_MOVE #move para t0 o verificador de movimentacao do Chitauri
	lw t6,0(t0) #coloca em t6 o verificador
	beq t1,t6,CHITAURI_PRINT #se ele ja tiver aparecido na posicao inicial, comeca a movimentacao

CHITAURI:
	la t0, contagem  #carrega em t0 a quantidade de janelas quebradas
	lw t1, 0(t0)	# t1 = contagem de janelas quebradas
	li t2, 4  #sera usado para verificar quantas janelas foram quebradas
	blt t1, t2, CHIT_END	# se contagem < 4, faz nada
	
	# gera n aleatorio de 80 a 200 em a0
		#li a7, 42
		#li a1, 120	# limite
		#ecall
		#addi a0, a0, 80
		#mv t1, a0
		
		# atualiza a coordenada y do chitauri
		#la t0, CHITAURI_POS
		#sw t1, 4(t0)	# coordenada y do chitauri = t1
		
		
	la t0, CHITAURI_ATIVO #carrega em t0 a posicao inicial do chitauri
	lw t1, 0(t0)    #carrega em t1 se ele esta ativo
	li t2, 1          #sera usado para verificar se ele ja apareceu na tela
	beq t1, t2, CHITAURI_PRINT	# se o estado for ativo, pula
		# muda o estado para ativo
		li t2, 1 # muda o estado para ativo
		la t0, CHITAURI_ATIVO #carrega em t0 a posicao do chitauri
		sw t2, 0(t0) # CHITAURI_ATIVO = 1
		
		# renderiza o chitauri
		la t0, CHITAURI_POS #carrega em t0 a nova posicao do chitauri
		lw a1, 0(t0)  #passa como argumento para print a posicao X do Chitauri,o primeiro print nao buga
		lw a2, 4(t0) #passa como argumento para print a posicao Y do Chitauri
		la a0, chitauri #passa como argumento para print a imagem que deve ser printada
		jal renderImage #renderiza o sprite
		
		    
                la t0,CHITAURI_MOVE #carrega em t0 o verificador
                li t6,1 # valor a ser colocado no verificador
                sw t6,0(t0) # coloca o valor no verificador
		
		j CHIT_END
	
CHITAURI_ERASE: #se o chitauri chegou na ultima posicao,para de aparecer
    
la t0,CHITAURI_MOVE #atualiza para 2 o verificador do chitauri
li t2,2 
sw t2,0(t0) #agora o verificador tem valor 2, ou seja, o chitauri deve sumir, pois ja se moveu completamente


VERIFICA_POS_CHITAURI:  
      li s11,0
	la t1,JANELAS_QUEBRADAS 
	
	li t2,1 #vera se a jenela foi quebrada 
	lw t3,12(t1)#verifica o estado da janela 1

	beq t2,t3,JANELA1_QUEBRADA#se estiver quebrada
	  
	WINDOW_2:

	la t1,JANELAS_QUEBRADAS
	li t2,1 #vera se a jenela foi quebrada
	li t4,0 #se foi,sera restaurada
	lw t3,16(t1)#verifica o estado da janela 1
	
	beq t2,t3,JANELA2_QUEBRADA
	 
	WINDOW_3:

	la t1,JANELAS_QUEBRADAS
	li t2,1 #vera se a jenela foi quebrada
	lw t3,20(t1)#verifica o estado da janela 1
	beq t2,t3,JANELA3_QUEBRADA
	    
	DONE_CHECKING:
	 
	li t2,1 #vera se a jenela foi quebrada
	li t4,0 #se foi,sera restaurada
	li t5,2
	li t6,3
	
	beq t4,s11,NONE#se tot=0
	     
	beq t2,s11,ONCE#se tot=1
	
	
	beq t5,s11,TWICE#se tot= 2
	
	beq t6,s11,ALL #se tot= 3
	
	
                
JANELA1_QUEBRADA: # SE QUEBROU A JANELA 1
addi s11,s11,1 #TOT++
la t2,J1_BROKE #CONFIRMA_QUEBRA DA 1
li t3,1
sw t3,0(t2)#ATT A JANELA QUE FOI QUEBRADA
j WINDOW_2
JANELA2_QUEBRADA:# SE QUEBROU A JANELA 1
addi s11,s11,1#TOT++
la t2,J2_BROKE#CONFIRMA_QUEBRA DA 2
li t3,1
sw t3,0(t2)
j WINDOW_3                
JANELA3_QUEBRADA:
addi s11,s11,1# SE QUEBROU A JANELA 3
la t2,J3_BROKE#CONFIRMA_QUEBRA DA 3
li t3,1
sw t3,0(t2)#ATT A JANELA QUE FOI QUEBRADA
j DONE_CHECKING#VOLTA COM QUAIS E QUANTAS JANELAS QUEBRADAS


NONE:
j CHIT_END

ONCE:
la t4,J1_BROKE
lw t2, 0(t4)
li t3,1
beq t2,t3,N1#se a unica foi a 1

la t4,J2_BROKE
lw t2, 0(t4)
li t3,1
beq t2,t3,N2#se a unica foi a 2

la t4,J3_BROKE
lw t2, 0(t4)
li t3,1
beq t2,t3,N3#se a unica foi a 3

TWICE:
la t4,J1_BROKE

lw t2, 0(t4)
li t3,1
beq t2,t3,ONE_AND

               
                lw t0,pontos #qunado aparece, o chitauri reseta os pontos
                li t1,2 #reseta as 1 janela
                sub t0,t0,t1 #pega a diferença,geralmente eh 1
                la t2,pontos #endereço de armazenamento dos pontos
                sw  t0,0(t2)    #att os pts 
                
                lw t0,contagem #qunado aparece, o chitauri reseta os pontos
                li t1,2 #reseta as 3 janelas
                sub t0,t0,t1 #pega a diferença,geralmente eh 1
                la t2,contagem #endereço de armazenamento dos pontos
                sw  t0,0(t2)    #att os pts
            la t1,JANELAS_QUEBRADAS
            li t4,0
	sw t4,20(t1)#reseta a janela 3
	sw t4,16(t1)#reseta a janela 2
                j CHIT_END






N1:

               lw t0,pontos #qunado aparece, o chitauri reseta os pontos
                li t1,1 #reseta as 1 janela
                sub t0,t0,t1 #pega a diferença,geralmente eh 1
                la t2,pontos #endereço de armazenamento dos pontos
                sw  t0,0(t2)    #att os pts 
                
                lw t0,contagem #qunado aparece, o chitauri reseta os pontos
                li t1,1 #reseta as 3 janelas
                sub t0,t0,t1 #pega a diferença,geralmente eh 1
                la t2,contagem #endereço de armazenamento dos pontos
                sw  t0,0(t2)    #att os pts
                
         la t1,JANELAS_QUEBRADAS
	li t4,0 #se foi,sera restaurada
	sw t4,12(t1)#reseta a janela 1
                j CHIT_END
                
 N2:

               lw t0,pontos #qunado aparece, o chitauri reseta os pontos
                li t1,1 #reseta as 1 janela
                sub t0,t0,t1 #pega a diferença,geralmente eh 1
                la t2,pontos #endereço de armazenamento dos pontos
                sw  t0,0(t2)    #att os pts 
                
                lw t0,contagem #qunado aparece, o chitauri reseta os pontos
                li t1,1 #reseta as 3 janelas
                sub t0,t0,t1 #pega a diferença,geralmente eh 1
                la t2,contagem #endereço de armazenamento dos pontos
                sw  t0,0(t2)    #att os pts
                
         la t1,JANELAS_QUEBRADAS
	li t4,0 #se foi,sera restaurada
	sw t4,16(t1)#reseta a janela 2
                j CHIT_END
                
 N3:

               lw t0,pontos #qunado aparece, o chitauri reseta os pontos
                li t1,1 #reseta as 1 janela
                sub t0,t0,t1 #pega a diferença,geralmente eh 1
                la t2,pontos #endereço de armazenamento dos pontos
                sw  t0,0(t2)    #att os pts 
                
                lw t0,contagem #qunado aparece, o chitauri reseta os pontos
                li t1,1 #reseta as 3 janelas
                sub t0,t0,t1 #pega a diferença,geralmente eh 1
                la t2,contagem #endereço de armazenamento dos pontos
                sw  t0,0(t2)    #att os pts
                
         la t1,JANELAS_QUEBRADAS
	li t4,0 #se foi,sera restaurada
	sw t4,20(t1)#reseta a janela 3
                j CHIT_END
                
 ONE_AND:
     
     la t4,J2_BROKE
      lw t2, 0(t4)
       li t3,1
     beq t3,t2,N1_N2
     
      lw t0,pontos #qunado aparece, o chitauri reseta os pontos
                li t1,2 #reseta as 1 janela
                sub t0,t0,t1 #pega a diferença,geralmente eh 1
                la t2,pontos #endereço de armazenamento dos pontos
                sw  t0,0(t2)    #att os pts 
                
                lw t0,contagem #qunado aparece, o chitauri reseta os pontos
                li t1,2 #reseta as 3 janelas
                sub t0,t0,t1 #pega a diferença,geralmente eh 1
                la t2,contagem #endereço de armazenamento dos pontos
                sw  t0,0(t2)    #att os pts
            la t1,JANELAS_QUEBRADAS
	li t4,0 #se foi,sera restaurada
	sw t4,20(t1)#reseta a janela 3
	sw t4,12(t1)#reseta a janela 1
                j CHIT_END
  N1_N2:
  
   lw t0,pontos #qunado aparece, o chitauri reseta os pontos
                li t1,2 #reseta as 1 janela
                sub t0,t0,t1 #pega a diferença,geralmente eh 1
                la t2,pontos #endereço de armazenamento dos pontos
                sw  t0,0(t2)    #att os pts 
                
                lw t0,contagem #qunado aparece, o chitauri reseta os pontos
                li t1,2 #reseta as 3 janelas
                sub t0,t0,t1 #pega a diferença,geralmente eh 1
                la t2,contagem #endereço de armazenamento dos pontos
                sw  t0,0(t2)    #att os pts
            la t1,JANELAS_QUEBRADAS
	li t4,0 #se foi,sera restaurada
	sw t4,16(t1)#reseta a janela 2
	sw t4,12(t1)#reseta a janela 1
                j CHIT_END
                
                
                
        ALL:
        lw t0,pontos #qunado aparece, o chitauri reseta os pontos
                li t1,3 #reseta as 1 janela
                sub t0,t0,t1 #pega a diferença,geralmente eh 1
                la t2,pontos #endereço de armazenamento dos pontos
                sw  t0,0(t2)    #att os pts 
                
                lw t0,contagem #qunado aparece, o chitauri reseta os pontos
                li t1,3 #reseta as 3 janelas
                sub t0,t0,t1 
                la t2,contagem #endereço de armazenamento dos pontos
                sw  t0,0(t2)    #att os pts
            la t1,JANELAS_QUEBRADAS
	li t4,0 #se foi,sera restaurada
	sw t4,16(t1)#reseta a janela 2
	sw t4,12(t1)#reseta a janela 1
	sw t4,20(t1)#reseta a janela 3
                j CHIT_END
                              
LOKI_CHECK:

	la t0,PROJETIL_MOVE # move o verificador para t0
	lw t6,0(t0)  #coloca em t6 o verificador
	bnez t6, LOKI_PRINT    # Se já há projétil ativo, não atira novamente	
        
LOKI_ATIRA:

	#efeito sonoro
	li a0, 100    # define a nota
	li a1,127        # define a dura??o da nota em ms
	li a2,97        # define o instrumento
	li a3,127        # define o volume
	li a7,31        # define o syscall
	ecall  

	 li t1,1 #poe loki como ativo
	la t0,PROJETIL_MOVE # move o verificador para t0
	sw t1,0(t0)  #coloca em t6 o verificador
	
	#faz animação do Loki para ele atirar
	la t0, LOKI_POS #carrega em t0 as coordenadas do loki
	la a0, loki_ativo #argumento para print que indica com qual cor o sprite deve ser apagado
	lw a1, 0(t0) #argumento para print com a posicao X do Loki
	lw a2, 4(t0) #argumento para print com a posicao Y do Loki
	jal renderImage  #renderiza a imagem
	
		# apaga o loki antigo
	la t0, LOKI_POS #carrega em t0 as coordenadas do loki
	la a0, loki_fundo #argumento para print que indica com qual cor o sprite deve ser apagado
	lw a1, 0(t0) #argumento para print com a posicao X do Loki
	lw a2, 4(t0) #argumento para print com a posicao Y do Loki
	jal renderImage  #renderiza a imagem
	
	
	
	# gera numero aleatorio entre 85 e 185
	li a7, 42  #ecall para gerar numero aleatorio
	li a1, 100 #garante que nao saia dos limites do mapa
	ecall
	addi a0, a0, 85 #move 85 colunas
	mv t1, a0 #coloca em t1 a nova posicao Y
	# registra a posicao
	la t0, LOKI_POS #carrega em t0 a posicao desatualizada
	sw t1, 0(t0)  #atualiza a posicao
	la t0, PROJETIL_POS
	sw t1, 0(t0)
	
	#faz animação do Loki para ele atirar
	la t0, LOKI_POS #carrega em t0 as coordenadas do loki
	la a0, loki_ativo #argumento para print que indica com qual cor o sprite deve ser apagado
	lw a1, 0(t0) #argumento para print com a posicao X do Loki
	lw a2, 4(t0) #argumento para print com a posicao Y do Loki
	jal renderImage  #renderiza a imagem
	
	
	
	
	li a7,32
	li a0,200
	ecall
	#apaga ele atirando
	la t0, LOKI_POS #carrega em t0 as coordenadas do loki
	la a0, loki_fundo #argumento para print que indica com qual cor o sprite deve ser apagado
	lw a1, 0(t0) #argumento para print com a posicao X do Loki
	lw a2, 4(t0) #argumento para print com a posicao Y do Loki
	jal renderImage  #renderiza a imagem
	
        # renderiza o loki na nova posicao
	la a0, loki_parado #argumento para print do sprite a ser renderizado
	la t0, LOKI_POS # carrega em t0 as posicoes X e Y do Loki
	lw a1, 0(t0) #argumento para print da posicao X do Loki
	lw a2, 4(t0) # argumento Y para print da posicao Y do Loki
	jal renderImage #renderiza a imagem
	
		j LASERSZ
	
PROJETIL_ERASE: #se o chitauri chegou na ultima posicao,para de aparecer
    
la t0,PROJETIL_MOVE #atualiza para 2 o verificador do chitauri
li t2,0 
sw t2,0(t0) #agora o verificador tem valor 2, ou seja, o chitauri deve sumir, pois ja se moveu completamente
la t3, LOKI_POS
la t4, PROJETIL_POS
lw t5, 4(t3)
addi t5,t5,30
sw t5, 4(t4) 
 j LOKI_END


CARREGA_FASE2:
        la t0,VERIFICA_FASE #att o verificador p fase 2
        li t1,1
        sw t1,0(t0)
        
	li t0,1
	sw t0,0(a4)			# alterando numero da fase para 1(fase 2)
	la s6,HULK_POS		# carrega posicao do hulk
	li t1,85
	sw t1,0(s6)			# redefine o x do hulk
	li t2,200
	sw t2,4(s6)			# redefine o y do hulk
	j CARREGA_FUNDO


MUSICA_VITORIA:
	li s1,4        # le o numero de notas em s1
	la s0,NOTAS_VITORIA        # define o endere?o das notas
	li a2,0        # define o instrumento
	li a3,127        # define o volume
	li t0, 0

	LOOP_NOTAS_VITORIA:    
		beq t0,s1, DONE_MUSIC_VITORIA        # contador chegou no final? ent?o  v? para FIM
		lw a0,0(s0)        # le o valor da nota
		lw a1,4(s0)        # le a duracao da nota
		
		li a7,31        # define a chamada de syscall
		ecall            # toca a nota
		
		mv a0,a1        # passa a dura??o da nota para a pausa
		li a7,32        # define a chamada de syscal 
		ecall            # realiza uma pausa de a0 ms
		
		addi s0,s0,8        # incrementa para o endere?o da pr?xima nota
		
		addi t0,t0,1        # incrementa o contador de notas
		j LOOP_NOTAS_VITORIA
	DONE_MUSIC_VITORIA:
	ret

PRINT_PORTAIS:
	la a0,portal1		# printa portal1 e define posi??es x=217, y=180 
	li a1, 217
	li a2, 180
	jal renderImage
	la a0,portal2		# printa portal2 e define posi??es x=60, y=60 
	li a1, 60
	li a2, 60
	jal renderImage
	la a0,chitauri
	li a1, 243
	li a2, 95
	jal renderImage
	j PRINT_JANELAS

PRINT_LASER:
	lw t0,0(a4)
	beqz t0,FIM_LASER
	la t4,LASER_CONT
	lw t1,0(t4)
    li t2, 800000
	li t3, 400000

	beq t1,t3,LASER1
	beq t1,t2,LASER2
	addi t1,t1,1
	sw t1,0(t4)
	j FIM_LASER

	LASER1:
		la a0,laser1
		li a1, 0
		li a2, 112
		jal renderImage
		li t1, 400001
		sw t1,0(t4)
		j FIM_LASER

	LASER2:
		la a0,laser2
		li a1, 0
		li a2, 112
		jal renderImage
		li t1,0
		sw t1,0(t4)

	FIM_LASER:
		# garante que nao vai bugar
		la t5, HULK_POS
		lw a1, 0(t5)
		lw a2, 4(t5)
		j LASER_CHECK
	
ZEROU:
	jal MUSICA_VITORIA
	CARREGA_FINAL:               # carrega a imagem no frame 0
		li t1,0xFF000000	# endereco inicial da Memoria VGA - Frame 0
		li t2,0xFF012C00	# endereco final 
		la t4,tela_vit
		j CONTINUAR_FUNDO_FINAL
		CONTINUAR_FUNDO_FINAL: addi t4,t4,8		# primeiro pixels depois das informa??es de nlin ncol
	LOOP2: 	beq t1,t2,DONE_FINAL		# Se for o ultimo endereco ent?o sai do loop
		lw t3,0(t4)		# le um conjunto de 4 pixels : word
		sw t3,0(t1)		# escreve a word na mem?ria VGA
		addi t1,t1,4		# soma 4 ao endereco
		addi t4,t4,4
		j LOOP2			# volta a verificar
	DONE_FINAL:
		MUSIC_FINAL:
		
			li s1,28        # le o numero de notas em s1
			la s0,NOTAS_FINAL        # define o endere?o das notas
			li a2,0        # define o instrumento
			li a3,127        # define o volume
			li t0, 0
			
		LOOP_NOTAS_FINAL:    
			bge t0,s1, DONE_MUSIC_FINAL        # contador chegou no final? ent?o  v? para FIM
			lw a0,0(s0)        # le o valor da nota
			lw a1,4(s0)        # le a duracao da nota
			
			li    t3, 0xFF200000 # carrega em t3 o endere?o do status do teclado.
			lb     t1, 0(t3) # carrega o status do teclado em t1.
			andi    t1, t1, 1 # isso eh um processo de mascaramento. Apenas queremos saber sobre o primeiro bit de t1, que indica se alguma tecla foi pressionada.
			beq    t1, zero, CONTINUAR_MUSICA_VITORIA #se a tecla 1 n?o foi pressionada, volta a verificar at? que a mesma seja acionada
			lb    t1, 4(t3) #ao ser pressionado, carrega 1 em t1 para fins de compara??o
			li    t2, 0x031 #valor do 1 na tabela ASCII
			beq    t1, t2, REINICIA_JOGO #se o que tiver sido registrado no teclado foi 1, reinicia o jogo
			li    t2, 0x032 #valor do 2 na tabela ASCII
			bne    t1, t2, CONTINUAR_MUSICA_VITORIA #Se o numero digitado n?o foi 2 nem 1, volta a esperar um input valido 
			j    END #se o input tiver sido 2, encerra o programa 
			CONTINUAR_MUSICA_VITORIA:


			li a7,31        # define a chamada de syscall
			ecall            # toca a nota
			
			mv a0,a1        # passa a dura??o da nota para a pausa
			li a7,32        # define a chamada de syscal 
			ecall            # realiza uma pausa de a0 ms
			
			addi s0,s0,8        # incrementa para o endere?o da pr?xima nota
			
			addi t0,t0,1        # incrementa o contador de notas
			j LOOP_NOTAS_FINAL
		DONE_MUSIC_FINAL:
			li a7,10
			ecall 				# ecall para o exit

PRINTA_VIDAS:
	la t0, vidas
	lw t2, 0(t0)	# t2 = vidas

	li t0, 3
	bne t2, t0, PROX_VIDAS	# se vidas < 3, PROX_VIDAS
		la a0, hulk_cabeca
		li a1, 290
		li a2, 18
		jal renderImage

		li a1, 265
		jal renderImage

		li a1, 240
		jal renderImage

		j PULA_HUD
	PROX_VIDAS:

	li t0, 2
	bne t2, t0, PROX_VIDAS2	# se vidas < 2, PROX_VIDAS2
		la a0, hulk_morte
		li a1, 290
		li a2, 18
		jal renderImage

		la a0, hulk_cabeca
		li a1, 265
		jal renderImage

		li a1, 240
		jal renderImage
	
		j PULA_HUD
	PROX_VIDAS2:
	li t0, 1
	bne t2, t0, PULA_HUD
	la a0, hulk_morte
		li a1, 290
		li a2, 18
		jal renderImage

		li a1, 265
		jal renderImage

		la a0, hulk_cabeca
		li a1, 240
		jal renderImage


	PULA_HUD:
	# garante que nao vai bugar

	la t0, LOKI_POS
	lw a1, 0(t0)
	lw a2, 0(t0)
	
	j GAME_LOOP
	

PRINTA_SCORE:


    la a0, tabela_hud
    li a1, 1
    li a2, 1
    jal renderImage

	la a0, taco
	li a1, 3
	li a2, 24
	jal renderImage

	# calcula os pontos
	la t0, contagem
	lw t1, 0(t0)	# t1 = contagem (0 - 9)

	la t0, pontos
	lw t2, 0(t0)	# t2 = pontos

	mv t2, t1	# pontos = contagem

	li t0, 0
	bne t2, t0, pula_pontos0
		j FIM_SCORE
	pula_pontos0:
	
	li t0, 1
	bne t2, t0, pula_pontos1
		la a0, um
		j fim_calc
	pula_pontos1:

	li t0, 2
	bne t2, t0, pula_pontos2
		la a0, dois
		j fim_calc
	pula_pontos2:

	li t0, 3
	bne t2, t0, pula_pontos3
		la a0, tres
		j fim_calc
	pula_pontos3:

	li t0, 4
	bne t2, t0, pula_pontos4
		la a0, quatro
		j fim_calc
	pula_pontos4:

	li t0, 5
	bne t2, t0, pula_pontos5
		la a0, cinco
		j fim_calc
	pula_pontos5:

	li t0, 6
	bne t2, t0, pula_pontos6
		la a0, seis
		j fim_calc
	pula_pontos6:

	li t0, 7
	bne t2, t0, pula_pontos7
		la a0, sete
		j fim_calc
	pula_pontos7:

	li t0, 8
	bne t2, t0, pula_pontos8
		la a0, oito
		j fim_calc
	pula_pontos8:

	li t0, 9
	bne t2, t0, pula_pontos9
		la a0, nove
		j fim_calc
	pula_pontos9:

	li t0, 10
	bne t2, t0, pula_pontos10
		la a0, dez
		j fim_calc
	pula_pontos10:

	li t0, 11
	bne t2, t0, pula_pontos11
		la a0, onze
		j fim_calc
	pula_pontos11:

	li t0, 12
	bne t2, t0, pula_pontos12
		la a0, doze
		j fim_calc
	pula_pontos12:

	li t0, 13
	bne t2, t0, pula_pontos13
		la a0, treze
		j fim_calc
	pula_pontos13:

	li t0, 14
	bne t2, t0, pula_pontos14
		la a0, quatorze
		j fim_calc
	pula_pontos14:

	li t0, 15
	bne t2, t0, pula_pontos15
		la a0, quinze
		j fim_calc
	pula_pontos15:

	li t0, 16
	bne t2, t0, pula_pontos16
		la a0, dezesseis
		j fim_calc
	pula_pontos16:

	li t0, 17
	bne t2, t0, pula_pontos17
		la a0, dezessete
		j fim_calc
	pula_pontos17:

	li t0, 18
	bne t2, t0, pula_pontos18
		la a0, dezoito
		j fim_calc
	pula_pontos18:


	fim_calc:
	
	# PRINTA O SCORE ATUAL
	li a1, 49
	li a2, 5
	jal renderImage

	# verifica n de tacos
	la t0, contagem
	lw t1, 0(t0)	# pontos
	li t2, 10
	bne t1, t2, PULA_TACO
        la t0, pontos
	lw t1, 4(t0)
	bnez t1,PULA_TACO
	
		# seta tacos para 1
		la t0, tacos
		lw t1, 0(t0)	# t1 = tacos
		li t1, 1		# t1 = 1
		sw t1, 0(t0)	# tacos = 1
		
	PULA_TACO:

	# PRINTA TACOS
	la t0, tacos
	lw t1, 0(t0)	# t1 = tacos
	li t2, 1
	bne t2, t1,  PULA_TACOS1
		la a0, um
		li a1, 34
		li a2, 26 
		jal renderImage

	PULA_TACOS1:


    j FIM_SCORE

SET_INVENCIVEL:	# altera o estado de invencivel para 1 quando aperta 1
	# verfica se tem tacos
	la t0, tacos
	lw t1, 0(t0)	# t1 = tacos
	beqz t1, FIM_INV

	la t0, invencivel
	li t1, 1
	sw t1, 0(t0)

	# atualiza o sprite do hulk
	jal SET_SPRITE_HULK
	la t0, HULK_POS
	lw a1, 0(t0)
	lw a2, 4(t0)
	jal renderImage

	# zera os tacos
	la t0, tacos
	sw zero, 0(t0)
        la t0,pontos
	li t1,1
	sw t1,4(t0)
	
	# renderiza o score com tacos zerado
	j PRINTA_SCORE


VER_INVENCIVEL:	# a ser adicionado no game_loop
	la t0, invencivel
	lw t3, 0(t0)	# t3 = invencivel (0 ou 1)
	li t0, 1
	bne t0, t3, FIM_INV # se nao estiver invencivel, pula

	# contagem
	la t0, invencivel_cont
	lw t1, 0(t0)	# t1 = contagem
	addi t1, t1, 1  # t1++
	sw t1, 0(t0)	# contagem = t1

        li t0, 10000000
	beq t0, t1, inv_volta
		j FIM_INV
	inv_volta:
		# zera a contagem
		la t0, invencivel_cont
		sw zero, 0(t0)

		# altera o estado para normal
		la t0, invencivel
		sw zero, 0(t0)	# invencivel = 0 (volta ao normal)

		la t0, HULK_POS
		lw a1, 0(t0)
		lw a2, 4(t0)
		la a0, hulk_parado
		jal renderImage

		j PRINTA_SCORE

		FIM_INV:
		j INV_CHECK

SET_SPRITE_HULK:
	# seta o sprite do hulk caso invencivel
	la t0, invencivel
	lw t1, 0(t0)
	bnez t1, printa_vermelho
		la a0, hulk_parado
		j check_invencivel
	printa_vermelho:
		la a0, hulk_ver_parado
          check_invencivel:
	ret

SET_HULK_ATIVO:
	# seta o sprite do hulk ativo caso invencivel
	la t0, invencivel
	lw t1, 0(t0)
	bnez t1, printa_vermelho1
		la a0, hulk_ativo
		j check_invencivel1
	printa_vermelho1:
		la a0, hulk_ver_ativo
          check_invencivel1:

ret
VER_COLISAO:
	# verifica invencibilidade
	la t0, invencivel
	lw t1, 0(t0)	# t1 = estado invencivel (0 ou 1)
	bnez t1, PULA_COLISAO

	# verifica colisao chitauri
#	sprite do hulk 34x34, o pixel do meio eh o (x + 17)(y + 17)
#	sprite do chiaturi 34x34, o pixel do meio eh o (x + 17)(y + 17)
	la t0, HULK_POS
    lw s0, 0(t0)  # s0 = coordenada x do hulk
    addi s0, s0, 17  # coordenada x do pixel central
    lw s1, 4(t0)  # s1 = coordenada y do hulk
    la t1, CHITAURI_POS
    lw s2, 0(t1)  # s2 = coordenada x do chitauri
    addi s2, s2, 17
    lw s3, 4(t1)  # s3 = coordenada y do chitauri
    # verifica colisao no eixo Y
    sub t4, s1, s3  # t4 = diferença entre as coordenadas y
    slt t5, t4, zero  # t5 = 1 se t4 < 0, caso contrário t5 = 0
    beqz t5, abs_y_end  # se t4 >= 0, pule para abs_y_end
    sub t4, zero, t4  # t4 = -t4 (valor absoluto)
abs_y_end:
    li t5, 34  # altura dos sprites
    bge t4, t5, PULA_COLISAO_CHIT  # se a diferença for maior ou igual a 34, pula
    # verifica colisao no eixo X
    sub t2, s0, s2  # t2 = diferença entre as coordenadas x
    slt t3, t2, zero  # t3 = 1 se t2 < 0, caso contrário t3 = 0
    beqz t3, abs_x_end  # se t2 >= 0, pule para abs_x_end
    sub t2, zero, t2  # t2 = -t2 (valor absoluto)
abs_x_end:
    li t0, 30  # largura dos sprites
    bge t2, t0, PULA_COLISAO_CHIT  # se a diferença for maior ou igual a 30, pula
		# perde 1 vida
		la t0, vidas
		lw t1, 0(t0)
		addi t1, t1, -1
		sw t1, 0(t0)
		# efeito sonoro
	    li a0, 50    # define a nota
	    li a1,800        # define a dura??o da nota em ms
	    li a2,120        # define o instrumento
	    li a3,127        # define o volume
	    li a7,31        # define o syscall
	    ecall            # toca a nota
	
		# move chiaturi para fora da area de colisao
		la t0, CHITAURI_POS
		lw t1, 0(t0)	# t1 = coordenada x atual do chitauri
		addi t1, t1, -100
		sw t1, 0(t0)

		j PRINTA_VIDAS	
	PULA_COLISAO_CHIT:
	
	# verifica colisao projetil loki 

#	sprite do hulk 24x24 (com 7 pixels antes do x verdadeiro), o pixel do meio eh o (x + 17)(y + 17)
#	sprite do projetil 8x8, o pixel do meio eh o (x + 10)(y + 10)
	la t0, HULK_POS
    lw s0, 0(t0)  # s0 = coordenada x do hulk
    addi s0, s0, 19  # coordenada x do pixel central
    lw s1, 4(t0)  # s1 = coordenada y do hulk
    la t1, PROJETIL_POS
    lw s2, 0(t1)  # s2 = coordenada x do projetil
    addi s2, s2, 4
    lw s3, 4(t1)  # s3 = coordenada y do projetil
    # verifica colisao no eixo Y
    sub t4, s1, s3  # t4 = diferença entre as coordenadas y
    slt t5, t4, zero  # t5 = 1 se t4 < 0, caso contrário t5 = 0
    beqz t5, abs_y_end1  # se t4 >= 0, pule para abs_y_end
    sub t4, zero, t4  # t4 = -t4 (valor absoluto)
abs_y_end1:
    li t5, 10  # altura dos sprites
    bge t4, t5, PULA_COLISAO_PROJ  # se a diferença for maior ou igual a 10, pula
    # verifica colisao no eixo X
    sub t2, s0, s2  # t2 = diferença entre as coordenadas x
    slt t3, t2, zero  # t3 = 1 se t2 < 0, caso contrário t3 = 0
    beqz t3, abs_x_end1  # se t2 >= 0, pule para abs_x_end
    sub t2, zero, t2  # t2 = -t2 (valor absoluto)
abs_x_end1:
    li t0, 16  # largura dos sprites
    bge t2, t0, PULA_COLISAO_PROJ  # se a diferença for maior ou igual a 27, pula
		# perde 1 vida
		la t0, vidas
		lw t1, 0(t0)
		addi t1, t1, -1
		sw t1, 0(t0)
		# efeito sonoro
	    li a0, 50    # define a nota
	    li a1,800        # define a dura??o da nota em ms
	    li a2,120        # define o instrumento
	    li a3,127        # define o volume
	    li a7,31        # define o syscall
	    ecall            # toca a nota

		# move projetil para fora da area de colisao
		 la t0, PROJETIL_POS
		 lw t1, 4(t0)	# t1 = coordenada y atual do projetil
		 li t3, 239
		 mv t1, t3
		 sw t1, 4(t0)

		j PRINTA_VIDAS	 
	PULA_COLISAO_PROJ:

	PULA_COLISAO:

	ret

CHEAT_FASE2:	# contagem = 9
	la t0, contagem
	li t2, 9
	sw t2, 0(t0)

	ret

CHEAT_GAMEOVER_SCREEN:	# vidas = 0
	la t0, vidas
	sw zero, 0(t0)
	ret

CHEAT_POWERUP:
	la t0, tacos
	li t1, 1
	sw t1, 0(t0)
	ret



