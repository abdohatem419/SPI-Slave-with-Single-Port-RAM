//===========================================================
// Project:     SPI Slave with Single Port RAM
// File:        spi_master_tb.v
// Author:      Abdelrahman Hatem Nasr
// Date:        2024-08-05
// Description: Testbench for the SPI_Wrapper module. 
//              Tests various RAM read and write operations 
//              by sending commands via SPI and verifying 
//              the memory contents.
//===========================================================

module SPI_Master_tb();

//===========================================================
// Testbench Signal Declarations
//===========================================================

reg MOSI, SS_n, clk, rst_n;       // SPI interface signals and reset
wire MISO;                        // SPI MISO line

reg [7:0] expected_written_data_1; // Expected data for address 2
reg [7:0] expected_written_data_2; // Expected data for address 100

// Instantiate the SPI_Wrapper module
SPI_Wrapper SPI1 (
    .MOSI(MOSI),
    .MISO(MISO),
    .SS_n(SS_n),
    .rst_n(rst_n),
    .clk(clk)
);

//===========================================================
// Clock Generation
//===========================================================

initial begin
    clk = 0;
    forever #5 clk = ~clk; // Clock period of 10 units
end

//===========================================================
// Test Sequence
//===========================================================

initial begin
    $readmemh("mem.dat", SPI1.m1.mem); // Initialize RAM memory from file
    rst_n = 0;
    SS_n = 1;
    MOSI = 0;
    @(negedge clk);
    rst_n = 1; // Release reset

    expected_written_data_1 = 8;
    expected_written_data_2 = 14;

    // Test RAM write command: Write address 2
    SS_n = 0;
    @(negedge clk);
    MOSI = 0;
    @(negedge clk);
    repeat (8) begin
        MOSI = 0;
        @(negedge clk);
    end
    MOSI = 1;
    @(negedge clk);
    MOSI = 0;
    @(negedge clk);
    SS_n = 1;
    @(negedge clk);

    // Test RAM write command: Write data 8 to address 2
    SS_n = 0;
    @(negedge clk);
    MOSI = 0;
    @(negedge clk);
    MOSI = 0;
    @(negedge clk);
    MOSI = 1;
    @(negedge clk);
    repeat (4) begin
        MOSI = 0;
        @(negedge clk);
    end
    MOSI = 1;
    @(negedge clk);
    MOSI = 0;
    @(negedge clk);
    MOSI = 0;
    @(negedge clk);
    MOSI = 0;
    @(negedge clk);
    SS_n = 1;
    repeat(5)@(negedge clk);
    if (SPI1.m1.mem[2] != expected_written_data_1) begin
        $display("Error in write data at address 2 in RAM!");
    end

    // Test RAM write command: Write address 100
    SS_n = 0;
    @(negedge clk);
    MOSI = 0;
    @(negedge clk);
    repeat (3) begin
        MOSI = 0;
        @(negedge clk);
    end
    MOSI = 1;
    @(negedge clk);
    MOSI = 1;
    @(negedge clk);
    MOSI = 0;
    @(negedge clk);
    MOSI = 0;
    @(negedge clk);
    MOSI = 1;
    @(negedge clk);
    MOSI = 0;
    @(negedge clk);
    MOSI = 0;
    @(negedge clk);
    SS_n = 1;
    @(negedge clk);

    // Test RAM write command: Write data 14 to address 100
    SS_n = 0;
    @(negedge clk);
    MOSI = 0;
    @(negedge clk);
    MOSI = 0;
    @(negedge clk);
    MOSI = 1;
    @(negedge clk);
    repeat (4) begin
        MOSI = 0;
        @(negedge clk);
    end
    MOSI = 1;
    @(negedge clk);
    MOSI = 1;
    @(negedge clk);
    MOSI = 1;
    @(negedge clk);
    MOSI = 0;
    @(negedge clk);
    SS_n = 1;
    repeat(5)@(negedge clk);
    if (SPI1.m1.mem[100] != expected_written_data_2) begin
        $display("Error in write data at address 100 in RAM!");
    end

    // Test RAM read command: Read address 2
    SS_n = 0;
    @(negedge clk);
    MOSI = 1;
    @(negedge clk);
    MOSI = 1;
    @(negedge clk);
    MOSI = 0;
    @(negedge clk);
    repeat (6) begin
        MOSI = 0;
        @(negedge clk);
    end
    MOSI = 1;
    @(negedge clk);
    MOSI = 0;
    @(negedge clk);
    SS_n = 1;
    @(negedge clk);

    // Test RAM read command: Read data from address 2
    SS_n = 0;
    @(negedge clk);
    MOSI = 1;
    @(negedge clk);
    MOSI = 1;
    @(negedge clk);
    MOSI = 1;
    @(negedge clk);
    repeat (6) begin
        MOSI = 0;
        @(negedge clk);
    end
    MOSI = 1;
    @(negedge clk);
    MOSI = 0;
    repeat(11)@(negedge clk);
    SS_n = 1;
    @(negedge clk);

    // Test RAM read command: Read address 100
    SS_n = 0;
    @(negedge clk);
    MOSI = 1;
    @(negedge clk);
    MOSI = 1;
    @(negedge clk);
    MOSI = 0;
    @(negedge clk);
    MOSI = 0;
    @(negedge clk);
    MOSI = 1;
    @(negedge clk);
    MOSI = 1;
    @(negedge clk);
    MOSI = 0;
    @(negedge clk);
    MOSI = 0;
    @(negedge clk);
    MOSI = 1;
    @(negedge clk);
    MOSI = 0;
    @(negedge clk);
    MOSI = 0;
    @(negedge clk);
    SS_n = 1;
    @(negedge clk);

    // Test RAM read command: Read data from address 100
    SS_n = 0;
    @(negedge clk);
    MOSI = 1;
    @(negedge clk);
    MOSI = 1;
    @(negedge clk);
    MOSI = 1;
    @(negedge clk);
    repeat (6) begin
        MOSI = 0;
        @(negedge clk);
    end
    MOSI = 1;
    @(negedge clk);
    MOSI = 0;
    repeat(11)@(negedge clk);
    SS_n = 1;
    @(negedge clk);

    $stop; // Stop simulation
end

//===========================================================
// Signal Monitoring
//===========================================================

initial begin
    $monitor("Time: %0t | MOSI: %b | MISO: %b | SS_n: %b | clk: %b | rst_n: %b",
             $time, MOSI, MISO, SS_n, clk, rst_n);
end

endmodule
