Processador de 32 bits para a 2 atividade avaliativa da disciplina de Arquitetura e Organização de Computadores. 

Professor: Vitor Coutinho 

Grupo: Aldo Ferreira, Andressa Américo, Carlos de Souza, Gustavo do Monte


Ferramentas Utilizadas

Linguagem: Verilog

Compilador: Icarus Verilog

Visualização de Ondas: GTKWave 

Editor: VScode

Instruções Suportadas

O processador implementa as seguintes instruções do MIPS:

Tipo	Instruções
R-Type	add, sub, and, or, xor, nor, slt, sltu, sll, srl, sra, sllv, srlv, srav, jr
I-Type	addi, andi, ori, xori, beq, bne, slti, sltiu, lui, lw, sw
J-Type	j, jal

O processador é composto pelos seguintes módulos interconectados:

mips.v (Top-Level): Integra todos os componentes do datapath e controle.
pc.v: Contador de Programa (Program Counter).
i_mem.v: Memória de Instruções (Lê o arquivo instruction.list).
d_mem.v: Memória de Dados (RAM).
regfile.v: Banco de Registradores (32 registradores de 32 bits).
ula.v: Unidade Lógica e Aritmética.
control.v: Unidade de Controle Principal.
ula_ctrl.v: Unidade de Controle da ULA.
sign_extend.v: Extensor de sinal (16 bits -> 32 bits).

comandos

Compilar: iverilog -o mips_simu -I include test/testbench.v src/*.v

Executar: vvp mips_simu

visualizar ondas gtkwave: gtkwave mips_waveform.vcd

Visualizar ondas no Gtkwave: gtkwave mips_waveform.vcd
