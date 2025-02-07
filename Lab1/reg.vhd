library ieee;
use ieee.std_logic_1164.all;

entity reg is
    generic (width: integer := 8);
    port (
        clk: in std_logic;
        resetn: in std_logic;
        loadEnable: in std_logic;
        dataIn: in std_logic_vector(width-1 downto 0);
        dataOut: out std_logic_vector(width-1 downto 0)
    );
end entity reg;

architecture behavioral of reg is
	signal reg_data : std_logic_vector(width-1 downto 0);
begin
	process(clk, resetn)
	begin
		if resetn = '0' then
			reg_data <= (OTHERS => '0');
		elsif rising_edge(clk) then
			if loadEnable = '1' then
				reg_data <= dataIn;
			end if;
		end if;
	end process;

	dataOut <= reg_data;
end behavioral;
