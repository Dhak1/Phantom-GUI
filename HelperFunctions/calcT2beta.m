function [ betasMat ] = calcT2beta( vol )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


sliceNum=size(vol,3);



for k=1:sliceNum
    
actDat = squeeze(vol(:,:,k,:));
sz = size(actDat);
ly = reshape(log(actDat+1), [sz(1)*sz(2), sz(3)]);
%%subtract the minimum value from the data to remove the offset

for i = 1:size(ly,2)
    lyN(:,i) = ly(:,i) - min(ly')';
end

%% fit to model of exponentoial decay
lx = repmat(([1:12]),[length(lyN) 1]);    
mx2 = mean(lx.^2,2);
mx  = mean(lx,2);
mxy = mean(lx.*lyN,2);
my = mean(lyN,2);
covxy = (mxy-mx.*my);
vx = (mx2-mx.^2);
betas = (-1*covxy./vx);  % slope = cov(X,Y)/var(X)
betas = reshape(betas, [sz(1), sz(2)]);


betasMat(:,:,k) = betas;

end

