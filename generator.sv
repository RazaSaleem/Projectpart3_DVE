//Generates randomized transaction packets and put them in the mailbox to send the packets to driver 
///////////////////////////GENERATOR//////////////////////////////////////

class generator;
  //declare transaction class 
  transaction trans,trans1;
  int repeat_count;
  //create mailbox handle
  mailbox gen2driv;      //one mailbox will be transfered again and again
  //declare an event
  event OK_gen;          //this will be triggered if mail puts all data successfully 	
    bit j;// this will be 1 when gen mail putted to scrboard
    bit i;
  int test_type;
  int data_inc=0;
  //constructor
  function new(  mailbox gen2driv,  int repeat_count, int test_type);
      this.gen2driv=gen2driv;
      this.repeat_count=repeat_count;
      this.test_type=test_type;
    endfunction
  //main methods
     task run();
       //$display("###############Generator######################");
       if(test_type==1)
         begin
           repeat(repeat_count)
             begin
       			trans=new();
               j = trans.randomize(); //randomizing the transaction
       			trans.hwrite=1;     			 //for writting before reading 
       			trans1=new trans;  		  //copyng the transaction
         		if (j)
                  begin       		 //if randomization failes  that this will fail and returns error
        			gen2driv.put(trans); 	//trans to mailbox
        			trans1.hwrite=0;   		//for reading signal altered
        			gen2driv.put(trans1);  //to mail box 
       				 //trans.display(); //just for debugging purposes
       				//   trans1.display();
        		  end
               if(!i)
            	-> OK_gen;   //event triggered
        		else 
                  begin	
        		$display ("OK_gen not triggered");
        			$display("FATAL::ERROR Line 40  generator.sv gen failed");
                  end
        	end
       
           
     if(test_type==2) 
       begin
                for (bit [31:0] i=0; i<=repeat_count+46; i=i+4) //we use i+4 due to address manipulation                
                  begin
                  trans = new();  //rand trans for writing to DUT 
            		  trans.hwrite =1; //write operation
              		  trans.hprot=1;
            		  trans.hburst=1;
            	 	  trans.htrans=2;
            		  trans.hsize=2;
            		  trans.haddr=i;
               	      trans.hwdata=32'h01234567;
           			  gen2driv.put(trans);
           			  trans.display();
         	
          			end
           for (int i=0; i<=repeat_count+46; i=i+4)   // same as upper one as we written the data in same phase and read in same phase 
       			    begin
       			      trans = new();
       			      trans.hwrite =0; //read opertaion
       			      trans.hprot=1;
       			      trans.hburst=1;
       			      trans.htrans=2;
       			      trans.hsize=2;
       			      trans.haddr=i;
       			      trans.hwdata=0;
       			      gen2driv.put(trans);
       			      trans.display();
       			    end
              end
       if(test_type == 3)
         begin
           for (bit [31:0] i=0; i<=repeat_count+30; i=i+4)     //directed test with burst zero 
          	begin
              trans = new(); // generationn
          	  trans.hwrite =1; //write OP signal
          	  trans.hprot=1;
          	  trans.hburst=0;
          	  trans.htrans=2;
          	  trans.hsize=2;
          	  trans.haddr=i;
          	  trans.hwdata=data_inc;
          	  gen2driv.put(trans);
          	  trans.display();
          	  data_inc+=2;
          end
           for (int i=0; i<=repeat_count+26; i=i+4)
          begin
            trans = new();
            trans.hwrite =0; //Read  operation
            trans.hprot=1;
            trans.hburst=0;
            trans.htrans=2;
            trans.hsize=2;
            trans.haddr=i;
            trans.hwdata=0;
            gen2driv.put(trans);
            trans.display();
          end
      end
           
      end
   //$display("####################################");
    endtask:run  
endclass
