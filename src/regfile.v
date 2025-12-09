/*
-------------------------------------------------------------------------
Disciplina: Arquitetura e Organização de Computadores - 2025.2
Atividade: Projeto 02 - Implementação de MIPS em Verilog
Grupo: Aldo Ferreira, Andressa Américo, Carlos de Souza, Gustavo do Monte
Arquivo: regfile.v
Descrição: Banco com 32 registradores de 32 bits. Reg $0 é sempre zero.
-------------------------------------------------------------------------
*/
module regfile(
  input clock,
  input reset,
  input RegWrite,            // Habilita escrita
  input [4:0] ReadAddr1,     // Endereço rs
  input [4:0] ReadAddr2,     // Endereço rt
  input [4:0] WriteAddr,     // Endereço rd (ou rt em tipo-I)
  input [31:0] WriteData,    // Dado a ser escrito
  output [31:0] ReadData1,   // Saída rs
  output [31:0] ReadData2    // Saída rt
);
  reg [31:0] registers [0:31]; 
  integer i;

  // Leitura Assíncrona
  assign ReadData1 = (ReadAddr1 == 0) ? 32'b0 : registers[ReadAddr1];
  assign ReadData2 = (ReadAddr2 == 0) ? 32'b0 : registers[ReadAddr2];

  // Escrita Síncrona
  always @(posedge clock or posedge reset) begin
    if (reset) begin
      for (i=0; i<32; i=i+1) registers[i] <= 0;
    end 
    else if (RegWrite && WriteAddr != 0) begin
      registers[WriteAddr] <= WriteData;
    end
  end
endmodule