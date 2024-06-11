library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;  

entity bidir_shift is
    port (clk, clr: in std_logic;
        S, M: in std_logic_vector(1 downto 0);
        I: in unsigned(3 downto 0);
	    Q: inout unsigned(3 downto 0));    
end bidir_shift;


architecture behavioral of bidir_shift is
-- state machine approach
  type state_type is (clear, s0, s1, s2, s3);
 
  signal present_state, next_state: state_type := clear; --initial state idle
  --signal load: unsigned(3 downto 0); 
begin

comb_process: process(present_state, I, S, M )
    variable load : unsigned(3 downto 0); 
	begin
	  case present_state is
	    when clear =>
	        --load := "0000";
	        Q <= "0000"; 
	        
	        next_state <= s0;
	        
	    when s0 =>
	       --Q <= load;
	       -- hold
	       
	       if (M = "00" ) then   
	           next_state <= s0;

	       elsif (M = "01" ) then 
	           next_state <= s1;

	       elsif (M = "10" ) then 
	           next_state <= s2;

	       elsif (M = "11") then
	           next_state <= s3;
	       else 
	           next_state <= clear;
	       end if;
		

	    when s1 =>
	       -- shift right
	       if(S(0) = '1') then
	           Q(3) <= Q(2);
	           Q(2) <= Q(1);
	           Q(1) <= Q(0);
	           Q(0) <= '1';
	       else
	           load := shift_right(load, 1);
	       end if;
	          Q <= load;
		   if (M = "00" ) then   
	           next_state <= s0;

	       elsif (M = "01" ) then 
	           next_state <= s1;

	       elsif (M = "10" ) then 
	           next_state <= s2;

	       elsif (M = "11") then
	           next_state <= s3;
	       else 
	           next_state <= clear;
	       end if;
                                
       when s2 =>
            -- shift left
            
            if(S(1) = '1') then
	           load := shift_left(load, 1) + 8;
	       else
	           load := shift_left(load, 1);
	       end if;
                Q <= load;
           if (M = "00" ) then   
	           next_state <= s0;

	       elsif (M = "01" ) then 
	           next_state <= s1;

	       elsif (M = "10" ) then 
	           next_state <= s2;

	       elsif (M = "11") then
	           next_state <= s3;
	       else 
	           next_state <= clear;
	       end if;

       when s3 =>
            --parallel load
            load := I;
            Q <= load;
           if (M = "00" ) then   
	           next_state <= s0;

	       elsif (M = "01" ) then 
	           next_state <= s1;

	       elsif (M = "10" ) then 
	           next_state <= s2;

	       elsif (M = "11") then
	           next_state <= s3;
	       else 
	           next_state <= clear;
	       end if;
	       when others => next_state <= clear; -- no hang states
	end case;
end process comb_process;

clk_process: process(clk, clr, present_state, next_state)
	begin
	if(clr = '1') then
	   present_state <= clear;
	elsif rising_edge(clk) then --wait until the rising edge
	       present_state <= next_state; 
    end if;
end process clk_process;

end behavioral;

