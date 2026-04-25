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
        CLK        : in std_logic;
        RST        : in std_logic;
        ENTROPY_IN : in std_logic;
        SEED_READY : out std_logic;
        SEED_OUT   : out std_logic_vector(SEED_LENGTH - 1 downto 0)
    );
end entity;

architecture Behavioral of Accumulator is
    constant C_BUF_LENGTH : integer := 2 * SEED_LENGTH;
    signal buff_r         : std_logic_vector(C_BUF_LENGTH - 1 downto 0);
    signal wr_ptr         : integer range 0 to C_BUF_LENGTH - 1 := 0;
    signal ready_r        : std_logic                           := '0';
    signal seed_r         : std_logic_vector(SEED_LENGTH - 1 downto 0);

begin

    process (CLK)
    begin
        if rising_edge(CLK) then
            if RST = '1' then
                buff_r  <= (others => '0');
                wr_ptr  <= 0;
                ready_r <= '0';
            else
                buff_r(wr_ptr) <= ENTROPY_IN;

                if wr_ptr = C_BUF_LENGTH - 1 then
                    wr_ptr  <= 0;
                    seed_r  <= ENTROPY_IN & buff_r(C_BUF_LENGTH - 2 downto SEED_LENGTH);
                    ready_r <= '1';
                elsif wr_ptr = SEED_LENGTH then
                    wr_ptr  <= wr_ptr + 1;
                    seed_r  <= buff_r(SEED_LENGTH - 1 downto 0);
                    ready_r <= '1';
                else
                    wr_ptr  <= wr_ptr + 1;
                    ready_r <= '0';
                end if;
            end if;
        end if;
    end process;

    SEED_OUT   <= seed_r;
    SEED_READY <= ready_r;

end architecture;