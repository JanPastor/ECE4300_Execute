`timescale 1ns / 1ps

// the fix here was changing the logic
// from always @* (combinational) to always @(posedge clk) (synchronous).

module ex_mem(
    input wire clk,
    input wire [1:0] ctlwb_in,
    input wire [2:0] ctlm_in,
    input wire [31:0] adder_in,
    input wire aluzero_in,
    input wire [31:0] alu_res_in, rdata2_in,
    input wire [4:0] write_reg_in,
    output reg [1:0] ctlwb_out,
    output reg [2:0] ctlm_out,
    output reg [31:0] adder_out,
    output reg [31:0] alu_result_out, rdata2_out,
    output reg [4:0] muxout_out
);

    initial begin
        ctlwb_out = 0; ctlm_out = 0; adder_out = 0;
        alu_result_out = 0; rdata2_out = 0; muxout_out = 0;
    end

    // The Latch "snaps" the data on the rising edge of the clock
    always @(posedge clk) begin
        ctlwb_out      <= ctlwb_in;
        ctlm_out       <= ctlm_in;
        adder_out      <= adder_in;
        alu_result_out <= alu_res_in;
        rdata2_out     <= rdata2_in;
        muxout_out     <= write_reg_in;
    end

endmodule