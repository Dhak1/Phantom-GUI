function [ seqDeg ] = writeSeq( seqDeg,fname ,tstep)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
seq=seqDeg;
seqDeg(seqDeg<0)=360+seqDeg(seqDeg<0);

Nump=length(seqDeg);
T = 1:tstep:Nump;
tbl = table(T(:), seqDeg(:));
%%
figure(1)
subplot(3,1,1)
plot(T,seq,'.')
subplot(3,1,2)
plot(T,seqDeg,'.')
subplot(3,1,3)
plot(acosd(cosd(seqDeg)),'.-')
%%
writetable(tbl,[fname '.xls'])
end

