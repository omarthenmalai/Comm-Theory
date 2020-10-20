%% Comm Theory Matlab Project #1
% Omar Thenmalai
tic
BCH7to4 = BCH_BERR(7,4,2500);
toc
tic
BCH15to7 = BCH_BERR(15,7,1500);
toc
trellis1to2 = poly2trellis(5, [37 33], 37); % WTF does this do?
BERR = []
tic
for p = 0:0.01:0.5
    msg = randi([0 1], 1000000, 1);
    code = convenc(msg, trellis1to2);
    ndata = bsc(code, p);
    output = vitdec(ndata, trellis1to2, 25, 'trunc', 'hard');
    bit_error = biterr(msg, output);
    bit_error_rate = bit_error/numel(msg);
    BERR = [BERR bit_error_rate];
end
CONV1to2 = BERR;
toc

trellis2to3 = poly2trellis([5 4],[23 35 0; 0 5 13]);
BERR = [];
tic
for p = 0:0.01:0.5
    msg = randi([0 1], 1000000, 1);
    code = convenc(msg, trellis2to3);
    ndata = bsc(code, p);
    output = vitdec(ndata, trellis2to3, 25, 'trunc', 'hard');
    bit_error = biterr(msg, output);
    bit_error_rate = bit_error/numel(msg);
    BERR = [BERR bit_error_rate];
end
toc
CONV2to3 = BERR;

p = 0:0.01:0.5;
figure;
hold on
plot(p, BCH7to4)
plot(p, BCH15to7)
plot(p, CONV1to2)
plot(p, CONV2to3)
legend('Rate 7-4 BCH Code', 'Rate 15-7 BCH Code', 'Rate 1/2 Convolutional Code', 'Rate 2/3 Convolutional Code');
hold off