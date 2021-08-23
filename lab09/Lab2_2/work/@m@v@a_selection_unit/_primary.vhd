library verilog;
use verilog.vl_types.all;
entity MVA_selection_unit is
    port(
        MVA             : in     vl_logic_vector(31 downto 0);
        Entry_MVA       : in     vl_logic_vector(26 downto 0);
        TLB_Check       : in     vl_logic;
        Addr_phase_MVA  : out    vl_logic_vector(31 downto 0)
    );
end MVA_selection_unit;
