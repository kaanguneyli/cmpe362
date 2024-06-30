% Bilge Kaan Güneyli - 2020400051

% Britney Spears - Hit Me Baby One More Time

pause = 0;
f = 174.61;
g = 196.00;
a = 220.00;
b = 246.94;
c = 261.63;
dbemol = 277.18;
d = 293.66;
dsharp = 311.13;
e = 329.63;

srate = 44000;
amplitude = 0.25;
duration = 0.08;

notes =                 [c, c, c, c, c, pause, c, d, b, g, g, pause, f, g,  pause, g, c, c, d, dsharp, d, c];
duration_multipliers =  [4, 4, 4, 4, 4, 4,     4, 4, 4, 4, 6, 6    , 4, 12, 20,    4, 4, 4, 4, 4,      8, 8];

melody = []; 
for i = 1:length(notes)
    d = duration*duration_multipliers(i);
    sample = 0:1/srate:d;
    waveform = amplitude * sin(sample * 2 * pi * notes(i));
    melody = [melody, waveform];
end

sound(melody, srate);

audiowrite("melody2.wav", melody, srate);
