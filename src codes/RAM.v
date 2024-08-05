//===========================================================
// Project:     SPI Slave with Single Port RAM
// File:        ram.v
// Author:      Abdelrahman Hatem Nasr
// Date:        2024-08-05
// Description: Implementation of a simple RAM module with
//              basic read and write operations. The module
//              stores data in memory and provides output based
//              on command signals.
//===========================================================

module RAM (din,clk, rx_valid, rst_n,dout,tx_valid);

//===========================================================
// Parameter Declarations
//===========================================================

parameter MEM_DEPTH = 256;
parameter ADDR_SIZE = 8;

//===========================================================
// Port Declarations
//===========================================================

input  [9:0] din;
input  clk, rx_valid, rst_n;
output reg [7:0] dout;
output reg tx_valid;

//===========================================================
// Internal Signal Declarations
// mem : Memory array for storage
// stored_command : Command for read or write operations
//===========================================================

reg [ADDR_SIZE-1:0] mem [MEM_DEPTH-1:0];
reg [9:0] stored_command;

//===========================================================
// Main Functionality
//===========================================================

always @(posedge clk) begin
    if (~rst_n) begin
        // Reset logic: clear outputs and stored command
        tx_valid <= 0;
        dout <= 0;
        stored_command<=0;
    end else begin
        if(rx_valid)begin
            // Command decoding based on the higher 2 bits of din
            case(din[9:8])
            2'b00: begin
                 // Store the command in stored_command
                stored_command<=din;
                tx_valid<=0;
            end
            2'b01:begin
                // Write data to memory at the address specified by stored_command
                mem[stored_command[7:0]]<=din[7:0];
                tx_valid<=0;
            end
            2'b10:begin
                 // Update the stored command
                stored_command<=din;
                tx_valid<=0;
            end
            2'b11:begin
                // Read data from memory at the address specified by stored_command
                dout<=mem[stored_command[7:0]];
                tx_valid<=1;
            end
            default:tx_valid<=0;
        endcase
        end
    end
end

endmodule
