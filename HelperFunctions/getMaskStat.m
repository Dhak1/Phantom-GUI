function [ mt2star ] = getMaskStat( img,angDeg,center,radius,ifplot )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
img1=img(:,:,1);
s=floor(size(img)/2)+0.5;
%[masks] = generateMasks3(img1,4,[radius,s(2), s(1)],pi*0.1);
AnguarIdent=pi*0.15;
[masks,  maskSize_ic , masks_oc, maskSize_oc] = generateMasks5(img1,4,[radius,s([2 1])],AnguarIdent,[0.3 0.25]);
decentering = [-0.5,-0.5];
CreateMapFlag=0;
%80/256/2
%%

im1=zeros(size(masks));
im2=zeros(size(masks));
for ii=1:4
    im=masks(:,:,ii);
    im1(:,:,ii)=imrotate(im,angDeg,'nearest','crop');
    im2(:,:,ii)=imtranslate(im1(:,:,ii),center-[s(2) s(1)]+decentering);
    if CreateMapFlag
        im2(:,:,ii) = mask_weights.*im2(:,:,ii);
    end
    im2(:,:,ii)=im2(:,:,ii)./sum(sum(im2(:,:,ii)));
end


for jj=1:size(img,3)
    for ii=1:4
        img1=img(:,:,jj);
        [i,j]=find(im2(:,:,ii));
        k=img1(sub2ind(size(img1),i,j));
        mt2star(jj,ii)=mean(k);
        st2star(jj,ii)=std(k);
    end
end

if (ifplot)
    
    img1=img(:,:,1);
    
    figure(1);
    imagesc(img1);
    colormap gray;
    maskOverlay_simple(im2*100);
    
    figure (2);
    leg = {'Red','Green','Blue','Yellow'};
    for ii=1:4
        subplot(2,2,ii)
        [i,j]=find(im2(:,:,ii));
        k=img1(sub2ind(size(img1),i,j));
        mt2star(ii)=mean(k);
        st2star(ii)=std(k);
        histogram(k)
        title([leg{ii} ' mean ' num2str(mt2star(ii))])
    end
    
    figure(3)
    clf
    c=mt2star;
    set(gca,'ColorOrder',[1 0 0; 0 1 0; 0 0 1; 1 1 0])
    hold all
    plot(100*(c-mean(c,2))./mean(c,2),'LineWidth',2)
    leg = {'mask 1','mask 2','mask 3','mask 4'};
    legend(leg)
    hold off

end
%%mm=(mean(mt2star([1 3]))-mean(mt2star([2 4])))*100/mean(mt2star);

end

