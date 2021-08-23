library verilog;
use verilog.vl_types.all;
entity EASY is
    port(
        HCLK            : in     vl_logic;
        HRESETn         : in     vl_logic;
        SW1_IRQ         : in     vl_logic;
        LED1_ACK        : out    vl_logic
    );
end EASY;
