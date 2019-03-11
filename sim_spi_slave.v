// A generic SPI slave that support the four possible combinations
// for CPHA & CPOL
// It uses c2v values to get data and configuration from the verification
// program
// `TB.c2v_value[27] : select the CPHA/CPOL configuration
// `TB.c2v_value[28] : data to send back when CPOL=0, CPHA=0
// `TB.c2v_value[29] : data to send back when CPOL=1, CPHA=0
// `TB.c2v_value[30] : data to send back when CPOL=0, CPHA=1
// `TB.c2v_value[31] : data to send back when CPOL=1, CPHA=1



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
   event      evt_dbt_mosi10_0;
   event      evt_dbt_mosi01_0;
   event      evt_dbt_mosi11_0;

   wire 	      miso;

   wire 	      miso_0_0_sel = (`TB.c2v_value[27] === 32'h1);
   wire 	      miso_1_0_sel = (`TB.c2v_value[27] === 32'h2);
   wire 	      miso_0_1_sel = (`TB.c2v_value[27] === 32'h3);
   wire 	      miso_1_1_sel = (`TB.c2v_value[27] === 32'h4);
   
   assign miso = ( {32{miso_0_0_sel}} & miso_0_0) | ( {32{miso_1_0_sel}} & miso_1_0) | ( {32{miso_0_1_sel}} & miso_0_1) | ( {32{miso_1_1_sel}} & miso_1_1);
   
   // We don't try to be clever by implementing a piece of code that support all SPI configurations (CPOL, CPHA)
   // I rather prefer to have dedicated blocks of code for each setting , making easier to check it against
   // expected waveform
   
   // CPOL=0, CPHA=0
   initial begin
      bits_cpol_0_cpha_0 = 8;      
      #10;      
      forever begin
	 @(posedge miso_0_0_sel);
	 
	 @(negedge csn);
	 $display("-V receiving (CPOL=0, CPHA=0)");
	 
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
	       // $display("-D- %d",bits_cpol_0_cpha_0 - 2 -i_00);	       
	    end
	 end
	 @(posedge csn);
	 
	 // $display("-I- Data received (CPOL=0, CPHA=0) : 0x%08x",data_cpol_0_cpha_0);
	 `TB.v2c_value[28] = data_cpol_0_cpha_0;
      end
   end

   // CPOL=1, CPHA=0
   initial begin
      bits_cpol_1_cpha_0 = 8;      
      #10;      
      forever begin
	 @(posedge miso_1_0_sel);
	 @(negedge csn);
	 $display("-V receiving (CPOL=1, CPHA=0)");
	 data_cpol_1_cpha_0 = 32'd0;
	 rx_data_cpol_1_cpha_0 = `TB.c2v_value[29];
	 miso_1_0 = rx_data_cpol_1_cpha_0[bits_cpol_1_cpha_0-1];
	 for(i_10 = 0; i_10<bits_cpol_1_cpha_0; i_10 = i_10 +1) begin
	    @(negedge sck);
	    data_cpol_1_cpha_0 = {data_cpol_1_cpha_0[30:0],mosi};	    
	    
	 
	    @(posedge sck);
	    if(i_10 != (bits_cpol_1_cpha_0-1)) begin
	       -> evt_dbt_mosi10_0;	       
	       miso_1_0 = rx_data_cpol_1_cpha_0[bits_cpol_1_cpha_0 - 2 -i_10];
	       // $display("-D- %d",bits_cpol_1_cpha_0 - 2 -i_10);	       
	    end
	 end
	 // $display("-I- Data received (CPOL=1, CPHA=0) : 0x%08x",data_cpol_1_cpha_0);
	 `TB.v2c_value[29] = data_cpol_1_cpha_0;
      end
   end // initial begin



   // CPOL=0, CPHA=1
   initial begin
      bits_cpol_0_cpha_1 = 8;      
      #10;      
      forever begin
	 @(posedge miso_0_1_sel);
	 @(negedge csn);
	 $display("-V receiving (CPOL=0, CPHA=1)");
	 data_cpol_0_cpha_1 = 32'd0;
	 rx_data_cpol_0_cpha_1 = `TB.c2v_value[30];
	 for(i_01 = 0; i_01<bits_cpol_0_cpha_1; i_01 = i_01 +1) begin
	    ->evt_dbt_mosi01_0;	    
	    @(posedge sck);
	    miso_0_1 = rx_data_cpol_0_cpha_1[bits_cpol_1_cpha_0 - 1 - i_01];
	    @(negedge sck);
	    data_cpol_0_cpha_1 = {data_cpol_0_cpha_1[30:0],mosi};	    
	    
	    
	 end
	 @(posedge csn);
	 // $display("-I- Data received (CPOL=0, CPHA=1) : 0x%08x",data_cpol_0_cpha_1);
	 `TB.v2c_value[30] = data_cpol_0_cpha_1;
	 
      end
   end // initial begin


   // CPOL=1, CPHA=1
   initial begin
      bits_cpol_1_cpha_1 = 8;      
      #10;      
      forever begin
	 @(posedge miso_1_1_sel);
	 @(negedge csn);
	 $display("-V receiving (CPOL=1, CPH=1)");
	 data_cpol_1_cpha_1 = 32'd0;
	 rx_data_cpol_1_cpha_1 = `TB.c2v_value[31];
	 for(i_11 = 0; i_11<bits_cpol_1_cpha_1; i_11 = i_11 +1) begin
	    @(negedge sck);
	    miso_1_1 = rx_data_cpol_1_cpha_1[bits_cpol_1_cpha_1 - 1 - i_11];
	    @(posedge sck);
	    data_cpol_1_cpha_1 = {data_cpol_1_cpha_1[30:0],mosi};	    
	    
	 end
	 @(posedge csn);
	 // $display("-I- Data received (CPOL=1, CPHA=1) : 0x%08x",data_cpol_1_cpha_1);
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
