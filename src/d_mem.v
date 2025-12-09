/*
-------------------------------------------------------------------------
Disciplina: Arquitetura e Organização de Computadores - 2025.2
Atividade: Projeto 02 - Implementação de MIPS em Verilog
Grupo: Aldo Ferreira, Andressa Américo, Carlos de Souza, Gustavo do Monte
Arquivo: d_mem.v
Descrição: Memória RAM para armazenamento de dados (Load/Store).
-------------------------------------------------------------------------
*/
`include "defines.vh"

module d_mem(
  input clock,
  input MemRead,          // Habilita leitura
  input MemWrite,         // Habilita escrita
  input [31:0] address,   // Endereço
  input [31:0] WriteData, // Dado a ser escrito
  output [31:0] ReadData  // Dado lido
);
  reg [31:0] mem [0:`DMEM_SIZE-1];
  integer k;

  initial begin
     for (k=0; k<`DMEM_SIZE; k=k+1) mem[k] = 32'b0;
  end

  assign ReadData = MemRead ? mem[address[11:2]] : 32'bz;
  
  always @(posedge clock) begin
    if (MemWrite) 
      mem[address[11:2]] <= WriteData;
  end
endmodule