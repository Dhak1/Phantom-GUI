function [mnts, mask]  = tsClick2(handles, slice, range, mask)
% Getting mean Time-Series within ROI mask
% Uses roipoly or ginput to specify ROI or single voxel TS is no input mask
% is specified
% Last edited 08/04/2016 #stg#

try
    mask = handles.mask;
end

if ~exist('mask','var')
    axes(handles.imageAxis)
    handles.mO = 0;
    maskOverlay(handles);
    handles.image = squeeze(handles.data(:,:,handles.sliceNum,1));
    bw = roipoly;
    state = 'mask';
    handles.mO = 1;
elseif exist('mask','var') && length(mask) > 2;
    bw = handles.mask;
    state = 'mask';
else
    handles.mO = 0;
    maskOverlay(handles);
    [y x] = ginput(1);
    x = floor(x)+1;
    y = floor(y)+1;
    state = 'coor';
    handles.mO = 1;
end



switch handles.trimState
    case 1
        handles = switchDetFilt(handles);
    case 0
end

vol = handles.volume;
if strcmp(state, 'mask') == 1
    numMasks = size(bw,3);
    for iMask = 1:numMasks
        temp = reshape(vol,[size(vol,1)*size(vol,2) size(vol,3)]);
        temp = temp(find(bw(:,:,iMask)),:);
        mnts(:,iMask) = mean(temp);
    end
    
    if ~exist('mask','var')
        mask = reshape(bw, [size(vol,1), size(vol,2)]);
    else
    end
else
    mnts = squeeze(vol(x,y,:));
    mask = zeros(size(vol,1), size(vol,2));
    mask(x, y) = 1;
end

handles.mnts = mnts;
handles.mask = mask;
maskOverlay(handles);
