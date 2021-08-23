library verilog;
use verilog.vl_types.all;
entity memory_read_unit is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        nWAIT           : in     vl_logic;
        load_pc_flush   : in     vl_logic;
        multiple_last   : in     vl_logic;
        exe_swap_enable : in     vl_logic;
        mem_access_addr_last2: in     vl_logic_vector(1 downto 0);
        load_data_width : in     vl_logic_vector(1 downto 0);
        load_data_sign  : in     vl_logic;
        multiple_access : in     vl_logic;
        multiple_list   : in     vl_logic_vector(15 downto 0);
        data_processing_result: in     vl_logic_vector(31 downto 0);
        exe_data_from_mem: in     vl_logic;
        exe_mem_write_addr: in     vl_logic_vector(3 downto 0);
        exe_mem_write_enable: in     vl_logic;
        cause_exception : in     vl_logic;
        what_exception  : in     vl_logic_vector(2 downto 0);
        DDIN            : in     vl_logic_vector(31 downto 0);
        mem_write_data  : out    vl_logic_vector(31 downto 0);
        mem_write_addr  : out    vl_logic_vector(3 downto 0);
        mem_write_enable: out    vl_logic;
        exe_ldm2        : in     vl_logic;
        mem_ldm2        : out    vl_logic
    );
end memory_read_unit;
