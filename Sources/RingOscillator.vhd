----------------------------------------------------------------------------------
-- Engineer: Andrea Bizzotto
-- 
-- Create Date: 04/25/2026 04:56:16 PM
-- Design Name: 
-- Module Name: RingOscillator - RTL
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Configurable ring oscillator
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
-- use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;


entity RingOscillator is
    generic (
        NUM_STAGES : integer := 5 -- Number of inverter stages (MUST be odd)
    );
    port (
        EN_i      : in  std_logic; -- active high
        CLK_o : out std_logic
    );
    attribute KEEP_HIERARCHY : string;
    attribute KEEP_HIERARCHY of RingOscillator : entity is "YES"; -- prevent vivado from flattening this entity

end entity RingOscillator;

architecture RTL of RingOscillator is
    
    signal stage : std_logic_vector(NUM_STAGES downto 0); -- signal carrying all stage outputs

    attribute KEEP : string;
    attribute KEEP of stage : signal is "TRUE"; -- prevents inverters merge/absorb into adjacent logic

begin
    -- -----------------------------------------------------------------------
    -- Stage 0 : Enable gate
    -- -----------------------------------------------------------------------
    stage(0) <= stage(NUM_STAGES) and EN_i;

    -- -----------------------------------------------------------------------
    -- Stages 1 .. NUM_STAGES : inverter chain
    -- -----------------------------------------------------------------------
    gen_inv : for i in 1 to NUM_STAGES generate
        stage(i) <= not stage(i - 1);
    end generate gen_inv;

    -- -----------------------------------------------------------------------
    -- Output tap: take the oscillating signal from the last stage
    -- -----------------------------------------------------------------------
    CLK_o <= stage(NUM_STAGES);

end architecture RTL;
