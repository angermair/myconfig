library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity axi_dma_testgen is
	port (
		s_axi_aclk	    : in std_logic;
		s_axi_aresetn	: in std_logic;
		
		-- AXI Lite Slave - Configuration Port
		s_axi_awaddr	: in std_logic_vector(31 downto 0);
		s_axi_awprot	: in std_logic_vector(2 downto 0);
		s_axi_awvalid	: in std_logic;
		s_axi_awready	: out std_logic;
		
		s_axi_wdata 	: in std_logic_vector(31 downto 0);
        s_axi_wstrbe    : in std_logic_vector(3 downto 0);
		s_axi_wvalid	: in std_logic;
		s_axi_wready	: out std_logic;
		
		s_axi_bresp	    : out std_logic_vector(1 downto 0);
		s_axi_bvalid	: out std_logic;
		s_axi_bready	: in std_logic;
		
		s_axi_araddr	: in std_logic_vector(31 downto 0);
		s_axi_arprot	: in std_logic_vector(2 downto 0);
		s_axi_arvalid	: in std_logic;
		s_axi_arready	: out std_logic;
		
		s_axi_rdata	    : out std_logic_vector(31 downto 0);
		s_axi_rresp	    : out std_logic_vector(1 downto 0);
		s_axi_rvalid	: out std_logic;
		s_axi_rready	: n std_logic;
		
		-- AXI Master - DMA Port 
		 m_axi_aclk	    : in std_logic;
         m_axi_aresetn  : in std_logic;
         
         m_axi_awid     : out std_logic_vector(5 downto 0);
         m_axi_awaddr   : out std_logic_vector(31 downto 0);
         m_axi_awlen    : out std_logic_vector(7 downto 0);
         m_axi_awsize   : out std_logic_vector(2 downto 0);
         m_axi_awburst  : out std_logic_vector(1 downto 0);
         m_axi_awcache  : out std_logic_vector(3 downto 0);
         m_axi_awprot   : out std_logic_vector(2 downto 0);
         m_axi_awvalid  : out std_logic;
         m_axi_awready  : in std_logic;
         
         m_axi_wid      : out std_logic_vector(5 downto 0);
         m_axi_wdata    : out std_logic_vector(63 downto 0);
         m_axi_wstrb    : out std_logic_vector(7 downto 0);
         m_axi_wlast    : out std_logic;
         m_axi_wvalid   : out std_logic;
         m_axi_wready   : in std_logic;
         
         m_axi_bvalid   : in std_logic;
         m_axi_bready   : out std_logic;
         m_axi_bresp    : in std_logic_vector(1 downto 0);
		
		 led             : out std_logic_vector(7 downto 0);

         -- INterrupt output
         irq_testgen            : out std_logic
	);
end axi_dma_testgen;

architecture Behavioral of axi_dma_testgen is

    -- register 
    signal cfg_reg          : std_logic_vector(7 downto 0);
    signal cfg_next         : std_logic_vector(7 downto 0);
    signal start_adr_reg    : std_logic_vector(31 downto 0);
    signal start_adr_next   : std_logic_vector(31 downto 0);
    
    -- axi lite slave interface
    signal s_wvalid         : std_logic;
    signal s_bvalid_reg     : std_logic;
    signal s_bvalid_next    : std_logic;
    
    signal s_axi_arready_reg  : std_logic;
    signal s_axi_arready_next : std_logic;
    signal s_axi_rvalid_reg   : std_logic;
    signal s_axi_rvalid_next  : std_logic;
    signal araddr_reg         : std_logic_vector(31 downto 0);

    -- axi master interface
    signal m_rvalid         : std_logic;
    signal m_wlast          : std_logic;
    signal m_awvalid_reg    : std_logic;
    signal m_awvalid_next   : std_logic;
    signal m_wvalid_reg     : std_logic;
    signal m_wvalid_next    : std_logic;
    signal m_adr_reg        : std_logic_vector(7 downto 0);
    signal m_adr_next       : std_logic_vector(7 downto 0);
    signal m_wid_reg        : std_logic_vector(5 downto 0);
    signal m_wid_next       : std_logic_vector(5 downto 0);
    
    -- debug signals
    signal bresp_dbg        : std_logic_vector(1 downto 0);
  
