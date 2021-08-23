library verilog;
use verilog.vl_types.all;
entity Timers is
    port(
        HCLK            : in     vl_logic;
        HRESETn         : in     vl_logic;
        HSELT           : in     vl_logic;
        ENABLE_D        : in     vl_logic_vector(31 downto 0);
        VALUE_D         : in     vl_logic_vector(31 downto 0);
        HADDR           : in     vl_logic_vector(31 downto 0);
        ACK             : in     vl_logic;
        timer_itr       : out    vl_logic
    );
end Timers;
