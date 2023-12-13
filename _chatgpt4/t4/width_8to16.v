module width_8to16(
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    output reg valid_out,
    output reg [15:0] data_out
);

    // Internal signal to track the stored byte
    reg [7:0] data_lock;
    // Internal signal to indicate if we've stored the first byte
    reg flag;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset the state
            data_out <= 16'd0;
            valid_out <= 1'b0;
            data_lock <= 8'd0;
            flag <= 1'b0;
        end else if (valid_in) begin
            if (flag) begin
                // We've received the second byte, concatenate
                data_out <= {data_lock, data_in};
                valid_out <= 1'b1;
                flag <= 1'b0;  // Reset the flag as we've used the stored byte
            end else begin
                // Store the first byte and wait for the second byte
                data_lock <= data_in;
                flag <= 1'b1;
                valid_out <= 1'b0;  // Output is not valid until we have two bytes
            end
        end else if (flag) begin
            // If we have a stored byte but no new valid input, keep outputs invalid
            valid_out <= 1'b0;
        end
    end

endmodule