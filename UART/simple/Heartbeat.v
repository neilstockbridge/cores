/*

Once each second, `beat` is driven HIGH for a cycle.

*/

module Heartbeat (
  clk,
  beat
);
  input   clk;
  output  beat;

  parameter  CLK_DIV = 12000000;

  reg [23:0]  countdown = CLK_DIV; // NOTE: Doesn't seem to warn when register isn't wide enough for a value

  always @ (posedge clk) begin

    countdown = countdown - 1;

    if (countdown == 0) begin

      countdown = CLK_DIV;
      beat = 1;

    end else begin

      beat = 0;
    end

  end // posedge clk

endmodule

