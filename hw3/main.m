[input_audio, sample_rate] = audioread('audio.wav');
duration = length(input_audio) / sample_rate;
time_axis = linspace(0, duration, length(input_audio));
%plot(time_axis, input_audio);


lowpass_freq = 500;
filter_order = 6;

[b, a] = butter(filter_order, lowpass_freq / (sample_rate / 2), 'low');
[x,y] = freqz(b, a, 1024, sample_rate);
plot(y, abs(x));
lowpass_audio = filter(b, a, input_audio);
%plot(time_axis, lowpass_audio);
audiowrite('kick.wav', lowpass_audio, sample_rate);


highpass_freq = 4000;
[b, a] = butter(filter_order, highpass_freq/(sample_rate/2), 'high');
[x,y] = freqz(b, a, 1024, sample_rate);
plot(y, abs(x));
highpass_audio = filter(b, a, input_audio);
%plot(time_axis, highpass_audio);
audiowrite('cymbal.wav', highpass_audio, sample_rate);


[b, a] = butter(filter_order, [lowpass_freq highpass_freq]/(sample_rate/2), 'bandpass');
[x,y] = freqz(b, a, 1024, sample_rate);
plot(y, abs(x));
bandpass_audio = filter(b, a, input_audio);
%plot(time_axis, bandpass_audio);
audiowrite('piano.wav', bandpass_audio, sample_rate);