begin

----------------------------------------------------------------------
-- AXI LITE SLAVE INTERFACE 
----------------------------------------------------------------------

    -- configuration register
    process(s_axi_aclk, s_axi_aresetn) 
    begin
       if s_axi_aresetn = '0' then
           cfg_reg <= "00001000"; 
           start_adr_reg <= (others => '0');
       elsif rising_edge( s_axi_aclk ) then
           cfg_reg <= cfg_next;
           start_adr_reg <= start_adr_next;
       end if;
    end process;
    
    process( s_wvalid, s_axi_awaddr, s_axi_wdata, cfg_reg, start_adr_reg, m_wlast )
    begin 
        cfg_next <= cfg_reg; 
        start_adr_next <= start_adr_reg;
        
        if s_wvalid = '1' then
            case s_axi_awaddr is
                when  x"40000000" => cfg_next <= s_axi_wdata(7 downto 0);
                when  x"40000004" => start_adr_next <= s_axi_wdata(31 downto 0);
                when others => null;
            end case;
        end if;   
        
        if m_wlast = '1' then
          cfg_next <= cfg_reg(7 downto 2) & '1' & '0';
        end if;

    end process;
    
    irq_testgen <= cfg_reg(1); 
    -- WRITE -------------------------------------------------------------
    -- wvalid
    s_wvalid <= s_axi_awvalid and s_axi_wvalid;

    -- wready 
    s_axi_wready  <= s_wvalid;

    -- bvalid
    process( s_axi_aclk, s_axi_aresetn )
    begin
        if s_axi_aresetn = '0' then
           s_bvalid_reg <= '0'; 
        elsif rising_edge( s_axi_aclk ) then
           s_bvalid_reg <= s_bvalid_next;
        end if;
    end process;
    s_axi_bvalid  <= s_bvalid_reg;

    process( s_wvalid, s_bvalid_reg, s_axi_bready)
    begin
        s_bvalid_next <= s_bvalid_reg;
        if s_wvalid = '1' then                                -- set bvalid
            s_bvalid_next <= '1';
        end if;
        if s_bvalid_reg = '1' and s_axi_bready = '1' then     -- clear bvalid
            s_bvalid_next <= '0';
        end if;
    end process;
 
    -- READ -------------------------------------------------------------
    -- arready 
    process( s_axi_aclk, s_axi_aresetn )
    begin
        if s_axi_aresetn = '0' then
            s_axi_arready_reg <= '0';
        elsif rising_edge( s_axi_aclk ) then
            s_axi_arready_reg <= s_axi_arready_next;
        end if;
    end process;

    process( s_axi_arready_reg, s_axi_arvalid )
    begin
        s_axi_arready_next <= s_axi_arready_reg;
        if s_axi_arready_reg = '0' and s_axi_arvalid = '1'  then  -- set arvalid
            s_axi_arready_next <= '1';
        end if;

        if s_axi_arready_reg = '1' and s_axi_arvalid = '1' then  -- clear arvalid
            s_axi_arready_next <= '0';
        end if;
    end process;
    s_axi_arready <= s_axi_arready_reg;

    -- rvalid
    process( s_axi_aclk, s_axi_aresetn )
    begin
        if s_axi_aresetn = '0' then
            s_axi_rvalid_reg <= '0';
        elsif rising_edge( s_axi_aclk ) then
            s_axi_rvalid_reg <= s_axi_rvalid_next;
        end if;
    end process;
    s_axi_rvalid  <= s_axi_rvalid_reg;

    process( s_axi_arready_reg, s_axi_arvalid, s_axi_rready )
    begin
        s_axi_rvalid_next <= s_axi_rvalid_reg;
        if s_axi_arready_reg = '1' and s_axi_arvalid = '1' then -- set rvalid
           s_axi_rvalid_next <= '1'; 
        end if;

        if s_axi_rvalid_reg = '1' and s_axi_rready = '1' then                              -- clear rvalid
           s_axi_rvalid_next <= '0'; 
        end if;
    end process;

    -- rdata
    process( s_axi_aclk )
    begin
        if rising_edge( s_axi_aclk ) then
            if s_axi_arready_reg = '1' and s_axi_arvalid = '1' then
                araddr_reg  <= s_axi_araddr;
            end if;
        end if;
    end process; 

    process( araddr_reg, cfg_reg, start_adr_reg ) 
    begin
        s_axi_rdata <= (others => '0');
        case araddr_reg is
            when  x"40000000" => s_axi_rdata <= x"000000" & cfg_reg;
            when  x"40000004" => s_axi_rdata <= start_adr_reg;
            when others => null;
        end case;
    end process;

    -- axi signal assigment
    s_axi_bresp <= "00";
    s_axi_rresp <= "00";
    
    s_axi_awready <= s_wvalid;
    
