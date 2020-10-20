%% Omar Thenmalai - Comm Theory Project #3
%% Using Algorithm from the textbook
msg_length = 100000;
msg = randi([0 1], [1 msg_length]);
msg(msg == 0) = -1;
chan = [1 .2 .4];   %channel
filtered_msg = filter(chan, 1, msg)'; % Transpose so its (N+1),1 like in the textbook
tap_num = [3 5 7];  % Given equalizer lengths
mse = zeros(length(tap_num), sig_len); 
for i=1:length(tap_num)
    tap = tap_num(i); 
    mu = 0.1;                  
    w = zeros(tap,1);           
    y = zeros(1, sig_len);      
    e = zeros(1, sig_len);
    
    for j=tap:sig_len
        y(j) = filtered_msg(j-(tap-1):j)'*w;        %y[n] = xT[n]w[n]
        e(j) = msg(j)-y(j);                %e[n] = a[n] - y[n]
        w = w + mu*e(j)*filtered_msg(j-(tap-1):j);  %w[n+1] = w[n] + mu*e[n]x[n]
        mse(i,j) = sum(e(1:j).^2)/j;           
    end
end
figure;
hold on;
plot(1:1:msg_length, mse(1,:));
plot(1:1:msg_length, mse(2,:));
plot(1:1:msg_length, mse(3,:));
set(gca, 'XScale', 'log');
xlim([min(tap_num), sig_len])
title('MSE vs Number of Symbols for LMS Algorithm from the Textbook') 
ylabel('Mean Squared Error');
xlabel('Number of Symbols');
legend('Length 3', 'Length 5', 'Length 7');
hold off;

%% Using MatLab Equalizer
% I know this wasn't a part of the assignment, but I didn't read the part
% referring to the algorithm from the textbook when I first did the
% project. I felt it in here for no reason other than I didn't have the
% heart to delete it.
close all
num_samples = ceil(logspace(0,5,50));
eq_lengths = [3 5 7];
err = zeros(length(eq_lengths),length(num_samples));
for i=1:length(eq_lengths)
    for j=1:length(num_samples)
        msg = randi([0 1],[1 num_samples(j)]);
        msg(msg == 0) = -1;
        train_length = ceil(length(msg)/3);
        chan = [1 .2 .4];
        filtered_msg = filter(chan, 1, msg);
        equalizer = lineareq(eq_lengths(i), lms(0.01));
        [symbolest,yd,e] = equalize(equalizer,filtered_msg,msg(1:train_length)); % Equalize.

        err(i,j) = immse(symbolest, msg);
    end
end
figure;
hold on;
plot(num_samples, err(1,:));
plot(num_samples, err(2,:));
plot(num_samples, err(3,:));
set(gca, 'XScale', 'log');
title('MSE vs Number of Symbols for MatLab Equalizer')
ylabel('Mean Squared Error');
xlabel('Number of Symbols');
legend('Length 3', 'Length 5', 'Length 7');
hold off;