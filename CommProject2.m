% Omar Thenmalai - Comm Theory Project #2
signal = randi([0 1],[1 10000000]);
threshold = 0;
snr_range = (0:0.25:10);         
error_rate = zeros([1 length(snr_range)]); %error rate vector
for snr = 0:0.25:10
    rect_signal = rectpulse(signal, 8); % Create the rectangular pulses
    rect_signal(rect_signal == 0) = -1; % Replace 0s with -1s
    rect_signal = rect_signal + eps*j; % Add complex component so as not to break awgn function
    signal_with_noise = awgn(rect_signal, snr + 10*log10(1/8));
    matched_signal = intdump(signal_with_noise, 8); % Put signals through matched filter
    threshold_signal = (matched_signal(1,:) >= (threshold));   % Shift values to 1 and 0 based on the threshold
    [num_errors, error_rate(find(snr_range == snr,1))] = biterr(threshold_signal, signal); % Calculate biterr rate for the given SNR
end
figure;
semilogy(snr_range, berawgn(snr_range, 'psk',2, 'nondiff')); % Plot the SNR and theoretical biterr rates
hold on
semilogy(snr_range, error_rate); % Plot the SNR and the measured biterr rates
hold off
legend("Theoretical", "Measured")
xlabel("SNR(db)");
ylabel("Bit Error Rate");