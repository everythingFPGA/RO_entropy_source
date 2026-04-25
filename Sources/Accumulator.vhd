----------------------------------------------------------------------------------
-- Engineer: Andrea Bizzotto
-- 
-- Create Date: 04/25/2026 06:10:22 PM
-- Design Name: 
-- Module Name: Accumulator - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Accumulator is
    generic (
        SEED_LENGTH : integer := 256
    );
    port (
        clk        : in std_logic;
        rst        : in std_logic;
        entropy_in : in std_logic;
        seed_ready : out std_logic;
        seed_out   : out std_logic_vector(SEED_LENGTH - 1 downto 0)
    );
end entity;

architecture Behavioral of Accumulator is
    constant BUF_LENGTH : integer := 2 * SEED_LENGTH;
    signal buffer       : std_logic_vector(BUF_LENGTH - 1 downto 0);
    signal wr_ptr       : integer range 0 to BUF_LENGTH - 1 := 0;
    signal ready_r      : std_logic                         := '0';
    signal seed_r       : std_logic_vector(SEED_LENGTH - 1 downto 0);

begin

    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                buffer  <= (others => '0');
                wr_ptr  <= 0;
                ready_r <= '0';
            else
                buffer(wr_ptr) <= entropy_in;

                if wr_ptr = BUF_LENGTH - 1 then
                    wr_ptr <= 0;
                    seed_r <= buffer(BUF_LENGTH - 1 downto SEED_LENGTH);
                    -- pulse seed_ready
                    ready_r <= '1';
                elsif wr_ptr = SEED_LENGTH then
                    seed_r <= buffer(SEED_LENGTH - 1 downto 0);
                    -- pulse seed_ready
                    ready_r <= '1';
                else
                    wr_ptr  <= wr_ptr + 1;
                    ready_r <= '0';
                end if;
            end if;
        end if;
    end process;

    seed_out   <= seed_r;
    seed_ready <= ready_r;

end architecture;