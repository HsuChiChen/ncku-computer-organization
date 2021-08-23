library verilog;
use verilog.vl_types.all;
entity hazard_detection_unit is
    port(
        id_fourth_addr  : in     vl_logic_vector(3 downto 0);
        id_mem_write_addr: in     vl_logic_vector(3 downto 0);
        ctl_lw_str_instruction: in     vl_logic;
        lw_str_enable   : in     vl_logic;
        chk_multiply_type: in     vl_logic_vector(2 downto 0);
        instruction     : in     vl_logic_vector(31 downto 0);
        multiple_one    : in     vl_logic;
        multiple_last   : in     vl_logic;
        fet_first_addr  : in     vl_logic_vector(3 downto 0);
        fet_second_addr : in     vl_logic_vector(3 downto 0);
        fet_third_addr  : in     vl_logic_vector(3 downto 0);
        fet_fourth_addr : in     vl_logic_vector(3 downto 0);
        str_instruction : in     vl_logic;
        mcr_instruction : in     vl_logic;
        chk_coprocessor_enable: in     vl_logic;
        ctl_mcr_mrc_instruction: in     vl_logic;
        stall_instruction_fetch: out    vl_logic;
        insert_bubble   : out    vl_logic;
        multiple_store  : in     vl_logic;
        stall_for_stm2  : in     vl_logic;
        exe_ldm2        : in     vl_logic;
        mem_ldm2        : in     vl_logic;
        chk_multiple    : in     vl_logic;
        msr_i_f_bit     : in     vl_logic
    );
end hazard_detection_unit;
