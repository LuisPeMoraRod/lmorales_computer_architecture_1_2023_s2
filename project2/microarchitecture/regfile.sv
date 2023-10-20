`timescale 1 ps / 100 fs
module regfile
 (
		output [23:0] reg_read_data_1,
		output [23:0] reg_read_data_2,
		input [23:0] reg_write_data,
		input [3:0] reg_read_addr_1,
		input [3:0] reg_read_addr_2,
		input [3:0] reg_write_dest,
		input reg_write_en,
		input rst,
		input clk
 );
      reg     [23:0]     reg_array [15:0];  
      always @ (posedge clk or posedge rst) begin  
           if(rst) begin  
               reg_array[0] <= 24'h00000;  // $zero
               reg_array[1] <= 24'h00100;  // $a0
               reg_array[2] <= 24'h25F78;  // $a1
               reg_array[3] <= 24'h50000;  // $sp  
               reg_array[4] <= 24'h4BDF0;  // $cbh
               reg_array[5] <= 24'h4FEFF;  // $cbt
               reg_array[6] <= 24'h00000;  // $b0
               reg_array[7] <= 24'h00000;  // $b1
               reg_array[8] <= 24'h00000;  // $b2
               reg_array[9] <= 24'h00000;  // $b3
               reg_array[10] <= 24'h00000;  // $b4
               reg_array[11] <= 24'h00000;  // $b5
               reg_array[12] <= 24'h00000;  // $b6
               reg_array[13] <= 24'h00000;  // $b7
               reg_array[14] <= 24'h00000;  // $b8
               reg_array[15] <= 24'h00000;  // $b9
					 
           end  
           else begin  
                if(reg_write_en) begin  
                     reg_array[reg_write_dest] <= reg_write_data;  
                end  
           end  
      end  
      assign reg_read_data_1 = ( reg_read_addr_1 == 0)? 24'b0 : reg_array[reg_read_addr_1]; // if reg == $zero -> return 0 
      assign reg_read_data_2 = ( reg_read_addr_2 == 0)? 24'b0 : reg_array[reg_read_addr_2]; // if reg == $zero -> return 0 
 endmodule