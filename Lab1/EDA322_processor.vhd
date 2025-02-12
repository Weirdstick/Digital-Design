library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity EDA322_processor is
    generic ( dInitFile : string := "d_memory_lab2.mif";
              iInitFile : string := "i_memory_lab2.mif" );
    port(
        clk                : in  std_logic;
        resetn             : in  std_logic;
        master_load_enable : in  std_logic;
        extIn              : in  std_logic_vector(7 downto 0);
        pc2seg             : out std_logic_vector(7 downto 0);
        imDataOut2seg      : out std_logic_vector(11 downto 0);
        dmDataOut2seg      : out std_logic_vector(7 downto 0);
        aluOut2seg         : out std_logic_vector(7 downto 0);
        acc2seg            : out std_logic_vector(7 downto 0);
        busOut2seg         : out std_logic_vector(7 downto 0);
        ds2seg             : out std_logic_vector(7 downto 0)
    );
end EDA322_processor;

architecture structural of EDA322_processor is
    -- internal signals
    signal pcIncrOut, jumpAddr, nextPC, pcOut : std_logic_vector(7 downto 0);
    signal busSel : std_logic_vector(3 downto 0);
    signal busOut, aluOut, dmDataOut, accOut : std_logic_vector(7 downto 0);
    signal imDataOut : std_logic_vector(11 downto 0);
    signal imRead, dmRead, dmWrite, pcSel, pcLd, accSel, accLd, flagLd, dsLd : std_logic;
    signal aluOp : std_logic_vector(1 downto 0);
    signal e_flag, c_flag, z_flag : std_logic;
begin

    -- Instruction memory 
    I_MEM : entity work.memory
       generic map ( DATA_WIDTH => 12,
                     ADDR_WIDTH => 8,
                     INIT_FILE  => "i_memory_lab2.mif" )
       port map (
           clk     => clk,
           readEn  => imRead,
           writeEn => '0',
           address => pcOut,
           dataIn  => (others => '0'),
           dataOut => imDataOut
       );

    -- Data memory 
    D_MEM : entity work.memory
       generic map ( DATA_WIDTH => 8,
                     ADDR_WIDTH => 8,
                     INIT_FILE  => "d_memory_lab2.mif" )
       port map (
           clk     => clk,
           readEn  => dmRead,
           writeEn => dmWrite,
           address => imDataOut(7 downto 0),
           dataIn  => accOut,
           dataOut => dmDataOut
       );

    -- PC Reg
    PC_REG : entity work.reg
       generic map ( WIDTH => 8 )
       port map (
           clk        => clk,
           resetn     => resetn,
           loadEnable => pcLd,
           dataIn     => nextPC,
           dataOut    => pcOut
       );

    pcIncrOut <= std_logic_vector(unsigned(pcOut) + 1);

    -- block for offset
    process (busOut, pcOut)
    begin
        if busOut(7) = '0' then
            jumpAddr <= std_logic_vector(unsigned(pcOut) + unsigned(busOut(6 downto 0)));
        else
            jumpAddr <= std_logic_vector(unsigned(pcOut) - unsigned(busOut(6 downto 0)));
        end if;
    end process; 

    -- Mux for nextPC
    nextPC <= pcIncrOut when pcSel = '0' else jumpAddr;

    BUS_UNIT : entity work.proc_bus
       port map (
           imDataOut => imDataOut(7 downto 0),
           dmDataOut => dmDataOut,
           accOut    => accOut,
           extIn     => extIn,
           busSel    => busSel,
           busOut    => busOut
       );

    -- Outputs to 7-seg display
    pc2seg        <= pcOut;
    acc2seg       <= accOut;
    ds2seg        <= (others => '0');
    busOut2seg    <= busOut;
    imDataOut2seg <= imDataOut;
    dmDataOut2seg <= dmDataOut;
    aluOut2seg    <= aluOut; 

end structural;
