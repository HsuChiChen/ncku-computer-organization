library verilog;
use verilog.vl_types.all;
entity Data_phase_Value_MUX is
    port(
        fill            : in     vl_logic;
        Controller_Value_WAddr: in     vl_logic_vector(4 downto 0);
        Controller_Value_WE: in     vl_logic_vector(3 downto 0);
        Controller_Value_WData: in     vl_logic_vector(31 downto 0);
        Value_WAddr     : in     vl_logic_vector(4 downto 0);
        Value_WE        : in     vl_logic_vector(3 downto 0);
        Value_WData     : in     vl_logic_vector(31 downto 0);
        Data_phase_Value_WAddr: out    vl_logic_vector(4 downto 0);
        Data_phase_Value_WE: out    vl_logic_vector(3 downto 0);
        Data_phase_Value_WData: out    vl_logic_vector(31 downto 0)
    );
end Data_phase_Value_MUX;
