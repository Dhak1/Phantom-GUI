function [mt2star,sfs,tsnr,st2star, center, radius]=getStatBold3(img,angDeg,ifplot,rfactor,tempFiltFlag,decentering,AnguarIdent)

CreateMapFlag =0;
if nargin<5
    rfactor=1;
    img1=img(:,:,1,1);
else
   %img1=imresize(img(:,:,sliceNum,1),rfactor,'nearest');
   img1=imresize(img(:,:,1,1),rfactor,'bicubic');
end

radii=[5 15];

if nargin < 6
    %radii=[20 40];
    AnguarIdent=pi*0.15;
    decentering=[-0.5 -0.5];
    
    %radii=[5 17];
% else
%     radii = rcenter(1:2);
%     decentering=rcenter(3:4);
end

if (ifplot==2)
    figure(1);
    imagesc(img1);
    colormap gray;
end

%%
%[innerCylinder, outerCylinder, center, radius] = gen2_get_i_cylinder(img1,rfactor*[5 17]);
[innerCylinder, outerCylinder, center, radius] = gen3_get_i_cylinder(img1,rfactor*radii);

img_ic = img1;
img_ic(innerCylinder==0)=0;
img_oc = img1;
img_oc(outerCylinder==0)=0;

if CreateMapFlag
    img_oc = img1;
    [X,Y]=meshgrid(1:size(img_oc,1));
    outerCylinder(((Y - center(2)).^2 + (X - center(1)).^2) <= (radius*1.5).^2) = 0;
    outerCylinder(((Y - center(2)).^2 + (X - center(1)).^2) >= (radius*2.5).^2) = 0;
%    img_oc(outerCylinder<1000)=0;
    img_oc=outerCylinder;
    [i,j,k]=find(img_oc);

    
    p=fit([i j],1./k,'poly33');
    mask_weights=p(Y,X);
    if (ifplot)
        figure(1)
        plot(p,[i,j],1./k);
        %plot(k.*p(i,j))
        %imagesc(mask_weights.*img_ic);
    end
    
end



%% create masks
s=floor(size(img_ic)/2);
%[masks, maskSize] = generateMasks3(img_ic,4,[radius,s],pi*0.1);
%[masks, maskSize] = generateMasks3(img_ic,4,[radius,s],pi*80/512);
%[masks, maskSize] = generateMasks3(img_ic,4,[radius,s],pi*0.2);

[masks,  maskSize_ic , masks_oc, maskSize_oc] = generateMasks5(img_ic,4,[radius,s([2 1])],AnguarIdent,[0.3 0.25]);
masks_oc=imtranslate(masks_oc,center-[s(2) s(1)]+decentering);

if (ifplot==2)
    figure(2)
    imagesc(masks_oc.*img_oc + img_ic);
    %colormap gray;
end 

%% align masks to cartridge

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

if (ifplot)
figure(3);
fcenter=floor(center);
indcx=(fcenter(1)-floor(radius*1.3):fcenter(1)+floor(radius*1.3));
indcy=(fcenter(2)-floor(radius*1.3):fcenter(2)+floor(radius*1.3));
imagesc(img_ic(indcy,indcx));
colormap gray;
maskOverlay_simple(im2(indcy,indcx,:)*50);
end


%% get bold signal statistics

leg = {'Red','Green','Blue','Yellow'};
nimg=size(img,4);
%imgr=imresize(img(:,:,sliceNum,:),rfactor,'nearest');
% filter high frequency noise
if tempFiltFlag
    imgm=mean(img,4);
    imgf = filtVol(img,0.01,0.1 ) + imgm;
    imgr=imresize(imgf(:,:,1,:),rfactor,'bicubic');
else
    imgr=imresize(img(:,:,1,:),rfactor,'bicubic');
end


maskMat_ic=repmat(im2,1,1,1,nimg);
maskMat_oc=repmat(masks_oc,1,1,1,nimg);


if (ifplot==2)
    for ii=1:4
        %ic(:,:,ii,:)=maskMat_ic(:,:,ii,:).*imgr;
        %         [i,j]=find(im2(:,:,ii));
        %         k=imgr(j,i,1,1);
        im2i=reshape(im2(:,:,ii),[],ii);
        imgri = reshape(imgr(:,:,1,1),[],1);
        k=imgri(im2i>0);
        figure (4);
        subplot(2,2,ii)
        histogram(k)
        title([leg{ii} ' mean ' num2str(mean(k(:)))])
    end
    
end

ic= maskMat_ic.*repmat(imgr,1,1,4,1);
oc=maskMat_oc.*imgr;
ind=(maskMat_oc~=0);
%ocr=reshape(oc,[],nimg);
%ocrNz=reshape(ocr(ocr~=0),[],nimg);
ocrNz=reshape(oc(ind),[],nimg);
%oc_randi=randi(maskSize_oc,[maskSize_ic(1), 100]);


% for ii=1:size(oc_randi,2)
%     mt2star_t_oc_randi=mean(ocrNz(oc_randi(:,ii),:));
%     st2star_t_oc_randi(ii)=std(detrend(mt2star_t_oc_randi));
% end

mt2star_t_ic=squeeze(sum(sum(ic)))';
mt2star_t_oc=squeeze(sum(sum(oc)))/maskSize_oc;
mt2star_ic=mean(mt2star_t_ic);
mt2star_oc=mean(mt2star_t_oc);
%st2star_ic=std(mt2star_t_ic);
st2star_ic=std(detrend(mt2star_t_ic));
%st2star_ic=std(mt2star_t_ic);
%st2star_oc=mean(st2star_t_oc_randi);
% scale std of outter circle
st2star_oc=std(detrend(mean(ocrNz)))*sqrt(maskSize_oc/maskSize_ic(1));
%st2star_oc=std(mean(ocrNz))*sqrt(maskSize_oc/maskSize_ic(1));
%st2star_oc=std(mt2star_t_oc);
st2star = [st2star_ic st2star_oc];
mt2star = [mt2star_t_ic mt2star_t_oc];
sfs=100*(mt2star_ic/mt2star_oc).*(st2star_ic/st2star_oc);
tsnr= [mt2star_ic mt2star_oc]./ st2star;

    

%     if (ifplot==2)
%         figure(3);
%         fcenter=floor(center);
%         indcx=(fcenter(1)-floor(radius*1.3):fcenter(1)+floor(radius*1.3));
%         indcy=(fcenter(2)-floor(radius*1.3):fcenter(2)+floor(radius*1.3));
%         imagesc(img_ic(indcy,indcx));
%         colormap gray;
%         maskOverlay_simple(im2(indcy,indcx,:)*50);
%         input('');
%     end






