library IEEE;
use IEEE.std_logic_1164.all;

entity MUX is
	port(Sel : in std_logic_vector(1 downto 0) ;
			A, B, C, D : in std_logic;
				Y1, Y2, Y3, Y4 : out std_logic);
end MUX;
architecture RTL of MUX is
	signal tmp : std_logic ;
	begin

		Y1 <= A when Sel(0) = '0' else B;
		p0 : process (A, B, Sel)
		begin
			if (Sel(0) = '0') then
				Y2 <= A;
				else
					Y2 <= B;
			end if;
			if (Sel(1) = '1') then
					Y3 <= A;
			end if;
end process;

	p1 : process (A, B, C, D, Sel)
	begin
		case Sel is
			when "00" => Y4 <= A;
			when "01" => Y4 <= B;
			when "10" => Y4 <= C;
			when "11" => Y4 <= D;
			when others => Y4 <= A;
		end case;
end process;
end RTL;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
entity mem is
	port (addr : in std_logic_vector(3 downto 0);
	dout : out std_logic_vector(7 downto 0));
end mem;
architecture a1 of mem is
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
use IEEE.std_logic_unsigned.all;

entity unite_logique is
  port(A,B,sel : in std_logic_vector (3 downto 0);
  UAL_logic : out std_logic_vector(3 downto 0));

end unite_logique;
architecture logique_behavior of unite_logique is
  begin
    logique : process(A,B,sel(1),sel(0))begin
      if(sel(1)='0' and sel(0)='0') then
        UAL_logic <= A and B;
      elsif(sel(1)='0' and sel(0)='1')then
        UAL_logic<= A or B;
      elsif (sel(1)='1' and sel(0)='0') then
        UAL_logic<=A xor B;
      elsif (sel(1)='1' and sel(0)='1') then
        UAL_logic<=not b;
      else
         UAL_logic<=(others => '0');
  	end if;
    end process;
  end logique_behavior;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity unite_arith is
  port(A,B,sel : in std_logic_vector (3 downto 0);
  UAL_arith : out std_logic_vector(3 downto 0));

end unite_arith;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

architecture arith_behavior of unite_arith is
  begin
    arith : process(A,B,sel(1),sel(0))begin
      if(sel(1)='0' and sel(0)='0') then
        UAL_arith <= A+B;
      elsif(sel(1)='0' and sel(0)='1')then
        UAL_arith<= A-B;
      elsif (sel(1)='1' and sel(0)='0') then
        UAL_arith<=A+1;
      elsif (sel(1)='1' and sel(0)='1') then
        UAL_arith<=A-1;
      else
         UAL_arith<=(others => '0');
  	end if;
    end process;
  end arith_behavior;


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity unite_decalage is
  port(A,B,sel : in std_logic_vector (3 downto 0);
  UAL_shift : out std_logic_vector(3 downto 0));

end unite_decalage;


architecture decalage_behavior of unite_decalage is
  signal tmp : std_logic_vector(3 downto 0);

  begin
    decalage : process(A,B,sel(1),sel(0))begin
      if(sel(1)='0' and sel(0)='0') then
        UAL_shift <= shl(A,"1");
      elsif(sel(1)='0' and sel(0)='1')then
        UAL_shift<= shr(A,"1");
      elsif (sel(1)='1' and sel(0)='0') then
			UAL_shift<=	std_logic_vector(rotate_left(unsigned(A),1));
      elsif (sel(1)='1' and sel(0)='1') then
			UAL_shift<=std_logic_vector(rotate_right(unsigned(A),1));
      else
         UAL_shift<=(others => '0');
  	end if;
    end process;
  end decalage_behavior;

 library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;


  entity mux_bis is
    port(UAL_logic,UAL_arith,UAL_shift,sel : in std_logic_vector (3 downto 0);
      y: out std_logic_vector(3 downto 0));

  end mux_bis;

  architecture mux_behavior of mux_bis is
    begin
      mux : process(UAL_logic,UAL_arith,UAL_shift,sel(3),sel(2))begin
        if(sel(3)='0'and sel(2)='0')then
          y<=UAL_arith;
        elsif(sel(3)='0' and sel(2)='1') then
          y<=UAL_logic;
        elsif(sel(3)='1' and sel(2)='0')then
          y<=UAL_shift;
        else
           y<=(others => '0');
    	end if;
      end process;
    end mux_behavior;

	  library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

	entity design is
		port(A,B,Sel : in std_logic_vector(3 downto 0);
			y : out std_logic_vector(3 downto 0));
	end design;

	architecture comporte of design is
	COMPONENT unite_logique
		port(A,B,sel : in std_logic_vector (3 downto 0);
  			UAL_logic : out std_logic_vector(3 downto 0));
	end component;


	component unite_arith
		port(A,B,sel : in std_logic_vector (3 downto 0);
		  UAL_arith : out std_logic_vector(3 downto 0));
	end component;

	 component unite_decalage
		port(A,B,sel : in std_logic_vector (3 downto 0);
		  UAL_shift : out std_logic_vector(3 downto 0));
	end component;

	component mux
			 port(UAL_logic,UAL_arith,UAL_shift,sel : in std_logic_vector (3 downto 0);
      y: out std_logic_vector(3 downto 0));
	end component;

	signal UAL_logic_sig, UAL_arith_sig,UAL_shift_sig : std_logic_vector(3 downto 0);
	begin
		logique_unit : unite_logique port map(A,B,sel,UAL_logic_sig);
		logique_arith : unite_arith port map(A,B,sel,UAL_arith_sig);
		logique_decalage : unite_decalage port map(A,B,sel,UAL_shift_sig);
		multiplexeur : mux port map(UAL_logic_sig,UAL_arith_sig,UAL_shift_sig,sel,y);

end comporte;


library IEEE;
use IEEE.std_logic_1164.all;
use work.tp6_pkg.all;

entity tp6 is
    port(
        Clock : in std_logic;
        H50M : in std_logic;
        Reset : in std_logic;
        an : out std_logic_vector(3 downto 0);
        seg : out std_logic_vector(7 downto 0));
end tp6;

architecture comporte of tp6 is
    signal C0, C1, C2, C3 : std_logic_vector(3 downto 0);
    signal chiffre : std_logic_vector(3 downto 0);
    signal ceo0, ceo1, ceo2 : std_logic;
begin

	compteur_1 : compteur generic map(4,10) port map(Clock,'1',Reset,ceo0,C0);
	compteur_2 : compteur generic map(4,10) port map(Clock,ceo0,Reset,ceo1,C1);
	compteur_3 : compteur generic map(4,10) port map(Clock,ceo1,Reset,ceo2,C2);
	compteur_4 : compteur generic map(4,10) port map(Clock,ceo2,Reset,open,C3);
	 memoire : b7s port map(chiffre,seg);
	multiplexeur : mux4v1 port map(H50M,Reset,C0,C1,C2,C3,chiffre,an);


end comporte ;
