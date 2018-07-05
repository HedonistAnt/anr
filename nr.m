load nr_params

Nmic = 8;

nout=[];
fout=[];

for i=1:Nmic
    %filename=['musicfront_whiteside\08_07_2015(19_59_22)_' num2str(i-1) 'out.wav'];
    %filename=['numbers_musicnoise\15_07_2015(20_18_31)_' num2str(i-1) 'out.wav'];
    filename=['numbers_misicnoise2\15_07_2015(20_24_21)_' num2str(i-1) 'out.wav'];
    nout(:,i)=audioread(filename);
    nout(:,i)=nout(:,i)-mean(nout(:,i));
    
    fout(:,i)=fftfilt(h(:,i),nout(:,i));
end

dif_mul0 = ones(257,1) * 1 / (Nmic ^ 2 * (Nmic - 1));

%dif_mul = dif_mul0;
step = 1e-2;
step0 = 1e-4;
per80 = -3;
per20 = -4;

%suppress noise
[~, silence, features, wave_est, dif_mul,per80,per20] = srec_fe_ag(fout, dif_mul, step, step0, per80, per20); 

 

