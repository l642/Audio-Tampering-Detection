function [xdata_mfcc_mb xdata_mfcc_sd  xdata_mfcc_kur  xdata_mfcc_sb] = feature_table_mfcc()
myDir = uigetdir; %gets directory
 myFiles = dir(fullfile(myDir,'*.wav')); %gets all wav files in struct

 
 xdata_mfcc_mb = zeros(length(myFiles),13);
 xdata_mfcc_sd = zeros(length(myFiles),13);
 xdata_mfcc_kur = zeros(length(myFiles),13);
 xdata_mfcc_sb = zeros(length(myFiles),13);
 
for k = 1:length(myFiles)
  baseFileName = myFiles(k).name;
  fullFileName = fullfile('original1', baseFileName);
  fprintf(1, 'Now reading %s\n', fullFileName);
  [rec, Fs] = audioread(fullFileName);
  rec=rec(:,1);
  
 [mfcc_mb mfcc_sd mfcc_kur mfcc_sb] = featurefun_MFCC(rec , Fs);
  xdata_mfcc_mb(k,:) =mfcc_mb;
  xdata_mfcc_sd(k,:) = mfcc_sd;
  xdata_mfcc_kur(k,:) =mfcc_kur;
  xdata_mfcc_sb(k,:) = mfcc_sb;
end
