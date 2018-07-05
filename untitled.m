Files=dir('./Documents/MATLAB/bth/et05_bth');
ch0 = [];
ch1 = [];
ch3 = [];
ch4 = [];
ch5 = [];
ch6 = [];
maplist = {};

for k=1:length(Files)
   FileNames=Files(k).name;
  
   splt = split(FileNames,'.');
   chanel = splt(2);
  
   switch char(chanel)
       case 'CH1'
           ch1=[];
           [ch1,Fs]=audioread(strcat('./Documents/MATLAB/bth/et05_bth','/',char(FileNames)));
       case 'CH3'
           ch3=[];
           [ch3,Fs]=audioread(strcat('./Documents/MATLAB/bth/et05_bth','/',char(FileNames)));
       case 'CH4'
           ch0=[];
           [ch4,Fs]=audioread(strcat('./Documents/MATLAB/bth/et05_bth','/',char(FileNames)));
       case 'CH5'
           ch5=[];
           [ch5,Fs]=audioread(strcat('./Documents/MATLAB/bth/et05_bth','/',char(FileNames)));
       case 'CH6'
           ch6=[];
           [ch6,Fs]=audioread(strcat('./Documents/MATLAB/bth/et05_bth','/',char(FileNames)));
       maplist{end+1} = [ch1,ch3,ch4,ch5,ch6];
          %containers.Map({'CH0','CH1','CH3','CH4','CH5','CH6'},{ch0,ch1,ch3,ch4,ch5,ch6});
           
                
       
   end
        
end
Files1 = dir('./Documents/MATLAB/bcg');
ch1 = [];
ch3 = [];
ch4 = [];
ch5 = [];
ch6 = [];
bgk = {};

for k=1:length(Files1)
   FileNames=Files1(k).name;
  
   splt = split(FileNames,'.');
   chanel = splt(2);
  
   switch char(chanel)
       case 'CH1'
           ch1=[];
           [ch1,Fs]=audioread(strcat('./Documents/MATLAB/bcg','/',char(FileNames)));
       case 'CH3'
           ch3=[];
           [ch3,Fs]=audioread(strcat('./Documents/MATLAB/bcg','/',char(FileNames)));
       case 'CH4'
           ch0=[];
           [ch4,Fs]=audioread(strcat('./Documents/MATLAB/bcg','/',char(FileNames)));
       case 'CH5'
           ch5=[];
           [ch5,Fs]=audioread(strcat('./Documents/MATLAB/bcg','/',char(FileNames)));
       case 'CH6'
           ch6=[];
           [ch6,Fs]=audioread(strcat('./Documents/MATLAB/bcg','/',char(FileNames)));
           bgk{end+1} = [ch1,ch3,ch4,ch5,ch6];
         
           
                
       
   end
        
end






