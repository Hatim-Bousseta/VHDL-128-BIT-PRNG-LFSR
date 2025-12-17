library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

)
entity PRNG_128 is
    Port ( 
        clk         : in  STD_LOGIC;  
        rst         : in  STD_LOGIC;  
        key_out     : out STD_LOGIC_VECTOR (127 downto 0) -- La clé AES de 128 bits générée
    );
end PRNG_128;


architecture Behavioral of PRNG_128 is
    
    -- Le registre interne qui stocke l'état actuel de la clé
    signal r_lfsr : std_logic_vector(127 downto 0);
    
    -- La graine (seed) par défaut 
    constant DEFAULT_SEED : std_logic_vector(127 downto 0) := x"00112233445566778899aabbccddeeff";

begin

    -- Le registre r_lfsr est connecté en permanence à la sortie
    key_out <= r_lfsr;

    -- Le processus séquentiel (la logique du LFSR)
    process(clk, rst)
        -- Variable locale pour stocker le bit de rétroaction calculé
        variable v_feedback : std_logic;
    begin
        
        -- 1. Phase de Réinitialisation (Amorçage statique)
        if rst = '1' then
            r_lfsr <= DEFAULT_SEED;
            
        -- 2. Phase de Génération (À chaque front montant de l'horloge)
        elsif rising_edge(clk) then
            
            -- A. Calcul de la Rétroaction (Taps : 127, 125, 100, 98)
            -- C'est l'implémentation de l'équation : f = a127 + a125 + a100 + a98
            v_feedback := r_lfsr(127) XOR r_lfsr(125) XOR r_lfsr(100) XOR r_lfsr(98);
            
            -- B. Décalage et Insertion du Feedback (Configuration Fibonacci)
            r_lfsr <= r_lfsr(126 downto 0) & v_feedback;
            
        end if;
    end process;

end Behavioral;

