library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pingpong is
	port(clk : in std_logic;sw:in std_logic_vector(7 downto 0);push:in std_logic_vector(3 downto 0);
			led:out std_logic_vector(7 downto 0));
end pingpong;

architecture arch_1d of pingpong is
--functions
function point_function3(A:std_logic_vector(7 downto 0);invert:std_logic) return integer is
		variable result : integer := -4;
		begin
			for i in 0 to 7 loop	
				if A(i)='1' then
					if invert = '0' then
						result:=i-4;
					else
						result:=3-i;
					end if;
				end if;
			end loop;
			return result;
		end;
function score_display(A,B:integer) return std_logic_vector is 
	variable str : std_logic_vector(7 downto 0);
	variable str1 : std_logic_vector(3 downto 0):="0000";
	variable str2 : std_logic_vector(3 downto 0):="0000";
	begin
		if A<10 then
			str1:="0000";
		elsif A<20 then
			str1:="1000";
		elsif A<30  then
			str1:="1100";
		elsif A<40 then
			str1:="1110";
		else
			str1:="1111";
		end if;
		
		if B<10 then
			str2:="0000";
		elsif B<20 then
			str2:="0001";
		elsif B<30  then
			str2:="0011";
		elsif B<40 then
			str2:="0111";
		else
			str2:="1111";
		end if;
		str := str1 & str2;
		return str;
	end;
--state variable
constant IDLE : std_logic_vector(1 downto 0) := "00";
constant TOLEFT :std_logic_vector(1 downto 0) := "01";
constant TORIGHT:std_logic_vector(1 downto 0) := "10";
constant SCORE :std_logic_vector(1 downto 0) := "11";
--signal 
signal STATE:std_logic_vector(1 downto 0) := "00";
signal NEXTSTATE:std_logic_vector(1 downto 0):="00";
signal ledpres:std_logic_vector(7 downto 0);
signal lednext:std_logic_vector(7 downto 0);

begin

hmm : process(clk)

variable score0: integer := 0;
variable score3: integer := 0;
begin
if rising_edge(clk) then --using the 1Hz clock on Xen10
if(sw(4)='0') then
	NEXTSTATE <= IDLE; score0:=0; score3:=0;
	lednext<=(4=>'1',3=>'1',others=>'0'); 
else

case STATE is
		when "00" => --in idle
				if (push(0)='1') then
					lednext <= (4=>'1',others=>'0');
					NEXTSTATE <= TOLEFT;
				elsif (push(3)='1') then
					lednext <= (3=>'1',others=>'0');
					NEXTSTATE <= TORIGHT;
				end if;
		when "01" => --in toleft
				if (push(0)='1') then
					NEXTSTATE <= TORIGHT;
					score0 := score0 + point_function3(ledpres,'1');
					if (score0 >= 40 ) then
						NEXTSTATE <= SCORE;
					end if;
				elsif score0 < 40 then
					if(ledpres="10000000") then
						score0:= score0 - 2;
						NEXTSTATE<=TORIGHT;
					else
						lednext <= std_logic_vector(shift_left(unsigned(ledpres),1));
						NEXTSTATE<=STATE;
					end if;
					
				end if;
		when "10" => --in toright
				if (push(3)='1') then
					NEXTSTATE <= TOLEFT;
					score3 := score3 + point_function3(ledpres,'0');
					if (score3 >= 40 ) then
						NEXTSTATE <= SCORE;
					end if;
				elsif score3 < 40 then
					if(ledpres="00000001") then
						score3:= score3 - 2;
						NEXTSTATE<=TOLEFT;
					else
						lednext <= std_logic_vector(shift_right(unsigned(ledpres),1));
						NEXTSTATE<=STATE;
					end if;
				end if;
		when "11" => --in score
				lednext <= score_display(score0,score3);
				NEXTSTATE<=STATE;
end case;
end if;

STATE<=NEXTSTATE;
ledpres<=lednext;
end if;
end process;
led<=ledpres;


end arch_1d;