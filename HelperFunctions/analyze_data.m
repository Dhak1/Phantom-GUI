%% cartridge #9

cd('~/Documents/MultiCenterTestScans/Martinos/Bay6')
dname = 'Phantom1';
ls(dname)
%%
fname='gre_mgh_multiecho_1p5mm_003.nii';
img=nii_tool('load',fullfile(dname,fname));
T2Data= img.img;
TEs=  [5:5:60] ;
%TEs = 5:5:60; % Echo times in T2*-weighted image
[t2starmap] = mapT2star(T2Data,TEs);
%%
i=23;
[t2star_s,cross_mask,angDeg,center,radius] = registerSpokesT2s(  t2starmap,i,[8 15],1);
%% show mask overlay
angDeg=0;
c=getMaskStat( t2starmap(:,:,25,2),angDeg,center,radius,1 );
figure(2);
%% caculate slices average t2*
goodSlices=25:45;
c=getMaskStat( t2starmap(:,:,goodSlices,2),angDeg,center,radius,0 );
figure(2)
clf
set(gca,'ColorOrder',[1 0 0; 0 1 0; 0 0 1; 1 1 0])
hold all
subplot(2,1,1)
plot(goodSlices,c,'LineWidth',2)
subplot(2,1,2)
plot(goodSlices,100*(c-mean(c,2))./mean(c,2),'LineWidth',2)
leg = {'mask 1','mask 2','mask 3','mask 4'};
legend(leg)
hold off
title('cartrdige #8')

%% pink noise  not multi band 

scanName='ep2d_bold_mgh_SMS3_shift3_localshim_002';
nii=nii_tool('load', fullfile(dname,[scanName, '.nii']));
img=double(nii.img);

%%  slice selection
nii_viewer(fullfile(dname,[scanName, '.nii']))
%%
goodSlices=(32:41)';
load(fullfile(dname,['coords.mat']));
size(img)
%%
[ callq,mt2star,sfs,tsnr,st2star]=findCorr( goodSlices, pinkSeq(10:512,1),img(:,:,:,10:512),angDeg-45,pi*0.18,[0.4 0.3]);
%% Analyze data averaged
% average on 3 slices 
% mimg=squeeze(mean(reshape(img,84,84,3,22,800),3));
% %%
% goodSlices2=(10:15)';
% [ callq2,mt2star2,sfs2,tsnr2,st2star2]=findCorr( goodSlices2, bay8(:,1),mimg(:,:,:,1:795),angDeg-55+45,pi*0.2,[0.35 0.2]);
%%
figure(1)
cc=corr(sfs',abs(callq)');
plot(goodSlices,cc(1:(length(goodSlices)+1):end)','linewidth',2)
title('SFS Vs Fidelity correlation withint quarter')
xlabel('Slice #')
ylabel('correlation')
%%
figure(4)
scatter(sfs(:),abs(callq(:)),100,repmat((goodSlices),4,1),'filled')
colorbar
colormap jet
c=corrcoef(sfs(:),abs(callq(:)));
title(['correlation between fidelity and SFS without distortion = ' num2str(c(2,1))] )
ylabel('fidelity')
xlabel('SFS')
%% plot fit
xsfs=[20 80];
crit=(sfs<xsfs(2) & sfs >xsfs(1));
c=corrcoef(sfs(crit),abs(callq(crit)));
p=polyfit(sfs(crit),abs(callq(crit)),1);
hold on
plot(xsfs(1):xsfs(2),polyval(p,xsfs(1):xsfs(2)))
hold off
text(80,0.3,sprintf('slope %2.2d offset %2.2d',p))
title(['correlation between fidelity and SFS without distortion = ' num2str(c(2,1))] )

%% plot sequence
revSeq=reverseSeq(pinkSeq,[400 430],512*16);
plot(diff(revSeq'),'o-')

%% single slice analysis

[mt2stari,sfsi,tsnri, st2stari] =getStatBold3(img(:,:,35,:),angDeg-45,2,3,0,[-0.5 -0.5],pi*0.18,[0.4 0.3]); figure(3)

%% montage images
figure(9)
imgs=permute(img,[1 2 4 3]);
montage(imgs(:,:,10,:));
caxis([0 max(img(:))])
title('pink noise EPI')
%%
imagesc(img(:,:,17,105))
%% save data and figures

figdname=fullfile(dname,'plots');

mkdir(figdname)

figure(1)
savefig([figdname '/WithinSliceCorrFig'])

figure(2)
savefig([figdname '/SliceCorrFig'])

figure(3)
savefig([figdname '/MasksFig'])

figure(4)
savefig([figdname '/CorrFig'])


save([ dname '/seqRes.mat'],'callq','mt2star','sfs','tsnr','st2star','goodSlices','c','p')
