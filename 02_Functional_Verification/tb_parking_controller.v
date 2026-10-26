`timescale 1ns/1ps

module tb_parking_controller;

    localparam integer CAPACITY = 100;

    reg clk = 0;
    reg reset = 0;
    reg entry_event = 0;
    reg exit_event = 0;

    wire [6:0] occupied_count;
    wire parking_full;
    wire space_available;
    wire invalid_event;

    integer checks = 0;
    integer errors = 0;
    integer i;

    parking_controller #(
        .CAPACITY(CAPACITY)
    ) dut (
        .clk(clk),
        .reset(reset),
        .entry_event(entry_event),
        .exit_event(exit_event),
        .occupied_count(occupied_count),
        .parking_full(parking_full),
        .space_available(space_available),
        .invalid_event(invalid_event)
    );

    always #5 clk = ~clk;

    task check_state;
        input integer expected_count;
        input expected_full;
        input expected_available;
        input expected_invalid;
        begin
            checks = checks + 1;

            if (occupied_count !== expected_count ||
                parking_full !== expected_full ||
                space_available !== expected_available ||
                invalid_event !== expected_invalid) begin

                errors = errors + 1;
                $display(
                    "FAIL at %0t: count=%0d full=%b available=%b invalid=%b",
                    $time, occupied_count, parking_full,
                    space_available, invalid_event
                );
                $display(
                    "Expected: count=%0d full=%b available=%b invalid=%b",
                    expected_count, expected_full,
                    expected_available, expected_invalid
                );
            end
        end
    endtask

    task apply_cycle;
        input entry_value;
        input exit_value;
        input integer expected_count;
        input expected_full;
        input expected_available;
        input expected_invalid;
        begin
            @(negedge clk);
            entry_event = entry_value;
            exit_event = exit_value;

            @(posedge clk);
            #1;
            check_state(
                expected_count,
                expected_full,
                expected_available,
                expected_invalid
            );
        end
    endtask

    initial begin
        $dumpfile("reports/parking_controller.vcd");
        $dumpvars(0, tb_parking_controller);

        $display("-----------------------------------");
        $display("Smart Parking Controller Testbench");
        $display("-----------------------------------");

        // Apply asynchronous reset
        #2 reset = 1;
        #1;
        check_state(0, 0, 1, 0);

        @(negedge clk);
        reset = 0;

        // Fill the parking lot to capacity
        for (i = 1; i <= CAPACITY; i = i + 1)
            apply_cycle(1, 0, i, (i == CAPACITY),
                        (i < CAPACITY), 0);

        // Reject entry when full
        apply_cycle(1, 0, CAPACITY, 1, 0, 1);

        // Accept one vehicle exit
        apply_cycle(0, 1, CAPACITY-1, 0, 1, 0);

        // Empty the parking lot
        for (i = CAPACITY-2; i >= 0; i = i - 1)
            apply_cycle(0, 1, i, 0, 1, 0);

        // Reject exit when empty
        apply_cycle(0, 1, 0, 0, 1, 1);

        // Reject simultaneous entry and exit
        apply_cycle(1, 1, 0, 0, 1, 1);

        // Accept a valid entry
        apply_cycle(1, 0, 1, 0, 1, 0);

        // Test reset while occupied
        @(negedge clk);
        reset = 1;
        #1;
        check_state(0, 0, 1, 0);

        entry_event = 0;
        exit_event = 0;

        @(negedge clk);
        reset = 0;

        $display("-----------------------------------");
        $display("Total checks: %0d", checks);
        $display("Total errors: %0d", errors);

        if (errors == 0)
            $display("RESULT: ALL TESTS PASSED");
        else
            $display("RESULT: TESTS FAILED");

        $display("-----------------------------------");

        $finish;
    end

endmodule
