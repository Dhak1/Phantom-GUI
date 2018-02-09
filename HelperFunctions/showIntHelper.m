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

minmt=mean(min(handles.mnts));
maxmt=mean(max(handles.mnts));
curPos=handles.ints(:,2);
boldExpexcted=reverseSeq(curPos,[minmt maxmt],0);
showFlag = handles.show;

if showFlag == 0
    %smnt=std(handles.mnts);
    %mmnt=mean(handles.mnts);
    
   % int = (handles.ints(:,2))*std(handles.mnts)+mean(handles.mnts(handles.ints(:,2) == 0));
   % int = (handles.ints(:,2)-64)*smnt+mmnt;
   if handles.graph == 1
       for ii=1:4
           rr = corrcoef(boldExpexcted, handles.mnts(:,ii));
           r(ii) = rr(2);
       end
%         if r < 0
%             %int = (-handles.ints(:,2)*std(handles.mnts))+mean(handles.mnts(handles.ints(:,2) == 0));
%             %int = -(handles.ints(:,2)-64)*smnt+mmnt;
%                 
%         end
    end

    axes(handles.graphAxis);
    hold on;
    plot(boldExpexcted,'-')
    hold off;
    if handles.graph == 1
        
        set(findobj('Tag','corrInt'),'String',['Correlation: ',num2str(round((r)*10000)/10000)]);
    end
else
        axes(handles.graphAxis)
    cla;

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