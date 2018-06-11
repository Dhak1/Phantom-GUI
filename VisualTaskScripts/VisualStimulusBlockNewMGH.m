function VisualStimulusBlock(Grayperiod,Nblocks,OnDur,OffDur,EndDur,viewfield,TR,dotsize) 
% function VisualStimulusBlock(Grayperiod,Nblocks,OnDur,OffDur,viewfield,TR,dotsize) 
% 
% Block design visual stimulus, modified from Laura's oscillation task 
% 
% -- input: Grayperiod: baseline, prior to the stimulus onset (in seconds) 
%           Nblocks: number of blocks  
%           OnDur: the duration of stimulus within each block  
%      ===3=3===3====3     OffDur: the duration of off period within each block  
%           viewfield: 'left', left half viewfield; 
%                      'right', right half viewfield;  1
%                      'full', full viewfield  
%           TR: TR  
%           dotsize: the size of red dots  

% example VisualStimulusBlock(20,6,8,18,6,'full',0.8,20)  
          
%% set up saving path  
fpath='/Users/hstrey/Documents/fMRI/'; 
c=clock;
fname=sprintf('%sVB_%02.0f-%02.0f-%02.0f_%02.0f-%02.0f-%02.0f.mat',fpath,c);
mname=sprintf('%sVB_%02.0f-%02.0f-%02.0f_%02.0f-%02.0f-%02.0f.m',fpath,c);

%% initialization parameters  
MaxLum = 1;  
MinLum = 0;  
LumContrast = 0.80;  

% get the task paradigm   
Tdt = 1;  
Task = [zeros(Grayperiod,1); repmat([ones(OnDur,1); zeros(OffDur,1)], Nblocks, 1); zeros(EndDur,1)];  

%%   
FlipFreq = 12;  
TaskFlip = repmat(Task(:),1,round(FlipFreq*Tdt/2))';  
TaskFlip = [TaskFlip(:) TaskFlip(:)*2]';
TaskFlip = TaskFlip(:);  

TotalDur = length(Task); %+60*4;  
% TotalDur = 15+30*6+60*4; 
ScanTrigger = 46;  

fprintf('Total Duration is %d s, %d frames', TotalDur, fix((TotalDur)/TR)) 

% get keyboard information  
[i j]=GetKeyboardIndices;  
% KB = i(find(strcmp(j,'Apple Internal Keyboard / Trackpad')));  
KB = i(find(strcmp(j,'Xkeys'))); %'Apple Internal Keyboard / Trackpad')));  

% KB=i(find(strcmp(j,'USB Receiver'))) %% CHANGE THIS  'P.I. Engineering Xkeys'

%% set up screens  
screens = Screen('Screens');
whichScreen = max(screens);
[window,windowRect] = Screen(whichScreen, 'OpenWindow'); 
topPriorityLevel = MaxPriority(window);
Priority(topPriorityLevel);
measifi = Screen('GetFlipInterval', window);
Priority(0);

% check the flip frequency  
ifi=1/60;
if abs(ifi-measifi)>0.1
    disp('Warning: check IFI values');
end  

%% make colors and plot gray  
owhite = WhiteIndex(window); % pixel value for white
oblack = BlackIndex(window); % pixel value for black
white=oblack+(owhite-oblack)*MaxLum;
black=oblack+(owhite-oblack)*MinLum;

%% make textures  
% checkerboard  
imsize=2000;
l=linspace(-1,1,imsize);
[x,y] = meshgrid(l,l);

spacing_radial=6;
spacing_concentric=10;

I_radial= sin( ((((sqrt(x.^2+y.^2).^0.3)*2*pi)+0)*spacing_radial) );
I_concentric = sin( atan2(x,y)*spacing_concentric );

checks=sign(I_radial).*sign(I_concentric);
checks=(checks+1)/2;  

switch viewfield 
    case 'left'
        checks(:,1001:end) = 1/2;
    case 'right'
        checks(:,1:1000) = 1/2;
    case 'full'
        checks = checks;  
end

checks=checks*(white-black)+black;

StimLumCtrD = mean([white black])+(white-black)/2*LumContrast;
% make PTB texture  
% radialCheckerboardTexture(1)  = Screen('MakeTexture', window, mean([white black])*ones(size(checks)));
CheckerboardPattern{1} = (checks-255/2)/(255/2)*(StimLumCtrD-255/2)+255/2; 
CheckerboardPattern{2} = 255-CheckerboardPattern{1};
radialCheckerboardTexture{1} = Screen('MakeTexture', window, CheckerboardPattern{1}); 
radialCheckerboardTexture{2} = Screen('MakeTexture', window, CheckerboardPattern{2}); 
radialCheckerboardTexture{3} = Screen('MakeTexture', window, mean([white black])*ones(size(checks)));

%% set up the timing and contrasts 
NTotalFrames = length(TaskFlip);  
PTBlums = TaskFlip;  
PTBlums(find(TaskFlip == 0)) = 3; 

%% set up the dot luminance  
% range between 0.3 and 0.8
dotlum=ones(size(PTBlums));
dotcol=[1 0 0];

%dotlum=dotlum*200;
isi=unifrnd(0.8,3,(TotalDur),1);
switches=[0; cumsum(isi)];

