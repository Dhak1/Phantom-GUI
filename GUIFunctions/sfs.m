function [handles] = sfs(handles)
%Last edited 08/04/2016 #stg#


if handles.SFSbut == 1
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
    
    if ~exist('mnts','var') && ~exist('mask','var')
        [mnts, mask] = tsClick2(handles, handles.sliceNum, handles.rangeNum);
        x=1
    elseif ~exist('mnts','var') && exist('mask','var')
        [mnts, mask] = tsClick2(handles, handles.sliceNum, handles.rangeNum);
        x=2
    end
    
    handles.SFS = 100*(mean(mnts).*std(detrend(mnts)))./(mean((mean(mnts,2)))*std(detrend(mnts(:,size(mnts,2)))));
    
    set(findobj('Tag','SFSTable'),'RowName','SFS')
    set(findobj('Tag','SFSTable'),'Visible','On','Data',cellstr(num2str(round(handles.SFS',2)))')
    
    fprintf(['\nSlice: %d\n'], handles.sliceNum)
    SFS = array2table(handles.SFS);
    
    try
        set(findobj('Tag','SFSTable'),'ColumnName',handles.maskLegend)
        SFS.Properties.VariableNames = handles.maskLegend
        
    catch
        set(findobj('Tag','SFSTable'),'ColumnName','ROI')
        SFS.Properties.VariableNames = {'ROI'}
    end
    
    handles.mask = mask;
    handles.mnts = mnts;
    
else
    set(findobj('Tag','SFSTable'),'Visible','Off')
end

