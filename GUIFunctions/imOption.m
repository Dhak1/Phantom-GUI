function [image, m ,handles] = imOption(handles)
% Update displayed image when Slider/Slice# is updated #stg#
currChoice = handles.currChoice;
handles = switchDetFilt(handles); %% #stg# problem!
volume = handles.volume; 
slice = handles.sliceNum;
w = size(handles.data, 1);
len= size(handles.data, 4);
sli = size(handles.data,3);
switch currChoice
    case 'One Image'
%         image = squeeze(handles.volume(:,:, slice, 10));
       % image = squeeze(handles.data(:,:, slice, 40));
        image = squeeze(handles.data(:,:, slice));
        m = max(max(image))/1;
    case 'Average'
        image = mean(handles.data(:,:, slice, :),4);
        m = max(max(image))/1;
    case 'StandDev'
%         image = mean(handles.data(:,:, slice, :),4);
        image = std(handles.data(:,:, slice, :),[],4);
        m = max(max(image))/5;
    case 'Beta-sig'
        im = squeeze(handles.data(:,:,slice, :));
        v = reshape(im, [w*w,len]);
        v = v';
        v = reshape(v, [len, w, w]);
        [image,rs] = phanBeta(v, handles.lpcut, handles.hpcut, handles.TR);
        m = max(max(image));
        handles.show = 1;
    case 'ACF B'
        image = phanACF(handles.data,slice, 8);
        m = max(max(image));
        handles.show = 1;
    case 'Corr - Interrupts'
        ints = handles.ints(:,2);
        image = abs(phanCorrBasic(volume,ints,slice));
        m = max(max(image));
    case 'Corr - Interslice (set range)'
        startS = handles.startSlice;
        endS = handles.endSlice;
        data = volume;
        cdata = squeeze(volume(:,:,:));
        image = phanCorrBasic(data,cdata,[startS,endS]);
        m = max(max(image));
end