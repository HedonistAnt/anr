function [vad, silence, features, wave_est, dif_mul, per80, per20] = srec_fe_ag(wave, dif_mul, step, step0, per80, per20)
alpha_n = 0.80;
alpha_s = 0.55;

Nmic = size(wave, 2);

%bandpass filter 125Hz 5500Hz
window_length = 320;
np = 2 ^ ceil(log2(window_length));
band = zeros(np / 2 + 1, 1);
band(ceil(0.015 * np / 2) + 1 : floor(0.6875 * np / 2) + 1) = 1;

%% SREC frontend parameters
front_params_16000.mel_dim                = 12;
front_params_16000.samplerate             = 16000;
front_params_16000.window_factor          = 2.0;
front_params_16000.pre_mel                = 0.899999976;
front_params_16000.low_cut                = 125;
front_params_16000.high_cut               = 5500;
front_params_16000.do_skip_even_frames    = true;
front_params_16000.do_smooth_c0           = true;
front_params_16000.do_dd_mel              = true;
front_params_16000.peakpickup             = 0.300000012;
front_params_16000.peakpickdown           = 0.699999988;
front_params_16000.melA_scale             = [ 14, 45, 60, 70, 95, 115, 115, 135, 135, 155, 160, 180 ];
front_params_16000.melB_scale             = [ 42, 110, 105, 110, 140, 140, 150, 120, 150, 130, 140, 130 ];
front_params_16000.dmelA_scale            = [ 50, 150, 290, 320, 400, 500, 500, 600, 600, 700, 720, 750 ];
front_params_16000.dmelB_scale            = [ 127, 127, 127, 127, 127, 127, 127, 127, 127, 127, 127, 127 ];
front_params_16000.ddmelA_scale           = [ 4, 12, 22, 27, 32, 35, 35, 45, 45, 55, 57, 62 ];
front_params_16000.ddmelB_scale           = [ 127, 127, 127, 127, 127, 127, 127, 127, 127, 127, 127, 127 ];
front_params_16000.voice_margin           = 14;
front_params_16000.fast_voice_margin      = 18;
front_params_16000.tracker_margin         = 7;
front_params_16000.voice_duration         = 6;
front_params_16000.quiet_duration         = 20;

params = front_params_16000;

do_nonlinear_filter = true; 
framerate = 100;
rampup = 6;

params.n_features = 12;

frame_period  = params.samplerate / framerate;
window_length  = floor(params.window_factor * frame_period);
window = hamming(window_length);

bandwidth = params.samplerate / 2;
params.np = 2 ^ ceil(log2(window_length));
params.cut_off_below = (params.low_cut * params.np) / (2.0 * bandwidth) + 1;
params.cut_off_above = (params.high_cut * params.np) / (2.0 * bandwidth) + 1;

mel_fb = mel_filterbank(params);
params.n_mel = size(mel_fb, 1);

