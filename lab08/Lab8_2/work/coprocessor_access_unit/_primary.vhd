library verilog;
use verilog.vl_types.all;
entity coprocessor_access_unit is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        nWAIT           : in     vl_logic;
        load_pc_flush   : in     vl_logic;
        cause_exception : in     vl_logic;
        coprocessor_store_data: in     vl_logic_vector(31 downto 0);
        coprocessor_enable: in     vl_logic;
        mcr_mrc_instruction: in     vl_logic;
        mrc_CPSR_enable : in     vl_logic;
        chk_coprocessor_enable: in     vl_logic;
        ctl_mcr_mrc_instruction: in     vl_logic;
        coprocessor_write_enable: out    vl_logic;
        coprocessor_write_data: out    vl_logic_vector(31 downto 0);
        cp_psr_write_enable: out    vl_logic;
        cp_psr_write_data: out    vl_logic_vector(31 downto 0);
        CPDIN           : in     vl_logic_vector(31 downto 0);
        CPDOUT          : out    vl_logic_vector(31 downto 0)
    );
end coprocessor_access_unit;
