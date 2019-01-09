task timeout_ns;
   input [31:0] default_timeout;   
   integer dummy;
   integer timeout_ns;
   
   begin
      timeout_ns = default_timeout;      
      $timeformat(-9, 2, " ns", 10);
      if ($test$plusargs("simulation_timeout_ns")) begin
	 dummy = $value$plusargs("simulation_timeout_ns=%d", timeout_ns);
      end
      
      #timeout_ns;
      
      $display("-E- Test failed - Timeout !");
      $display("-E- Time is %t",$realtime);
      -> tb.tb_finish_error;      
      // $stop(1);

   end
endtask // timeout_ns
