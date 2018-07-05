function[Input,Output] = nnet_data_gen(fout,Input,Output,input,output)

ws=1e4;
wl=512;
X=stft_multi(mean(fout,2).', wl);


phase = X ./ (abs(X) + eps);
X = abs(X);

Nmic=5;
pairs = [1,2;1,3;1,4;1,5;2,3;2,4;2,5;3,4;3,5;4,5];
z = zeros(size(fout,1), size(pairs,1));

for i=1:size(pairs,1)
    p1 = pairs(i,1);
    p2 = pairs(i,2);
    
    z(:,i) = fout(:,p1)-fout(:,p2);
end

Z=abs(stft_multi(z.', wl));




    for i=1:100
        input(i) = {sum(Z(:,i,:),3)};
        output(i) = {X(:,i)};
    end

Input = [Input input] ;
Output =[Output output] ;


end