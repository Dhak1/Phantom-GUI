function [ handles ] = updatePhanIm( handles ,resetSliderFlag)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

handles.data = handles.volume;
handles.slices = size(handles.volume,3);
handles.maskOverlay.Value=handles.mO;


if resetSliderFlag
    
handles.sliceNum = round(handles.slices/2);

set(findobj('Tag','sliceText'),'String',num2str(handles.sliceNum));% Update handles structure
set(findobj('Tag','sliceSlider'),'Max',handles.slices);
set(findobj('Tag','sliceSlider'),'Min',1);
set(findobj('Tag','sliceSlider'), 'SliderStep', [1/handles.slices, 10/handles.slices]);
set(findobj('Tag','sliceSlider'),'value',handles.sliceNum);
handles.trimmed = 0;
handles.startSlice = 1;
handles.endSlice = handles.slices;

set(findobj('Tag','startSlice'),'String','1')% Update handles structure
set(findobj('Tag','endSlice'),'String',handles.slices)% Update handles structure
set(findobj('Tag','currentSlice'),'String',handles.sliceNum)% Update handles structure

set(findobj('Tag','statusText'),'String','Loaded!')% Update handles structure
set(findobj('Tag','startTRtext'),'String',num2str(1))% Update handles structure
set(findobj('Tag','endTRtext'),'String',num2str(size(handles.volume,4)))% Update handles structure

end

axes(handles.imageAxis);
handles.image = squeeze(handles.volume(:,:, handles.sliceNum, 1));
imshow(handles.image,[0 max(max(squeeze(handles.volume(:,:, handles.sliceNum, 1))))]);

end

