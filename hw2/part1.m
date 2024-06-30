
A = 0.5; % Amplitude

sr = 300000; % Sample Rate (samples per second) 

s = 2; % Signal length (in seconds)

f = 100; % Frequency (in Hz)

tt = 0: 1/sr :s; % Time axis

n_list = [5, 15, 150, 500]; % Number of sine waves in finite computation

% tiledlayout(length(n_list), 1);

for i = 1:length(n_list)
    wave = 0;
    n = n_list(i);
    for k = 1:n
        if mod(k, 2) == 1
            wave = wave + sin(2 * pi * f * k * tt) / k;
        end
    end
    wave = 4 / pi * A * wave;
    %nexttile;
    subplot(2,2,i);
    plot(tt, wave);
    axis([0 0.0200 -1 1]);
    title('n', n);
end
