`ifndef VERILATOR 
task apb_read;
   input [9:0]  addr;
   output [31:0] data;
   begin
      
      #APB_TASKS_START_DELAY;
      $display("-I- APB Read : 0x%03x",addr);

      apb_dut_paddr = addr;
      apb_dut_pwrite = 1'b0;
      apb_dut_psel   = 1'b1;
      apb_dut_penable   = 1'b0;
      @(posedge clk_apb);
      apb_dut_penable   = 1'b1;
      #1;
      wait(dut_apb_pready == 1'b1);

      @(posedge clk_apb)
        data = dut_apb_prdata;
      $display("-I-     Data : 0x%08x",data);
      #APB_TASKS_END_DELAY;
      apb_dut_paddr = 32'bx;
      apb_dut_psel   = 1'b0;
      apb_dut_penable= 1'b0;
   end
endtask // apb_read


task apb_write;
   input [9:0]  addr;
   input [31:0]  data;
   begin
      #APB_TASKS_START_DELAY;
      $display("-I- APB Write : 0x%03x",addr);
      apb_dut_paddr = addr;
      apb_dut_pwrite = 1'b1;
      apb_dut_psel   = 1'b1;
      apb_dut_penable   = 1'b0;
      apb_dut_pwdata = data;

      @(posedge clk_apb);
      apb_dut_penable   = 1'b1;
      #1;
      wait(dut_apb_pready == 1'b1);

      @(posedge clk_apb);
      $display("-I-     Data : 0x%08x",data);
      #APB_TASKS_END_DELAY;
      apb_dut_paddr = 32'bx;
      apb_dut_psel   = 1'b0;
      apb_dut_penable= 1'b0;

   end
endtask //


task apb_reset;
   begin

      apb_dut_paddr = 10'b0;
      apb_dut_pwrite = 1'b1;
      apb_dut_psel   = 1'b1;
      apb_dut_penable   = 1'b0;
      apb_dut_pwdata = 32'b0;
      apb_dut_pstrb = 4'b0;

   end

endtask // apb_reset


event evt_call_begin;
event evt_call_end;
task wait_reset_released;
   begin
      -> evt_call_begin;      
    @(posedge rst_apb_n === 1'b1 );
      -> evt_call_end;
   end

endtask // apb_reset

task wait_posedge_clk_apb;
   input delay;
   integer delay;   
   begin
      @(posedge clk_apb === 1'b1);
      #delay;      
   end
endtask
   

`endif //  `ifndef VERILATOR

