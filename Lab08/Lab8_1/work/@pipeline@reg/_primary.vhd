library verilog;
use verilog.vl_types.all;
entity PipelineReg is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        nWAIT           : in     vl_logic;
        nTRANS          : in     vl_logic;
        LOCK            : in     vl_logic;
        MAS             : in     vl_logic_vector(1 downto 0);
        nRW             : in     vl_logic;
        Data_phase_nTRANS: out    vl_logic;
        Data_phase_LOCK : out    vl_logic;
        Data_phase_MAS  : out    vl_logic_vector(1 downto 0);
        Data_phase_nRW  : out    vl_logic
    );
end PipelineReg;
