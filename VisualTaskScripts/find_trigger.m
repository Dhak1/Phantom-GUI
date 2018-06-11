
% get keyboard information  
[i j]=GetKeyboardIndices;  
% KB = i(find(strcmp(j,'Apple Internal Keyboard / Trackpad')));  
%KB = i(find(strcmp(j,'932'))); %'Apple Internal Keyboard / Trackpad')));  
%KB = i(find(strcmp(j,'USB Compliant Keypad'))); %'Apple Internal Keyboard / Trackpad')));  
%KB = i(find(strcmp(j,'Apple Internal Keyboard / Trackpad')));
%KB=i(find(strcmp(j,'P.I. Engineering Xkeys'))) %% CHANGE THIS  'P.I. Engineering Xkeys'
KB=4;

pressed=0;
while (1)
    while ~pressed
        pause(0.005);
        [test firstpress]=KbQueueCheck(KB);
        %if ismember(ScanTrigger,find(firstpress))
        if sum(firstpress)
            pressed=1;
        end
    end
     disp(find(firstpress))
     pressed=0;
end