library IEEE;
use IEEE.std_logic_1164.all;

package tp6_pkg is

	COMPONENT compteur
	    generic (WDTH : integer :=4; STOP : integer :=10);
	    port( CLK : in std_logic ;
	           CE : in std_logic ;
	        CLEAR : in std_logic;
		      CEO : out std_logic;
			 DOUT : out std_logic_vector(WDTH -1 downto 0));
	END COMPONENT;

	COMPONENT b7s 
	   	port (addr : in std_logic_vector(3 downto 0);
	          dout : out std_logic_vector(7 downto 0));
	END COMPONENT;

	COMPONENT mux4v1 
	    port( H50M : in std_logic ;
	         CLEAR : in std_logic;
		         C0 : in std_logic_vector(3 downto 0);
		         C1 : in std_logic_vector(3 downto 0);
		         C2 : in std_logic_vector(3 downto 0);
		         C3 : in std_logic_vector(3 downto 0);
			 chiffre : out std_logic_vector(3 downto 0);
			      an : out std_logic_vector(3 downto 0));
	END COMPONENT;

end tp6_pkg;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity compteur is
	    generic (WDTH : integer :=4; STOP : integer :=10);
	    port( CLK : in std_logic ;
	           CE : in std_logic ;
	        CLEAR : in std_logic;
		      CEO : out std_logic;
			 DOUT : out std_logic_vector(WDTH -1 downto 0));
end compteur;

architecture a1 of compteur is
	signal INT_DOUT : std_logic_vector(DOUT'range) ; 
begin
	process(CLK, CLEAR) begin
        if (CLEAR='1') then
			INT_DOUT <= (others => '0');
		elsif (CLK'event and CLK='1') then
			if (CE='1') then
			    if (INT_DOUT=STOP-1) then
				    INT_DOUT <= (others => '0');
				else			
				    INT_DOUT <= (INT_DOUT + 1);
		        end if;
		    end if; 
        end if;
	end process;
	CEO <= INT_DOUT(0) and not INT_DOUT(1) and not INT_DOUT(2) and INT_DOUT(3) and CE;
	dout <= int_dout;
end;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity b7s is
   	port (addr : in std_logic_vector(3 downto 0);
          dout : out std_logic_vector(7 downto 0));
end b7s;

architecture a1 of b7s is
	TYPE mem_data IS ARRAY (0 TO 15) OF std_logic_vector(7 DOWNTO 0);
	constant data : mem_data := (
		("01000000"),	
		("01111001"),	
		("00100100"),	
		("00110000"),
		("00011001"),	
		("00010010"),	
		("00000010"),	
		("01111000"),
		("00000000"),	
		("00010000"),
		("00000000"),	
		("00000000"),	
		("00000000"),	
		("00000000"),	
		("00000000"),	
		("00000000"));	
begin
 	    dout <= data(CONV_INTEGER(addr));
end;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity mux4v1 is
	port( H50M : in std_logic ;
	     CLEAR : in std_logic;
		     C0 : in std_logic_vector(3 downto 0);
		     C1 : in std_logic_vector(3 downto 0);
		     C2 : in std_logic_vector(3 downto 0);
		     C3 : in std_logic_vector(3 downto 0);
		chiffre : out std_logic_vector(3 downto 0);
			  an : out std_logic_vector(3 downto 0));
end mux4v1;

architecture a1 of mux4v1 is
	signal compte : std_logic_vector(15 downto 0) ; 
	signal an_int : std_logic_vector(3 downto 0) ; 
begin

	process(H50M, CLEAR) begin
		if (CLEAR='1') then
			compte <= (others => '0');
			an_int <= "1110";
		elsif (H50M'event and H50M='1') then
			if (compte = 49999) then
				compte <= (others => '0');
				an_int(3) <= an_int(2);
				an_int(2) <= an_int(1);
				an_int(1) <= an_int(0);
				an_int(0) <= an_int(3);
			else			
				compte <= compte + 1;
			end if;
		end if;
	end process;

	process(an_int, C3, C2, C1, C0) begin
		if (an_int(3) = '0') then -- chiffres de gauche à droite
			chiffre <= C3;
		elsif	(an_int(2) = '0')	then
			chiffre <= C2;
		elsif	(an_int(1) = '0')	then
			chiffre <= C1;
		else
			chiffre <= C0;
		end if;
	end process;

	an <= an_int;
end;
