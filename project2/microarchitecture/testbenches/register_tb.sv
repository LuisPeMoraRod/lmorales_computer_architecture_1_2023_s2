module register_tb();
    logic [31:0] reg_in;
    logic [31:0] reg_out;
    logic rst, clk, write_en;

    register dut(
        .RegOut(reg_out),
        .RegIn(reg_in),
        .WriteEn(write_en),
        .reset(rst),
        .clk(clk)
    );

    always #10 clk = ~clk;

    initial begin
        clk <= 1;
        reg_in <= 32'hff;
        write_en <= 1;

        rst <= 1;
        #5;
        rst <= 0;
        #20;
        reg_in <= 32'hfc;
        write_en <= 0; 
        $display("reg_in=%h\treg_out=%h", reg_in, reg_out);
        #20;
        write_en <= 1;
        #40;
        $finish;    
    end

endmodule
