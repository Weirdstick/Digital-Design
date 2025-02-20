library ieee;
use ieee.std_logic_1164.all;

entity rotateleft is
    port(   
    	    ain: in   std_logic_vector (7 downto 0);
    	    bout: out  std_logic_vector (7 downto 0)
   	);
end rotateleft;

architecture dataflow of rotateleft is
begin
	bout <= ain(6 downto 0) & ain(7);
end dataflow;