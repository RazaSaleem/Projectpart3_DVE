//Gets the packet from monitor, generates the expected result and compares with the actual result received from the Monitor

class scoreboard;
   
  //create mailbox handle
mailbox mon2scr;      //as we are using only one mail box through out the process
int repeat_count;event OK_scrbd;
  //array to use as local memory
  reg     [7:0] mem [0:1024-1];     // 1024 was defined in define file as MS which was not declared in interface parameters array is exactly the same as in design memory 
  //constructor
  function new(mailbox mon2scr,int repeat_count);
	this.mon2scr = mon2scr;
	this.repeat_count=repeat_count;
	//this.repeat_count = repeat_count;
   endfunction
  //main method
  task run();
    transaction t_from_mon;
    bit ok_mon;
    int fails=0;   //as we have to check the failed ratio
    $display("###################Scrbd#################");
  //  int ncount=0,nsuccess=0,nfails=0;
    repeat(repeat_count*2) begin
    mon2scr.get(t_from_mon);
    t_from_mon.display();
      if(ok_mon)$display(""/*"get accomplished from mon"*/);
      else $display(/*"get failed from mon"*/"");   //for debugging puposes
      if(t_from_mon.hwrite==1)
      mem[t_from_mon.haddr]=t_from_mon.hwdata;
    else begin
      if((mem[t_from_mon.haddr]!=t_from_mon.hrdata))  //comparing the data of slave and our virtual memory
      begin
        t_from_mon.display();$display("mem data = %d and recieved data = %d ",mem[t_from_mon.haddr],t_from_mon.hrdata);fails++;end
        else  ; 
          $display("rdata is same as in V.memory mem data = %d and recieved data = %d ",mem[t_from_mon.haddr],t_from_mon.hrdata);
        
   end
//         $display(" data compared   error = %d ,hsel= %d ,haddr= %d ,htrans= %d ,hwrite= %d ,hsize= %d ,hburst= %d ,hprot= %d ,hwdata= %d , hrdata from DUT = %d ,hready= %d ,hresp= %d  \n  ",t_from_mon.error ,t_from_mon.hsel,t_from_mon.haddr,t_from_mon.htrans,t_from_mon.hwrite,t_from_mon.hsize,t_from_mon.hburst,t_from_mon.hprot,t_from_mon.hwdata,t_from_mon.hrdata,t_from_mon.hready,t_from_mon.hresp);end
  
if(fails)    begin
      $display("the test failed with %d times of failure",fails);end
      else $display("congrats Test passed");
//       $display(" data compared   error = %d ,hsel= %d ,haddr= %d ,htrans= %d ,hwrite= %d ,hsize= %d ,hburst= %d ,hprot= %d ,hwdata= %d , hrdata from DUT = %d ,hready= %d ,hresp= %d     Expected data in Local mem :: %d  \n   ",t_from_mon.error ,t_from_mon.hsel,t_from_mon.haddr,t_from_mon.htrans,t_from_mon.hwrite,t_from_mon.hsize,t_from_mon.hburst,t_from_mon.hprot,t_from_mon.hwdata,t_from_mon.hrdata,t_from_mon.hready,t_from_mon.hresp,mem[t_from_mon.haddr]);
    end   
    ->OK_scrbd;
          //$display("####################################");
  endtask:run
  

endclass