----------------------------------------------------------------------
-- AXI MASTER INTERFACE 
----------------------------------------------------------------------
    
    process(m_axi_aclk, m_axi_aresetn)
    begin
        if m_axi_aresetn = '0' then
            m_awvalid_reg <= '0';
            m_wvalid_reg <= '0';
            m_adr_reg <= (others => '0');
            m_wid_reg  <= (others => '0');
        elsif rising_edge(m_axi_aclk) then
            m_awvalid_reg <= m_awvalid_next;
            m_wvalid_reg <= m_wvalid_next;
            m_adr_reg <= m_adr_next;
            m_wid_reg <= m_wid_next;
        end if;
    end process;
    
    
    m_rvalid <= m_axi_wready and m_wvalid_reg;
    m_wlast  <= '1' when m_adr_reg = x"F0" else '0';
    
    process( cfg_reg, m_awvalid_reg, m_wvalid_reg, m_adr_reg, m_wid_reg, m_axi_awready, m_rvalid, m_axi_wready, m_wlast)
    begin
        m_awvalid_next <= m_awvalid_reg;
        m_wvalid_next <= m_wvalid_reg;
        m_adr_next <= m_adr_reg;
        m_wid_next <= m_wid_reg;
        
        if cfg_reg(0) = '1' and m_awvalid_reg = '0' and m_wvalid_reg = '0' then 
            m_awvalid_next <= '1';
            m_wvalid_next <= '1';
        end if;
        
        if m_axi_awready = '1' and m_awvalid_reg = '1' then
            m_awvalid_next <= '0';
        end if;
        
        if m_rvalid = '1' then
            m_adr_next <= std_logic_vector(unsigned(m_adr_reg) + 1);
        end if;

        if m_axi_wready = '1' and m_wlast = '1' then
           -- m_wid_next <= std_logic_vector(unsigned(m_wid_reg) + 1);
            m_adr_next <= (others => '0');
            m_wvalid_next <= '0';
        end if;
    end process;
    
    m_axi_awid      <= m_wid_reg;
    m_axi_awaddr    <= std_logic_vector(resize(unsigned(start_adr_reg) + unsigned(m_adr_reg), m_axi_awaddr'length));
    m_axi_awlen     <= x"F0";       --std_logic_vector(to_unsigned(10, m_axi_awlen'length));
    m_axi_awsize    <= "011";       --std_logic_vector(to_unsigned(4, m_axi_awsize'length));
    m_axi_awburst   <= "01";
    m_axi_awprot    <= "000";
    m_axi_awcache   <= "0000";
    m_axi_awvalid   <= m_awvalid_reg;
    m_axi_wid       <= m_wid_reg;
    --m_axi_wdata     <= x"A0A0A0A0" when m_wvalid_reg = '1' else x"00000000";  --std_logic_vector(resize(unsigned(m_adr_reg), m_axi_wdata'length));           -- dummy data
    --m_axi_wdata     <= std_logic_vector(resize(unsigned(m_adr_reg), m_axi_wdata'length));           -- dummy data
    m_axi_wdata     <= x"A0A0A0A0A0A0A0" & m_adr_reg; 
    m_axi_wstrb     <= "11111111";
    m_axi_wlast     <= m_wlast;
    m_axi_wvalid    <= m_wvalid_reg;
    m_axi_bready    <= '1';
   
----------------------------------------------------------------------
-- DEBUG SIGNALS
----------------------------------------------------------------------
    bresp_dbg <= m_axi_bresp;
    led <= cfg_reg;
     
end Behavioral;
