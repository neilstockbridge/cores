/*

My first try at a UART.  Transmits ASCII '.' roughly once a second.

- https://en.wikipedia.org/wiki/RS-232
- Build this in a sid root (for the latest arachne-pnr)
- `clk` is 12 MHz

Questions:

  - Should the TXD line be driven by an intermediate register or is it OK to be
    driven directly from the `frame` register (as long as we accept that a
    change to `frame` during a transmission will change a bit on the line at a
    non-baud boundary).

  - Is it more efficient to rotate the bits of the frame rather than use an
    index register?

  - Is it more efficient to count down to zero than to compare to a target value?

*/

module top (
  clk,      // The external clock (12 MHz)
  tx_line,  // The external line between devices driven by this UART
);
  input   clk;
  output  tx_line;

  wire        reset;
  reg [7:0]   tx_data = 8'h2e; // ASCII '.'
  wire        beat;

  // Hold `reset` low.  It's active high, so this means: Do not reset.
  assign  reset = 0;

  // Instantiate a UART and connect its `clk` to the external clock, `reset` to
  // the `reset` wire (held low) and connect up the TXD line, the register that
  // holds the data to be transmitted and the "begin transmission" strobe,
  // `tx_request`.
  UART  uart (
    .clk        (clk),
    .reset      (reset),
    .tx_line    (tx_line),
    .tx_data    (tx_data),
    .tx_request (beat),
  );
  defparam uart.BAUD_RATE = 115200;

  // `heartbeat` drives the `beat` line HIGH for one cycle every second.
  Heartbeat  heartbeat (
    .clk  (clk),
    .beat (beat)
  );

endmodule

