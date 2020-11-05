function [ xdata_m_t xdata_me_an  xdata_st_d xdata_var_an xdata_skew_ness xdata_ku_r]= feature_table_DRD()
myDir = uigetdir; %gets directory
 myFiles = dir(fullfile(myDir,'*.wav')); %gets all wav files in struct
 xdata_m_t = zeros(length(myFiles),32);
 xdata_me_an = zeros(length(myFiles),1);
 xdata_st_d = zeros(length(myFiles),1);
 xdata_var_an = zeros(length(myFiles),1);
 xdata_skew_ness = zeros(length(myFiles),1);
 xdata_ku_r = zeros(length(myFiles),1);
 
for k = 1:length(myFiles)
  baseFileName = myFiles(k).name;
  fullFileName = fullfile('original1', baseFileName);
  fprintf(1, 'Now reading %s\n', fullFileName);
  [rec, Fs] = audioread(fullFileName);
  %[M_t mb sd variance sb kur] = featurefun_DRD(rec , Fs);
  [M_t mb sd variance sb kur]=featurefun_DRD(rec,Fs);
   
 xdata_m_t(k,:)=M_t;
  xdata_me_an(k,:)=mb;
  xdata_st_d(k,:)=sd;
   xdata_var_an(k,:) =variance;
   xdata_skew_ness(k,:)=sb;
   xdata_ku_r(k,:)=kur;
 
end

