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
# inclusao dos audios
# Numero de Notas a tocar
NUM: .word 112
# lista de nota,dura??o,nota,dura??o,nota,dura??o,...

NOTAS:	#Tema 1(8 notas por linha = 16)
	43,2500,44,1200,45,1200,46,1200,45,1200,44,1200,39,600,41,600,
	43,2500,44,1200,45,1200,46,1200,45,1200,44,1200,39,600,41,600,
	#Tema 2(11 notas por linha = 44)
	60,2200,67,550,65,500,63,600,65,500,67,700,60,1700,67,550,65,500,63,700,62,700,
	60,2200,67,550,65,500,63,600,65,500,67,700,60,1700,67,550,65,500,63,700,62,700,
	72,2200,79,550,77,500,75,600,77,500,79,700,72,1700,79,550,77,500,75,700,74,700,
	72,2200,79,550,77,500,75,600,77,500,79,700,72,1700,79,550,77,500,75,700,74,700,
	#Ponte (8 notas por linha = 24)
	63,300,60,300,60,300,63,300,63,300,60,300,60,300,63,300,
	63,300,60,300,60,300,63,300,63,300,60,300,60,300,63,300,
	46,300,48,800,48,300,50,800,58,300,60,800,60,300,62,800,
	#Refr?o(14 notas por linha = 28)
	60,2500,60,500,60,750,67,250,65,2010,63,1000,62,1000,60,2500,60,500,60,750,67,250,69,1000,65,1000,67,2010,
	72,2500,72,500,72,750,79,250,77,2010,75,1000,74,1000,72,2500,72,500,72,750,79,250,81,1000,77,1000,79,4000,
#.include "/midi.s"


#inclusao das imagens

.include "../DATA/fundo1.data"
.include "../DATA/fundo2.data"
.include "../DATA/hulk_ativo.data"
.include "../DATA/hulk_parado.data"
.include "../DATA/hulk_pulando_d.data"
.include "../DATA/hulk_pulando_e.data"
.include "../DATA/hulk_pulando_cima.data"
.include "../DATA/hulk_pulando_baixo.data"
.include "../DATA/loki_ativo.data"
.include "../DATA/loki_parado.data"
.include "../DATA/loki_fundo.data"
.include "../DATA/doende.data"
.include "../DATA/projetil.data"
.include "../DATA/portal.data"
.include "../DATA/janela.data"
.include "../DATA/janela_quebrada.data"
.include "../DATA/porta.data"
.include "../DATA/porta_quebrada.data"
.include "../DATA/tela.data"

#############  SETUP INICIAL
# posicoes iniciais

HULK_POS:            .word 85,200
OLD_HULK_POS:    .word 85,200

LOKI_POS:	.word 130,18
OLD_LOKI_POS:	.word 130,18
LOKI_CONT: 	.word 0

# endereco da janela[0][0]
janelaX: 	.word 90
janelaY:	.word 70

