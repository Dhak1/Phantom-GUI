function [ind,vals] = register_imgs( img1,imgMat,ifplot)

if nargin<3
    ifplot=0;
end
nimages1=size(img1,3);
l=size(imgMat,3);
%% Register spokes
for jj=1:nimages1
    for ii=1:l
        im =img1(:,:,jj);
        sums(ii)=sum(sum(imgMat(:,:,ii).*im))/nnz(imgMat(:,:,ii));
    end
    [vals(jj,1),ind(jj,1)]=max(sums);
    if ifplot
        figure(1)
        clf
        imagesc(im)
        colormap gray
        maskOverlay_simple(imgMat(:,:,ind(jj)));
        title(num2str(jj))
    end
end
%%
end

