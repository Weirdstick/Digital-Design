library ieee;
use ieee.std_logic_1164.all;

entity fa is
    port(
        a, b: in std_logic;
        cin: in std_logic;
        cout: out std_logic;
        s: out std_logic
    );
end fa;

architecture dataflow of fa is
begin
	s <= a XOR b XOR cin;
	cout <= (a AND b) OR (a AND cin) OR (b AND cin);
end dataflow;