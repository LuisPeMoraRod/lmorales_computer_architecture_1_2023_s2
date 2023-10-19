module D_FF_tb();
    logic q, d, we, rst, clk;

    D_FF dut(q, d, we, rst, clk);

    always #10 clk = ~clk;

    initial begin
        clk <= 1;
        d <= 1;
        we <= 1;

        rst <= 1;
        #5;
        rst <= 0;

        #20; 
        $display("d=%b\tq=%b", d, q);

        d <= 0;
        #20;
        $display("d=%b\tq=%b", d, q);

        we <= 0;
        #20;
        d <=1;
        #20;
        $display("d=%b\tq=%b", d, q);

        #40;
        $finish;    
    end
endmodule
