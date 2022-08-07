/Fields required to generate the stimulus are declared in the transaction class
///////////////////////////TRANSACTION//////////////////////////////////////
`define HDATA_SIZE 32
`define HADDR_SIZE 32
class transaction;
  parameter HADDR_SIZE = `HADDR_SIZE;
  parameter HDATA_SIZE = `HDATA_SIZE;
  //declare transaction items
  ////excluding the hwrite signal so that it would be configured after wards in the different sections// Transfer direction    // for writting first then reading all the data 
  bit [HDATA_SIZE-1:0] hwdata;
  bit [HDATA_SIZE-1:0] hrdata;   // Read data bus
  bit           hready;   // Transfer done
  bit  [HDATA_SIZE-1:0] hresp;    // Transfer response
  bit [2:0] hsize;    //randomness removed in constraints
  bit [2:0] hburst;    //
  rand bit [3:0] hprot;
  randc bit  [HADDR_SIZE-1:0] haddr;            
  rand bit    [1:0] htrans;  
  bit hwrite;
//////////////////////////////////////////////////////////////
  //Add Constraints

 constraint c1 {htrans == 2;}     //only non seq transfer
 constraint c2 {hsize inside {2};} //  32 bit size 
  constraint c3 {if(hsize==1)haddr%2==0;             
                else if(hsize==2)haddr%4==0;
                 else haddr%1==0;}   // for allignmetn of data adress
  constraint c4 {haddr<=1023;}      // to make the addrersses under 1024
  constraint c5 {hwdata<=255;}   //to make data under 8bits
  constraint c6 {hprot == 4'b0001;}     // protetion set according to 
  constraint c7 {hburst == 0;}   //single burst data 
  
  //Add print transaction method(optional)
  function void display;
    $display("Transaction  haddr= %d ,htrans= %d ,hwrite= %d , hsize= %d ,hburst= %d ,hprot= %d ,hwdata= %d ,hrdata= %d , hready= %d ,hresp= %d ",haddr,htrans,hwrite,hsize,hburst,hprot,hwdata,hrdata,hready,hresp);
  endfunction
   
endclass
