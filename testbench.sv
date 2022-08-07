// Code your testbench here //
// or browse Examples


`define HDATA_SIZE 32
`define HADDR_SIZE 32
`define MEM_SIZE 4
`include "interface.sv"
//`include "amba_ahb_defines.v"
`include "test.sv"

module tb_top;
// Clock generator
  bit hclk;
  bit hresetn;
  

always #5 hclk = ~hclk;
  //reset generation
  initial begin
    hresetn = 0;
    #5 hresetn =1;
  end

  dut_if inf(hclk,hresetn);
  ahb3lite_sram1rw #(
      .MEM_SIZE(`MEM_SIZE),   //Memory in Bytes
    .HADDR_SIZE(`HADDR_SIZE),
    .HDATA_SIZE(`HDATA_SIZE))
  inst(
   .HCLK(inf.hclk),
    .HRESETn(inf.hresetn),
    .HSEL(1'b1),
    .HADDR(inf.haddr),
    .HTRANS(inf.htrans),
    .HWRITE(inf.hwrite),
    .HSIZE(inf.hsize),
    .HBURST(inf.hburst),
    .HPROT(inf.hprot),
    .HWDATA(inf.hwdata),
    .HRDATA(inf.hrdata),
    .HREADY(1'b1),
    .HRESP(inf.hresp),
    .HREADYOUT(inf.hreadyout));
  test ta(inf);
  
  
  initial begin
    
   $dumpfile("dump.vcd"); $dumpvars;
    #5000;
  end
endmodule
