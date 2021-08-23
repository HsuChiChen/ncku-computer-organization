library verilog;
use verilog.vl_types.all;
entity DefaultSlave is
    port(
        HCLK            : in     vl_logic;
        HRESETn         : in     vl_logic;
        HTRANS          : in     vl_logic_vector(1 downto 0);
        HSELDefault     : in     vl_logic;
        HREADYin        : in     vl_logic;
        HREADYout       : out    vl_logic;
        HRESP           : out    vl_logic_vector(1 downto 0)
    );
end DefaultSlave;
