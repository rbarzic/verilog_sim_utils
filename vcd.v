`ifndef VCD_EXTRA_MODULE
`define VCD_EXTRA_MODULE
`endif

`ifndef TB_NAME
`define TB_NAME tb
`endif

`ifndef TB_VCD_NAME
`define TB_VCD_NAME "tb.vcd"
`endif

`ifndef TB_LXT2_NAME
`define TB_LXT2_NAME "tb.lxt2"
`endif


   task vcd_dump;
      begin
         if ($test$plusargs("vcd")) begin
            $display("-I- VCD dump is enabled !");
	    $dumpfile(`TB_VCD_NAME);
	    $dumpvars(0, `TB_NAME `VCD_EXTRA_MODULE);
	 end
	 else begin
	   if ($test$plusargs("lxt2")) begin
	      $display("-I- LXT2 dump is enabled !");
	      $dumpfile(`TB_LXT2_NAME);
	      $dumpvars(0, `TB_NAME `VCD_EXTRA_MODULE);
	   end
	 end
      end
   endtask // if
