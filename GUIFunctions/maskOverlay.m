function handles  = maskOverlay( handles )
% As name suggests #stg#
% Last edited 08/02/2016 #stg#
% Now can handle all masks part of the 'handles.mask' variable; expects
% mask index in the 3rd dimension

%   Detailed explanation goes here
[image,~,~] = imOption(handles);
if handles.mO ==1
    axes(handles.imageAxis);
    %cla
    hold on
    numMasks = size(handles.mask,3);
    if numMasks>size(handles.mOcolors,1)
        handles.mOcolors = repmat(handles.mOcolors,ceil(numMasks/size(handles.mOcolors,1)),1)
    end
    for iMask = 1:numMasks
%         handles.maskLegend{iMask} = ['Mask #: ' num2str(iMask)];
        handles.redBack = cat(3,  handles.mOcolors(iMask,1)*ones(size(handles.image)), handles.mOcolors(iMask,2)*ones(size(handles.image)), handles.mOcolors(iMask,3)*ones(size(handles.image)));
        overlayBack = imshow(handles.redBack);
        try
            set(overlayBack,'AlphaData',handles.mask(:,:,handles.sliceNum)*(.3))
        catch
            try
                set(overlayBack,'AlphaData',handles.mask(:,:,iMask)*(.3))
            catch
                set(overlayBack,'AlphaData',handles.mask(:,:)*(.3))
            end
        end
    end
    hold off
else
    axes(handles.imageAxis);
    cla
    imshow(image,[0 max(max(squeeze(handles.volume(:,:,1))))])
end

end

