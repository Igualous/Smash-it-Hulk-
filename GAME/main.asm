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

#inclusao das imagens

.include "../DATA/fundo1.data"
.include "../DATA/fundo2.data"
.include "../DATA/hulk_ativo.data"
.include "../DATA/hulk_parado.data"
.include "../DATA/hulk_pulando_d.data"
.include "../DATA/hulk_pulando_e.data"
.include "../DATA/hulk_pulando_cima.data"
.include "../DATA/hulk_pulando_baixo.data"
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
.include "../DATA/tela.data"
.include "../DATA/tela_vit.data"

#############  SETUP INICIAL
# posicoes iniciais

HULK_POS:            .word 85,200
OLD_HULK_POS:    .word 85,200

LOKI_POS:	.word 130,18
OLD_LOKI_POS:	.word 130,18
LOKI_CONT: 	.word 0

LASER_CONT: .word 0

PROJETIL_POS: .word 120, 23
PROJETIL_CONT: .word 0
projetil_ativo_cont: .word 0

CHITAURI_POS:	.word 280,140
CHITAURI_ATIVO: .word 0	# 0 - padrao; 1 - ativo
# endereco da janela[0][0]
janelaX: 	.word 90
janelaY:	.word 70

JANELAS_QUEBRADAS: .word 0,0,0,0,0,0,0,0,0 # 0 = inteira; 1 = quebrada
contagem: .word 0
pontos: .word 0
vidas: .word 3
fase: .word 1
##############
.text
#### START
# Carrega tela de menu
la a4,fase			# define a4 como numero da fase
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
MUSIC:
    
    li s1,68        # le o numero de notas em s1
    la s0,NOTAS        # define o endere�o das notas
    li a2,48        # define o instrumento
    li a3,127        # define o volume
    li t0, 0

LOOP_NOTAS:    
	bge t0,s1, DONE_MUSIC        # contador chegou no final? ent�o  v� para FIM
    lw a0,0(s0)        # le o valor da nota
    lw a1,4(s0)        # le a duracao da nota

	li t3, 0xFF200000    # carrega em t3 o endereco do status do teclado.
    lb t1, 0(t3)         #carrega o status do teclado em t1
    andi t1, t1, 1       #verificar apenas o bit 0 (tecla pressionada)
    bne t1, zero, VERIFICAR_TECLA #se uma tecla foi pressionada, verifica qual foi
    
    li a7,31        # define a chamada de syscall
    ecall            # toca a nota
    
    mv a0,a1        # passa a dura��o da nota para a pausa
    li a7,32        # define a chamada de syscal 
    ecall            # realiza uma pausa de a0 ms
    
    addi s0,s0,8        # incrementa para o endere�o da pr�xima nota
    
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

CARREGA_FUNDO:               # carrega a imagem no frame 0
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
	
	# 3: movimentacao inimigos
	j MOV_LOKI
	LOKI_CHECK:
	
	j PRINT_LASER
	LASER_CHECK:

	jal CHITAURI
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
	lw t0,0(a4)	#verifica a fase
	beqz t0,CIMA_FASE1	#se for a fase1 pula essa parte

	#Impedindo o hulk de subir pelo obstáculo
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
	la a0, hulk_parado #carrega as dimensoes do hulk em a0
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
	bne t0,t1,ESQ_FASE1 #se não cumprir o requisito, é como se estivesse na fase 1

	#Teleportando o hulk
	addi a1,a1,100
	li a2,200
	sw a2, 4(s6)	   # atualiza a posicao y do personagem 

	j ESQ_FASE1
	
CHAR_BAIXO:
    la a0, hulk_parado #carrega as dimensoes do hulk em a0
    la s6,HULK_POS
	lw a2, 4(s6)       #carrega em a2 a posicao y atual do personagem
	addi a2, a2, 60   #move o hulk para baixo
	bgt a2,s5,PARA3   #limite do mapa
	lw t0,0(a4)	#verifica a fase
	beqz t0,BAIXO_FASE1	#se for a fase1 pula essa parte

	#Impedindo o hulk de descer pelo obstáculo
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
	la a0, hulk_parado #carrega as dimensoes do hulk em a0
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
	bne t0,t1,DIR_FASE1 #se não cumprir o requisito, é como se estivesse na fase 1

	#Teleportando o hulk
	addi a1,a1,-100
	li a2,80
	sw a2, 4(s6)	   # atualiza a posicao y do personagem 
	
	j DIR_FASE1
	

QUEBRA_JAN:
       
      
	la a0, hulk_ativo #carrega o tamanho da imagem em a0
	la t0, HULK_POS  #carrega em t0 a word que contem as posicoes xy do hulk
	lw a1, 0(t0)  #carrega em t0 o numero que esta na primeira word de HULK_POS(esse numero e a posicao x)
	lw a2, 4(t0)  #carrega em t0 o numero que esta na segunda word(offset da word = 4) de HULK_POS(esse numero e a posicao y)
	
	jal renderImage
       li a7,32
       li a0,100
       ecall
       
       # efeito sonoro
	    li a0, 40    # define a nota
	    li a1,800        # define a dura��o da nota em ms
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

