.data
# inclusao dos audios

#inclusao das imagens

.include "../DATA/fundo1.data"
.include "../DATA/fundo2.data"
.include "../DATA/hulk_ativo.data"
.include "../DATA/hulk_parado.data"
.include "../DATA/hulk_pulando.data"
.include "../DATA/loki_ativo.data"
.include "../DATA/loki_parado.data"
.include "../DATA/doende.data"
.include "../DATA/projetil.data"
.include "../DATA/portal.data"

hulkX:
.word 90
hulkY:
.word 200

lokiX:
.word 130
lokiY:
.word 30

.text
# Carrega o fundo1
	li t1,0xFF000000	# endereco inicial da Memoria VGA - Frame 0
	li t2,0xFF012C00	# endereco final 
	la s1,fundo1		# endere�o dos dados da tela na memoria
	addi s1,s1,8		# primeiro pixels depois das informa��es de nlin ncol
LOOP1: 	beq t1,t2,DONE		# Se for o �ltimo endere�o ent�o sai do loop
	lw t3,0(s1)		# le um conjunto de 4 pixels : word
	sw t3,0(t1)		# escreve a word na mem�ria VGA
	addi t1,t1,4		# soma 4 ao endere�o
	addi s1,s1,4
	j LOOP1			# volta a verificar
DONE:


# renderizar hulk na tela
	la a0, hulk_parado
	lw a1, hulkX
	lw a2, hulkY
	
	jal renderImage
	
# renderizar loki na tela
	la a0, loki_parado
	lw a1, lokiX
	lw a2, lokiY
	
	

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