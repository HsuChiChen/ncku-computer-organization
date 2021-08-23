library verilog;
use verilog.vl_types.all;
entity Decoder is
    port(
        HRESETn         : in     vl_logic;
        HADDR           : in     vl_logic_vector(31 downto 0);
        HSELDefault     : out    vl_logic;
        HSEL_Slave1     : out    vl_logic;
        HSEL_Slave2     : out    vl_logic;
        HSEL_Slave3     : out    vl_logic;
        HSEL_Slave4     : out    vl_logic;
        HSEL_Slave5     : out    vl_logic
    );
end Decoder;
