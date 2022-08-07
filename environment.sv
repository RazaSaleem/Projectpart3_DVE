//A container class that contains Mailbox, Generator, Driver, Monitor and Scoreboard
//Connects all the components of the verification environment
`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
class environment;
  //handles of all components
  generator gen;
  driver dr;
  monitor mon;
  scoreboard scbrd;
  //mailbox handles
  
  mailbox gen2driv , mon2scr;
  //declare an event
  //event gen2test_synq;               //no need here because already createdt he event of completion in generation class.
  //constructor
  function new(virtual dut_if vi,int repeat_count,int test_type);
  this.gen2driv = new();
  this.mon2scr = new();
    this.gen = new(gen2driv, repeat_count,test_type);
    this.dr = new(gen2driv, vi,repeat_count);
    this.mon = new( vi,mon2scr,repeat_count);
    this.scbrd = new(mon2scr,repeat_count);
  
  endfunction 
  //pre_test methods
                   task pre_test();
                     dr.reset();
                     //$display("reset function called");
                   endtask:pre_test
  //test methods
                    task test();
                     fork
                        gen.run();
                        dr.run();
                        mon.run();
                        scbrd.run();
                     join_any
                   endtask:test  
  //post_test methods
                   task check();                     
                     wait(gen.OK_gen.triggered);
                     //$display("GEN triggered");
                     wait(dr.Ok_driver.triggered); 
                     //$display("driver triggered");
                     wait(mon.OK_mon.triggered); 
                     //$display("monitor triggered");
                    //wait(scbrd.OK_scrbd.triggered); 
                     
                   endtask:check
  //run methods
                   task run(); // run for main calling
                     pre_test();
                     $display("Reset function");
                     test();                    
                     $display("test functions");
                     check();
                     $display("check  functions");
                     $finish;
                   endtask:run    
endclass
