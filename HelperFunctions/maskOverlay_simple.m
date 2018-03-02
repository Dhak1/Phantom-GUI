function mOcolors = maskOverlay_simple(masks)

numMasks = size(masks,3);

mOcolorSet = [1 0 0; 0 1 0; 0 0 1; 1 0.5 0]; %Mask overlay colors

if numMasks < size(mOcolorSet,1)
    mOcolors = mOcolorSet;
else
    for iSet = 1:ceil(numMasks/4)
        mOcolors((iSet-1)*4 +(1:4),:) = mOcolorSet;
    end
end

hold on
for iMask = 1:numMasks
    colorBack = cat(3,  mOcolors(iMask,1)*ones(size(masks(:,:,iMask))), ...
        mOcolors(iMask,2)*ones(size(masks(:,:,iMask))), ...
        mOcolors(iMask,3)*ones(size(masks(:,:,iMask))));
    overlayBack = imshow(colorBack);
    set(overlayBack,'AlphaData',masks(:,:,iMask)*(.3))
    clear colorBack
end

hold off
end