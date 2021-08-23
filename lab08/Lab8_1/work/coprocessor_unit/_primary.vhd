library verilog;
use verilog.vl_types.all;
entity coprocessor_unit is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        nWAIT           : in     vl_logic;
        load_pc_flush   : in     vl_logic;
        cause_exception : in     vl_logic;
        chk_coprocessor_enable: in     vl_logic;
        ctl_mcr_mrc_instruction: in     vl_logic;
        ctl_mrc_CPSR_enable: in     vl_logic;
        curren_processor_mode: in     vl_logic_vector(4 downto 0);
        CHSEX           : in     vl_logic_vector(1 downto 0);
        CPEN            : in     vl_logic;
        coprocessor_enable: out    vl_logic;
        mcr_mrc_instruction: out    vl_logic;
        mrc_CPSR_enable : out    vl_logic;
        coprocessor_state: out    vl_logic_vector(1 downto 0);
        CPLATECANCEL    : out    vl_logic;
        CPTBIT          : out    vl_logic;
        nCPTRANS        : out    vl_logic
    );
end coprocessor_unit;
