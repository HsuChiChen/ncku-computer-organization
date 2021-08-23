library verilog;
use verilog.vl_types.all;
entity VAtoPA_unit is
    port(
        TLB_Check       : in     vl_logic;
        Data_phase_nRW  : in     vl_logic;
        Internal_ABORT  : in     vl_logic;
        Data_phase_nMREQ: in     vl_logic;
        Data_phase_MVA  : in     vl_logic_vector(31 downto 0);
        Data_phase_MMU_Enable: in     vl_logic;
        Data_phase_Descriptor: in     vl_logic_vector(31 downto 0);
        Data_phase_Cache_Enable: in     vl_logic;
        Data_phase_EXT_Enable: out    vl_logic;
        Data_phase_Cacheable: out    vl_logic;
        Data_phase_Bufferable: out    vl_logic;
        Data_phase_PA   : out    vl_logic_vector(31 downto 0);
        Write_Buffer_Enable: out    vl_logic
    );
end VAtoPA_unit;
