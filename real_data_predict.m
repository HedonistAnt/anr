realdata_path = '/media/hedonistant/16E47210E471F1FB/MATLAB/anr/real_data';
Files=dir(realdata_path);
ch0 = [];
ch1 = [];
ch3 = [];
ch4 = [];
ch5 = [];
ch6 = [];
AuData = {};
audioname = {};
wiener_all = {};
real_wiener_all={};
for k=1:length(Files)
   FileNames=Files(k).name;
  
   splt = split(FileNames,'.');
   chanel = splt(2);
  
   switch char(chanel)
       case 'CH1'
           ch1=[];
           [ch1,Fs]=audioread(strcat(realdata_path,'/',char(FileNames)));
          
       case 'CH3'
           ch3=[];
           [ch3,Fs]=audioread(strcat(realdata_path,'/',char(FileNames)));
       case 'CH4'
           ch0=[];
           [ch4,Fs]=audioread(strcat(realdata_path,'/',char(FileNames)));
       case 'CH5'
           ch5=[];
           [ch5,Fs]=audioread(strcat(realdata_path,'/',char(FileNames)));
       case 'CH6'
           ch6=[];
           [ch6,Fs]=audioread(strcat(realdata_path,'/',char(FileNames)));
           AuData{end+1} = [ch1,ch3,ch4,ch5,ch6];
           audioname{end + 1} = char(FileNames);
           
   end
    
   
        
end



            step = 1e-2;
            step0 = 1e-4;
            per80 = -3;
            per20 = -4;
            Nmic = 5;
         
          
          
            step = 1e-2;
            step0 = 1e-4;
            per80 = -3;
            per20 = -6;
            
            CurrData =AuData;
            
            
            for i=1:length(AuData)
            
             [vad, silence, features, wave_est, ~, ~, ~,~,~]  = srec_fe_ag(AuData{i},CurrData{i},dif_mul, step, step0, per80, per20,{}, {},trainedNet);
             namesplt = split(audioname{i},'.');
             wave_est = wave_est./max(abs(wave_est));
             audiowrite(char(strcat('/media/hedonistant/16E47210E471F1FB/MATLAB/anr/enhanced/',namesplt(1),'.wav')),wave_est,16000)
             plot(wave_est)
             disp(' ')
            end
            
           
            
    