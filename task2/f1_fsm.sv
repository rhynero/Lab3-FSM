module f1_fsm (
    input   logic       rst,
    input   logic       en,
    input   logic       clk,
    output  logic [7:0] data_out
);

    // Define states
    typedef enum {S0, S1, S2, S3, S4, S5, S6, S7, S8} my_state;
    my_state current_state, next_state;

    // Signal for edge detection of `en`
    logic en_d, en_pulse;

    // // State register
    // always_ff @(posedge clk or posedge rst) begin
    //     if (rst)
    //         current_state <= S0;
    //     else if (en) 
    //         current_state <= next_state;
    // end

    // Edge detection logic for `en`
    always_ff @(posedge clk or posedge rst) 
        if (rst) 
            en_d <= 1'b0;
            en_pulse <= 1'b0;
        else 
            en_d <= en;
            en_pulse <= en && ~en_d;  // Detect rising edge of `en`
        
    // State register update (advance only on en_pulse)
    always_ff @(posedge clk or posedge rst) 
        if (rst)
            current_state <= S0;
        else if (en_pulse)
            current_state <= next_state;

    // Next state logic
    always_comb begin
        case (current_state)
            S0:     next_state = S1;
            S1:     next_state = S2;
            S2:     next_state = S3;
            S3:     next_state = S4;
            S4:     next_state = S5;
            S5:     next_state = S6;
            S6:     next_state = S7;
            S7:     next_state = S8;
            S8:     next_state = S0;
            default: next_state = S0;
        endcase
    end

    // Output logic based on state
    always_comb begin
        case (current_state)
            S0: data_out = 8'b00000000;
            S1: data_out = 8'b00000001;
            S2: data_out = 8'b00000011;
            S3: data_out = 8'b00000111;
            S4: data_out = 8'b00001111;
            S5: data_out = 8'b00011111;
            S6: data_out = 8'b00111111;
            S7: data_out = 8'b01111111;
            S8: data_out = 8'b11111111;
            default: data_out = 8'b00000000;
        endcase
    end

endmodule
