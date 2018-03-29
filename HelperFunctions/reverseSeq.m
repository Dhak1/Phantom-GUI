function revSeqScaled=reverseSeq(tgtPos,boldValues,cPerCycle)
seqDeg=tgtPos*360/cPerCycle;

revSeq=seqDeg;
revSeq(seqDeg>180)=seqDeg(seqDeg>180)-360;


rng=[-27 27]; %range of mask in Deg


revSeqScaled=interp1(rng,boldValues,revSeq,'linear');
revSeqScaled(revSeq<rng(1))=boldValues(1);
revSeqScaled(revSeq>rng(2))=boldValues(2);


% subplot(2,1,1)
% %plot(p,'.')
% plot(cseq)
% subplot(2,1,2)
% plot(revSeqScaled-cseq,'.')
end

