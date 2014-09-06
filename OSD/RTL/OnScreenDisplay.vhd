library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

-- OnScreenDisplay module, generates a character-based display synced with external
-- H and V sync signals.  (Essentially a simple genlock.)
-- Provides a Window and Pixel output, allowing the host to dim the display around
-- the OSD if need be.
-- Registers provided for the following:
--   0 W XPOS
--   1 W YPOS
--   2 W Pixel clock (firmware will guess this from the framing.)
--   3 R hframe - counting how many clocks HSync remains high
--   4 R vframe - ditto, but low.
--   5 W enable - bit 0: OSD enable, bit 1: HSync polarity, bit 2: VSync polarity

-- Also provided, a 512 byte character buffer with its own req signal.


entity OnScreenDisplay is
port(
	reset_n : in std_logic;
	clk : in std_logic;
	-- Video
	hsync_n : in std_logic;
	vsync_n : in std_logic;
	pixel : out std_logic;
	window : out std_logic;
	-- Registers
	addr : in std_logic_vector(8 downto 0);
	data_in : in std_logic_vector(15 downto 0);
	data_out : out std_logic_vector(15 downto 0);
	r_w : in std_logic;
	reg_req : in std_logic;
	reg_ack : out std_logic;
	char_req : in std_logic
);
end entity;

architecture rtl of OnScreenDisplay is

-- Counted in terms of master clocks.
signal hframe : std_logic_vector(15 downto 0);
signal vframe : std_logic_vector(15 downto 0);
signal hcounter : unsigned(15 downto 0);
signal vcounter: unsigned(15 downto 0);

signal hsync_pol : std_logic; -- Polarity
signal vsync_pol : std_logic; -- Polarity
signal hsync_p : std_logic; -- Previous state
signal vsync_p : std_logic; -- Previous state
signal newline : std_logic;
signal newframe : std_logic;

-- Pixel clock generation

signal pixelclock : unsigned(3 downto 0);
signal pixelcounter : unsigned(3 downto 0);
signal pix : std_logic; -- Triggered momentarily at a pixel boundary

-- Pixel-clock-based signals
signal xpixelpos : unsigned(15 downto 0);
signal ypixelpos : unsigned(15 downto 0);
signal hwindowactive : std_logic;
signal vwindowactive : std_logic;
signal hactive : std_logic;
signal vactive : std_logic;

-- Registers 
signal xpos : unsigned(15 downto 0);
signal ypos : unsigned(15 downto 0);
signal charram_wr : std_logic;
signal osd_enable : std_logic;

signal char : std_logic_vector(7 downto 0);
signal charpixels : std_logic_vector(7 downto 0);

begin

-- Monitor hsync and count the pulse widths

process(clk,hsync_n)
begin
	if rising_edge(clk) then
		hsync_p<=hsync_n;
		if pix='1' then
			hcounter<=hcounter+1;
		end if;

		newline<='0';
		if hsync_n='1' then
			if hsync_p='0' then -- rising edge?
				hframe(15 downto 8)<=std_logic_vector(hcounter(11 downto 4));
				hcounter<=(others => '0'); -- Reset counter
				newline<=hsync_pol; -- New line starts here if polarity is reversed
			end if;
		else
			if hsync_p='1' then -- falling edge?
				hframe(7 downto 0)<=std_logic_vector(hcounter(11 downto 4));
				hcounter<=(others => '0'); -- Reset counter
				newline<=not hsync_pol; -- New line starts here if polarity is not reversed 
			end if;		
		end if;
	end if;
end process;


-- Monitor newline and count the vsync pulses

process(clk,hsync_n)
begin
	if rising_edge(clk) then
		if newline='1' then
			vsync_p<=vsync_n;
			vcounter<=vcounter+1;
			newframe<='0';
			if vsync_n='1' then
				if vsync_p='0' then -- rising edge?
					vframe(15 downto 8)<=std_logic_vector(vcounter(10 downto 3));
					vcounter<=(others => '0'); -- Reset counter
					newframe=vsync_pol;
				end if;
			else
				if vsync_p='1' then -- falling edge?
					vframe(7 downto 0)<=std_logic_vector(vcounter(10 downto 3));
					vcounter<=(others => '0'); -- Reset counter
					newframe=not vsync_pol;
				end if;		
			end if;
		end if;
	end if;
end process;


-- Increment pixel counter and generate pixel pulse.

process(clk)
begin
	if rising_edge(clk) then
		if pixelcounter=pixelclock then
			pixelcounter<="0000";
			pix<='1';
		else
			pixelcounter<=pixelcounter+1;
			pix<='0';
		end if;
	end if;
end process;


process(clk,reg_req,addr,data_in,hframe,vframe)
begin

	if rising_edge(clk) then
		reg_ack<='0';
		
		if reg_req='1' then
			reg_ack<='1';
			if r_w='0' then -- write
				case addr(3 downto 0) is
					when X"0" =>
						xpos<=unsigned(data_in);
					when X"1" =>
						ypos<=unsigned(data_in);
					when X"2" =>
						pixelclock<=unsigned(data_in(3 downto 0));
					when X"5" =>
						osd_enable<=data_in(0);
						hsync_pol<=data_in(1);
						vsync_pol<=data_in(2);
					when others =>
						null;
				end case;
			else	-- Read
				case addr(3 downto 0) is
					when X"3" =>
						data_out<=hframe;
					when X"4" =>
						data_out<=vframe;
					when others =>
						null;
				end case;
			end if;
		end if;
	end if;
end process;



-- Generate window signal

process(clk)
begin

	window<=hwindowactive and vwindowactive;
	pixel<=hactive and vactive;

	-- Enable vactive for ypixel positions between 0 and 127, inclusive.
	vactive<='1' when ypixelpos(15)='0' and ypixelpos(11 downto 7)=(others=>'0') else '0';
	-- Enable hactive for xpixel positions between 0 and 255, inclusive.
	hactive<='1' when ypixelpos(15)='0' and ypixelpos(11 downto 8)=(others=>'0') else '0';

	if rising_edge(clk) then

		if pix='1' then
			if xpixelpos(11 downto 0)=X"FFC" then -- 4 pixel border
				hwindowactive<='1';
			end if;
			if xpixelpos(11 downto 0)=X"104" then -- 4 pixel border
				hwindowactive<='0';
			end if;
			xpixelpos<=xpixelpos+1;
		end if;
	
		if newline='1' then	-- Reset horizontal counter
			if ypixelpos(11 downto 0)=X"FFC" then -- 4 pixel border
				vwindowactive<='1';
			end if;
			if ypixelpos(11 downto 0)=X"084" then -- 4 pixel border
				vwindowactive<='0';
			end if;
			
			xpixelpos<=xpos;
			ypixelpos<=ypixelpos+1;
		end if;

		if newframe<='1' then	-- Reset vertical counter
			ypixelpos<=ypos;
		end if;

	end if;
end process;



-- Character RAM

charram_wr <= '1' when char_req='1' and r_w='0';

charram : entity Work.DualPortRAM_Unreg
	generic map
		(
			AddrBits => 9,
			DataWidth => 8
		)
	port map (
		clock => clk,
		data => data_in(7 downto 0),
		rdaddress => (others => '0'),
		wraddress => addr(8 downto 0),
		wren => charram_wr,
		q => char
	);

charrom: entity Work.CharROM_ROM
	generic map
	(
		addrbits => 10
	)
	port map (
	clock => clk,
	address => char(6 downto 0)&std_logic_vector(ypixelpos(2 downto 0)),
	q => charpixels
);


end architecture;