JANELAS_QUEBRADAS: .word 0,0,0,0,0,0,0,0,0 # 0 = inteira; 1 = quebrada
contagem: .word 0
pontos: .word 0
vidas: .word 3
fase: .word 0
##############
.text
#### START
# Carrega tela de menu
li t1,0xFF000000    # endereco inicial da Memoria VGA - Frame 0
li t2,0xFF012C00    # endereco final 
la t4, tela          # endere?o dos dados da tela na memoria
addi t4,t4,8        # primeiro pixels depois das informacoes de nlin ncol
LOOP5:     beq t1,t2, mainMenuSelect        # Se for o ultimo endereco entao sai do loop
lw t3,0(t4)        # le um conjunto de 4 pixels : word
sw t3,0(t1)        # escreve a word na mem?ria VGA
addi t1,t1,4        # soma 4 ao endere?o
addi t4,t4,4
j LOOP5
mainMenuSelect:
        # Codigo abaixo obtem a entrada
        li    t0, 0xFF200000 # carrega em t0 o endere?o do status do teclado.
        lb     t1, 0(t0) # carrega o status do teclado em t1.

        andi    t1, t1, 1 # isso eh um processo de mascaramento. Apenas queremos saber sobre o primeiro bit de t1, que indica se alguma tecla foi pressionada.

        beq    t1, zero, mainMenuSelect #se a tecla 1 n?o foi pressionada, volta a verificar at? que a mesma seja acionada

        lb    t1, 4(t0) #ao ser pressionado, carrega 1 em t1 para fins de compara??o

        li    t2, 0x031 #valor do 1 na tabela ASCII
        beq    t1, t2, CARREGA_FUNDO1 #se o que tiver sido registrado no teclado foi 1, carrega a fase

        li    t2, 0x032 #valor do 2 na tabela ASCII
        bne    t1, t2, continueMMSelect #Se o numero digitado n?o foi 2 nem 1, volta a esperar um input valido 
        j    END #se o input tiver sido 2, encerra o programa 
    continueMMSelect:
        j    mainMenuSelect
        
        
# Carrega a fase 1 em ambos os frames

CARREGA_FUNDO1:               # carrega a imagem no frame 0
	li t1,0xFF000000	# endereco inicial da Memoria VGA - Frame 0
	li t2,0xFF012C00	# endereco final 
	la t4,fundo1		# endere?o dos dados da tela na memoria
	addi t4,t4,8		# primeiro pixels depois das informa??es de nlin ncol
LOOP1: 	beq t1,t2,DONE		# Se for o ultimo endereco ent?o sai do loop
	lw t3,0(t4)		# le um conjunto de 4 pixels : word
	sw t3,0(t1)		# escreve a word na mem?ria VGA
	addi t1,t1,4		# soma 4 ao endereco
	addi t4,t4,4
	j LOOP1			# volta a verificar

DONE:
	
# Renderiza as janelas
PRINT_JANELAS:
        
      
	la t0, JANELAS_QUEBRADAS
	
	# janela 1
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
	
	# porta
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
	la a0, hulk_parado #carrega o tamanho da imagem em a0
	la t0, HULK_POS  #carrega em t0 a word que contem as posicoes xy do hulk
	lw a1, 0(t0)  #carrega em t0 o numero que esta na primeira word de HULK_POS(esse numero e a posicao x)
	lw a2, 4(t0)  #carrega em t0 o numero que esta na segunda word(offset da word = 4) de HULK_POS(esse numero e a posicao y)
	
	jal renderImage
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
	
	# movimentacao loki
	j MOV_LOKI
	LOKI_CHECK:
	# 3: musica
	# 4: verifica vitoria ou derrota
	
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
FIM_KEY:	ret				# retorna

# FUNCOES DE MOVIMENTACAO


#NOTAS:
#a partir de agora, a posicao atualizada do hulk esta guardada em s6 
#Os registradores a0,a1 e a2 sao os argumentos passados para a funcao print

CHAR_CIMA:


 
    	la a0, hulk_parado #carrega as dimensoes do hulk em a0
	la s6,HULK_POS #posicao atual
	lw t2,0(s6) #passa a posicao antes do movimento para a antiga
	lw a2, 4(s6)  #carrega em a2 a posicao y atual do personagem
	addi a2, a2, -60 #move o hulk 
	blt a2,s9,PARA #limite do mapa
	jal renderImage #renderiza o sprite na nova posicao
	sw a2, 4(s6) # atualiza a posicao y do personagem
	j PRINT_JANELAS
	j GAME_LOOP #volta para o gameloop
	#ret
	PARA:
	addi a2,a2,60
	j GAME_LOOP
	
