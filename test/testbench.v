/*
-------------------------------------------------------------------------
Disciplina: Arquitetura e Organização de Computadores - 2025.2
Atividade: Projeto 02 - Implementação de MIPS em Verilog
Grupo: Aldo Ferreira, Andressa Américo, Carlos de Souza, Gustavo do Monte
Arquivo: testbench.v
Descrição: Gera clock/reset e monitora a execução do processador.
           Versão ajustada para exibir 0 em vez de Z na leitura de memória.
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
    
    // Tempo de simulação calibrado para a lista de 64 instruções
    #800; 
    
    $display("---------------------------------------------------------");
    $display("Simulação finalizada por limite de tempo.");
    $finish;
  end

  // Monitoramento (Imprime no terminal a cada ciclo de clock)
  always @(posedge clock) begin
    if (!reset) begin
      // AQUI ESTÁ A MUDANÇA:
      // Usamos (dut.MemRead ? MemOut : 32'h0)
      // Se estiver lendo (MemRead=1), mostra o valor real. Se não, mostra 0.
      $write("Time: %4d | PC: %h | Instr: %h | ULA: %h | Mem: %h", 
             $time, PCOut, dut.instruction, ALUResultOut, 
             (dut.MemRead ? MemOut : 32'h0));

      // Feedback específico para operações de Memória (Logs extras)
      if (dut.MemWrite) begin
          $display(" | [MEM WRITE] Escreveu %h no end. %h", dut.dmem.WriteData, ALUResultOut);
      end
      else if (dut.MemRead) begin
          $display(" | [MEM READ] Leu %h do end. %h", MemOut, ALUResultOut);
      end
      else begin
          $display(""); // Apenas pular linha para manter a formatação
      end
    end
  end
endmodule