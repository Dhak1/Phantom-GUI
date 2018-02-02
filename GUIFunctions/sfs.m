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
    try
        res = handles.Results.DynFidelity;
    end
    
    if exist('res','var')
        SFS = handles.Results.DynFidelity.sfs(handles.sliceNum,:);
        set(findobj('Tag','corrTitle'),'String','SFS vs fidelity');
        set(findobj('Tag','corrTitle'),'Visible','On');
        set(findobj('Tag','matAxis'),'Visible','On');
        axes(handles.matAxis);
        
        quadCorrRs=handles.Results.DynFidelity.quadCorrRs(:,1:length(SFS));
        plot(res.sfs,abs(quadCorrRs),'o')
        xlabel('SFS')
        ylabel('fidelity')
        
        set(gca,'XTickMode','auto','YTickMode','auto','XTickLabelMode','auto','YTickLabelMode','auto')
        set(gca,'XColor',[ 1 1 1],'YColor', [ 1 1 1])
        legend(handles.maskLegend)
    elseif ~exist('mnts','var') && ~exist('mask','var')
        [mnts, mask] = tsClick2(handles, handles.sliceNum, handles.rangeNum);
        SFS = 100*(mean(mnts).*std(detrend(mnts)))./(mean((mean(mnts,2)))*std(detrend(mnts(:,size(mnts,2)))));
    elseif ~exist('mnts','var') && exist('mask','var')
        [mnts, mask] = tsClick2(handles, handles.sliceNum, handles.rangeNum);
        SFS = 100*(mean(mnts).*std(detrend(mnts)))./(mean((mean(mnts,2)))*std(detrend(mnts(:,size(mnts,2)))));
    else
        SFS = 100*(mean(mnts).*std(detrend(mnts)))./(mean((mean(mnts,2)))*std(detrend(mnts(:,size(mnts,2)))));
    end
    
    
    set(findobj('Tag','Table'),'RowName','SFS')
    set(findobj('Tag','Table'),'Visible','On','Data',cellstr(num2str(round(SFS',2)))')
    
    fprintf(['\nSlice: %d\n'], handles.sliceNum)
    SFSt = array2table(SFS);
    
    try
        set(findobj('Tag','Table'),'ColumnName',handles.maskLegend)
        SFSt.Properties.VariableNames = handles.maskLegend(1:length(SFS));
        
    catch
        set(findobj('Tag','Table'),'ColumnName','ROI')
        SFSt.Properties.VariableNames = {'ROI'};
    end
    
    handles.mask = mask;
    handles.mnts = mnts;
    
else
   % set(findobj('Tag','Table'),'Visible','Off')
end