CHITAURI:
	la t0, contagem
	lw t1, 0(t0)	# t1 = contagem de janelas quebradas
	li t2, 4
	blt t1, t2, CHIT_END	# se contagem < 4, faz nada
	
	la t0, CHITAURI_ATIVO
	lw t1, 0(t0)
	li t2, 1
	beq t1, t2, MOV_CHITAURI	# se o estado for ativo, pula
		# muda o estado para ativo
		li t2, 1
		la t0, CHITAURI_ATIVO
		sw t2, 0(t0) # CHITAURI_ATIVO = 1
		
		# gera n aleatorio de 80 a 200 em a0
		li a7, 42
		li a1, 120	# limite
		ecall
		addi a0, a0, 80
		mv t1, a0
		
		# atualiza a coordenada y do chitauri
		la t0, CHITAURI_POS
		sw t1, 4(t0)	# coordenada y do chitauri = t1
		
		# renderiza o chitauri
		la t0, CHITAURI_POS
		lw a1, 0(t0)
		lw a2, 4(t0)
		la a0, chitauri
		jal renderImage
		
		
		j CHIT_END
	
MOV_CHITAURI:	# A FAZER
	j CHIT_END
	
PROJETIL:
	la t0, PROJETIL_CONT
	lw t1, 0(t0)	# t1 = contagem atual
	
	li t0, 30000000
	blt, t1, t0, FIM_PROJ	# se contagem < t0, faz nada
	
	# zera a contagem
	la t0, PROJETIL_CONT
	sw zero, 0(t0)
	
	# define a posicao x do projetil
	la t1, LOKI_POS
	lw t2, 0(t1) 	# t2 = coordenada 'x' atual do loki
	lw t3, 4(t1)	# t3 = coordenada 'y' do loki
	
	la t0, PROJETIL_POS
	sw t2, 0(t0)	# registra a coordenada 'y' fixa
	
	# incrementa 1 a coordenada y
	la t0, PROJETIL_POS
	lw t1, 4(t0)
	addi t1, t1, 2	# desce a posicao y do sprite de 2 em 2 pixels
	sw t1, 4(t0)
	li s0, 200
	bgt t1, s0, FIM_PROJ
	
	# renderiza o fundo
	jal renderFundo
	
	# renderiza o projetil
	la t0, PROJETIL_POS
	lw a1, 0(t0)
	lw a2, 4(t0)
	la a0, projetil
	jal renderImage
	
	
	
	
	
	FIM_PROJ:
	addi t1, t1, 1	# incrementa 1 na contagem
	sw t1, 0(t0)	# registra a contagem
	ret
	

CARREGA_FASE2:
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
	la s0,NOTAS_VITORIA        # define o endere�o das notas
	li a2,0        # define o instrumento
	li a3,127        # define o volume
	li t0, 0

	LOOP_NOTAS_VITORIA:    
		beq t0,s1, DONE_MUSIC_VITORIA        # contador chegou no final? ent�o  v� para FIM
		lw a0,0(s0)        # le o valor da nota
		lw a1,4(s0)        # le a duracao da nota
		
		li a7,31        # define a chamada de syscall
		ecall            # toca a nota
		
		mv a0,a1        # passa a dura��o da nota para a pausa
		li a7,32        # define a chamada de syscal 
		ecall            # realiza uma pausa de a0 ms
		
		addi s0,s0,8        # incrementa para o endere�o da pr�xima nota
		
		addi t0,t0,1        # incrementa o contador de notas
		j LOOP_NOTAS_VITORIA
DONE_MUSIC_VITORIA:
ret

PRINT_PORTAIS:
	la a0,portal1		# printa portal1 e define posições x=217, y=180 
	li a1, 217
	li a2, 180
	jal renderImage
	la a0,portal2		# printa portal2 e define posições x=60, y=60 
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


renderFundo: # carrega todos os elementos de novo
	la a0, fundo1
	li a1, 0
	li a2, 0
	jal renderImage
	
	j PRINT_JANELAS
	
	la t0, HULK_POS
	lw a1, 0(t0)
	lw a2, 4(t0)
	jal renderImage
	
	la t0, LOKI_POS
	lw a1, 0(t0)
	lw a2, 0(t0)
	jal renderImage
	
	ret
	
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
			la s0,NOTAS_FINAL        # define o endere�o das notas
			li a2,0        # define o instrumento
			li a3,127        # define o volume
			li t0, 0

		LOOP_NOTAS_FINAL:    
			bge t0,s1, DONE_MUSIC_FINAL        # contador chegou no final? ent�o  v� para FIM
			lw a0,0(s0)        # le o valor da nota
			lw a1,4(s0)        # le a duracao da nota
			
			li a7,31        # define a chamada de syscall
			ecall            # toca a nota
			
			mv a0,a1        # passa a dura��o da nota para a pausa
			li a7,32        # define a chamada de syscal 
			ecall            # realiza uma pausa de a0 ms
			
			addi s0,s0,8        # incrementa para o endere�o da pr�xima nota
			
			addi t0,t0,1        # incrementa o contador de notas
			j LOOP_NOTAS_FINAL
		DONE_MUSIC_FINAL:
			li a7,10
			ecall 				# ecall para o exit
