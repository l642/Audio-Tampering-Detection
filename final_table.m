clc;
clear all;
close all;
[ xdata_m_t xdata_me_an  xdata_st_d xdata_var_an xdata_skew_ness xdata_ku_r]= feature_table_DRD();
[xdata_mfcc_mb xdata_mfcc_sd  xdata_mfcc_kur  xdata_mfcc_sb] = feature_table_mfcc();

%labeling
TS=70;

for j=1:TS
    if(j<=10)
        label{j}='basement';
    elseif(j<=16)
        label{j}='church1';
    elseif(j<=28)
        label{j}='Church 2';
    elseif(j<=34)
        label{j}='Living Room';
    elseif(j<=46)
        label{j}=' Room 1';
    elseif(j<=58)
         label{j}='Room 2';
    elseif(j<=70)
        label{j}='Room 3';
    end
       
end
label=label';

%table creation
table_t = table( xdata_m_t,xdata_me_an,xdata_st_d,xdata_var_an,xdata_skew_ness,xdata_ku_r,xdata_mfcc_mb,xdata_mfcc_sd , xdata_mfcc_kur , xdata_mfcc_sb,label);