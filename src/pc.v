/*
-------------------------------------------------------------------------
Disciplina: Arquitetura e Organização de Computadores - 2025.2
Atividade: Projeto 02 - Implementação de MIPS em Verilog
Grupo: Aldo Ferreira, Andressa Américo, Carlos de Souza, Gustavo do Monte
Arquivo: pc.v
Descrição: Registrador de 32 bits que armazena o endereço da instrução atual.
-------------------------------------------------------------------------
*/
module pc(
  input clock,          // Clock do sistema
  input reset,          // Reset global
  input [31:0] nextPC,  // Próximo endereço calculado
  output reg [31:0] PC  // Endereço atual
);
  always @(posedge clock or posedge reset) begin
    if (reset) 
      PC <= 32'h00000000; 
    else       
      PC <= nextPC;       
  end
endmodule