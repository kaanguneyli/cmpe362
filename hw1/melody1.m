% Bilge Kaan Güneyli - 2020400051

% E – D# – E – D# – E – B – D – C – A

% E = 329.63
% D# = 311.13
% B = 246.94
% D = 293.66
% C = 261.63
% A = 220.00

srate = 44000;
max_duration = 0.5;
min_duration = 0.2;
amplitude = 0.25;

e_freq = 329.63;
dsharp_freq = 311.13;
b_freq = 246.94;
d_freq = 293.66;
c_freq = 261.63;
a_freq = 220.00;

notes = [e_freq, dsharp_freq, e_freq, dsharp_freq, e_freq, b_freq, d_freq, c_freq, a_freq];

% durations = rand(1, length(notes)) * (max_duration - min_duration) + min_duration;
% total_samples = sum(ceil(durations * srate));
% t = (0:1/srate:total_samples/srate);
% melody = amplitude * sin(notes' .* samples * 2 * pi)

melody = [];
for i = 1:length(notes)
    duration = min_duration + (max_duration - min_duration) * rand();
    sample = 0:1/srate:duration;
    waveform = amplitude * sin(sample * 2 * pi * notes(i));
    melody = [melody , waveform];
end    

sound(melody, srate);

audiowrite("melody1.wav", melody, srate);