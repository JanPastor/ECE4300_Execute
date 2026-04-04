`timescale 1ns / 1ps

module executeTB;

    // 1. Clock and Input Regs (Driving the Simulation)
    reg clk;
    reg [1:0] ctlwb_in;
    reg [2:0] ctlm_in;
    reg [31:0] npc, rdata1, rdata2, s_extend;
    reg [4:0] instr_2016, instr_1511;
    reg [1:0] alu_op;
    reg [5:0] funct;
    reg alusrc, regdst;

    // 2. Output Wires (Observing the Results)
    wire [1:0] ctlwb_out;
    wire [2:0] ctlm_out;
    wire [31:0] adder_out, alu_result_out, rdata2_out;
    wire [4:0] muxout_out;

    // 3. Instantiate the Unit Under Test (UUT)
    execute uut (
        .clk(clk),
        .ctlwb_in(ctlwb_in),
        .ctlm_in(ctlm_in),
        .npc(npc),
        .rdata1(rdata1),
        .rdata2(rdata2),
        .s_extend(s_extend),
        .instr_2016(instr_2016),
        .instr_1511(instr_1511),
        .alu_op(alu_op),
        .funct(funct),
        .alusrc(alusrc),
        .regdst(regdst),
        .ctlwb_out(ctlwb_out),
        .ctlm_out(ctlm_out),
        .adder_out(adder_out),
        .alu_result_out(alu_result_out),
        .rdata2_out(rdata2_out),
        .muxout_out(muxout_out)
    );

    // 4. Clock Generation (100MHz / 10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // 5. Test Stimulus
    initial begin
        // Initialize all inputs to zero
        ctlwb_in = 0; ctlm_in = 0; npc = 0; rdata1 = 0; rdata2 = 0;
        s_extend = 0; instr_2016 = 0; instr_1511 = 0; alu_op = 0;
        funct = 0; alusrc = 0; regdst = 0;
        #10; // Wait for global reset

        // --- TEST CASE 1: R-Type ADD Instruction ($rd = $rs + $rt) ---
        // Assume: ADD $3, $1, $2
        ctlwb_in   = 2'b10;    // RegWrite = 1
        ctlm_in    = 3'b000;   // No branch/mem
        npc        = 32'd100;  // Current PC address
        rdata1     = 32'd15;   // Value in $rs ($1)
        rdata2     = 32'd25;   // Value in $rt ($2)
        s_extend   = 32'd4;    // Offset (ignored for R-type)
        instr_2016 = 5'd2;     // rt address
        instr_1511 = 5'd3;     // rd address (destination)
        alu_op     = 2'b10;    // R-type opcode
        funct      = 6'b100000; // ADD function code
        alusrc     = 0;        // Use rdata2 (Register)
        regdst     = 1;        // Use instr_1511 (rd)

        #20; // Allow two clock cycles for data to pass through the latch

        // --- TEST CASE 2: I-Type LW Instruction ($rt = Mem[$rs + Offset]) ---
        // Assume: LW $4, 8($1)
        alusrc     = 1;        // Use s_extend (Immediate)
        regdst     = 0;        // Use instr_2016 (rt) as destination
        s_extend   = 32'd8;    // Offset
        alu_op     = 2'b00;    // LW opcode (Add for address)
        instr_2016 = 5'd4;     // rt address (destination for LW)
        
        #20;
        $stop; // End simulation
    end

endmodule