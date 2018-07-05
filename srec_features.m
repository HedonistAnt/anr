function features = srec_features(params, mfcc, deltas, ddeltas)
    normer = log(2) * sqrt([1; 0.5 * ones(params.n_features - 1, 1)] / params.n_mel)';

    nmfcc = mfcc .* normer;
    nmfcc(1) = nmfcc(1) + 21 * log(2) ;
    
    nmfcc = nmfcc .* params.melA_scale + params.melB_scale;
    
    ndeltas = deltas .* normer;
    ndeltas = ndeltas .* params.dmelA_scale + params.dmelB_scale;
    
    nddeltas = ddeltas .* normer;
    nddeltas = nddeltas .* params.ddmelA_scale + params.ddmelB_scale;
    
    features = [nmfcc, ndeltas, nddeltas];
    
    features = round(features);
    
    features(features < 0) = 0;
    features(features > 255) = 255;
end
