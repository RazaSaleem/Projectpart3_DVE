//Gets the packet from generator and drive the transaction packet items into interface (interface is connected to DUT, so the items driven into interface signal will get driven in to DUT) 

///////////////////////////DRIVER//////////////////////////////////////
class driver;
  //virtual interface handle
	virtual interface dut_if.drv vi;event rest;event Ok_driver;  //create mailbox handle
mailbox gen2driv;
int repeat_count;
  //constructor
      function new (mailbox gen2driv,virtual interface dut_if.drv vi,int repeat_count);
        this.gen2driv=gen2driv;
        this.vi=vi;
        this.repeat_count=repeat_count;
      endfunction:new
  //reset methods  default values
        
        task reset();
        wait(!vi.hresetn);    //wait for reset signal to toggle 
         // vi.drv_cb.error<=0;
          vi.drv_cb.htrans <= 0;
          vi.drv_cb.haddr<=0;
          vi.drv_cb.hwrite<=0;
          vi.drv_cb.hsize<=0;
          vi.drv_cb.hwdata<=0;
          vi.drv_cb.hburst<=0;
          vi.drv_cb.hprot<=0;
          wait(vi.hresetn);
          //$display("all the signals were reset to zero except HBURST And Hprot that were set to 0 and 0001 Symultaneously");  //debug purposes
          ->rest;//$display("event triggered");
        endtask:reset
  //drive methods
        task drive();       // drive the signals from transaction to interface.
          transaction trans;    //object creation
          //   $display(Driver task");
          repeat(repeat_count*2) begin     //loop for repeating the test
          trans=new();
            if(gen2driv.try_get(trans))$display(""/*"transfered in the driver"*/);else $display("mail didnt get line 33 driver.sv");
        
          @(posedge vi.hclk);
          //vi1.drv_cb.hsel=trans.hsel;
          vi.drv_cb.haddr<=trans.haddr;
          vi.drv_cb.htrans<=trans.htrans;
          vi.drv_cb.hwrite<=trans.hwrite;
          vi.drv_cb.hsize<=trans.hsize;
          vi.drv_cb.hburst<=trans.hburst;
          vi.drv_cb.hprot<=trans.hprot;
          vi.drv_cb.hwdata<=trans.hwdata;
          @(posedge vi.hclk);     
            
                //#################all for debugging purposes  ##############
           //$display("transaction trasfered to virtual interface");     //debugiing purpose  
//             $display(" data of vi2 interface from dut  error = %d ,haddr= %d ,htrans= %d ,hwrite= %d ,hsize= %d ,hburst= %d ,hprot= %d ,hwdata= %d ,hrdata= %d ,hready= %d ,hresp= %d  \n ",vi.drv_cb.error,vi.drv_c $display(" data of vi2 interface from dut  error = %d ,haddr= %d ,htrans= %d ,hwrite= %d ,hsize= %d ,hburst= %d ,hprot= %d ,hwdata= %d ,hrdata= %d ,hready= %d ,hresp= %d  \n ",vi.drv_cb.error,vi.drv_cb.haddr,vi.drv_cb.htrans,vi.drv_cb.hwrite,vi.drv_cb.hsize,vi.drv_cb.hburst,vi.drv_cb.hprot,vi.drv_cb.hwdata,vi.drv_cb.hrdata,vi.drv_cb.hready,vi.drv_cb.hresp);b.haddr,vi.drv_cb.htrans,vi.drv_cb.hwrite,vi.drv_cb.hsize,vi.drv_cb.hburst,vi.drv_cb.hprot,vi.drv_cb.hwdata,vi.drv_cb.hrdata,vi.drv_cb.hready,vi.drv_cb.hresp);           //#################all for debugging purposes  ##############
            
           end 
           ->Ok_driver;
        endtask:drive
  //main methods
        
        task run();
          //$display("######driver started ####");
          wait(vi.hresetn);     //when reset signal is 1 as our reset signal is actively low for testing the toggling of reset
          drive();              //task for driver 
        //  $display("driver called");   //when all is done then this will be displayed..
        endtask:run
          
endclass
