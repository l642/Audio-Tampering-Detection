function [mfcc_mb mfcc_sd mfcc_kur mfcc_sb] = featurefun_MFCC(rec , Fs)

siglen = length(rec);

wlen = 1024;
hop = wlen/4;
fftpt = 4096;
win = hamming(wlen,'periodic');

% Setting the STFT matrix size
r = ceil((1+fftpt)/2)-1;         % rows in stft matrix            
c = 1+floor((siglen-wlen)/hop); % columns in stft matrix     
stft = zeros(r,c);          

indx = 0;

% Short Time Fourier Transform
for i = 1:c
    rec_win = rec(indx+1:indx+wlen).*win; %windowed signal
    R = fft(rec_win, fftpt); %fft of windowed signal
    stft(:, i) = R(1:r);
    indx = indx + hop;
end
timevec = (wlen/2:hop:wlen/2+(c-1)*hop)/Fs;
freqvec = (0:r-1)*Fs/fftpt;

% Log of magnitude of spectrum
magSpec = abs(stft);
for i=1:size(magSpec,1)
    for j=1:size(magSpec,2)
        if magSpec(i,j)==0
            magSpec(i,j)=0.00001;
        end
    end
end
logMagSpec = 10*log10(magSpec);

% Conversion to perceptual scale
[filteramp]=melbank(Fs,freqvec);
meSMOpec=filteramp*logMagSpec;
logMel = log10(meSMOpec);
melCeps = dct(logMel);
mfccs = abs(melCeps(1:13,:));
[r1,c1]=size(mfccs);

mb=zeros(13,1);
sd=zeros(13,1);
kur=zeros(13,1);
sb=zeros(13,1);

%Statistical functions on MFCCs
for z=1:r1
    mb(z,1) = mean(mfccs(z,:),2);
    sd(z,1) = std(mfccs(z,:),0,2);
    kur(z,1) = kurtosis(mfccs(z,:),1,2);
    sb(z,1) = skewness(mfccs(z,:));
end
mfcc_mb=mb';
mfcc_sd=sd';
mfcc_kur=kur';
mfcc_sb=sb';

