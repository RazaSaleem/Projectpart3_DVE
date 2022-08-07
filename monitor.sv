//Samples the interface signals, captures into transaction packet and sends the packet to scoreboard.
///////////////////////////////MONITOR/////////////////////////////////////////////
class monitor;
  
  //virtual interface handle
virtual interface dut_if.mon vi;event OK_mon;
  int repeat_count;
  int OK;
  //create mailbox handle
mailbox mon2scr;
  //constructor
  function new (virtual interface dut_if.mon vi,mailbox mon2scr,int repeat_count);   //construction function for initializations
    this.vi=vi;
    this.mon2scr=mon2scr;
    this.repeat_count=repeat_count;
    endfunction:new
  //main method
    task run();
      transaction trans;
      
     // $display("monor");
      repeat(repeat_count*2) begin   //repeating exactly as driver for 2 times more than generator
      trans=new();
      @(posedge vi.hclk);
            trans.hwrite = vi.mon_cb.hwrite;
            trans.haddr = vi.mon_cb.haddr; 
            trans.htrans = vi.mon_cb.htrans; 
            trans.hwdata = vi.mon_cb.hwdata;
            trans.hsize = vi.mon_cb.hsize;
            trans.hburst = vi.mon_cb.hburst;
            trans.hprot = vi.mon_cb.hprot;
            trans.hwdata = vi.mon_cb.hwdata;
            trans.hrdata = vi.mon_cb.hrdata;
            trans.hready = vi.mon_cb.hready;
            trans.hresp = vi.mon_cb.hresp;
        @(posedge vi.hclk);              
      mon2scr.put(trans);
//      if(OK) //debugging puposes;;
//         $display("mail put successfull in monitor class helo");
//        else
//         $display("mail put was not successfull in monitor class in monitor.sv line nmbr 21");
      //below 2 displays are  just for debugging purposes  no relation with logic or any thing 
//       $display(" data of vi2 interface from dut  error = %d ,haddr= %d ,htrans= %d ,hwrite= %d ,hsize= %d ,hburst= %d ,hprot= %d ,hwdata= %d ,hrdata= %d ,hready= %d ,hresp= %d  \n ",vi.mon_cb.error ,vi.mon_cb.haddr,vi.mon_cb.htrans,vi.mon_cb.hwrite,vi.mon_cb.hsize,vi.mon_cb.hburst,vi.mon_cb.hprot,vi.mon_cb.hwdata,vi.mon_cb.hrdata,vi.mon_cb.hready,vi.mon_cb.hresp);
  // trans.display();
      
//       $display(" data of trans that is created from dut  error = %d ,hsel= %d ,haddr= %d ,htrans= %d ,hwrite= %d ,hsize= %d ,hburst= %d ,hprot= %d ,hwdata= %d ,hrdata= %d ,hready= %d ,hresp= %d  \n ",trans.error ,trans.hsel,trans.haddr,trans.htrans,trans.hwrite,trans.hsize,trans.hburst,trans.hprot,trans.hwdata,trans.hrdata,trans.hready,trans.hresp);
      end
      //$display("end mon");      
      ->OK_mon;
     // $display("end of monitor");
    endtask:run
endclass
