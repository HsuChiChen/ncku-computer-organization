library verilog;
use verilog.vl_types.all;
entity MVA_Reg is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        nWAIT           : in     vl_logic;
        nMREQ           : in     vl_logic;
        MVA             : in     vl_logic_vector(31 downto 0);
        Data_phase_MVA  : out    vl_logic_vector(31 downto 0)
    );
end MVA_Reg;
