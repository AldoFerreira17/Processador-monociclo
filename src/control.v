/*
-------------------------------------------------------------------------
Disciplina: Arquitetura e Organização de Computadores - 2025.2
Atividade: Projeto 02 - Implementação de MIPS em Verilog
Grupo: [INSERIR NOMES AQUI]
Arquivo: control.v
Descrição: Decodifica o Opcode e gera sinais de controle para o Datapath.
-------------------------------------------------------------------------
*/
`include "defines.vh"

module control(
  input [5:0] opcode,
  input [5:0] funct,
  output reg RegDst, Jump, Branch, MemRead, MemtoReg,
  output reg [1:0] ALUOp,
  output reg MemWrite, ALUSrc, RegWrite, Jr, ExtOp, JalEn, LuiEn
);
  always @(*) begin
    // Reset padrão
    RegDst=0; Jump=0; Branch=0; MemRead=0; MemtoReg=0;
    ALUOp=`ALUOP_LW_SW_ADDI; MemWrite=0; ALUSrc=0; RegWrite=0;
    Jr=0; ExtOp=1; JalEn=0; LuiEn=0;

    case (opcode)
      `MIPS_RTYPE: begin
        RegDst = 1; RegWrite = 1; ALUOp = `ALUOP_RTYPE;
        Jr = (funct == `FUNCT_JR) ? 1 : 0;
      end
      `MIPS_ADDI: begin ALUSrc = 1; RegWrite = 1; end
      `MIPS_ANDI: begin ALUSrc = 1; RegWrite = 1; ExtOp = 0; ALUOp = `ALUOP_ANDI_ORI_XORI; end
      `MIPS_ORI:  begin ALUSrc = 1; RegWrite = 1; ExtOp = 0; ALUOp = `ALUOP_ANDI_ORI_XORI; end
      `MIPS_XORI: begin ALUSrc = 1; RegWrite = 1; ExtOp = 0; ALUOp = `ALUOP_ANDI_ORI_XORI; end
      `MIPS_BEQ:  begin Branch = 1; ALUOp = `ALUOP_BEQ_BNE; end
      `MIPS_BNE:  begin Branch = 1; ALUOp = `ALUOP_BEQ_BNE; end
      `MIPS_SLTI: begin ALUSrc = 1; RegDst = 0; RegWrite = 1; ALUOp = 2'b10; end
      `MIPS_SLTIU:begin ALUSrc = 1; RegDst = 0; RegWrite = 1; ALUOp = 2'b11; end
      `MIPS_LUI:  begin ALUSrc = 1; RegWrite = 1; LuiEn = 1; end
      `MIPS_LW:   begin ALUSrc = 1; MemtoReg = 1; RegWrite = 1; MemRead = 1; end
      `MIPS_SW:   begin ALUSrc = 1; MemWrite = 1; end
      `MIPS_J:    begin Jump = 1; end
      `MIPS_JAL:  begin Jump = 1; RegWrite = 1; JalEn = 1; end
      default: begin end
    endcase
  end
endmodule