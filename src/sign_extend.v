/*
-------------------------------------------------------------------------
Disciplina: Arquitetura e Organização de Computadores - 2025.2
Atividade: Projeto 02 - Implementação de MIPS em Verilog
Grupo: [INSERIR NOMES AQUI]
Arquivo: sign_extend.v
Descrição: Estende imediatos de 16 bits para 32 bits (com sinal ou zero).
-------------------------------------------------------------------------
*/
module sign_extend(
  input [15:0] imm,
  input ExtOp,       // 1 = Sinal, 0 = Zero
  output reg [31:0] ext_out
);
  always @(*) begin
    if (ExtOp) 
      ext_out = {{16{imm[15]}}, imm}; // Extensão de sinal
    else       
      ext_out = {16'b0, imm};         // Extensão de zero
  end
endmodule