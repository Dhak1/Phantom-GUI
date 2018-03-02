function [ callq,mt2star,sfs,tsnr,st2star] = findCorr( staticSlices, tgtPos, curPos,boldExpected,img,angDeg )
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
CreateMapFlag=0;
%goodSlices=10:26;
%indStatic=timing(goodSlices)<1500;
%indStatic=timing(goodSlices)<500 & timing(goodSlices) >0;
%indStatic=timing(goodSlices)<3500;
boldActual=reverseSeq(curPos+64,[6225 6725],0);


getStatBold3(img(:,:,floor(mean(staticSlices)),:),angDeg,1,3,CreateMapFlag,[-0.5 -0.5],pi*0.15);

% plot([boldExpected(:)  boldActual(:)])
% legend('bold expected','bold actual')
% title('recreated bold from targets')



%% get bold values from images
%staticSlices=goodSlices(indStatic);
l=length(staticSlices);
for ii=1:l
      % [mt2star(:,:,ii),innerCylinder, center(:,ii), radius(:,ii)] =getMeanBold(img,staticSlices(ii),angDeg,0,3,CreateMapFlag);
      [mt2star(:,:,ii),sfs(ii,:) , tsnr(ii,:),st2star(ii,:)] =getStatBold3(img(:,:,staticSlices(ii),:),angDeg,0,3,CreateMapFlag,[-0.5 -0.5],pi*0.15);
end


%%

leg = {'Red','Green','Blue','Yellow'};

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
plot(staticSlices,abs(callq),'o-','LineWidth',2)
legend(leg)
title(' correlation with expected signal')
xlabel('slice #')
ylabel('correlation')