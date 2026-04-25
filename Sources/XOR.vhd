----------------------------------------------------------------------------------
-- Engineer: Andrea Bizzotto
-- 
-- Create Date: 04/25/2026 06:09:55 PM
-- Design Name: 
-- Module Name: XOR_1bit - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity XOR_1bit is
    generic (
        N : integer := 8 -- Number of ROs
    );
    port (
        CLK         : in std_logic;                        -- Sampling clock
        RO          : in std_logic_vector(N - 1 downto 0); -- Ring Oscillators
        ENTROPY_BIT : out std_logic
    );
end XOR_1bit;

architecture Behavioral of XOR_1bit is
    signal ro_sampled : std_logic_vector(N - 1 downto 0);
    signal xor_w      : std_logic;
begin

    --------------------------------------------------------------------
    -- CDC RO
    --------------------------------------------------------------------
    xpm_cdc_array_single_inst : xpm_cdc_array_single
    generic map(
        DEST_SYNC_FF   => 2, -- DECIMAL; range: 2-10
        INIT_SYNC_FF   => 0, -- DECIMAL; 0=disable simulation init values, 1=enable simulation init values
        SIM_ASSERT_CHK => 0, -- DECIMAL; 0=disable simulation messages, 1=enable simulation messages
        SRC_INPUT_REG  => 0, -- DECIMAL; 0=do not register input, 1=register input
        WIDTH          => N  -- DECIMAL; range: 1-1024
    )
    port map(
        dest_out => ro_sampled, -- WIDTH-bit output: src_in synchronized to the destination clock domain. This output is registered.
        dest_clk => CLK,        -- 1-bit input: Clock signal for the destination clock domain.
        src_clk  => '0',        -- 1-bit input: optional; required when SRC_INPUT_REG = 1
        src_in   => RO          -- WIDTH-bit input: Input single-bit array to be synchronized to destination clock domain. It is assumed that each bit of
        -- the array is unrelated to the others. This is reflected in the constraints applied to this macro. To transfer a binary
        -- value losslessly across the two clock domains, use the XPM_CDC_GRAY macro instead.
    );

    --------------------------------------------------------------------
    -- XOR reduction
    --------------------------------------------------------------------
    process (ro_sampled)
        variable tmp : std_logic;
    begin
        tmp := '0';
        for i in 0 to N - 1 loop
            tmp := tmp xor ro_sampled(i);
        end loop;
        xor_w <= tmp;
    end process;

    ENTROPY_BIT <= xor_w;

end Behavioral;