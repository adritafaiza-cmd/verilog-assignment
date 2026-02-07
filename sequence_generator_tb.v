`timescale 1ns/1ps

module sequence_generator_tb;

    reg clk;
    reg reset_n;
    reg enable;
    wire [3:0] data;

    // Instantiate your 4-bit generator
    sequence_generator uut (
        .clk(clk),
        .reset_n(reset_n),
        .enable(enable),
        .data(data)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Test Sequence
    initial begin
        $dumpfile("sequence_generator.vcd");
        $dumpvars(0, sequence_generator_tb);

        // 1. Initialize
        reset_n = 0;
        enable = 0;
        #20;

        // 2. Release Reset
        reset_n = 1;
        #10;
        
        // 3. Enable Generator
        $display("Starting Sequence Check...");
        enable = 1;

        // Check the sequence over 8 clock cycles
        // Note: The design outputs the current value, then updates index.
        // We wait for negative edges to sample stable data.
        
        @(negedge clk); if (data !== 4'hA) $display("Error: Expected A, got %h", data); else $display("Pass: Got A");
        @(negedge clk); if (data !== 4'hB) $display("Error: Expected B, got %h", data); else $display("Pass: Got B");
        @(negedge clk); if (data !== 4'hE) $display("Error: Expected E, got %h", data); else $display("Pass: Got E");
        @(negedge clk); if (data !== 4'h7) $display("Error: Expected 7, got %h", data); else $display("Pass: Got 7");
        @(negedge clk); if (data !== 4'hF) $display("Error: Expected F, got %h", data); else $display("Pass: Got F");
        @(negedge clk); if (data !== 4'h2) $display("Error: Expected 2, got %h", data); else $display("Pass: Got 2");
        @(negedge clk); if (data !== 4'h0) $display("Error: Expected 0, got %h", data); else $display("Pass: Got 0");
        @(negedge clk); if (data !== 4'hD) $display("Error: Expected D, got %h", data); else $display("Pass: Got D");
        
        // Wrap around check
        @(negedge clk); if (data !== 4'hA) $display("Error: Wrap failed. Expected A, got %h", data); else $display("Pass: Wrap to A successful");

        $finish;
    end

endmodule
'''

with open("sequence_generator/custom_tb.v", "w") as f:
    f.write(custom_tb_code)