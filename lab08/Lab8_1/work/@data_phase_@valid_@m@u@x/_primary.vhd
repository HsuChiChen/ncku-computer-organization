library verilog;
use verilog.vl_types.all;
entity Data_phase_Valid_MUX is
    port(
        Cache_operation_EN: in     vl_logic;
        Invalid_Valid_WE: in     vl_logic;
        Invalid_Valid_WData: in     vl_logic;
        Valid_WAddr     : in     vl_logic_vector(1 downto 0);
        Valid_WE        : in     vl_logic;
        Valid_WData     : in     vl_logic;
        Entry_MVA       : in     vl_logic_vector(1 downto 0);
        Data_phase_Valid_WAddr: out    vl_logic_vector(1 downto 0);
        Data_phase_Valid_WE: out    vl_logic;
        Data_phase_Valid_WData: out    vl_logic
    );
end Data_phase_Valid_MUX;
