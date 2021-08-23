library verilog;
use verilog.vl_types.all;
entity condition_code_check is
    port(
        ctl_coprocessor_enable: in     vl_logic;
        ctl_exe_write_enable: in     vl_logic;
        ctl_mem_write_enable: in     vl_logic;
        ctl_lw_str_enable: in     vl_logic;
        ctl_psr_write_enable: in     vl_logic;
        ctl_branch      : in     vl_logic;
        ctl_multiple    : in     vl_logic;
        ctl_multiply_type: in     vl_logic_vector(2 downto 0);
        id_condition_code: in     vl_logic_vector(3 downto 0);
        psr_condition_code: in     vl_logic_vector(3 downto 0);
        chk_exe_write_enable: out    vl_logic;
        chk_mem_write_enable: out    vl_logic;
        chk_coprocessor_enable: out    vl_logic;
        chk_lw_str_enable: out    vl_logic;
        chk_psr_write_enable: out    vl_logic;
        chk_multiple    : out    vl_logic;
        chk_branch      : out    vl_logic;
        chk_multiply_type: out    vl_logic_vector(2 downto 0)
    );
end condition_code_check;
