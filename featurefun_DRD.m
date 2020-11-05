
function [M_t mb sd variance sb kur] = featurefun_DRD(rec , Fs)


siglen = length(rec);
%% Transformation to a suitable frequency domain
wlen = 1024;
hop = wlen/4;
fftpt = 1024;
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
melSpec=filteramp*logMagSpec;
% logMel = log10(melSpec);
% melCeps = dct(logMel);
% mfccs = abs(melCeps(1:13,:));

[r1,c1]=size(melSpec);
%% Decay rate calculation (Prateek Murgai)
% Energy Envelope Estimation

alpha=0.5;

for i=2:r1
    e1=melSpec(i,:);
    for j=2:c1
        e(i,j)=alpha*(e1(j-1))^2+(1-alpha)*(e1(j))^2;
    end
end

y=zeros(size(e));
tau=0.005; % time constant of detector


beta=exp(-1/(tau*Fs));
for i=2:r1
    for j=2:c1
        y(i,j)=sqrt(beta*(y(i,j-1)).^2+(1-beta)*(e(i,j)).^2);
    end
end
[r2,c2]=size(y);
%Local Peak Detection
count=0;
for i=2:r2
    for j=2:c2-1
        if (((y(i,j)-y(i,j-1))>0) && ((y(i,j)-y(i,j+1))>0))
            count=count+1;
            loc(count,:)=[i,j];
        end
    end
end
 
%Selection of valid decay start and stop points
t_th=floor(3*10^-3*Fs); % setting the monotonically decreasing search threshold to 3 msec
[r3,c3]=size(loc);
count1=0;
for i=1:r3
    if (loc(i,2)+t_th)<c2
        start(i) = loc(i,2);
        stop(i) = loc(i,2)+t_th;
        arr(i,:) = y(loc(i,1),start(i):stop(i));
        difference(i,:) = diff(arr(i,:));
        if difference(i,:)<0
            count1=count1+1;
            loc_final(count1,:)=[loc(i,1),start(i),stop(i)];
            arr_final(count1,:)=y(loc(i,1),start(i):stop(i));
        end
    end        
end

% logMel = log10(arr_final);
% melCeps = dct(logMel);
% mfccs = abs(melCeps(:,1:13));
% 
% %Statistical functions on MFCCs
% mb = mean(mfccs,2);
% sd = std(mfccs,0,2);
% kur = kurtosis(mfccs,1,2);
% for i=1:r1
%     sb(i,1)=skewness(mfccs(i,:));
% end
% mb=mb';
% sd=sd';
% kur=kur';
% sb=sb';
% mfcc_baseline=[mb,sd,sb,kur];

%Line Fitting in Least Squares
[r4,c4]=size(loc_final);
for i=1:r4
    x1(i,:) = loc_final(i,2):loc_final(i,3);
    y1(i,:) = 20*log10(y(loc_final(i,1),x1(i,:)));
    p(i,:) = polyfit(x1(i,:),y1(i,:),1);
    f(i,:) = polyval(p(i,:),x1(i,:));
end

%% Decay Rate Distribution feature vector
%Decay vector for each frequency band
Nb = r1;
D=zeros(Nb,r4);
count2=0;
for k=1:r4
    for j=1:Nb
        if loc_final(k,1) == j
            count2=count2+1;
            D(j,count2)=p(k,1);
         end
    end
end

%Mean vector m_t
%m_t=zeros(Nb,1);
sum_t = sum(D,2);
for i=1:Nb
    Np(i)=nnz(D(i,:));
    if Np(i)>0
        m_t(i)=sum_t(i)/Np(i);
    else
        m_t(i)=0;
    end
end
M_t=m_t';

%Statistical functions on M_t
mb=mean(M_t);    
sd=std(M_t);
variance=var(M_t);
sb=skewness(M_t);
kur=kurtosis(M_t);

%DRD feature vector
features_test1 = [m_t mb sd variance sb kur];
