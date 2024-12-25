module TopMTB();
reg clk, ssdclk, reset, load, ledSel, ssdSel;
wire leds, ssd;

TopModule DUT ( clk, ssdclk, reset, load, ledSel,  ssdSel, leds,  ssd);

initial begin 
clk = 0 ;
forever #5 clk = ~ clk;
end 

initial begin 
reset = 1 ; 
load = 0 ;
#10 
reset = 0 ;
load = 1 ;
#500
$finish;
end

endmodule

