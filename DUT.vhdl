-- A DUT entity is used to wrap your design so that we can combine it with testbench.
-- This example shows how you can do this for the OR Gate

library ieee;
use ieee.std_logic_1164.all;

entity DUT is
    port(input_vector: in std_logic_vector(13 downto 0);
       	output_vector: out std_logic_vector(7 downto 0));
end entity;

architecture DutWrap of DUT is
   component  pingpong is
     port(clk:in std_logic;sw:in std_logic_vector(7 downto 0);push:in std_logic_vector(3 downto 0);
			led:out std_logic_vector(7 downto 0));
   end component;
begin

   -- input/output vector element ordering is critical,
   -- and must match the ordering in the trace file!
   add_instance:  pingpong
			port map (
					-- order of inputs B A
					clk =>input_vector(0),
					sw => input_vector(8 downto 1),
					push => input_vector(12 downto 9),
               -- order of output OUTPUT
					led =>output_vector(7 downto 0));
end DutWrap;