function handles = showIntHelper(handles)
try
    mnts = handles.mnts;
end
if ~exist('mnts','var')
    return
end

switch handles.currChoice
    case 'Beta-sig'
        return
    case 'ACF B'
        return
end



i = handles.show;

if i == 0
    int = (handles.ints(:,2))*std(handles.mnts)+mean(handles.mnts(handles.ints(:,2) == 0));
    if handles.graph == 1
        r = corrcoef(smooth(smooth(int)), handles.mnts);
        r = r(2);
        if r < 0
            int = (-handles.ints(:,2)*std(handles.mnts))+mean(handles.mnts(handles.ints(:,2) == 0));
        end
    end

    axes(handles.graphAxis);
    hold on;
    plot(smooth(smooth(int)),'-')
    hold off;
    if handles.graph == 1
        
        set(findobj('Tag','corrInt'),'String',['Correlation: ',num2str(round((r)*10000)/10000)]);
    end
else
    cla;
    axes(handles.graphAxis)
    if  handles.graph == 1
        handles.curGrap = plot(handles.mnts);
        try
            legend(handles.maskLegend, 'FontSize',10);
        end
%         title(['Coordinates X: ', num2str(handles.coor(1)), ' Y: ' , num2str(handles.coor(2))])
    end
    set(findobj('Tag','corrInt'),'String',[' ']);

end
clear tag