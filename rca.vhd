library ieee;
use ieee.std_logic_1164.all;

entity rca is
    port(
        a, b: in std_logic_vector(7 downto 0);
        cin: in std_logic;
        cout: out std_logic;
        s: out std_logic_vector(7 downto 0)
    );
end rca;

architecture structural of rca is
	component fa
		port(
			a,b,cin : in std_logic;
			cout,s : out std_logic
	);
	end component;

	signal carry : std_logic_vector(8 downto 0);
begin
	carry(0) <= cin;

	GEN_RCA: for i in 0 to 7 generate
		FAx: fa port map(
			a 	=> a(i),
			b 	=> b(i),
			cin 	=> carry(i),
			cout 	=> carry(i+1),
			s  	=> s(i)
		);
	end generate GEN_RCA;
	
	cout <= carry(8);
end structural;
		


























