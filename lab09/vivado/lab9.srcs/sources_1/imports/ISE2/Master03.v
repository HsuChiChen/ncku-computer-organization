
module Master03  (HCLK, HRESETn,HREADYM,HRESPM,HGRANTM, HADDRM, HTRANSM, HWRITEM, HSIZEM, HBURSTM, HPROTM,
          HWDATAM, HBUSREQM
          );

  // Signals used during normal operation 
  input     HCLK;
  input     HRESETn;

  // Signals from AMBA bus used during normal operation
  input         HREADYM;
  input  [1:0]  HRESPM;    //dont care
  input         HGRANTM;

  // Signals to AMBA bus used during normal operation
  output[31:0] HADDRM;
  output [1:0] HTRANSM;
  output       HWRITEM;
  output [2:0] HSIZEM;
  output [2:0] HBURSTM;
  output [3:0] HPROTM;
  output[31:0] HWDATAM;
  output       HBUSREQM;

  
  //---------------------------------------------------------------------- 
  // Signal declarations
  //----------------------------------------------------------------------


  assign HBURSTM = 3'b000;  //SINGLE
  assign HSIZEM = 3'b010;  //WORD
  assign HWRITEM =  1'b1 ;
  assign HADDRM = 32'h2000_0000; //Tube
  assign HTRANSM = 2'b10;  // NONSEQ
  assign HBUSREQM =  (~HRESETn)?1'b0:1'b1;    
  assign HWDATAM = 32'h0000_0047;
  assign HPROTM = 4'b0000;

  
endmodule

