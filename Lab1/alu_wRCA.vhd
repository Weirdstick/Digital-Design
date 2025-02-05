library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Interface declarations
entity alu_wRCA is
    port(
        alu_inA, alu_inB : in  std_logic_vector(7 downto 0);
        alu_op           : in  std_logic_vector(1 downto 0);
        alu_out          : out std_logic_vector(7 downto 0);
        C                : out std_logic;
        E                : out std_logic;
        Z                : out std_logic
    );
end alu_wRCA;

-- Describes expected behaviour for struct and components
architecture structural of alu_wRCA is
    component rca
        port(
            a, b  : in  std_logic_vector(7 downto 0);
            cin   : in  std_logic;
            cout  : out std_logic;
            s     : out std_logic_vector(7 downto 0)
        );
    end component;

    component cmp
        port(
            a, b : in  std_logic_vector(7 downto 0);
            e    : out std_logic
        );
    end component;
    
    signal adder_out, and_out, rol_out : std_logic_vector(7 downto 0);
    signal sub_b, mux_out              : std_logic_vector(7 downto 0);
    signal cin_sub, carry_flag         : std_logic;
    signal cmp_result                  : std_logic;
    
begin
    -- Subtraction (2's complement)
    sub_b   <= not alu_inB when alu_op = "11" else alu_inB; -- Invert
    cin_sub <= '1' when alu_op = "11" else '0'; -- Add 1 by pre-loading c_in
    

    -- Adder/Subtractor 
    ADDER: rca port map(
        a    => alu_inA,
        b    => sub_b,
        cin  => cin_sub, -- Set as 1 when instruction b'11 is called
        cout => carry_flag,
        s    => adder_out
    );

    -- AND Operation
    and_out <= alu_inA and alu_inB;

    -- ROL Operation (1-bit left rotation)
    rol_out <= alu_inA(6 downto 0) & alu_inA(7);

    -- Comparator Unit (Always active, will always output result hence not included in multiplexer)
    CMP_UNIT: cmp port map(
        a => alu_inA,
        b => alu_inB,
        e => cmp_result
    );

    -- Output MUX (Multiplexer)
    with alu_op select mux_out <=
        rol_out    when "00",  -- ROL
        and_out    when "01",  -- AND
        adder_out  when "10",  -- ADD
        adder_out  when "11",  -- SUB
        (others => '0') when others;

    -- Flags
    alu_out <= mux_out;
    C <= not carry_flag when alu_op = "11" else  -- Invert carry for borrow
         carry_flag when alu_op = "10" else      -- Direct carry for ADD
         '0';
    E <= cmp_result;  -- Always output comp result
    Z <= '1' when mux_out = "00000000" else '0';
end structural;
