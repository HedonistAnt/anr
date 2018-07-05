load('/media/hedonistant/16E47210E471F1FB/MATLAB/SignalGraph-master/examples/regression/enhanced_wiener.mat')
load('./network_cv.mat')
bth_path = '/media/hedonistant/16E47210E471F1FB/MATLAB/anr/bcg_n_bth';
Files=dir(bth_path);
  step = 1e-2;
  step0 = 1e-4;
  per80 = -3;
  per20 = -4;
  Nmic = 5;
  dif_mul0 = ones(257,1) * 1 / (Nmic ^ 2 * (Nmic - 1));
  dif_mul = dif_mul0;
  wreal = Data_cv(2)
  AuData = {};
  

           ch1=[];
           [ch1,Fs]=audioread(strcat(bth_path,'/','150203_010F05_440C020E_BTHch1_10.wav'))

          
           
      
           [ch3,Fs]=audioread(strcat(bth_path,'/','150203_010F05_440C020E_BTHch3_10.wav'));
     
           ch4=[];
           [ch4,Fs]=audioread(strcat(bth_path,'/','150203_010F05_440C020E_BTHch1_10.wav'));
     
          ch5=[];
          [ch5,Fs]=audioread(strcat(bth_path,'/','150203_010F05_440C020E_BTHch1_10.wav'));
      
          ch6=[];
          [ch6,Fs]=audioread(strcat(bth_path,'/','150203_010F05_440C020E_BTHch1_10.wav'));
          AuData{end+1} = [ch1,ch3,ch4,ch5,ch6];
         
   for j=1:10
       [~, ~, ~, wave_est_1, dif_mul,~,~] = srec_fe_ag_orig(AuData{1}, dif_mul, step, step0, per80, per20); 
   end
   %[vad, silence, features, wave_est_wreal, dif_mul, per80, per20,wiener_all,real_wiener_all] = srec_fe_ag_wreal(wave,cwave, dif_mul, step, step0, per80, per20,wiener_all, real_wiener_all)
   
  %[~, silence, features, wave_est, dif_mul,per80,per20,n_frames] = srec_fe_ag_enhanced_wiener(AuData{1}, dif_mul, step, step0, per80, per20,enhanced);
  
  
   

   
   
 