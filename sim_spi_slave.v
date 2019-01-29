module sim_spi_slave (/*AUTOARG*/
   // Outputs
   data_cpol_0_cpha_0, data_cpol_1_cpha_0, data_cpol_0_cpha_1,
   data_cpol_1_cpha_1,
   // Inputs
   sck, miso, mosi, csn
   );

`include "tb_defines.v"
   
   input sck;
   output miso;
   input mosi;
   input csn;

   output  [31:0] data_cpol_0_cpha_0;
   output  [31:0] data_cpol_1_cpha_0;
   output  [31:0] data_cpol_0_cpha_1;
   output  [31:0] data_cpol_1_cpha_1;
   
   integer   bits_cpol_0_cpha_0;
   integer   i_00;

   integer   bits_cpol_1_cpha_0;
   integer   i_10;
   
   integer   bits_cpol_0_cpha_1;
   integer   i_01;
   
   integer   bits_cpol_1_cpha_1;
   integer   i_11;

   reg [31:0] data_cpol_0_cpha_0;
   reg [31:0] data_cpol_1_cpha_0;
   reg [31:0] data_cpol_0_cpha_1;
   reg [31:0] data_cpol_1_cpha_1;

   reg [31:0] rx_data_cpol_0_cpha_0;
   reg [31:0] rx_data_cpol_1_cpha_0;
   reg [31:0] rx_data_cpol_0_cpha_1;
   reg [31:0] rx_data_cpol_1_cpha_1;

   reg 	      miso_0_0;
   reg 	      miso_1_0;
   reg 	      miso_0_1;
   reg 	      miso_1_1;
   
   event      evt_dbt_mosi00_0;

   wire 	      miso;

   wire 	      miso_0_0_sel = (`TB.c2v_value[27] === 32'h0);
   wire 	      miso_1_0_sel = (`TB.c2v_value[27] === 32'h1);
   wire 	      miso_0_1_sel = (`TB.c2v_value[27] === 32'h2);
   wire 	      miso_1_1_sel = (`TB.c2v_value[27] === 32'h3);
   
   assign miso = ( {32{miso_0_0_sel}} & miso_0_0) | ( {32{miso_1_0_sel}} & miso_1_0) | ( {32{miso_0_1_sel}} & miso_0_1) | ( {32{miso_1_1_sel}} & miso_1_1);
   
   
   
   // CPOL=0, CPHA=0
   initial begin
      bits_cpol_0_cpha_0 = 8;      
      #10;      
      forever begin
	 @(negedge csn);
	 data_cpol_0_cpha_0 = 32'd0;
	 rx_data_cpol_0_cpha_0 = `TB.c2v_value[28];
	 miso_0_0 = rx_data_cpol_0_cpha_0[bits_cpol_0_cpha_0-1];	 
	 for(i_00 = 0; i_00<bits_cpol_0_cpha_0; i_00 = i_00 +1) begin
	    @(posedge sck);
	    data_cpol_0_cpha_0 = {data_cpol_0_cpha_0[30:0],mosi};
	    @(negedge sck);
	    if(i_00 != (bits_cpol_0_cpha_0-1)) begin
	       -> evt_dbt_mosi00_0;	       
	       miso_0_0 = rx_data_cpol_0_cpha_0[bits_cpol_0_cpha_0 - 2 -i_00];
	       $display("-D- %d",bits_cpol_0_cpha_0 - 2 -i_00);	       
	    end
	 end
	 @(posedge csn);
	 
	 $display("-I- Data received (CPOL=0, CPHA=0) : 0x%08x",data_cpol_0_cpha_0);
	 `TB.v2c_value[28] = data_cpol_0_cpha_0;
      end
   end

   // CPOL=1, CPHA=0
   initial begin
      bits_cpol_1_cpha_0 = 8;      
      #10;      
      forever begin
	 @(negedge csn);
	 data_cpol_1_cpha_0 = 32'd0;
	 rx_data_cpol_1_cpha_0 = `TB.c2v_value[29];
	 for(i_10 = 0; i_10<bits_cpol_1_cpha_0; i_10 = i_10 +1) begin
	    @(negedge sck);
	    data_cpol_1_cpha_0 = {data_cpol_1_cpha_0[30:0],mosi};	    
	    
	 end
	 @(posedge csn);
	 $display("-I- Data received (CPOL=1, CPHA=0) : 0x%08x",data_cpol_1_cpha_0);
	 `TB.v2c_value[29] = data_cpol_1_cpha_0;
      end
   end // initial begin



   // CPOL=0, CPHA=1
   initial begin
      bits_cpol_0_cpha_1 = 8;      
      #10;      
      forever begin
	 @(negedge csn);
	 data_cpol_0_cpha_1 = 32'd0;
	 rx_data_cpol_0_cpha_1 = `TB.c2v_value[30];
	 for(i_01 = 0; i_01<bits_cpol_0_cpha_1; i_01 = i_01 +1) begin
	    @(negedge sck);
	    data_cpol_0_cpha_1 = {data_cpol_0_cpha_1[30:0],mosi};	    
	    
	 end
	 @(posedge csn);
	 $display("-I- Data received (CPOL=0, CPHA=1) : 0x%08x",data_cpol_0_cpha_1);
	 `TB.v2c_value[30] = data_cpol_0_cpha_1;
	 
      end
   end // initial begin


   // CPOL=1, CPHA=1
   initial begin
      bits_cpol_1_cpha_1 = 8;      
      #10;      
      forever begin
	 @(negedge csn);
	 data_cpol_1_cpha_1 = 32'd0;
	 rx_data_cpol_1_cpha_1 = `TB.c2v_value[31];
	 for(i_11 = 0; i_11<bits_cpol_1_cpha_1; i_11 = i_11 +1) begin
	    @(posedge sck);
	    data_cpol_1_cpha_1 = {data_cpol_1_cpha_1[30:0],mosi};	    
	    
	 end
	 @(posedge csn);
	 $display("-I- Data received (CPOL=1, CPHA=1) : 0x%08x",data_cpol_1_cpha_1);
	 `TB.v2c_value[31] = data_cpol_1_cpha_1;
      end
   end


   

   
endmodule // sim_spi_slave
/*
 Local Variables:
 verilog-library-directories:(
 "."
 )
 End:
 */
