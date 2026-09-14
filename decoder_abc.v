//decoder_abc.v
//Decodificador para escolher qual dos valores (a, b ou c) devem carregar nos registradores

module decoder_abc (
    input key_pulse,
    input [1:0] count,
    output sel_a, sel_b, sel_c
);
    wire countN0, countN1;

    not (countN0, count[0]);
    not (countN1, count[1]);

    // sel_a = key_pulse & ~count[1] & ~count[0]   (count = 00)
    and (sel_a, key_pulse, countN1, countN0);

    // sel_b = key_pulse & ~count[1] & count[0]    (count = 01)
    and (sel_b, key_pulse, countN1, count[0]);

    // sel_c = key_pulse & count[1] & ~count[0]    (count = 10)
    and (sel_c, key_pulse, count[1], countN0);

    // count = 11 → nenhuma saída ativa (travado), implícito
endmodule
	