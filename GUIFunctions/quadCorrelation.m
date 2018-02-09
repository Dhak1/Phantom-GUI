function handles = quadCorrelation(handles)
% Calculate pearson correlation coefficents 
% Last edited 01/25/2018 #danihak#

clc



if handles.corr == 1
    handles.tSNRbut = 0;
    handles.SFSbut = 0;
    set(findobj('Tag','SFSTable'),'Visible','Off')
    set(findobj('Tag','tSNRTable'),'Visible','Off')
    set(findobj('Tag','tSNR'),'Value',0)
    set(findobj('Tag','SFS'),'Value',0)
    try
        % caculate coefficients
        [r,p] = corrcoef(handles.mnts);
        
        fprintf(['\nSlice: %d\n'], handles.sliceNum)
        R = array2table(r,'RowNames',handles.maskLegend);
        R.Properties.VariableNames = handles.maskLegend;
        
        set(findobj('Tag','corrTitle'),'Visible','On');
        set(findobj('Tag','matAxis'),'Visible','On');
        imagesc(r,'Parent',handles.matAxis);
        set(handles.matAxis,'xtick',[1:size(handles.mnts,2)], ...
            'ytick',[1:size(handles.mnts,2)],'yticklabel',[1:size(handles.mnts,2)], ...
            'XColor',[1 1 1], 'YColor',[1 1 1], ...
            'XAxisLocation','top', ...
            'FontWeight','bold','FontSize',12)
        colormap(handles.matAxis,'jet')
        caxis(handles.matAxis,[-1 1])
        c = colorbar(handles.matAxis);
        set(c,'color','white','Location','westoutside')
        handles.quadCorrRs = r;
        handles.quadCorrPs = p;
    catch
        fprintf('\nNo Mask Specified\n')
        set(findobj('Tag','corrTitle'),'Visible','Off');
        set(handles.matAxis,'Visible','Off');
        set(get(handles.matAxis,'children'),'Visible','Off');
        colorbar(handles.matAxis,'off');
    end
    
    
else
%     set(findobj('Tag','corrTitle'),'Visible','Off');
%     set(handles.matAxis,'Visible','Off');
%     set(get(handles.matAxis,'children'),'Visible','Off');
%     colorbar(handles.matAxis,'off');
    %         set(findobj('Tag','corrTable'),'Visible','Off');
end

