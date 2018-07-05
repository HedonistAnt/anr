%calculate filter params
[b,a]=butter(10, [0.02,0.95]);
fs=16e3;
c = 10;
ref_pos=5;
N=512;

for i=[1:8]
    %filename=['white_front\08_07_2015(19_49_34)_' num2str(i-1) 'out.wav'];
    %filename=['ssh1\15_07_2015(20_12_15)_' num2str(i-1) 'out.wav'];
    filename=['numbers\15_07_2015(20_14_37)_' num2str(i-1) 'out.wav'];
    tout(:,i)=filter(b,a,audioread(filename));
    tout(:,i)=tout(:,i)-mean(tout(:,i));   
    out(:,i)=resample(tout(:,i),c,1);
end

ref = mean(out(:,4:5),2);

for i=[1:8]
    ac(:,i)=xcorr(out(:,i),out(:,i),N/2);
    cc(:,i)=xcorr(ref,out(:,i),c*10);
    [m(i),k(i)]=max(cc(:,i));
    h0(:,i)=frac_delay_filt(k(i)/c,N);
end

vout=fftfilt(h0,tout);

nref=mean(vout,2);
v=vout'*nref;
v=v./sum(vout.^2)';

%filter
h=h0*diag(v);
%fft filter
fh=fft(h,512);