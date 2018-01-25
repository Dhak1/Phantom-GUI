function [handles] = tSNR(handles)
%Last edited 08/04/2016 #stg#
% If no mask previously chosen, this skips to roipoly



if handles.tSNRbut == 1
    set(findobj('Tag','corrTitle'),'Visible','Off');
    set(handles.matAxis,'Visible','Off');
    set(get(handles.matAxis,'children'),'Visible','Off');
    colorbar(handles.matAxis,'off');
    set(findobj('Tag','Correlation'),'Value',0)
    handles.corr = 0;
    try
        mnts = handles.mnts;
    end
    try
        mask = handles.mask;
    end
    
    if ~exist('mnts','var')
        handles = sliderHelper(handles);
        %{
&& ~exist('mask','var')
        [mnts, mask] = tsClick2(handles, handles.sliceNum, handles.rangeNum);
        x=1
    elseif ~exist('mnts','var') && exist('mask','var')
        [mnts, mask] = tsClick2(handles, handles.sliceNum, handles.rangeNum);
        x=2
        %}
    end
    
    handles.tSNR = mean(handles.mnts)./std(detrend(handles.mnts));
    
    set(findobj('Tag','tSNRTable'),'RowName','tSNR')
    set(findobj('Tag','tSNRTable'),'Visible','On','Data',cellstr(num2str(round(handles.tSNR',2)))')
    
    fprintf(['\nSlice: %d\n'], handles.sliceNum)
    tSNR = array2table(handles.tSNR);
    
    
    try
        set(findobj('Tag','tSNRTable'),'ColumnName',handles.maskLegend)
        tSNR.Properties.VariableNames = handles.maskLegend
        
    catch
        set(findobj('Tag','tSNRTable'),'ColumnName','ROI')
        tSNR.Properties.VariableNames = {'ROI'}
    end
    
else
    set(findobj('Tag','tSNRTable'),'Visible','Off')
end

