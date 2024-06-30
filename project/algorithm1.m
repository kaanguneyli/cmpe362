
a = 4;

if a == 1
    [audioinput, fs] = audioread('sevdacicegi.wav');   % 114.5
elseif a == 2
    [audioinput, fs] = audioread('dudu.wav');    % 91
elseif a == 3
    [audioinput, fs] = audioread('aleph.wav');   % 81
elseif a == 4
    [audioinput, fs] = audioread('beat.wav');    % 60 
end


fft_size = 2205;

C = 2.056;
if a == 1
    C = 1.95;
end

aa = audioinput(:, 1);
bb = audioinput(:, 2);
number_of_frames = length(audioinput) / fft_size;
fortythree = fs / fft_size;


mags = [0, 0.001, 0.01, 0.1, 1, 10, 100];

number_of_subbands = length(mags) - 1;
energy_history = zeros(number_of_subbands, fortythree);
beats = 1;

for frame_index = 1:number_of_frames
    frame_end = frame_index * fft_size;
    frame_start = frame_end - fft_size + 1;

    frame = aa(frame_start:frame_end) + 1i * bb(frame_start:frame_end);
    frame = frame .* hamming(fft_size);
    frame_fft = fft(frame);
    magnitude = abs(frame_fft);

    Es = zeros(number_of_subbands, 1);
    

    for i = 1:number_of_subbands
        subband = [];
        count = 0;

        for j = 1:length(magnitude)
            if magnitude(j) > mags(i) && magnitude(j) < mags(i+1)
                subband(count+1) = magnitude(j);
                count = count + 1;
            end
        end
        subband = subband.^2;
        Es(i) = number_of_subbands / fft_size * sum(subband) / length(subband);
    end
    
    energy_history(:, 2:fortythree) = energy_history(:, 1:fortythree-1);
    energy_history(:, 1) = Es;

    for i = 2:number_of_subbands
        if frame_index < fortythree
            if energy_history(i, 1) > C * mean(energy_history(i, 2:frame_index))
                %fprintf('beat detected: frame = %d i = %d energy = %f, mean energy = %f\n', frame_index, i, energy_history(i, 1), mean(energy_history(i, 2:frame_index)));
                beats = beats + 1;
                break;
            end
        else 
            if energy_history(i, 1) > C * mean(energy_history(i, 1:fortythree))
                %fprintf('beat detected: frame = %d i = %d energy = %f, mean energy = %f\n', frame_index, i, energy_history(i, 1), mean(energy_history(i, 2:fortythree)));
                beats = beats + 1;
                break;
            end
        end
    end
end
disp(["bpm:", num2str(beats)]);