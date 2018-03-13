%% cartridge #4 12-20-17
fname='gre2D_128matrix.nii';
img=nii_tool('load',fname);
T2Data= img.img;
TEs=  5:5:60 ;
%TEs = 5:5:60; % Echo times in T2*-weighted image
[t2starmap] = mapT2star(T2Data,TEs);
%%
i=18;
[t2star_s,cross_mask,angDeg,center,radius] = registerSpokesT2s(  t2starmap,i,[5 12]);
figure(1);imshowpair(t2star_s(:,:,i),[0 80]);maskOverlay_simple(im2bw(cross_mask));
%c=getMaskStat( t2starmap2(:,:,:),angDeg,center,radius,0,0 );

%% analyze areas

[mt2stari,sfsi,tsnri, st2stari] =getStatBold3(img(:,:,14,:),angDeg+45,2,3,0,[-0.5 -0.5],pi*0.15); figure(3)

%% montage images
figure(9)
imgs=permute(img,[1 2 4 3]);
montage(imgs(:,:,10,:));
caxis([0 max(img(:))])
title('pink noise EPI')
%% pink noise  not multi band 
scanName='ep2d_bold_3mm_TR2s_155meas_11';
nii=nii_tool('load', [ scanName '.nii']);
img=double(nii.img);
load('dcmHeaders.mat')
scanName='ep2d_bold_3mm_TR2s_155meas';
timing=h.(scanName).MosaicRefAcqTimes;
l=length(timing);
sprintf('TE  =  %d ,  TR = %d , #Slices = %d' ,  h.(scanName).EchoTime, ...
    h.(scanName).RepetitionTime , size(timing,1))
%%
figure(1)
plot(1:l,timing,'o',[1 l],[300 300],'r')
title('timing all points under line are in motion')
%%
% slice selection
goodSlices2=(4:20)';
[ callq2,mt2star2,sfs2,tsnr2,st2star2]=findCorr( goodSlices2, pink(:,2), pink(:,1),pink(:,1),img(:,:,:,:),angDeg+45);
%%
figure(7)
scatter(sfs2(:),abs(callq2(:)),100,repmat((goodSlices2),4,1),'filled')
colorbar
colormap jet
c=corrcoef(sfs2(:),abs(callq2(:)));
title(['correlation between fidelity and SFS without distortion = ' num2str(c(2,1))] )
ylabel('fidelity')
xlabel('SFS')



%%  filter bubbles


m=squeeze(mean(mt2star2(:,1:4,:)))';
qchange2 = abs((m-mean(m,2))./m);

qchange = qchange2;
crit=qchange(:)<0.1;
%%
figure(6)
plot(sfs2(crit),abs(callq2(crit)),'o')
colorbar
colormap jet
c=corrcoef(sfs2(crit),abs(callq2(crit)));
title(['correlation between fidelity and SFS without distortion = ' num2str(c(2,1))] )
ylabel('fidelity')
xlabel('SFS')

