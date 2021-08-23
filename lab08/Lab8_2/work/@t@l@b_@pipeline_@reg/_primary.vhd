library verilog;
use verilog.vl_types.all;
entity TLB_Pipeline_Reg is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        nWAIT           : in     vl_logic;
        nMREQ           : in     vl_logic;
        TLB_Check       : in     vl_logic;
        MVA             : in     vl_logic_vector(31 downto 0);
        Cache_Enable    : in     vl_logic;
        ROM_Protection  : in     vl_logic;
        System_Protection: in     vl_logic;
        Alignment_Fault_Enable: in     vl_logic;
        MMU_Enable      : in     vl_logic;
        DACR            : in     vl_logic_vector(31 downto 0);
        Translation_fault: in     vl_logic_vector(1 downto 0);
        Descriptor      : in     vl_logic_vector(31 downto 0);
        Domain          : in     vl_logic_vector(3 downto 0);
        Data_phase_nMREQ: out    vl_logic;
        Data_phase_MVA  : out    vl_logic_vector(31 downto 0);
        Data_phase_MMU_Enable: out    vl_logic;
        Data_phase_Descriptor: out    vl_logic_vector(31 downto 0);
        Data_phase_Cache_Enable: out    vl_logic;
        Data_phase_ROM_Protection: out    vl_logic;
        Data_phase_System_Protection: out    vl_logic;
        D_phase_Align_Fault_Enable: out    vl_logic;
        Data_phase_DACR : out    vl_logic_vector(31 downto 0);
        Data_phase_Translation_fault: out    vl_logic_vector(1 downto 0);
        Data_phase_Domain: out    vl_logic_vector(3 downto 0)
    );
end TLB_Pipeline_Reg;
