`timescale 1 ps / 100 fs

module reverb_operations_tb #(parameter N=24) ();

    logic [N-1:0] BussA;        // Input A (24-bit)
    logic [N-1:0] BussB;        // Input B (24-bit)

    logic [N-1:0] add, sub, slt, xori, sll, srl, mult;
	logic C_add, C_sub, C_mult, Z_add, Z_sub, Z_mult, V_add, V_sub, V_mult, N_add, N_sub, N_mult, gt_sub;
	logic [4:0] shamt;
	assign shamt = BussB[8:4];

	//add
	adder #(N) adder(.A(BussA), .B(BussB), .Cin(0), .R(add), .C(C_add), .Neg(N_add), .V(V_add), .Z(Z_add));
	
	//sub
	adder #(N) subtractor(.A(BussA), .B(BussB), .Cin(1), .R(sub), .C(C_sub), .Neg(N_sub), .V(V_sub), .Z(Z_sub));
	assign gt_sub = ~N_sub & ~V_sub & ~Z_sub;

	//xori
	assign xori = BussA ^ BussB;
	
	//set less than
	assign slt = (BussA < BussB) ? 24'b1 : 24'b0;
	
	//shift left logical
	assign sll = BussA << shamt;

	//shift right logical 
	assign srl = BussA >> shamt;

	//multiplication
	multiplicator #(N) multi(BussA, BussB, mult, Z_mult, C_mult, V_mult, N_mult);

    initial begin

        $display("\nTesting ALU:\n");

        $display("\nTesting Adder...\n");


        $display("\n1.a. (0.25) + (0.375) = 0.625");
        BussA <= 24'b0000000001000000; // 0.25
		BussB <= 24'b0000000001100000; // 0.375
        #10;
        $display("A = %b\tB = %b\tOutput = (%b) %b.%b", BussA, BussB, add[23:16], add[15:8], add[7:0],
        "\ncarry=%b\tzero=%b\toverflow=%b\tnegative=%b", C_add, Z_add, V_add, N_add);

        $display("\n1.b. (0.9375) + (0.375) = 1.3125");
        BussA <= 24'b0000000011110000; // 0.9375
		BussB <= 24'b0000000001100000; // 0.375
        #10;
        $display("A = %b\tB = %b\tOutput = (%b) %b.%b", BussA, BussB, add[23:16], add[15:8], add[7:0],
        "\ncarry=%b\tzero=%b\toverflow=%b\tnegative=%b", C_add, Z_add, V_add, N_add);

        $display("\n1.c. (2.4071) + (3.7654) = 6.1725");
        BussA <= 24'b0000001001101000; // 2.4071
		BussB <= 24'b0000001111000011; // 3.7654
        #10;
        $display("A = %b\tB = %b\tOutput = (%b) %b.%b", BussA, BussB, add[23:16], add[15:8], add[7:0],
        "\ncarry=%b\tzero=%b\toverflow=%b\tnegative=%b", C_add, Z_add, V_add, N_add);


        $display("\n2.a. (0.9375) + (-0.375) = 0.5625");
		BussA <= 24'b0000000011110000; //  0.9375
		BussB <= 24'b1111111110100000; // -0.375
        #10;
        $display("A = %b\tB = %b\tOutput = (%b) %b.%b", BussA, BussB, add[23:16], add[15:8], add[7:0],
        "\ncarry=%b\tzero=%b\toverflow=%b\tnegative=%b", C_add, Z_add, V_add, N_add);

        $display("\n2.b. (0.375) + (-1.6563) = -1.2813");
        BussA <= 24'b0000000001100000; //  0.375
		BussB <= 24'b1111111001011000; // -1.6563
        #10;
        $display("A = %b\tB = %b\tOutput = (%b) %b.%b", BussA, BussB, add[23:16], add[15:8], add[7:0],
        "\ncarry=%b\tzero=%b\toverflow=%b\tnegative=%b", C_add, Z_add, V_add, N_add);


        $display("\n3.a. (-3.7654) + (0.25) = -3.5154");
		BussA <= 24'b1111110000111101; // -3.7654
		BussB <= 24'b0000000001000000; //  0.25
        #10;
        $display("A = %b\tB = %b\tOutput = (%b) %b.%b", BussA, BussB, add[23:16], add[15:8], add[7:0],
        "\ncarry=%b\tzero=%b\toverflow=%b\tnegative=%b", C_add, Z_add, V_add, N_add);

        $display("\n3.b. (-1.6563) + (2.4071) = 0.7508");
		BussA <= 24'b1111111001011000; // -1.6563
		BussB <= 24'b0000001001101000; //  2.4071
        #10;
        $display("A = %b\tB = %b\tOutput = (%b) %b.%b", BussA, BussB, add[23:16], add[15:8], add[7:0],
        "\ncarry=%b\tzero=%b\toverflow=%b\tnegative=%b", C_add, Z_add, V_add, N_add);

        $display("\n4.a. (-0.25) + (-0.375) = -0.625");
		BussA <= 24'b1111111111000000; // -0.25
		BussB <= 24'b1111111110100000; // -0.375
        #10;
        $display("A = %b\tB = %b\tOutput = (%b) %b.%b", BussA, BussB, add[23:16], add[15:8], add[7:0],
        "\ncarry=%b\tzero=%b\toverflow=%b\tnegative=%b", C_add, Z_add, V_add, N_add);

        $display("\n4.b. (-3.7654) + (-2.4071) = -6.1725");
		BussA <= 24'b1111110000111101; // -3.7654
		BussB <= 24'b1111110110011000; // -2.4071
        #10;
        $display("A = %b\tB = %b\tOutput = (%b) %b.%b", BussA, BussB, add[23:16], add[15:8], add[7:0],
        "\ncarry=%b\tzero=%b\toverflow=%b\tnegative=%b", C_add, Z_add, V_add, N_add);


        $display("\n\nTesting Substractor...\n");


        $display("\n5.a. (1) - (0.25) = 0.75");
		BussA <= 24'b0000000100000000; //  1
		BussB <= 24'b0000000001000000; //  0.25
        #10;
        $display("A = %b\tB = %b\tOutput = (%b) %b.%b", BussA, BussB, sub[23:16], sub[15:8], sub[7:0],
        "\ncarry=%b\tzero=%b\toverflow=%b\tnegative=%b", C_sub, Z_sub, V_sub, N_sub);

        $display("\n5.b. (0.9375) - (0.375) = 0.5625");
		BussA <= 24'b0000000011110000; // 0.9375
		BussB <= 24'b0000000001100000; // 0.375
        #10;
        $display("A = %b\tB = %b\tOutput = (%b) %b.%b", BussA, BussB, sub[23:16], sub[15:8], sub[7:0],
        "\ncarry=%b\tzero=%b\toverflow=%b\tnegative=%b", C_sub, Z_sub, V_sub, N_sub);

        $display("\n5.c. (2.4071) - (1.6563) = 0.7508");
		BussA <= 24'b0000001001101000; // 2.4071
		BussB <= 24'b0000000110101000; // 1.6563
        #10;
        $display("A = %b\tB = %b\tOutput = (%b) %b.%b", BussA, BussB, sub[23:16], sub[15:8], sub[7:0],
        "\ncarry=%b\tzero=%b\toverflow=%b\tnegative=%b", C_sub, Z_sub, V_sub, N_sub);


        $display("\n6.a. (0.25) - (-0.375) = 0.625");
		BussA <= 24'b0000000001000000; //  0.25
		BussB <= 24'b1111111110100000; // -0.375
        #10;
        $display("A = %b\tB = %b\tOutput = (%b) %b.%b", BussA, BussB, sub[23:16], sub[15:8], sub[7:0],
        "\ncarry=%b\tzero=%b\toverflow=%b\tnegative=%b", C_sub, Z_sub, V_sub, N_sub);

        $display("\n6.b. (2.4071) - (-3.7654) = 6.1725");
		BussA <= 24'b0000001001101000; // 2.4071
		BussB <= 24'b1111110000111101; // -3.7654
        #10;
        $display("A = %b\tB = %b\tOutput = (%b) %b.%b", BussA, BussB, sub[23:16], sub[15:8], sub[7:0],
        "\ncarry=%b\tzero=%b\toverflow=%b\tnegative=%b", C_sub, Z_sub, V_sub, N_sub);


        $display("\n7.a. (-0.25) - (-0.375) = -0.625");
		BussA <= 24'b1111111111000000; // -0.25
		BussB <= 24'b0000000001100000; // 0.375
        #10;
        $display("A = %b\tB = %b\tOutput = (%b) %b.%b", BussA, BussB, sub[23:16], sub[15:8], sub[7:0],
        "\ncarry=%b\tzero=%b\toverflow=%b\tnegative=%b", C_sub, Z_sub, V_sub, N_sub);

        $display("\n7.b. (-3.7654) - (2.4071) = -6.1725");
		BussA <= 24'b1111110000111101; // -3.7654
		BussB <= 24'b0000001001101000; // 2.4071
        #10;
        $display("A = %b\tB = %b\tOutput = (%b) %b.%b", BussA, BussB, sub[23:16], sub[15:8], sub[7:0],
        "\ncarry=%b\tzero=%b\toverflow=%b\tnegative=%b", C_sub, Z_sub, V_sub, N_sub);


        $display("\n8.a. (-3.7654) - (-0.25) = -3.5154");
		BussA <= 24'b1111110000111101; // -3.7654
		BussB <= 24'b1111111111000000; // -0.25
        #10;
        $display("A = %b\tB = %b\tOutput = (%b) %b.%b", BussA, BussB, sub[23:16], sub[15:8], sub[7:0],
        "\ncarry=%b\tzero=%b\toverflow=%b\tnegative=%b", C_sub, Z_sub, V_sub, N_sub);

        $display("\n8.b. (-1.6563) - (-2.4071) = 0.7508");
		BussA <= 24'b1111111001011000; // -1.6563
		BussB <= 24'b1111110110011000; // -2.4071
        #10;
        $display("A = %b\tB = %b\tOutput = (%b) %b.%b", BussA, BussB, sub[23:16], sub[15:8], sub[7:0],
        "\ncarry=%b\tzero=%b\toverflow=%b\tnegative=%b", C_sub, Z_sub, V_sub, N_sub);


        $display("\n\nTesting Multiplicator...\n");


        $display("\n9.a. (1.6563) x (3.7654) = 6.236632");
		BussA <= 24'b0000000110101000; // 1.6563
		BussB <= 24'b0000001111000011; // 3.7654
        #10;
        $display("A = %b\tB = %b\tOutput = (%b) %b.%b", BussA, BussB, mult[23:16], mult[15:8], mult[7:0],
        "\ncarry=%b\tzero=%b\toverflow=%b\tnegative=%b", C_mult, Z_mult, V_mult, N_mult);

        $display("\n9.b. (2.4071) x (0.9375) = 2.256656");
		BussA <= 24'b0000001001101000; // 2.4071
		BussB <= 24'b0000000011110000; // 0.9375
        #10;
        $display("A = %b\tB = %b\tOutput = (%b) %b.%b", BussA, BussB, mult[23:16], mult[15:8], mult[7:0],
        "\ncarry=%b\tzero=%b\toverflow=%b\tnegative=%b", C_mult, Z_mult, V_mult, N_mult);


        $display("\n10.a. (3.7654) x (-2.4071) = -9.063694");
		BussA <= 24'b0000001111000011; // 3.7654
		BussB <= 24'b1111110110011000; // -2.4071
        #10;
        $display("A = %b\tB = %b\tOutput = (%b) %b.%b", BussA, BussB, mult[23:16], mult[15:8], mult[7:0],
        "\ncarry=%b\tzero=%b\toverflow=%b\tnegative=%b", C_mult, Z_mult, V_mult, N_mult);

        $display("\n10.b. (1.6563) x (-0.375) = -0.6211125");
		BussA <= 24'b0000000110101000; // 1.6563
		BussB <= 24'b1111111110100000; // -0.375
        #10;
        $display("A = %b\tB = %b\tOutput = (%b) %b.%b", BussA, BussB, mult[23:16], mult[15:8], mult[7:0],
        "\ncarry=%b\tzero=%b\toverflow=%b\tnegative=%b", C_mult, Z_mult, V_mult, N_mult);


        $display("\n11.a. (-3.7654) x (1.6563) = -6.236632");
		BussA <= 24'b1111110000111101; // -3.7654
		BussB <= 24'b0000000110101000; // 1.6563
        #10;
        $display("A = %b\tB = %b\tOutput = (%b) %b.%b", BussA, BussB, mult[23:16], mult[15:8], mult[7:0],
        "\ncarry=%b\tzero=%b\toverflow=%b\tnegative=%b", C_mult, Z_mult, V_mult, N_mult);

        $display("\n11.b. (-0.9375) x (0.25) = -0.234375");
		BussA <= 24'b1111111100010000; // -0.9375
		BussB <= 24'b0000000001000000; //  0.25
        #10;
        $display("A = %b\tB = %b\tOutput = (%b) %b.%b", BussA, BussB, mult[23:16], mult[15:8], mult[7:0],
        "\ncarry=%b\tzero=%b\toverflow=%b\tnegative=%b", C_mult, Z_mult, V_mult, N_mult);


        $display("\n12.a. (-3.7654) x (-1.6563) = 6.236632");
		BussA <= 24'b1111110000111101; // -3.7654
		BussB <= 24'b1111111001011000; // -1.6563
        #10;
        $display("A = %b\tB = %b\tOutput = (%b) %b.%b", BussA, BussB, mult[23:16], mult[15:8], mult[7:0],
        "\ncarry=%b\tzero=%b\toverflow=%b\tnegative=%b", C_mult, Z_mult, V_mult, N_mult);

        $display("\n12.b. (-0.375) x (-0.25) = 0.09375");
		BussA <= 24'b1111111110100000; // -0.375
		BussB <= 24'b1111111111000000; // -0.25
        #10;
        $display("A = %b\tB = %b\tOutput = (%b) %b.%b", BussA, BussB, mult[23:16], mult[15:8], mult[7:0],
        "\ncarry=%b\tzero=%b\toverflow=%b\tnegative=%b", C_mult, Z_mult, V_mult, N_mult);


		#10;
		//assert((f_sum4 === 4'b0001) & (sum4 === 4'b1000)) else $error("failed %b + %b = 0000 0000 . 1001 0000", BussA, BussB);

    end
endmodule