preemph = fft([1, -params.pre_mel], 512);
preemph = abs(preemph(1:end/2 + 1)') .^ 2;

% Number of full windowed frames
n_frames = floor(size(wave, 1) / frame_period) - ceil(params.window_factor) - 1;
mfcc = zeros(n_frames, params.n_features);

c0_sm = zeros(3, 1); % first mfcc, need for VAD
vad(n_frames) = 0;
silence(n_frames) = 0;

phin = zeros(257, 1);
phip = zeros(257, 1);
mag_sqr_prev = zeros(257, 1);
summ_all = zeros(257, n_frames);

mag_sqr_next = zeros(257, 1);
mag_sqr_dif_next = zeros(257, 1);
phase_next = zeros(257, 1);
prob = zeros(257, 1);
atr = 0;
ldif_mul = log(dif_mul);
eps = 1e-10;
K = Nmic^3 - Nmic^2;


f0 = 9;
f1 = 109;

for i = 1:n_frames;
    frame = wave((i-1) * frame_period + (1:window_length),:);
    windowed = frame .* kron(ones(1, Nmic), window);
    fd_frame = fft(windowed, params.np); 

    half_fd_frame = fd_frame(1:params.np / 2 + 1, :);% .* kron(ones(1, Nmic), band); 

    summ = mean(half_fd_frame, 2);
        

    phase = phase_next;
    phase_next = summ ./ (abs(summ) + eps);
    
    mag_sqr = mag_sqr_next;
    mag_sqr_dif = mag_sqr_dif_next;
    sum0 = abs(summ) .^ 2;
    mag_sqr_next = 4*sum0;
    
    dif0 = zeros(257, 1);
    
    ss = 0;
    dd = 0;
    
    for ii = 1:Nmic-1,
        for j = ii+1:Nmic,
            dd_ij = abs(half_fd_frame(:,ii) - half_fd_frame(:,j)) .^ 2;
            ss_ij = abs(half_fd_frame(:,ii) + half_fd_frame(:,j)) .^ 2;
            dif0 = dif0 + dd_ij;
            dd = dd + sum(dd_ij(f0:f1));
            ss = ss + sum(ss_ij(f0:f1));
        end
    end
    
    ss0 = sum(sum0(f0:f1));
    dd0 = dd / Nmic^2;
   
    lstep = log(1+step);
    
    crit = log(sum0 + eps) - log(dif0 + eps);% + log(Nmic^3 - Nmic^2);
    
    crit0 = mean(crit(f0:f1)); 
       
    per80 = per80 + step0 * (sign(crit0-per80) + 2 * 0.8 - 1);
    per20 = per20 + step0 * (sign(crit0-per20) + 2 * 0.2 - 1);
        
    flag = crit0 < per80 && crit0 > per20;
    
    ct2_all(i) = mean(crit(32:109));
    ct3_all(i) = mean(crit(9:109));
    flag_all(i) = flag;
    
   % if flag,              
        ldif_mul = ldif_mul + lstep * sign(crit - ldif_mul);             
   % end        
    
    dif_mul = exp(ldif_mul);
    
    dif = dif0 .* dif_mul;    
    
    if Nmic == 0
        dif = 0;
    end
    
    mag_sqr_dif_next = 4*dif;

    pp = 0.5 * (mag_sqr + mag_sqr_next);
    pn = 0.5 * (mag_sqr_dif + mag_sqr_dif_next);
    
    phip = alpha_s * phip + (1 - alpha_s) * pp;
    phin = alpha_n * phin + (1 - alpha_n) * pn;
    
    phin1 = phin;
    
    ln_sig = 0.35*(log(abs(phin1) + eps)) - 6.0266;
        
    reg = eps;
    wiener = min(1-eps, max(eps, phip - phin1 + reg)./(abs(phip) + eps));
  
    nsr = (wiener .^ -1 - 1);
                
    prob = 1 ./ (1 + 2 * nsr);
    log_voice_est = log(mag_sqr + eps) + 2 * log(wiener) + expint(nsr .^ -1);
    mag_sqr = exp((log_voice_est - ln_sig) .* prob + ln_sig);    

    mag_sqr_nr = mag_sqr;

    if (do_nonlinear_filter),
        mag_sqr = peek_peak_mel(params, mag_sqr);
    end
    
    mag_sqr = max(0.1 * mag_sqr_prev, mag_sqr);
    mag_sqr_prev = mag_sqr;
	
	summ_all(:, i) = sqrt(mag_sqr_nr) .* phase;
	
	mag_sqr = mag_sqr .* preemph;

    mel = mel_fb * mag_sqr; 
    log_mel = max(log2(mel), -24);
    all_mfcc = dct(log_mel);   
    mfcc(i, :) = all_mfcc(1:params.n_features);

    %% VAD (almost as in SREC frontend)
    if (i == 1),
        c0_sm = all_mfcc(1) * ones(3, 1);
        sm_filt = [1, 2, 1] / 4;
    end
    c0_sm = [c0_sm(2:end, 1); all_mfcc(1)];
    c0 = sm_filt * c0_sm;  
    c0_smooth = srec_features(params, [c0, zeros(1, params.n_features-1)], zeros(1, params.n_features), zeros(1, params.n_features));
    c0 = c0_smooth(1) + 2; % Systematic error due to inaccurate rounding in SREC

%     [vad(i), silence(i), below_thr, above_thr] = VAD_MFCC0(c0 / 256, framerate, i < rampup);      
    [vad(i), silence(i), ~, atr] = VAD_MFCC0(c0 / 256, framerate, i < rampup); 
end
summ_all = summ_all(:,2:end);
ext_mfcc = [ones(rampup, 1) * mfcc(1, :); mfcc]; 

ext_deltas = filter([3, 2, 1, 0, -1, -2, -3] / 28, 1, ext_mfcc);
ext_ddeltas = filter([2, 0, -1, -2, -1, 0, 2], 1, ext_mfcc);

deltas = ext_deltas(rampup + 1:end, :);
ddeltas = ext_ddeltas(rampup + 1:end, :);

nmfcc = zeros(n_frames, 3 * params.n_features);

for i = 1:n_frames;
    nmfcc(i, :) = srec_features(params, mfcc(i, :), deltas(i, :), ddeltas(i, :));
end
features =  nmfcc;

vad = vad(:) > 0;

wave_est = zeros((n_frames) * 160, 1);
for  i = 1:n_frames-1,
        af_half = summ_all(:, i);
        af = [af_half; conj(af_half(end - 1:-1:2))];
        a = ifft(af);
        wave_est((i - 1) * frame_period + (1:window_length), 1) = wave_est((i - 1) * frame_period + (1:window_length), 1) + a(1:window_length) ./ window .* hanning(window_length);
end
