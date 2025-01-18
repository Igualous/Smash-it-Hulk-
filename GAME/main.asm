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
# lista de nota,dura��o,nota,dura��o,nota,dura��o,...

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
	#Refr�o(14 notas por linha = 28)
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
.include "../DATA/doende.data"
.include "../DATA/projetil.data"
.include "../DATA/portal.data"
.include "../DATA/janela.data"
.include "../DATA/janela_quebrada.data"
.include "../DATA/porta.data"
.include "../DATA/porta_quebrada.data"
.include "../DATA/tela.data"

#############  SETUP INICIAL

# posicao inicial
hulkX:
.word 90
hulkY:
.word 200

lokiX:
.word 130
lokiY:
.word 20

janelaX:
.word 90
janelaY:
.word 70

##############
.text
#### START
# Carrega tela de menu
li t1,0xFF000000    # endereco inicial da Memoria VGA - Frame 0
li t2,0xFF012C00    # endereco final 
la s1, tela          # endere?o dos dados da tela na memoria
addi s1,s1,8        # primeiro pixels depois das informa??es de nlin ncol
LOOP5:     beq t1,t2, mainMenuSelect        # Se for o ?ltimo endere?o ent?o sai do loop
lw t3,0(s1)        # le um conjunto de 4 pixels : word
sw t3,0(t1)        # escreve a word na mem?ria VGA
addi t1,t1,4        # soma 4 ao endere?o
addi s1,s1,4
j LOOP5
mainMenuSelect:
        # C�digo abaixo obt�m a entrada
        li    t0, 0xFF200000 # carrega em t0 o endere�o do status do teclado.
        lb     t1, 0(t0) # carrega o status do teclado em t1.

        andi    t1, t1, 1 # isso � um processo de mascaramento. Apenas queremos saber sobre o primeiro bit de t1, que indica se alguma tecla foi pressionada.

        beq    t1, zero, mainMenuSelect 

        lb    t1, 4(t0) 

        li    t2, 0x031 
        beq    t1, t2, CARREGA_FUNDO1

        li    t2, 0x032 
        bne    t1, t2, continueMMSelect
        j    END
    continueMMSelect:
        j    mainMenuSelect
# Carrega o fundo1
CARREGA_FUNDO1:
	li t1,0xFF000000	# endereco inicial da Memoria VGA - Frame 0
	li t2,0xFF012C00	# endereco final 
	la s1,fundo1		# endere�o dos dados da tela na memoria
	addi s1,s1,8		# primeiro pixels depois das informa��es de nlin ncol
LOOP1: 	beq t1,t2,DONE		# Se for o ultimo endereco ent�o sai do loop
	lw t3,0(s1)		# le um conjunto de 4 pixels : word
	sw t3,0(t1)		# escreve a word na mem�ria VGA
	addi t1,t1,4		# soma 4 ao endereco
	addi s1,s1,4
	j LOOP1			# volta a verificar
DONE:


# Renderiza Loki na tela na posicao x = a1, y = a2
PRINT_LOKI:
	la a0, loki_parado
	lw a1, lokiX
	lw a2, lokiY
	
	jal renderImage
	

# Renderiza as janelas
PRINT_JANELAS:
	la a0, janela
	
	# janela 1
	lw a1, janelaX
	lw a2, janelaY
	jal renderImage
	
	# janela 2
	addi a1, a1, 50
	jal renderImage
	# janela 3
	addi a1, a1, 50
	jal renderImage
	
	# janela 4
	lw a1, janelaX
	addi a2, a2, 60
	jal renderImage
	
	# janela 5
	addi a1, a1, 50
	jal renderImage
	
	# janela 6
	addi a1, a1, 50
	jal renderImage
	
	# janela 7
	lw a1, janelaX
	addi a2, a2, 60
	jal renderImage
	
	# janela 8
	addi a1, a1, 100
	jal renderImage
	
	# porta
	la a0, porta
	lw a1, janelaX
	addi a1, a1, 50
	lw a2, janelaY
	addi a2, a2, 120
	jal renderImage

# Renderiza Hulk na posicao inicial
PRINT_HULK:
	la a0, hulk_parado
	lw a1, hulkX
	lw a2, hulkY
	
	jal renderImage
	
	
END:
	li a7, 10
	ecall	
	
#### RENDERIZACAO DE IMAGENS / PARAMETROS: a0 = arquivo.data; a1 = X; a2 = Y
renderImage:
# Argumentos da fun��o:
	# a0 cont�m o endere�o inicial da imagem
	# a1 cont�m a posi��o X da imagem
	# a2 cont�m a posi��o Y da imagem
	
	lw	s0, 0(a0) # Guarda em s0 a largura da imagem
	lw	s1, 4(a0) # Guarda em s1 a altura da imagem
	
	mv	s2, a0 # Copia o endere�o da imagem para s2
	addi	s2, s2, 8 # Pula 2 words - s2 agora aponta para o primeiro pixel da imagem
	
	li	s3, 0xff000000 # carrega em s3 o endere�o do bitmap display
	
	li		t1, 320 # t1 � o tamanho de uma linha no bitmap display
	mul		t1, t1, a2 # multiplica t1 pela posi��o Y desejada no bitmap display.
	# Multiplicamos 320 pela posi��o desejada para obter um offset em rela��o ao endere�o inicial do bimap display correspondente � linha na qual queremos desenhar a imagem. Basta agora obter mais um offset para chegar at� a coluna que queremos. Isso � mais simples, basta adicionar a posi��o X.
	add		t1, t1, a1
	# t1 agora tem o offset completo, basta adicion�-lo ao endere�o do bitmap.
	add		s3, s3, t1
	# O endere�o em s3 agora representa exatamente a posi��o em que o primeiro pixel da nossa imagem deve ser renderizado.
	
	li		t1, 0 # t1 = Y (linha) atual
	lineLoop:
		bge		t1, s1, endRender # Se terminamos a �ltima linha da imagem, encerrar
		li		t0, 0 # t0 = X (coluna) atual
		
		columnLoop:
			bge		t0, s0, columnEnd # Se terminamos a linha atual, ir pra pr�xima
			
			lb		t2, 0(s2) # Pega o pixel da imagem
			sb		t2, 0(s3) # P�e o pixel no display
			
			# Incrementa os endere�os e o contador de coluna
			addi	s2, s2, 1
			addi	s3, s3, 1
			addi	t0, t0, 1
			j		columnLoop
			
		columnEnd:
		
		addi	s3, s3, 320 # pr�xima linha no bitmap display
		sub		s3, s3, s0 # reposiciona o endere�o de coluna no bitmap display (subtraindo a largura da imagem). Note que essa subtra��o � necess�ria - verifique os efeitos da aus�ncia dela voc� mesmo, montando esse c�digo.
		
		addi	t1, t1, 1 # incrementar o contador de altura
		j		lineLoop
		endRender:
ret


