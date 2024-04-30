`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/24 19:35:04
// Design Name: 
// Module Name: tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module tb;

// Inputs
reg mul_clk;
reg resetn;
reg [31:0] x;
reg [31:0] y;
reg [31:0] x_r;
reg [31:0] y_r;

// Outputs
wire signed [63:0] result;

booth_multiplier u_booth_multiplier(
    .x(x_r),
    .y(y_r),
    .z(result)
);

initial begin
    // Initialize Inputs
    mul_clk = 0;
    resetn = 0;
    x = 0;
    y = 0;
    #100;
    resetn = 1;
end
always #5 mul_clk = ~mul_clk;

//产生随机乘数和有符号控制信号
always @(posedge mul_clk)
begin
    x          <= $random;
    y          <= $random; //$random为系统任务，产生一个随机的32位有符号数
    #100;
end

always @(posedge mul_clk)
begin
    if (!resetn)
    begin
        x_r          <= 32'd0;
        y_r          <= 32'd0;
    end
    else
    begin
        x_r          <= x;
        y_r          <= y;
    end
end

//参考结果
wire signed [63:0] result_ref;
wire signed [32:0] x_e;
wire signed [32:0] y_e;
assign x_e        = {x_r[31],x_r};
assign y_e        = {y_r[31],y_r};
assign result_ref = x_e * y_e;
assign ok         = (result_ref == result);

endmodule
