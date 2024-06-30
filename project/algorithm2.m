
a = 4;

if a == 1
    [original, Fs] = audioread('sevdacicegi.wav');   % 114.5
end
if a == 2
    [original, Fs] = audioread('dudu.wav');    % 91
end
if a == 3
    [original, Fs] = audioread('aleph.wav');   % 81
end
if a == 4
    [original, Fs] = audioread('beat.wav');    % 60 
end
bandlimits=[0 5 35 210 1248 7419];
maxfreq=Fs;
winlength = .4;

len = size(original,1);
begin = floor(len/2);
ending = begin+5*Fs;
dft = fft(original(begin:ending,1));

n = length(dft);
nbands = length(bandlimits);

bl = zeros(nbands,1);
br = zeros(nbands,1);

for i = 1:nbands-1
  bl(i) = floor(bandlimits(i)/maxfreq*n/2)+1;
  br(i) = floor(bandlimits(i+1)/maxfreq*n/2);
end
bl(nbands) = floor(bandlimits(nbands)/maxfreq*n/2)+1;
br(nbands) = floor(n/2);

bands = zeros(n,nbands);

for i = 1:nbands
  bands(bl(i):br(i),i) = dft(bl(i):br(i));
  bands(n+1-br(i):n+1-bl(i),i) = dft(n+1-br(i):n+1-bl(i));
end
bands(1,1)=0;

n = length(bands);
hannlen = winlength*2*maxfreq;
hann = [zeros(n,1)];

for a = 1:hannlen
  hann(a) = (cos(a*pi/hannlen/2)).^2;
end

wave = zeros([size(bands,1) nbands]);
for i = 1:nbands
  wave(:,i) = real(ifft(bands(:,i)));
end

freq = zeros([size(wave,1) nbands]);
for i = 1:nbands
    for j = 1:n
      if wave(j,i) < 0
	wave(j,i) = -wave(j,i);
      end
    end
    freq(:,i) = fft(wave(:,i));
end

hwindow_output = zeros([size(freq,1) nbands]);
for i = 1:nbands
  hwindow_output(:,i) = real(ifft(freq(:,i).*fft(hann)));
end

diff_output=zeros(n,nbands);
for i = 1:nbands
   for j = 5:n
     d = hwindow_output(j,i) - hwindow_output(j-1,i);    
     if d > 0 
       diff_output(j,i)=d;
     end
   end
end

  n=length(diff_output);

  nbands=length(bandlimits);

  % Set the number of pulses in the comb filter
  
  npulses = 5;

  % Get signal in frequency domain

  for i = 1:nbands
    dft(:,i)=fft(diff_output(:,i));
  end
  
  % Initialize max energy to zero
  
  maxe = 0;
  minbpm = 60;
  maxbpm = 240;
  acc=1;
  for bpm = minbpm:acc:maxbpm
    
    % Initialize energy and filter to zero(s)
    
    e = 0;
    fil=zeros(n,1);
    
    % Calculate the difference between peaks in the filter for a
    % certain tempo
    
    nstep = floor(60/bpm*maxfreq);
    
    % Print the progress
    
    % percent_done  = 100*(bpm-minbpm)/(maxbpm-minbpm)
    
    % Set every nstep samples of the filter to one
    
    for a = 0:npulses-1
      fil(a*nstep+1) = 1;
    end
    
    % Get the filter in the frequency domain
    
    dftfil = fft(fil);
    
    % Calculate the energy after convolution
    
    for i = 1:nbands
      x = (abs(dftfil.*dft(:,i))).^2;
      e = e + sum(x);
    end
    
    % If greater than all previous energies, set current bpm to the
    % bpm of the signal
    
    if e > maxe
      sbpm = bpm;
      maxe = e;
    end
  end
  
output = sbpm;
fprintf('Estimated BPM: %.2f\n', output);

