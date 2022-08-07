//A program block that creates the environment and initiate the stimulus
`include"environment.sv"
program test(dut_if vi1);
  
  //declare environment handle
  environment env;
  int test_type = 1;    // 1 : random test 2:directed test with burst 1 3:for directed test with burst 0
  int repeat_count = 3;
  initial begin
    //create environment
    // give an argument in the env =new(interface , repeat_count , test_type);   write 1 for random test with single burst  and 2 for direwcted test with incremented bus 
    env=new(vi1,repeat_count,test_type);
    //initiate the stimulus by calling run of env
    env.run();	
  end

endprogram
