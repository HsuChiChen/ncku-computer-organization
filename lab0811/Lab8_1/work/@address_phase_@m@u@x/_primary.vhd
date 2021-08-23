library verilog;
use verilog.vl_types.all;
entity Address_phase_MUX is
    port(
        Cache_operation_EN: in     vl_logic;
        nMREQ           : in     vl_logic;
        MVA             : in     vl_logic_vector(26 downto 0);
        Entry_MVA       : in     vl_logic_vector(26 downto 0);
        Address_phase_nMREQ: out    vl_logic;
        Address_phase_MVA: out    vl_logic_vector(26 downto 0)
    );
end Address_phase_MUX;
