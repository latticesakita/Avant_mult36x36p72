component addr38 is
    port(
        data_a_re_i: in std_logic_vector(37 downto 0);
        data_b_re_i: in std_logic_vector(37 downto 0);
        result_re_o: out std_logic_vector(37 downto 0);
        cout_re_o: out std_logic
    );
end component;

__: addr38 port map(
    data_a_re_i=>,
    data_b_re_i=>,
    result_re_o=>,
    cout_re_o=>
);
