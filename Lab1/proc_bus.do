# proc_bus.do

restart -f -nowave

add wave /proc_bus/busSel
add wave /proc_bus/imDataOut
add wave /proc_bus/dmDataOut
add wave /proc_bus/accOut
add wave /proc_bus/extIn
add wave /proc_bus/busOut

force imDataOut 8'b00000000 0
force dmDataOut 8'b00000000 0
force accOut    8'b00000000 0
force extIn     8'b00000000 0
force busSel    4'b0000 0  

run 100ns

# ================ Test imDataOut (0) ==================

#force imDataOut 8'b10101010 100ns 
#force busSel    4'b0001 100ns    
#run 300ns

  
# =============== Test dmDataOut (1) ===============

#force dmDataOut 8'b11001100 100ns
#force busSel    4'b0001 100nsforce busSel    4'b0010 100ns  
#force busSel    4'b0001 100ns
#run 300ns

  
# ============== Test accOut (2) =================

#force accOut    8'b01010101 100ns
#force busSel    4'b0100 100ns  
#run 300ns

  
#============= Test extIn (3) ===================

force extIn     8'b11110000 100ns
force busSel    4'b1000 100ns     
run 300ns
