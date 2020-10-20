function BERR_RATE = BCH_BERR(n,k,s)
    BERR = [];
    msg = gf(randi([0 1], s, k));
    code = bchenc(msg, n, k);
    data = msg.x;
    data_size = numel(data);
    for p = 0:0.01:0.5
        ndata = bsc(code, p);
        output = bchdec(ndata, n, k);
        bit_error = biterr(data, output.x);
        bit_error_rate = bit_error/data_size;
        BERR = [BERR bit_error_rate];
    end
    BERR_RATE = BERR;
end