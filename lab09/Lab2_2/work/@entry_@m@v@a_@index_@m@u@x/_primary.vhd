library verilog;
use verilog.vl_types.all;
entity Entry_MVA_Index_MUX is
    port(
        Clean_DCache_Index: in     vl_logic;
        Clean_Invalid_DCache_Index: in     vl_logic;
        Entry_MVA_Index : in     vl_logic_vector(26 downto 0);
        Index           : out    vl_logic_vector(1 downto 0)
    );
end Entry_MVA_Index_MUX;
