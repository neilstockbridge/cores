
module top (
  clk,
  tx_line,    // The external line between devices driven by this UART
);

  input   clk;
  output  tx_line;

  wire  beat;
  wire  reset;
  reg [7:0]  tx_data = 8'h3e;

  assign  reset = 0;
  UART  uart (
    .clk        (clk),
    .reset      (reset),
    .tx_line    (tx_line),
    .tx_data    (tx_data),
    .tx_request (beat),
  );

  Heartbeat  heartbeat (
    .clk  (clk),
    .beat (beat)
  );

endmodule

