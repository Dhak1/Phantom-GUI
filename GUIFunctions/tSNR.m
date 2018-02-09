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
    try
        res = handles.Results.DynFidelity;
    end
    
    if exist('res','var')
        handles.tSNR = handles.Results.DynFidelity.tsnr(handles.sliceNum,:);
        set(findobj('Tag','corrTitle'),'String','tSNR vs fidelity');
        set(findobj('Tag','corrTitle'),'Visible','On');
        set(findobj('Tag','matAxis'),'Visible','On');
        axes(handles.matAxis);
        
        quadCorrRs=handles.Results.DynFidelity.quadCorrRs(:,1:length(handles.tSNR));
        plot(res.tsnr,abs(quadCorrRs),'o')
        xlabel('tSNR')
        ylabel('fidelity')
        
        set(gca,'XTickMode','auto','YTickMode','auto','XTickLabelMode','auto','YTickLabelMode','auto')
        set(gca,'XColor',[ 1 1 1],'YColor', [ 1 1 1])
        legend(handles.maskLegend)
    elseif ~exist('mnts','var')
        handles = sliderHelper(handles);
        handles.tSNR = mean(handles.mnts)./std(detrend(handles.mnts));
        %{
&& ~exist('mask','var')
        [mnts, mask] = tsClick2(handles, handles.sliceNum, handles.rangeNum);
        x=1
    elseif ~exist('mnts','var') && exist('mask','var')
        [mnts, mask] = tsClick2(handles, handles.sliceNum, handles.rangeNum);
        x=2
        %}
    else
        handles.tSNR = mean(handles.mnts)./std(detrend(handles.mnts));

    end
    

    
    set(findobj('Tag','Table'),'RowName','tSNR')
    set(findobj('Tag','Table'),'Visible','On','Data',cellstr(num2str(round(handles.tSNR',2)))')
    
    fprintf(['\nSlice: %d\n'], handles.sliceNum)
    tSNR = array2table(handles.tSNR);
    
    
    try
        set(findobj('Tag','Table'),'ColumnName',handles.maskLegend)
        tSNR.Properties.VariableNames = handles.maskLegend;
        
    catch
        set(findobj('Tag','Table'),'ColumnName','ROI')
        tSNR.Properties.VariableNames = {'ROI'};
    end
    
else
   % set(findobj('Tag','Table'),'Visible','Off')
end

