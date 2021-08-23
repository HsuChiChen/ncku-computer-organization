library verilog;
use verilog.vl_types.all;
entity TLB_operation_MUX is
    port(
        TLB_operation_EN: in     vl_logic;
        nMREQ           : in     vl_logic;
        MVA             : in     vl_logic_vector(21 downto 0);
        TLB_Entry_MVA   : in     vl_logic_vector(21 downto 0);
        Address_phase_nMREQ: out    vl_logic;
        Address_phase_MVA: out    vl_logic_vector(21 downto 0)
    );
end TLB_operation_MUX;
