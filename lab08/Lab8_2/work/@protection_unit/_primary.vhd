library verilog;
use verilog.vl_types.all;
entity Protection_unit is
    port(
        TLB_Check       : in     vl_logic;
        Data_phase_nTRANS: in     vl_logic;
        Data_phase_MAS  : in     vl_logic_vector(1 downto 0);
        Data_phase_nRW  : in     vl_logic;
        Data_phase_nMREQ: in     vl_logic;
        Data_phase_MVA  : in     vl_logic_vector(31 downto 0);
        Data_phase_MMU_Enable: in     vl_logic;
        Data_phase_Descriptor: in     vl_logic_vector(11 downto 0);
        Data_phase_ROM_Protection: in     vl_logic;
        Data_phase_System_Protection: in     vl_logic;
        D_phase_Align_Fault_Enable: in     vl_logic;
        Data_phase_DACR : in     vl_logic_vector(31 downto 0);
        Data_phase_Translation_fault: in     vl_logic_vector(1 downto 0);
        Data_phase_Domain: in     vl_logic_vector(3 downto 0);
        Translation_fault_Domain: in     vl_logic_vector(3 downto 0);
        EXT_ABORT       : in     vl_logic;
        Internal_ABORT  : out    vl_logic;
        FSR             : out    vl_logic_vector(7 downto 0);
        FSR_we          : out    vl_logic;
        FAR             : out    vl_logic_vector(31 downto 0);
        FAR_we          : out    vl_logic;
        ABORT           : out    vl_logic
    );
end Protection_unit;
