/*
-------------------------------------------------------------------------
Disciplina: Arquitetura e Organização de Computadores - 2025.2
Atividade: Projeto 02 - Implementação de MIPS em Verilog
Grupo: [INSERIR NOMES AQUI]
Arquivo: mips.v
Descrição: Módulo Top-Level. Integra Datapath e Controle.
-------------------------------------------------------------------------
*/
`include "defines.vh"

module mips(
  input clock,
  input reset,
  output [31:0] PCOut,
  output [31:0] ALUResultOut,
  output [31:0] MemOut
);
  // Fios de interconexão
  wire [31:0] PC, nextPC, instruction;
  wire [31:0] read_data1, read_data2, write_data;
  wire [31:0] sign_ext_out, alu_in2, dmem_out;
  wire RegDst, Jump, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, Jr, ExtOp, JalEn, LuiEn;
  wire [1:0] ALUOp;
  wire [3:0] alu_control;
  wire zero_flag;

  // 1. Contador de Programa (PC)
  pc pc_inst(.clock(clock), .reset(reset), .nextPC(nextPC), .PC(PC));
  assign PCOut = PC;
  
  // 2. Memória de Instrução
  i_mem imem(.address(PC), .i_out(instruction));
  
  // Mux do registrador de escrita
  wire [4:0] write_reg = JalEn ? 5'b11111 : (RegDst ? instruction[15:11] : instruction[20:16]);
  
  // 3. Banco de Registradores
  regfile regs(
    .clock(clock), .reset(reset), .RegWrite(RegWrite),
    .ReadAddr1(instruction[25:21]), .ReadAddr2(instruction[20:16]),
    .WriteAddr(write_reg), .WriteData(write_data),
    .ReadData1(read_data1), .ReadData2(read_data2)
  );
  
  // 4. Extensão de Sinal
  sign_extend ext(.imm(instruction[15:0]), .ExtOp(ExtOp), .ext_out(sign_ext_out));
  
  // Mux da entrada B da ULA
  assign alu_in2 = ALUSrc ? sign_ext_out : read_data2;
  
  // 5. Controle e ULA
  ula_ctrl uctrl(.ALUOp(ALUOp), .funct(instruction[5:0]), .OP_ula(alu_control));
  
  ula alu(
    .In1(read_data1), .In2(alu_in2), .shamt(instruction[10:6]),
    .OP(alu_control), .result(ALUResultOut), .Zero_Flag(zero_flag)
  );
  
  // 6. Memória de Dados
  d_mem dmem(
    .clock(clock), .MemRead(MemRead), .MemWrite(MemWrite),
    .address(ALUResultOut), .WriteData(read_data2), .ReadData(dmem_out)
  );
  assign MemOut = dmem_out;
  
  // 7. Lógica de Próximo PC
  wire [31:0] pc_plus4 = PC + 4;
  wire [31:0] branch_target = pc_plus4 + {sign_ext_out[29:0], 2'b00};
  wire is_jr = (instruction[31:26] == `MIPS_RTYPE) && (instruction[5:0] == `FUNCT_JR);
  wire branch_taken = Branch & (
    (instruction[31:26] == `MIPS_BEQ & zero_flag) | 
    (instruction[31:26] == `MIPS_BNE & ~zero_flag)
  );
  
  assign nextPC = is_jr ? read_data1 :
                  Jump  ? {pc_plus4[31:28], instruction[25:0], 2'b00} :
                  branch_taken ? branch_target :
                  pc_plus4;
  
  assign write_data = JalEn ? pc_plus4 : 
                      LuiEn ? {instruction[15:0], 16'b0} : 
                      MemtoReg ? dmem_out : ALUResultOut;
  
  // 8. Unidade de Controle Principal
  control ctrl(
    .opcode(instruction[31:26]), .funct(instruction[5:0]),
    .RegDst(RegDst), .Jump(Jump), .Branch(Branch),
    .MemRead(MemRead), .MemtoReg(MemtoReg), .ALUOp(ALUOp),
    .MemWrite(MemWrite), .ALUSrc(ALUSrc), .RegWrite(RegWrite),
    .Jr(Jr), .ExtOp(ExtOp), .JalEn(JalEn), .LuiEn(LuiEn)
  );

endmodule