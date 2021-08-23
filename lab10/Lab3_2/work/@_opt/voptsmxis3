library verilog;
use verilog.vl_types.all;
entity Valid_unit is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        nWAIT           : in     vl_logic;
        Data_phase_MVA  : in     vl_logic_vector(1 downto 0);
        nMREQ           : in     vl_logic;
        RAddr           : in     vl_logic_vector(1 downto 0);
        WAddr           : in     vl_logic_vector(1 downto 0);
        WE              : in     vl_logic;
        WData           : in     vl_logic;
        Invalid_Cache_entry: in     vl_logic;
        Cache_operation_EN: in     vl_logic;
        Data_phase_Valid: out    vl_logic
    );
end Valid_unit;
