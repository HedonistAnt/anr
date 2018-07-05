function fb = mel_filterbank(params)
    maxMel = ceil(log(params.high_cut / 1000) / log(1.1));
    mel_vector = [params.low_cut, 200:100:1000, 1000 * cumprod(1.1 * ones(1, maxMel - 1)), params.high_cut];
    
    finc = params.samplerate / params.np;
    
    f = 0:finc:params.samplerate;
    
    pre_fb = zeros(length(mel_vector) - 1, params.np / 2 + 1);
    
    for i = 1:length(mel_vector) - 1,
        i0 = find(f > mel_vector(i), 1, 'first');
        i1 = find(f < mel_vector(i + 1), 1, 'last');

        pre_fb(i, i0:i1) = ((f(i0):finc:f(i1)) - mel_vector(i)) /  (mel_vector(i + 1) - mel_vector(i));
        pre_fb(i, i1 + 1:end)  = 1;        
    end
    
    fb = zeros(length(mel_vector) - 2, params.np / 2 + 1);
    
    for i = 1:length(mel_vector) - 2,
        fb(i, :) = pre_fb(i, :) - pre_fb(i + 1, :);
        fb(i, :) = fb(i, :) / sum(fb(i, :));
    end
    
%     fb = sparse(fb);    % Reduce memory size    
end