library verilog;
use verilog.vl_types.all;
entity exception_handler is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        nWAIT           : in     vl_logic;
        HIVECS          : in     vl_logic;
        nfiq            : in     vl_logic;
        nirq            : in     vl_logic;
        fetch_instruction_abort: in     vl_logic;
        dabort          : in     vl_logic;
        undefined_instruction: in     vl_logic;
        swi_instruction : in     vl_logic;
        instruction     : in     vl_logic_vector(31 downto 0);
        exe_psr_write_enable: in     vl_logic;
        exe_psr_sel     : in     vl_logic;
        exe_psr_write_mask: in     vl_logic_vector(3 downto 0);
        expt_psr_write_enable: out    vl_logic;
        expt_psr_sel    : out    vl_logic;
        expt_psr_write_mask: out    vl_logic_vector(3 downto 0);
        swi_enable      : out    vl_logic;
        cause_exception : out    vl_logic;
        what_exception  : out    vl_logic_vector(2 downto 0);
        exception_vector_addr: out    vl_logic_vector(31 downto 0);
        exe_lw_str_instruction: in     vl_logic;
        mem_lw_str_instruction: out    vl_logic
    );
end exception_handler;
