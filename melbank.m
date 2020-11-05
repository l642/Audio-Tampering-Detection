function [filteramp]= melbank(Fs,freqvec)
filterno=32;
fLow=0;
fHigh=Fs/2;
lmel=1125*log(1+fLow/700);
hmel=1125*log(1+fHigh/700);
melfreqpts=linspace(lmel,hmel,(filterno+2));
for i=1:filterno+2
    linfreqpts(i)=700*(exp(melfreqpts(i)/1125)-1);
end
f = freqvec;
for i = 1:filterno
    [r c] = min(abs(f-linfreqpts(i)));
    f(c) = linfreqpts(i);
end
lfreq = linfreqpts(1:filterno);
cfreq = linfreqpts(2:filterno+1);
ufreq = linfreqpts(3:filterno+2);
amp = 2./(ufreq-lfreq);

for c = 1:filterno
    filteramp(c,:) = ((f>lfreq(c)&f<=cfreq(c)).*amp(c).*(f-lfreq(c))/(cfreq(c)-lfreq(c)))+...
        ((f>cfreq(c)&f<ufreq(c)).*amp(c).*(ufreq(c)-f)/(ufreq(c)-cfreq(c)));
end

% plot(f,filteramp);
% title('Tiangular Filter Bank');
% xlabel('Frequency');
% ylabel('Amplitude');

% [freq,amp1]=melfilterbank(Fs);
% plot(freq,amp1);
% for i=1:c
%     for j=1:32
%         melSpec(j,i) = dot(logMagSpec(:,i), trimf(freqvec, freq(:,j))); 
%     end
% end


% [H,Hnorm]=mel_filterbank(Fs,freqvec);
% melSpec = H * logMagSpec;
% melSpec=melSpec';

% [filteramp]=melbank(Fs,freqvec);
% melSpec=filteramp*logMagSpec;
% plot(melSpec(:,1));