CHAR_ESQ:

 
 
 
 
	la a0, hulk_parado #carrega as dimensoes do hulk em a0
	la s6,HULK_POS
	lw a1,0(s6)        #carrega em a1 a posicao x atual do personagem
        addi a1, a1, -50   #move o hulk para esquerda
        blt a1,s4,PARA2     #limite do mapa
	jal renderImage    #renderiza o sprite na nova posicao
	sw a1, 0(s6)       # atualiza a posicao x do personagem
	j PRINT_JANELAS
	j GAME_LOOP
	#ret
	PARA2:
	addi a1,a1,50
	j GAME_LOOP
	
CHAR_BAIXO:


 
 
        la a0, hulk_parado #carrega as dimensoes do hulk em a0
        la s6,HULK_POS
       
    
	lw a2, 4(s6)       #carrega em a2 a posicao y atual do personagem
	addi a2, a2, 60   #move o hulk para baixo
	bgt a2,s5,PARA3   #limite do mapa
	jal renderImage    #renderiza o sprite na nova posicao
	sw a2, 4(s6)       # atualiza a posicao y do personagem
	j PRINT_JANELAS
	j GAME_LOOP        #volta para o gameloop
	#ret
	PARA3:
	addi a2,a2,-60
	j GAME_LOOP
CHAR_DIR:


 
	la a0, hulk_parado #carrega as dimensoes do hulk em a0
	la s6,HULK_POS
	
	lw a1,0(s6)        #carrega em a1 a posicao x atual do personagem
        addi a1, a1, 50    #move o hulk para direita
        bgt a1,s8,PARA4     #limite do mapa
	jal renderImage    #renderiza o sprite na nova posicao
	sw a1, 0(s6)       # atualiza a posicao x do personagem
	j PRINT_JANELAS
	j GAME_LOOP
	#ret
	PARA4:
	addi a1,a1,-50
	j GAME_LOOP
	
QUEBRA_JAN:
       
      
	la a0, hulk_ativo #carrega o tamanho da imagem em a0
	la t0, HULK_POS  #carrega em t0 a word que contem as posicoes xy do hulk
	lw a1, 0(t0)  #carrega em t0 o numero que esta na primeira word de HULK_POS(esse numero e a posicao x)
	lw a2, 4(t0)  #carrega em t0 o numero que esta na segunda word(offset da word = 4) de HULK_POS(esse numero e a posicao y)
	
	jal renderImage
       li a7,32
       li a0,200
       ecall
       
       
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
	
	li t0, 9
	bne s2, t0, NAO_VENCEU # se contagem < 9, nao venceu
	# j CARREGA_FASE2
	
	NAO_VENCEU:
	ret
VER_DERROTA:
	#la a0, DERROTA		# tela GAMEOVER
	#li a1, 0
	#li a2, 0
	#jal renderImage 	
	# j END
	ret

MOV_LOKI:
        
        # contagem
        la t0, LOKI_CONT
        lw t1, 0(t0)
        addi t1, t1, 1	# LOKI_CONT += 1
        sw t1, 0(t0)	# registra a contagem
        
        li t2, 21000000
	blt t1, t2, DONE_MOV	# se contagem < t2, nao faz nada
	
	# apaga o loki antigo
	la t0, LOKI_POS
	la a0, loki_fundo
	lw a1, 0(t0)
	lw a2, 4(t0)
	jal renderImage
	
	# gera numero aleatorio entre 85 e 185
	li a7, 42
	li a1, 100
	ecall
	addi a0, a0, 85
	mv t1, a0
	# registra a posicao
	la t0, LOKI_POS
	sw t1, 0(t0)
	
        # renderiza o loki na nova posicao
	la a0, loki_parado 
	la t0, LOKI_POS
	lw a1, 0(t0)
	lw a2, 4(t0)
	jal renderImage
	
	# zera contagem
	la t0, LOKI_CONT
	li s0, 0
	sw s0, 0(t0)
	
	# garante que nao vai bugar
	la t0, HULK_POS
	lw a1, 0(t0)
	lw a2, 4(t0)

	DONE_MOV:	j LOKI_CHECK
	
	
	