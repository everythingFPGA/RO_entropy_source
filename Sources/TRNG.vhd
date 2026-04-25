----------------------------------------------------------------------------------
-- Engineer: Andrea Bizzotto
-- 
-- Create Date: 04/25/2026 04:56:16 PM
-- Design Name: 
-- Module Name: RingOscillator - RTL
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: True Random Number Generator top-level.
--              Instantiates NUM_RO ring oscillators, combines their outputs
--              through XOR_1bit (CDC + XOR reduction), and accumulates the
--              resulting bitstream into SEED_LENGTH-bit seeds.
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
-- use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
-- library UNISIM;
-- use UNISIM.VComponents.all;

entity TRNG is
    generic (
        NUM_RO      : integer := 8;  -- Number of ring oscillators
        RO_STAGES   : integer := 5;  -- Inverter stages per RO (MUST be odd)
        SEED_LENGTH : integer := 256 -- Seed width in bits
    );
    port (
        CLK        : in std_logic;
        RST        : in std_logic;
        SEED_READY : out std_logic;
        SEED_OUT   : out std_logic_vector(SEED_LENGTH - 1 downto 0)
    );
end entity TRNG;

architecture Behavioral of TRNG is

    signal ro_w          : std_logic_vector(NUM_RO - 1 downto 0);
    signal entropy_bit_w : std_logic;

begin

    -- -------------------------------------------------------------------------
    -- Ring oscillators
    -- -------------------------------------------------------------------------
    gen_ro : for i in 0 to NUM_RO - 1 generate
        u_ro : entity work.RingOscillator
            generic map(
                NUM_STAGES => RO_STAGES
            )
            port map(
                EN  => '1',
                CLK => ro_w(i)
            );
    end generate gen_ro;

    -- -------------------------------------------------------------------------
    -- XOR reduction
    -- -------------------------------------------------------------------------
    u_xor : entity work.XOR_1bit
        generic map(
            N => NUM_RO
        )
        port map(
            CLK         => CLK,
            RO          => ro_w,
            ENTROPY_BIT => entropy_bit_w
        );

    -- -------------------------------------------------------------------------
    -- Bit accumulator
    -- -------------------------------------------------------------------------
    u_acc : entity work.Accumulator
        generic map(
            SEED_LENGTH => SEED_LENGTH
        )
        port map(
            CLK        => CLK,
            RST        => RST,
            ENTROPY_IN => entropy_bit_w,
            SEED_READY => SEED_READY,
            SEED_OUT   => SEED_OUT
        );

end architecture;