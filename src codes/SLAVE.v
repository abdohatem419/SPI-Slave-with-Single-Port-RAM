//===========================================================
// Project:     SPI Slave with Single Port RAM
// File:        slave.v
// Author:      Abdelrahman Hatem Nasr
// Date:        2024-08-05
// Description: Implementation of an SPI slave module for
//              serial communication. The module handles 
//              data reception and transmission with an SPI 
//              master, including state management and data 
//              handling logic.
//===========================================================

module SLAVE (MOSI, MISO, SS_n, clk, rst_n, rx_data, rx_valid, tx_data, tx_valid);

//===========================================================
// Parameter Declarations
//===========================================================

parameter IDLE      = 0;
parameter CHK_CMD   = 1;
parameter WRITE     = 2;
parameter READ_ADD  = 3;
parameter READ_DATA = 4;

//===========================================================
// Port Declarations
//===========================================================

input MOSI, SS_n, clk, rst_n, tx_valid;
input [7:0] tx_data;
output reg rx_valid, MISO;
output reg [9:0] rx_data; 

//===========================================================
// Internal Signal Declarations
// counter : Counter for bit shifts and data handling
// allow_memorize : Flag to determine if data should be memorized
// ns, cs : Next state and current state for state machine
//===========================================================

reg [3:0] counter;
reg allow_memorize;
(*fsm_encoding="gray"*)
reg [2:0] ns, cs;

//===========================================================
// State Memory
//===========================================================

always @(posedge clk) begin
    if (~rst_n) begin
        cs <= IDLE;
    end else begin
        cs <= ns;
    end
end

//===========================================================
// Next State Logic
//===========================================================

always @(*) begin
    case(cs)
    IDLE: begin
        if (SS_n) begin
            ns = IDLE;
        end else begin
            ns = CHK_CMD;
        end
    end
    CHK_CMD: begin
        if (SS_n) begin
            ns = IDLE;
        end else if (MOSI == 0) begin
            ns = WRITE;
        end else if (MOSI == 1 && allow_memorize == 0) begin
            ns = READ_ADD;
        end else if (MOSI == 1 && allow_memorize == 1) begin
            ns = READ_DATA;
        end
    end
    WRITE: begin
        if (SS_n) begin
            ns = IDLE;
        end else begin
            ns = WRITE;
        end
    end
    READ_ADD: begin
        if (SS_n) begin
            ns = IDLE;
        end else begin
            ns = READ_ADD;
        end
    end
    READ_DATA: begin
        if (SS_n) begin
            ns = IDLE;
        end else begin
            ns = READ_DATA;
        end
    end
    default : ns = IDLE;
    endcase
end

//===========================================================
// Output Logic
//===========================================================

always @(posedge clk) begin
    if (~rst_n) begin
        counter <= 0;
        rx_valid <= 0;
        rx_data <= 0;
        MISO <= 0;
        allow_memorize <= 0;
    end else begin
        case (cs)
            IDLE: begin
                rx_valid <= 0;
                MISO <= 0;
                counter <= 0;
            end
            WRITE: begin
                if (counter < 10) begin
                    rx_data <= {rx_data[8:0], MOSI};
                    rx_valid<=0;
                    counter <= counter + 1;
                end
                if (counter == 10) begin
                    rx_valid <= 1;
                end
            end
            READ_ADD: begin
                if (counter < 10) begin
                    rx_data <= {rx_data[8:0], MOSI};
                    rx_valid<=0;
                    counter <= counter + 1;
                end
                if (counter == 10) begin
                    rx_valid <= 1;
                    allow_memorize <= 1;
                end
            end
            READ_DATA: begin
                if (~tx_valid) begin
                    if (counter < 10) begin
                        rx_data <= {rx_data[8:0], MOSI};
                        rx_valid<=0;
                        counter <= counter + 1;
                    end
                    if (counter == 10) begin
                        rx_valid <= 1;
                        allow_memorize <= 0;
                    end
                end
                if (tx_valid) begin
                    if(counter >= 3)begin
                        MISO <= tx_data[counter - 3];
                        counter <= counter - 1;
                    end
                end
            end
        endcase
    end
end

endmodule
