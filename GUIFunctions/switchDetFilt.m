function handles = switchDetFilt(handles)
% Reads trim/filter/detrend state to update mean TS graph

fT = handles.fT;
dT = handles.dT;
s = handles.sliceNum;
switch fT
    case 0
        switch dT
            case 0
                switch handles.trimState
                    case 0
                        handles.volume = handles.data(:,:,s,handles.startTR:handles.endTR);
                    case 1
                        handles.volume = handles.data(:,:,s,handles.startTR:handles.endTR);
        
                end
            case 1
                handles.dT = 0;
                handles.volume = sq(handles.data(:,:,s,handles.startTR:handles.endTR));
                handles = phanDetrend(handles);
                handles.volume = handles.datad;
                handles.dT = 1;
        end
    case 1
        handles.fT = 0;
        handles.volume = sq(handles.data(:,:,s,handles.startTR:handles.endTR));
        handles = phanFilt(handles);
        handles.volume = handles.dataf;
        handles.fT = 1;
        
end
handles.volume = squeeze(handles.volume);
handles.ints = handles.intsraw(handles.startTR:handles.endTR,:);