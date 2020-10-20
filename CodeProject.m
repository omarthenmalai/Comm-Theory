%% Comm Theory Matlab Project #1
% Omar Thenmalai

% Initialize messages
msg4to7 = gf(randi([0 1], 50000, 4));
data4to7 = msg4to7.x;
msg7to15 = gf(randi([0 1], 50000, 7)); 
data7to15 = msg7to15.x;
msg1to2 = randi([0 1], 1000000, 1);
msg2to3 = randi([0 1], 1000000, 1);
msgBase = randi([0 1], 1000000, 1);
trellis1to2 = poly2trellis(5, [37 33], 37);
trellis2to3 = poly2trellis([5 4],[23 35 0; 0 5 13]);

% Encode the various messages using their respective codes
code4to7 = bchenc(msg4to7, 7, 4);
code7to15 = bchenc(msg7to15, 15, 7);
code1to2 = convenc(msg1to2, trellis1to2);
code2to3 = convenc(msg2to3, trellis2to3);

%Initialize variables to be used in the loop
ndata=0; % Data after passing through BSC
bit_error=0; % Total number of bit errors
bit_error_rate=0; % bit error rate
output=0; % Decoded data

N = 100; % Parameter to determine step of probability values in loop
p = 0:0.01:0.5; % Vector of probabilities

% Initialize vectors to hold bit error rates for each code
BERR4to7 = zeros(1,51);
BERR7to15 = zeros(1,51);
BERR1to2 = zeros(1,51);
BERR2to3 = zeros(1,51);
BERRBASE = zeros(1,51);
parfor i = 1:51    
    % Get bit error rate for the base case at probability p
    ndata = bsc(msgBase, p(i));
    bit_error = biterr(msgBase, ndata); % Get the number of bit errors
    bit_error_rate = bit_error/numel(msgBase); % Bit error rate for the base case (no coding or decoding)
    BERRBASE(i) = bit_error_rate;
    
    % Get bit error rate for the (7,4) block code at probability p
    ndata = bsc(code4to7, p(i));
    output = bchdec(ndata, 7, 4);
    bit_error = biterr(data4to7, output.x);
    bit_error_rate = bit_error/numel(data4to7);
    BERR4to7(i) = bit_error_rate;
    
    % Get bit error rate for the (15,7) block code at probability p
    ndata = bsc(code7to15, p(i));
    output = bchdec(ndata, 15, 7);
    bit_error = biterr(data7to15, output.x);
    bit_error_rate = bit_error/numel(data7to15);
    BERR7to15(i) = bit_error_rate;
    
    % Get bit error rate for the rate 1/2 conv code at probability p
    ndata = bsc(code1to2, p(i));
    output = vitdec(ndata, trellis1to2, 25, 'trunc', 'hard');
    bit_error = biterr(msg1to2, output);
    bit_error_rate = bit_error/numel(msg1to2);
    BERR1to2(i) = bit_error_rate;
    
    % Get bit error rate for the rate 1/2 conv code at probability p
    ndata = bsc(code2to3, p(i));
    output = vitdec(ndata, trellis2to3, 25, 'trunc', 'hard');
    bit_error = biterr(msg2to3, output);
    bit_error_rate = bit_error/numel(msg2to3);
    BERR2to3(i) = bit_error_rate;
end

figure; 
hold on
plot(p, BERRBASE)
plot(p, BERR4to7)
plot(p, BERR7to15)
plot(p, BERR1to2)
plot(p, BERR2to3)
xlabel('Error Probability of BSC');
ylabel('Bit Error Rate');
legend('No Code (Baseline)','Rate 7-4 BCH Code', 'Rate 15-7 BCH Code', 'Rate 1/2 Convolutional Code', 'Rate 2/3 Convolutional Code');
legend('Location', 'southeast')
hold off