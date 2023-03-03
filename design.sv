/* Design */

module memory 
#(
    parameter ADDR_WIDTH = 32 ,
    parameter DATA_WIDTH = 32 ,
    parameter DEPTH      = 32
)
(
  input  logic                  clk       ,
  input  logic                  rst_n     ,
  input  logic                  en        ,
  input  logic                  wr        ,
  input  logic [ADDR_WIDTH-1:0] addr      ,
  input  logic [DATA_WIDTH-1:0] data_in   ,
  output logic [DATA_WIDTH-1:0] data_out  ,
  output logic                  valid_out
);
  
  reg [DATA_WIDTH-1:0] MEM [0:DEPTH-1];
  integer i;
  
  // Write to the memory
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin 
      for (i = 0; i < DEPTH; i = i + 1) begin
        MEM[i] <= '0;
      end
      valid_out <= 1'b0;
    end
    else if (en==1'b1 && wr==1'b1) begin
      MEM[addr] <= data_in;
      valid_out <= 1'b0;
    end
    else if (en==1'b1 && wr==1'b0) begin
      data_out  <= MEM[addr];
      valid_out <= 1'b1;
    end
  end 
endmodule