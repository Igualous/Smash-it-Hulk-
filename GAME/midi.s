.data
# Numero de Notas a tocar
NUM: .word 112
# lista de nota,duração,nota,duração,nota,duração,...

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
	#Refrão(14 notas por linha = 28)
	60,2500,60,500,60,750,67,250,65,2010,63,1000,62,1000,60,2500,60,500,60,750,67,250,69,1000,65,1000,67,2010,
	72,2500,72,500,72,750,79,250,77,2010,75,1000,74,1000,72,2500,72,500,72,750,79,250,81,1000,77,1000,79,4000,

.text
li t1,0xFF000000    # endereco inicial da Memoria VGA - Frame 0
li t2,0xFF012C00    # endereco final 
la s1, tela          # endere?o dos dados da tela na memoria
addi s1,s1,8        # primeiro pixels depois das informa??es de nlin ncol
LOOP5:     beq t1,t2,MUSIC        # Se for o ?ltimo endere?o ent?o sai do loop
lw t3,0(s1)        # le um conjunto de 4 pixels : word
sw t3,0(t1)        # escreve a word na mem?ria VGA
addi t1,t1,4        # soma 4 ao endere?o
addi s1,s1,4
j LOOP5
MUSIC:
la s0,NUM        # define o endereço do número de notas
    lw s1,0(s0)        # le o numero de notas
    la s0,NOTAS        # define o endereço das notas
    li t0,0            # zera o contador de notas
    li a2,48        # define o instrumento Possíveis: 0,48
    li a3,127        # define o volume

LOOP_NOTAS:    beq t0,s1, mainMenuSelect        # contador chegou no final? então  vá para FIM
    lw a0,0(s0)        # le o valor da nota
    lw a1,4(s0)        # le a duracao da nota
    li a7,31        # define a chamada de syscall
    ecall            # toca a nota
    mv a0,a1        # passa a duração da nota para a pausa
    li a7,32        # define a chamada de syscal 
    ecall            # realiza uma pausa de a0 ms
    addi s0,s0,8        # incrementa para o endereço da próxima nota
    addi t0,t0,1        # incrementa o contador de notas
    j LOOP_NOTAS            # volta ao loop
mainMenuSelect:
        # Código abaixo obtém a entrada
        li    t0, 0xFF200000 # carrega em t0 o endereço do status do teclado.
        lb     t1, 0(t0) # carrega o status do teclado em t1.

        andi    t1, t1, 1 # isso é um processo de mascaramento. Apenas queremos saber sobre o primeiro bit de t1, que indica se alguma tecla foi pressionada.

        beq    t1, zero, mainMenuSelect 

        lb    t1, 4(t0) 

        li    t2, 0x031 
        beq    t1, t2, CARREGA_FUNDO1

        li    t2, 0x032 
        bne    t1, t2, continueMMSelect
        j    END
    continueMMSelect:
        j    mainMenuSelect

