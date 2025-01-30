library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

entity cmp is
    port(   a: in   std_logic_vector (7 downto 0);
            b: in   std_logic_vector (7 downto 0);
    	    e: out  std_logic);
end cmp;

architecture dataflow of cmp is
	signal diff : std_logic_vector (7 downto 0);
begin
	diff 	<= a XOR b;
	e	<= NOT OR_REDUCE(diff);
end dataflow; 