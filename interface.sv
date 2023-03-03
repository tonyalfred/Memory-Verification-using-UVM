/* Interface */

interface intf1
#(
  parameter ADDR_WIDTH=32 ,
  parameter DATA_WIDTH=32
);

  logic                  clk       ;
  logic                  rst_n     ;
  logic                  en        ;
  logic                  wr        ;
  logic [ADDR_WIDTH-1:0] addr      ;
  logic [DATA_WIDTH-1:0] data_in   ;
  logic [DATA_WIDTH-1:0] data_out  ;
  logic                  valid_out ;

endinterface 