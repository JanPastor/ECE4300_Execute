
//executeTB.v

module executeTB;
    reg clk;
    reg [1:0] wb_ctl; 
    reg [2:0] m_ctl;
    reg [31:0] npcout, rdata1, rdata2, s_extendout;
    reg [4:0] instrout_2016, instrout_1511;
    reg [1:0] aluop;
    reg alusrc, regdst;

    wire [1:0] wb_ctlout;
    wire branch, memread, memwrite;
    wire [31:0] EX_MEM_NPC, alu_result, rdata2out;
    wire [4:0] five_bit_muxout;
    wire zero;

    execute uut (
        
        .clk(clk),
        .wb_ctl(wb_ctl),
        .m_ctl(m_ctl),
        .regdst(regdst),
        .alusrc(alusrc),
        .aluop(aluop),
        .npcout(npcout),
        .rdata1(rdata1),
        .rdata2(rdata2),
        .s_extendout(s_extendout),
        .instrout_2016(instrout_2016),
        .instrout_1511(instrout_1511),
        .wb_ctlout(wb_ctlout),
        .branch(branch),
        .memread(memread),
        .memwrite(memwrite),
        .EX_MEM_NPC(EX_MEM_NPC),
        .zero(zero),
        .alu_result(alu_result),
        .rdata2out(rdata2out),
        .five_bit_muxout(five_bit_muxout)
    );
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        // Initialize inputs
        
        // R-type add
        
        wb_ctl = 2'b10; 
        m_ctl = 3'b011;
        npcout = 32'd100; 
        
        rdata1 = 32'd10; 
        rdata2 = 32'd20; 
        s_extendout = 32'b100000;
        instrout_2016 = 5'd5; 
        instrout_1511 = 5'd10;
        aluop = 2'b10; 
        aluop = 2'b10; 
        alusrc = 0; 
        regdst = 1;

        #15;
        
        // R-TYPE SUBTRACT
        
        npcout = 32'd104;
        rdata1 = 32'd30;
        rdata2 = 32'd10;
        s_extendout = 32'b100010;
        instrout_2016 = 5'd3;
        instrout_1511 = 5'd12;
        aluop = 2'b10;
        alusrc = 0;
        regdst = 1;
        #15;
        
        // R-TYPE AND
        
        npcout = 32'd108;
        rdata1 = 32'd12;     // 1100
        rdata2 = 32'd10;     // 1010
        s_extendout = 32'b100100;
        instrout_2016 = 5'd7;
        instrout_1511 = 5'd15;
        aluop = 2'b10;
        alusrc = 0;
        regdst = 1;
        #15;
        
        // R-TYPE OR
        
        npcout = 32'd112;
        rdata1 = 32'd12;
        rdata2 = 32'd10;
        s_extendout = 32'b100101;
        instrout_2016 = 5'd8;
        instrout_1511 = 5'd16;
        aluop = 2'b10;
        alusrc = 0;
        regdst = 1;
        #15;
        
        // r-type slt
        
        npcout = 32'd116;
        rdata1 = 32'd5;
        rdata2 = 32'd10;
        s_extendout = 32'b101010;
        instrout_2016 = 5'd9;
        instrout_1511 = 5'd17;
        aluop = 2'b10;
        alusrc = 0;
        regdst = 1;
        #15;
        
        // BEQ, COMPARE EQUAL
        
        wb_ctl = 2'b01;
        m_ctl = 3'b100;      
        npcout = 32'd120;
        rdata1 = 32'd25;
        rdata2 = 32'd25;
        s_extendout = 32'd4;
        instrout_2016 = 5'd4;
        instrout_1511 = 5'd18;
        aluop = 2'b01; 
        alusrc = 0;
        regdst = 0;
        #15;
        
        // BEQ not equal
        
        npcout = 32'd124;
        rdata1 = 32'd25;
        rdata2 = 32'd20;
        aluop = 2'b01;
        alusrc = 0;
        regdst = 0;
        #15;
        
        //imm add
        
        wb_ctl = 2'b10;
        m_ctl = 3'b010;
        npcout = 32'd128;
        rdata1 = 32'd7;
        rdata2 = 32'd99;     
        s_extendout = 32'd9;
        instrout_2016 = 5'd11;
        instrout_1511 = 5'd19;
        aluop = 2'b00;     
        alusrc = 1;
        regdst = 0;
        #15;
        
  
        
        $stop;
    end
endmodule
