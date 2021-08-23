library verilog;
use verilog.vl_types.all;
entity psr_status is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        nWAIT           : in     vl_logic;
        load_pc_flush   : in     vl_logic;
        psr_mode        : out    vl_logic_vector(4 downto 0);
        cause_exception : in     vl_logic;
        what_exception  : in     vl_logic_vector(2 downto 0);
        back_to_usr_mode: in     vl_logic;
        psr_write_data  : in     vl_logic_vector(31 downto 0);
        psr_write_mask  : in     vl_logic_vector(3 downto 0);
        psr_write_enable: in     vl_logic;
        psr_sel         : in     vl_logic;
        cp_psr_write_enable: in     vl_logic;
        cp_psr_write_data: in     vl_logic_vector(31 downto 0);
        psr_cpsr_reg    : out    vl_logic_vector(31 downto 0);
        psr_spsr_reg    : out    vl_logic_vector(31 downto 0);
        cpsr_i_bit      : out    vl_logic;
        cpsr_f_bit      : out    vl_logic;
        ldm_cpsr_update_go: in     vl_logic
    );
end psr_status;
