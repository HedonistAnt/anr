simu_path = '/media/hedonistant/16E47210E471F1FB/MATLAB/anr/simu';
noise_path = '/media/hedonistant/16E47210E471F1FB/CHiME4/data/audio/16kHz/noise';

Files=dir(simu_path);
minsize = 100000;
Dif0 = {};
Dif0_real = {};
Input = {};
Output = {};
KK={};
disp(Files)
fns = {}

input=cell(1,100);
output=cell(1,100);

for k=1:length(Files)
   FileNames=Files(k).name;
   splt = split(FileNames,'.');
   chanel = splt(2);
   
   switch char(chanel)
       case 'CH1'
           fns(end+1) =  {Files(k).name };
           [ch1,~]=audioread(strcat(simu_path,'/',char(FileNames)));
           sp = split(FileNames,'_');
           fn = char(strcat(noise_path,'/',char(FileNames)));
           
           f_noise = dir(fn);
           if length(f_noise)<1 
               disp("Ok")
               continue;
              
           end
           f_noise = f_noise.name;
           
           [ch1_n,~] = audioread(strcat(noise_path,'/',f_noise));
        
       case 'CH3'
           [ch3,~]=audioread(strcat(simu_path,'/',char(FileNames)));
           sp = split(FileNames,'_');
           fn = char(strcat(noise_path,'/',char(FileNames)));
           
           f_noise = dir(fn);
           
           if length(f_noise)<1 
               disp("Ok")
               continue;
              
           end
           f_noise = f_noise.name;
           
           [ch3_n,~] = audioread(strcat(noise_path,'/',f_noise));
       case 'CH4'
           
           [ch4,~]=audioread(strcat(simu_path,'/',char(FileNames)));
           sp = split(FileNames,'_');
           fn = char(strcat(noise_path,'/',char(FileNames)));
           
           f_noise = dir(fn);
          
           if length(f_noise)<1 
               disp("Ok")
               continue;
              
           end
           f_noise = f_noise.name;
           
           [ch4_n,~] = audioread(strcat(noise_path,'/',f_noise));
       case 'CH5'
           
          
           [ch5,~]=audioread(strcat(simu_path,'/',char(FileNames)));
           sp = split(FileNames,'_');
           fn = char(strcat(noise_path,'/',char(FileNames)));
           
           f_noise = dir(fn);
          
           if length(f_noise)<1 
               disp("Ok")
               continue;
              
           end
           f_noise = f_noise.name;
           [ch5_n,~] = audioread(strcat(noise_path,'/',f_noise));
       case 'CH6'
             
           [ch6,~]=audioread(strcat(simu_path,'/',char(FileNames)));
           sp = split(FileNames,'_');
           fn = char(strcat(noise_path,'/',char(FileNames)));
           
           f_noise = dir(fn);
          
           if length(f_noise)<1 
               disp("Ok")
               continue;
              
           end
           f_noise = f_noise.name;
           [ch6_n,~] = audioread(strcat(noise_path,'/',f_noise));
           
           simu_data = [ch1,ch3,ch4,ch5,ch6];
           noise_data =  [ch1_n,ch3_n,ch4_n,ch5_n,ch6_n];
           step = 1e-2;
           step0 = 1e-4;
           per80 = -3;
           per20 = -4;
           Nmic = 5;
           dif_mul0 = ones(257,1) * 1 / (Nmic ^ 2 * (Nmic - 1));
           dif_mul = dif_mul0;
           
           %for j=1:20 
           %  [~, silence, features, ~, dif_mul,per80,per20] = srec_fe_ag_orig(noise_data, dif_mul, step, step0, per80, per20); 
           %end
           
          
            
          %[~,~,~, wave_est, dif_mul,per80,per20,Dif0,Dif0_real] = srec_fe_ag_wreal(simu_data,noise_data,dif_mul, step, step0, per80, per20,Dif0,Dif0_real);
          [Input,Output] = nnet_data_gen(noise_data,Input,Output,input,output);
           disp(' * ') ;
              
   end
           

           
   end
    
   
        





  






