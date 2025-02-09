# memory.do

restart -f -nowave

add wave /memory/clk
add wave /memory/readEn
add wave /memory/writeEn
add wave /memory/address
add wave /memory/dataIn
add wave /memory/dataOut

force clk 0 0, 1 50ns -repeat 100ns

force writeEn 0 0
force readEn 0 0
force address 8'b0000000 0
force dataIn 8'b00000000 0
run 100ns

force writeEn 1 40ns
force address 8'b000100011 40ns
force dataIn 12'b111111110000 40ns
run 100ns

force writeEn 0 150ns
run 50ns

force readEn 1 200ns
force address 8'b00100011 200ns
run 150ns

force readEn 0 200ns
run 400ns
