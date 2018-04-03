function [ callq,mt2star,sfs,tsnr,st2star] = findCorr( staticSlices, curPos,img,angDeg )
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
BubbleMapFlag=0;
%goodSlices=10:26;
%indStatic=timing(goodSlices)<1500;
%indStatic=timing(goodSlices)<500 & timing(goodSlices) >0;
%indStatic=timing(goodSlices)<3500;
boldActual=reverseSeq(curPos,[6000 7000],512*16);


getStatBold3(img(:,:,floor(mean(staticSlices)),:),angDeg,1,3,BubbleMapFlag,[-0.5 -0.5],pi*0.15);

% plot([boldExpected(:)  boldActual(:)])
% legend('bold expected','bold actual')
% title('recreated bold from targets')



%% get bold values from images
%staticSlices=goodSlices(indStatic);
l=length(staticSlices);
for ii=1:l
      % [mt2star(:,:,ii),innerCylinder, center(:,ii), radius(:,ii)] =getMeanBold(img,staticSlices(ii),angDeg,0,3,CreateMapFlag);
      [mt2star(:,:,ii),sfs(ii,:) , tsnr(ii,:),st2star(ii,:)] =getStatBold3(img(:,:,staticSlices(ii),:),angDeg,0,3,BubbleMapFlag,[-0.5 -0.5],pi*0.15);
end

%%
for k=1:l
    for i=1:4
        m=squeeze(mt2star(:,i,k));
        cc=corrcoef(m,boldActual);
        callq(k,i)=cc(2,1);
    end
end



%%
figure(2)

clf
set(gca,'ColorOrder',[1 0 0; 0 1 0; 0 0 1; 1 1 0])
hold all
plot(staticSlices,abs(callq),'o-','LineWidth',2)
leg = {'mask 1','mask 2','mask 3','mask 4'};
legend(leg)
title(' correlation with expected signal')
xlabel('slice #')
ylabel('correlation')
hold off
