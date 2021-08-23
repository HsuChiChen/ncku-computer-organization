library verilog;
use verilog.vl_types.all;
entity alu_op is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        nWAIT           : in     vl_logic;
        alu_type        : in     vl_logic_vector(3 downto 0);
        bx_op           : in     vl_logic;
        multiply_type   : in     vl_logic_vector(2 downto 0);
        alu_first_opern : in     vl_logic_vector(31 downto 0);
        multiply_third_opern: in     vl_logic_vector(31 downto 0);
        multiply_fourth_opern: in     vl_logic_vector(31 downto 0);
        alu_second_opern: in     vl_logic_vector(31 downto 0);
        shift_carry_out : in     vl_logic;
        psr_cpsr        : in     vl_logic_vector(31 downto 0);
        alu_updated_cpsr: out    vl_logic_vector(31 downto 0);
        alu_out         : out    vl_logic_vector(31 downto 0);
        alu_results     : out    vl_logic_vector(31 downto 0);
        multiply_out    : out    vl_logic_vector(31 downto 0)
    );
end alu_op;
