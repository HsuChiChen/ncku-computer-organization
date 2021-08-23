library verilog;
use verilog.vl_types.all;
entity forwarding_unit is
    port(
        exe_write_addr  : in     vl_logic_vector(3 downto 0);
        exe_write_enable: in     vl_logic;
        mem_write_addr  : in     vl_logic_vector(3 downto 0);
        mem_write_enable: in     vl_logic;
        id_first_addr   : in     vl_logic_vector(3 downto 0);
        id_second_addr  : in     vl_logic_vector(3 downto 0);
        id_third_addr   : in     vl_logic_vector(3 downto 0);
        id_fourth_addr  : in     vl_logic_vector(3 downto 0);
        expt_psr_write_enable: in     vl_logic;
        expt_psr_sel    : in     vl_logic;
        for_first_sel   : out    vl_logic_vector(1 downto 0);
        for_second_sel  : out    vl_logic_vector(1 downto 0);
        for_third_sel   : out    vl_logic_vector(1 downto 0);
        for_fourth_sel  : out    vl_logic_vector(1 downto 0);
        for_cpsr_sel    : out    vl_logic
    );
end forwarding_unit;
