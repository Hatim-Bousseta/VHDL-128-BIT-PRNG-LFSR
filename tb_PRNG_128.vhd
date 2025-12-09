
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Entité du Testbench : elle n'a pas de ports, car elle pilote tout en interne
entity tb_PRNG_128 is
end tb_PRNG_128;

architecture bench of tb_PRNG_128 is
    
    -- Déclaration des constantes pour le temps
    constant CLK_PERIOD : time := 10 ns; -- Période de 10 ns (100 MHz)
    constant RESET_TIME : time := 100 ns;

    -- Signaux internes du Testbench
    signal s_clk : STD_LOGIC := '0';
    signal s_rst : STD_LOGIC := '1'; -- Commence à '1' pour le reset
    signal s_key_out : STD_LOGIC_VECTOR (127 downto 0);
    
    -- Composant à tester (votre PRNG_128)
    component PRNG_128
        Port ( 
            clk         : in  STD_LOGIC;
            rst         : in  STD_LOGIC;
            key_out     : out STD_LOGIC_VECTOR (127 downto 0) 
        );
    end component;

begin
    
    -- INSTANCIATION : Connecter les signaux du Testbench au module à tester
    UUT : PRNG_128
        port map (
            clk     => s_clk,
            rst     => s_rst,
            key_out => s_key_out
        );

    -- 1. GÉNÉRATEUR D'HORLOGE
    process
    begin
        loop
            s_clk <= '0';
            wait for CLK_PERIOD / 2; -- 5 ns bas
            s_clk <= '1';
            wait for CLK_PERIOD / 2; -- 5 ns haut
        end loop;
    end process;
    
    -- 2. GÉNÉRATEUR DE RESET ET FIN DE SIMULATION
    process
    begin
        -- PHASE 1 : Reset Actif (Amorçage)
        s_rst <= '1';
        wait for RESET_TIME; 

        -- PHASE 2 : Démarrage du LFSR (Fonctionnement normal)
        s_rst <= '0';
        wait for 10 * CLK_PERIOD; -- Laisser le LFSR générer 10 clés
        
        -- PHASE 3 : Fin de la simulation
        report "Simulation terminee." severity failure;
        wait;
    end process;

end architecture;