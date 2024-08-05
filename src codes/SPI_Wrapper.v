//===========================================================
// Project:     SPI Slave with Single Port RAM
// File:        spi_wrapper.v
// Author:      Abdelrahman Hatem Nasr
// Date:        2024-08-05
// Description: Wrapper module for interfacing with SPI. 
//              It instantiates the RAM and SPI Slave modules 
//              to handle data transfer and memory operations.
//===========================================================

module SPI_Wrapper(MOSI, MISO, SS_n, rst_n, clk);

//===========================================================
// Port Declarations
//===========================================================

input MOSI, SS_n, clk, rst_n;  // SPI input signals and reset
output MISO;                   // SPI output signal

//===========================================================
// Internal Signal Declarations
//===========================================================

wire [9:0] rx_data;  // Data received from SPI slave
wire rx_valid;       // Valid signal for received data
wire tx_valid;       // Valid signal for transmitted data
wire [7:0] tx_data;  // Data to be transmitted via SPI

//===========================================================
// Module Instantiations
//===========================================================

RAM #(.MEM_DEPTH(256), .ADDR_SIZE(8)) m1 (
    .din(rx_data),        // Data input to RAM
    .clk(clk),            // Clock signal
    .rx_valid(rx_valid),  // Valid signal for received data
    .rst_n(rst_n),        // Reset signal
    .dout(tx_data),       // Data output from RAM
    .tx_valid(tx_valid)   // Valid signal for transmitted data
);

SLAVE s1 (
    .MOSI(MOSI),         // SPI Master Out Slave In
    .MISO(MISO),         // SPI Master In Slave Out
    .SS_n(SS_n),         // SPI Slave Select
    .clk(clk),           // Clock signal
    .rst_n(rst_n),       // Reset signal
    .rx_data(rx_data),   // Data received from SPI master
    .rx_valid(rx_valid), // Valid signal for received data
    .tx_data(tx_data),   // Data to be transmitted to SPI master
    .tx_valid(tx_valid)  // Valid signal for transmitted data
);

endmodule
