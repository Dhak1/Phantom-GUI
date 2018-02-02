function handles = dynFidelityCorrelation(handles)
% Calculate pearson correlation coefficents 
% Last edited 01/25/2018 #danihak#

sliceRange=handles.rangeNum;
l=length(sliceRange);

minmt=mean(min(handles.mnts));
maxmt=mean(max(handles.mnts));
curPos=handles.ints(:,2);
boldExpexcted=reverseSeq(curPos,[minmt maxmt],0);
mnts = handles.Results.DynFidelity.mnts;

% if handles.corr == 1
handles.tSNRbut = 0;
handles.SFSbut = 0;
set(findobj('Tag','SFSTable'),'Visible','Off')
set(findobj('Tag','tSNRTable'),'Visible','Off')
set(findobj('Tag','tSNR'),'Value',0)
set(findobj('Tag','SFS'),'Value',0)
try
    % caculate coefficientfor all slices
    for ii=1:l
        for kk=1:size(handles.mask,3)
            [cc,pp] = corrcoef(boldExpexcted,mnts(:,kk,ii));
            r(ii,kk)=cc(2);
            p(ii,kk)=pp(2);
        end
    end
%     R = array2table(r,'RowNames',handles.maskLegend);
%     R.Properties.VariableNames = handles.maskLegend;
    
    set(findobj('Tag','corrTitle'),'Visible','On');
    set(findobj('Tag','matAxis'),'Visible','On');
    axes(handles.matAxis);
    
    plot(handles.rangeNum,abs(r),'Linewidth',2)
    set(gca,'XTickMode','auto','YTickMode','auto','XTickLabelMode','auto','YTickLabelMode','auto')
    set(gca,'XColor',[ 1 1 1],'YColor', [ 1 1 1])
    legend(handles.maskLegend)
    handles.quadCorrRs = r;
    handles.quadCorrPs = p;
catch
    fprintf('\nNo Mask Specified\n')
    set(findobj('Tag','corrTitle'),'Visible','Off');
    set(handles.matAxis,'Visible','Off');
    set(get(handles.matAxis,'children'),'Visible','Off');
    colorbar(handles.matAxis,'off');
end

    
% else
%     set(findobj('Tag','corrTitle'),'Visible','Off');
%     set(handles.matAxis,'Visible','Off');
%     set(get(handles.matAxis,'children'),'Visible','Off');
%     colorbar(handles.matAxis,'off');
%     %         set(findobj('Tag','corrTable'),'Visible','Off');
% end

