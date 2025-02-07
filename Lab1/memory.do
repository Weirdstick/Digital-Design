# memory.do

restart -f -nowave

add wave /memory/clk
add wave /memory/readEn
add wave /memory/writeEn
add wave /memory/address
add wave /memory/dataIn
add wave /memory/dataOut

force clk 0 0, 1 50ns -repeat 100ns

force readEn 0 0
force writeEn 0 0
force address 8'b00000000 0
force dataIn 12'b000000000000 0
run 150 ns

force writeEn 1 200ns
force address 8'b00000001 200ns
force dataIn 12'b111111111111 200ns
run 200ns
force writeEn 0 300ns
run 50ns

force address 8'b00001010 350ns
force readEn 1 350ns
run 100ns
force readEn 0 450ns
run 50ns
