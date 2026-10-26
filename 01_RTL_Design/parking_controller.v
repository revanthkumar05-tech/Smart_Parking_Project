`timescale 1ns/1ps

module parking_controller #(
    parameter integer CAPACITY = 100
)(
    input  wire clk,
    input  wire reset,
    input  wire entry_event,
    input  wire exit_event,

    output reg [((CAPACITY < 1) ? 1 : $clog2(CAPACITY + 1))-1:0]
        occupied_count,

    output wire parking_full,
    output wire space_available,
    output reg invalid_event
);

    // Combinational parking status outputs
    assign parking_full = (occupied_count == CAPACITY);
    assign space_available = (occupied_count < CAPACITY);

    // Occupancy counter and invalid-event register
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            occupied_count <= 0;
            invalid_event  <= 1'b0;
        end
        else begin
            // Clear invalid-event flag by default
            invalid_event <= 1'b0;

            // Reject simultaneous entry and exit
            if (entry_event && exit_event) begin
                invalid_event <= 1'b1;
            end

            // Vehicle entry
            else if (entry_event) begin
                if (occupied_count < CAPACITY)
                    occupied_count <= occupied_count + 1'b1;
                else
                    invalid_event <= 1'b1;
            end

            // Vehicle exit
            else if (exit_event) begin
                if (occupied_count > 0)
                    occupied_count <= occupied_count - 1'b1;
                else
                    invalid_event <= 1'b1;
            end
        end
    end

endmodule
