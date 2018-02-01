function handles = sliderHelper(handles)
% Update (mean) time-series when Slider/Slice# is updated. #stg#
% Last edited 08/04/2016 #stg#

range = handles.rangeNum;
fT = handles.fT;
dT =handles.dT;

% handles = switchDetFilt(handles);
slice = handles.sliceNum;
show = handles.show;
% x = handles.coor(1);
% y = handles.coor(2);
try
    mask = handles.mask;
    dynFidelityRes=handles.Results.DynFidelity;
end

% Here, if ive selected a ts to observe, I want to be able to move the
% slider and see the ts over slices.
if ~exist('mask','var') || ~handles.isCoordsData 
    mnts=0;
    % [mnts, mask] = tsClick2(handles, handles.sliceNum, handles.rangeNum);
elseif exist('dynFidelityRes','var')
    mnts=handles.Results.DynFidelity.mnts(:,:,handles.sliceNum);
else
    [mnts, mask] = tsClick2(handles, handles.sliceNum, handles.rangeNum,mask);
end
if length(mnts)>1 
    axes(handles.graphAxis);
    set(gca,'XTickMode','auto','YTickMode','auto','XTickLabelMode','auto','YTickLabelMode','auto')
    
    hold off;
    set(findobj('Tag','corrInt'),'String',[' ']);
    switch handles.currChoice
        case 'One Image'
            set(gca, 'ColorOrder', handles.mOcolors, 'NextPlot', 'replacechildren')
            handles.curGrap = plot(mnts); axis([handles.startTR 1.01*handles.endTR 0.9*min(mnts(:)) 1.1*max(mnts(:))]);
            x = 1;
            try
                maskLegend = handles.maskLegend(1:size(mask,3));
                legend(maskLegend, 'FontSize',10);
            end
        case 'Average'
            handles.curGrap = plot(mnts);
        case 'StandDev'
            handles.curGrap = plot(mnts);
        case 'Beta-sig'
            handles.curGrap = phanBeta(mnts,0.01, 0.1, 2.0, 1);
        case 'ACF B'
            handles.curGrap = acfPlot(mnts, handles.TR);
            handles.show = 0;
        case 'Corr - Interrupts'
            handles.curGrap = plot(mnts);
        case 'Corr - Interslice (set range)'
            handles.curGrap = plot(mnts);
    end
    % title(['Coordinates X: ', num2str(handles.coor(1)), ' Y: ' , num2str(handles.coor(2))])
    handles.mnts = mnts;
    handles.mask = mask;
    handles = quadCorrelation(handles);
    handles = tSNR(handles);
    handles = sfs(handles);
    handles = showIntHelper(handles);
else
    axes(handles.graphAxis);cla;
    set(gca,'XTickLabel',[],'YTickLabel',[])
    legend([])
    hold off;
end

