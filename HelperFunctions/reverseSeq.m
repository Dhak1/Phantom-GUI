function revSeqScaled=reverseSeq(tgtPos,boldValues,deadZone)
d=128-deadZone';
p=tgtPos*pi/256;
rng=[-d/2 d/2]*pi/256;

revSeq=abs(cos(p));%+cos(pi/4);
revSeq=acos(revSeq)-pi/4;
revSeqScaled=interp1(rng,boldValues,revSeq,'linear');
revSeqScaled(revSeq<rng(1))=boldValues(1);
revSeqScaled(revSeq>rng(2))=boldValues(2);


% subplot(2,1,1)
% %plot(p,'.')
% plot(cseq)
% subplot(2,1,2)
% plot(revSeqScaled-cseq,'.')
end

