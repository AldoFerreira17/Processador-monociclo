/*
-------------------------------------------------------------------------
Disciplina: Arquitetura e Organização de Computadores - 2025.2
Atividade: Projeto 02 - Implementação de MIPS em Verilog
Grupo: Aldo Ferreira, Andressa Américo, Carlos de Souza, Gustavo do Monte
Arquivo: i_mem.v
Descrição: Memória de Instrução (ROM). Lê o programa de 'instruction.list'.
-------------------------------------------------------------------------
*/
`include "defines.vh"

module i_mem(
  input  wire [31:0] address,   // Endereço vindo do PC
  output wire [31:0] i_out      // Instrução lida
);
  reg [31:0] mem [0:`IMEM_SIZE-1];
  integer i;

  initial begin
    // Inicializa com zeros
    for (i = 0; i < `IMEM_SIZE; i = i + 1) mem[i] = 32'b0;

    // Carrega o arquivo externo (Requisito do PDF)
    $readmemb("instruction.list", mem);
  end
  
  // Leitura assíncrona (word align: address / 4)
  assign i_out = mem[address[11:2]]; 
endmodule