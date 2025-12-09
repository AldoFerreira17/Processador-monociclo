/*
-------------------------------------------------------------------------
Disciplina: Arquitetura e Organização de Computadores - 2025.2
Atividade: Projeto 02 - Implementação de MIPS em Verilog
Grupo: [INSERIR NOMES AQUI]
Arquivo: testbench.v
Descrição: Gera clock/reset e monitora a execução do processador.
           Configurado com tempo estendido para programas maiores.
-------------------------------------------------------------------------
*/
`include "defines.vh"

module testbench;
  reg clock;
  reg reset;
  wire [31:0] PCOut;
  wire [31:0] ALUResultOut;
  wire [31:0] MemOut;

  // Instância do DUT (Device Under Test) - O Processador MIPS
  mips dut(
    .clock(clock),
    .reset(reset),
    .PCOut(PCOut),
    .ALUResultOut(ALUResultOut),
    .MemOut(MemOut)
  );

  // Geração de Clock (Período = 10ns)
  initial begin
    clock = 0;
    forever #5 clock = ~clock;
  end

  // Sequência de Controle da Simulação
  initial begin
    // Configura arquivo para visualização de ondas no GTKWave
    $dumpfile("mips_waveform.vcd");
    $dumpvars(0, testbench);

    // Reset inicial
    $display(">>> Iniciando Simulação...");
    reset = 1;
    #10;
    reset = 0;
    
    // -----------------------------------------------------------
    // TEMPO DE SIMULAÇÃO AUMENTADO
    // Como a instruction.list é grande, aumentamos para 5000ns.
    // Se o programa não terminar, aumente este valor (ex: #10000).
    // -----------------------------------------------------------
    #800; 
    
    $display("---------------------------------------------------------");
    $display("Simulação finalizada por limite de tempo.");
    $finish;
  end

  // Monitoramento (Imprime no terminal a cada ciclo de clock)
  always @(posedge clock) begin
    if (!reset) begin
      // Exibe estado básico: Tempo, PC, Instrução (Hex), Resultado ULA
      $write("Time: %4d | PC: %h | Instr: %h | ULA: %h ", 
               $time, PCOut, dut.instruction, ALUResultOut);

      // Feedback específico para operações de Memória
      if (dut.MemWrite) begin
          $display("| [MEM WRITE] Escreveu %h no end. %h", dut.dmem.WriteData, ALUResultOut);
      end
      else if (dut.MemRead) begin
          $display("| [MEM READ] Leu %h do end. %h", MemOut, ALUResultOut);
      end
      else begin
          $display(""); // Apenas pular linha
      end
    end
  end
endmodule