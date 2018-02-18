function handles = dynFidelityCorrelation(handles)
% Calculate pearson correlation coefficents 
% Last edited 01/25/2018 #danihak#


% if handles.corr == 1
handles.tSNRbut = 0;
handles.SFSbut = 0;
set(findobj('Tag','SFSTable'),'Visible','Off')
set(findobj('Tag','tSNRTable'),'Visible','Off')
set(findobj('Tag','tSNR'),'Value',0)
set(findobj('Tag','SFS'),'Value',0)

try
    res = handles.Results.DynFidelity;
end

if exist('res','var')

    try
        
        %     R = array2table(r,'RowNames',handles.maskLegend);
        %     R.Properties.VariableNames = handles.maskLegend;
        set(findobj('Tag','corrTitle'),'String','Fidelity');
        set(findobj('Tag','corrTitle'),'Visible','On');
        set(findobj('Tag','matAxis'),'Visible','On');
        axes(handles.matAxis);
        cla
        set(gca, 'ColorOrder', handles.mOcolors)
        hold on
        plot(handles.rangeNum,abs(res.quadCorrRs),'Linewidth',2)
        hold off
        xlabel('slice #')
        ylabel('Fidelity')
        set(gca,'XTickMode','auto','YTickMode','auto','XTickLabelMode','auto','YTickLabelMode','auto')
        set(gca,'XColor',[ 1 1 1],'YColor', [ 1 1 1])
        %legend(handles.maskLegend)
        
    catch
        fprintf('\nNo Mask Specified\n')
        set(findobj('Tag','corrTitle'),'Visible','Off');
        set(handles.matAxis,'Visible','Off');
        set(get(handles.matAxis,'children'),'Visible','Off');
        colorbar(handles.matAxis,'off');
    end
    set(findobj('Tag','Table'),'Visible','Off');
end

    
% else
%     set(findobj('Tag','corrTitle'),'Visible','Off');
%     set(handles.matAxis,'Visible','Off');
%     set(get(handles.matAxis,'children'),'Visible','Off');
%     colorbar(handles.matAxis,'off');
%     %         set(findobj('Tag','corrTable'),'Visible','Off');
% end

