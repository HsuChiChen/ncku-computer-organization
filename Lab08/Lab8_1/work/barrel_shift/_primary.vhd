library verilog;
use verilog.vl_types.all;
entity barrel_shift is
    port(
        shift_opern     : out    vl_logic_vector(31 downto 0);
        shift_carry_carry: out    vl_logic;
        shift_in        : in     vl_logic_vector(31 downto 0);
        shift_count     : in     vl_logic_vector(4 downto 0);
        shift_count_high3bit: in     vl_logic_vector(2 downto 0);
        shift_type      : in     vl_logic_vector(1 downto 0);
        shift_count_in_reg: in     vl_logic;
        operand2_is_reg : in     vl_logic;
        c_flag          : in     vl_logic
    );
end barrel_shift;