DotSigns = 1/FlipFreq*(1:NTotalFrames);  

for i=1:NTotalFrames
    f=find((-DotSigns(i)+switches)>0);
    f=f(1);
    dotlum(i)=mod(f,2)*80+150;
end
Screen('DrawDots',window,[windowRect(3)/2 windowRect(4)/2],dotsize,dotcol*dotlum(i),[0 0],2);

%% set up the keyboard  
KbQueueCreate(KB);
KbQueueStart(KB);  

TRtimes=zeros(ceil((TotalDur)/TR)+200,1);
keyval=zeros(size(TRtimes));

% ts=firstpress(keyindex);

%% Welcome page 1   
% plot welcome page  
Screen(window, 'FillRect',mean([white black])); 
Screen('Flip', window);
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
[xCenter, yCenter] = RectCenter(windowRect);
line1 = 'Welcome to the visual task ';
line2 = '\n Press any key to proceed if you are ready ';
Screen('TextSize', window, 50);
DrawFormattedText(window, [line1 line2],...
    'center', screenYpixels*0.4, white);
Screen('Flip', window);

[secs, keyCode, deltaSecs] = KbPressWait(KB);

ifi = Screen('GetFlipInterval', window);
Screen('TextSize', window, 100);
DrawFormattedText(window, 'Ready','center', screenYpixels * 0.5, white);
Screen('Flip', window); 

%% waiting for the scanner's trigger   
pressed=0;
while ~pressed
    pause(0.005);
    [test firstpress]=KbQueueCheck(KB);
    if ismember(ScanTrigger,find(firstpress))
        pressed=1;
    end
end  

TRtimes(1)=firstpress(ScanTrigger); 

indx=2;  

tic  
StimRunTime = TRtimes(1);  

% Counting down ... 
% Ncount = 4;  
% CountDur = 1.3;  
% for ic = 1:Ncount 
%     DrawFormattedText(window, num2str(Ncount+1-ic),'center', screenYpixels * 0.5, white);
%     Screen('Flip', window);  
%     pause(CountDur)
% end

StimRunTime = StimRunTime; 
CurrentTime = GetSecs();
pause(StimRunTime-CurrentTime);  

Screen('DrawDots',window,[windowRect(3)/2 windowRect(4)/2],dotsize,dotcol*dotlum(i),[0 0],2);
HideCursor;  
Priority(topPriorityLevel);  
Screen('Flip',window); 

% Starting flickering experiment   
for ifr = 1:NTotalFrames  
%     radialCheckerboardTextureTemp  = Screen('MakeTexture', window, (CheckerboardPattern{PTBframes(ifr)}-255/2)/(255/2)*(PTBlums(ifr)-255/2)+255/2);
    % set the contrast level  
    Screen('FillRect', window,  mean([white black]));    
%     Screen('Blendfunction', window, GL_DST_ALPHA, GL_ONE);
    Screen('DrawTexture', window, radialCheckerboardTexture{PTBlums(ifr)});  
%     Screen('Blendfunction', window, GL_ONE, GL_ZERO);
    Screen('DrawDots',window,[windowRect(3)/2 windowRect(4)/2],50,[1 1 1]*255/2,[0 0],2); % make a black background  
    Screen('DrawDots',window,[windowRect(3)/2 windowRect(4)/2],dotsize,dotcol*dotlum(ifr),[0 0],2);   
    StimRunTime = StimRunTime + 1/FlipFreq;  
    [StimRunTimeEst,stimon]=Screen(window,'Flip',StimRunTime);  
    StimAllTime(ifr) = StimRunTimeEst;  
    
    % record the key press  
    [pressed,firstpress] = KbQueueCheck(KB);
    if pressed
        k=find(firstpress);
        for j=1:length(k)
            keyval(indx)=k(j);
            TRtimes(indx)=firstpress(k(j));
            indx=indx+1;
        end
    end  
end

toc 

% end the experiment  
Screen(window, 'FillRect',mean([white black]));  
Screen('TextSize', window, 120);
DrawFormattedText(window, 'The task is over ... \n Thanks!', 'center', screenYpixels*0.4 , white);
Screen(window,'Flip') 

pause(3); 

ShowCursor;
Priority(0);
Screen('CloseAll');

%% warp up and save files  
save(fname,'StimAllTime','TRtimes','MaxLum','MinLum','Task','LumContrast','TR','FlipFreq','keyval','switches','TRtimes');

m=mfilename('fullpath');
system(['cp ' m '.m ' mname]);
KbQueueRelease(KB);

%% calculate accuracy
maxrt=0.8;  
realswitches=sum(switches<TotalDur);  
rt=zeros(realswitches,1);  

for i=1:(realswitches)
    resp=TRtimes(keyval~=0&keyval~=46);
    resp=resp-StimAllTime(1)-switches(i);
    resp=resp(resp>0&resp<maxrt);
    if isempty(resp)
        rt(i)=nan;
    else
        rt(i)=min(resp);
    end
end
disp(['Responses: ' num2str(sum(~isnan(rt))/length(rt)*100) '%']);
disp(['Mean RT: ' num2str(nanmean(rt)*1000) ' ms']);
% save(fname,'rt','-append');

clear all;  
close all;  

end



