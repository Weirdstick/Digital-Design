#reg.do

restart -f -nowave

add wave /reg/clk
add wave /reg/resetn
add wave /reg/loadEnable
add wave /reg/dataIn
add wave /reg/dataOut
# Takes care of adding relevant signals and reseting simulation automatically
  
force clk 0 0, 1 50ns -repeat 100ns
force resetn 0 0, 1 120ns

force loadEnable 0 0
force dataIn "00000000" 0
run 300ns

force loadEnable 1 100ns
force dataIn "11110000" 170ns
run 200ns

force loadEnable 0 200ns
force dataIn "00001111" 170ns
run 200ns


# Expected: dataOut: 11110000 - Pass
# Question/Concern: loadEnable signal stays at 1 despite force instruction (row 23). This is not reflected in the dataOut signal.
