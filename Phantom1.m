function varargout = Phantom1(varargin)
% PHANTOM1 MATLAB code for Phantom1.fig
%      PHANTOM1, by itself, createsload a new PHANTOM1 or raises the existing
%      singleton*.
%
%      H = PHANTOM1 returns the handle to a new PHANTOM1 or the handle to
%      the existing singleton*.
%
%      PHANTOM1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PHANTOM1.M with the given input arguments.
%
%      PHANTOM1('Property','Value',...) creates a new PHANTOM1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Phantom1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Phantom1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Phantom1

% Last Modified by GUIDE v2.5 19-Jul-2016 14:44:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Phantom1_OpeningFcn, ...
    'gui_OutputFcn',  @Phantom1_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Phantom1 is made visible.
function Phantom1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Phantom1 (see VARARGIN)

% Choose default command line output for Phantom1
clc; warning('off','all')
handles.output = hObject;
set(hObject, 'Color', [0 0 0]);
cla
set(handles.imageAxis,'xticklabel',[],'yticklabel',[])
set(handles.graphAxis,'xticklabel',[],'yticklabel',[])
set(handles.matAxis,'xticklabel',[],'yticklabel',[]) %correlationMatrix and such
% axes(handles.graphAxis);xlabel('Time','Fontsize',10);ylabel('Signal','Fontsize',10);
set(handles.graphAxis,'XColor','w'); set(handles.graphAxis,'YColor','w');
handles.currChoice = 'One Image';
handles.show = 2;
handles.graph = 0;
handles.fT = 0;
handles.dT = 0;
handles.mO = 0;
handles.rangeNum = 0;
handles.dontRunMasks = 0; %% this helps a function out.
handles.trimmed = 0;
handles.corr = 0;
handles.tSNRbut = 0;
handles.SFSbut = 0;
handles.isCoordsData=0; % is there coordiantes data
handles.mOcolors = [1 0 0; 0 1 0; 0 0 1; 1 0.5 0];%[1 0 0; 0 1 0; 0 0 1; 1 0.6 0; 1 0 1; 0 1 1; 1 1 1]; %Mask overlay colors
set(findobj('Tag','rangeText'),'String',num2str(handles.rangeNum));% Update handles structure

addpath('GUIfunctions')
addpath(pwd)
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Phantom1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Phantom1_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in loadImBut.
function loadImBut_Callback(hObject, eventdata, handles)
% hObject    handle to loadImBut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.imageAxis)
set(findobj('Tag','statusText'),'String','Loading Data...')% Update handles structure
[handles.volume, cwd, name,fn] = loadPhanIm;
handles = updatePhanIm( handles ,1);

set(findobj('Tag','fileNameText'),'String',fn)% Update handles structure

handles.volume = squeeze(handles.data(:,:,handles.sliceNum,:));
axes(handles.imageAxis)
handles.image = squeeze(handles.volume(:,:, 1));
imshow(handles.image,[0 max(max(squeeze(handles.volume(:,:,1))))]);
[~,scanname,~] = fileparts(fn);

if isfield(handles,'Results')
    handles=rmfield(handles,'Results');
end
%a = dir([cwd ,'*.csv']);

if exist([cwd, scanname , '.csv'],'file')
    handles.isCoordsData=1;
    handles.intsraw = csvread([cwd, scanname , '.csv'],0);
    handles.ints = handles.intsraw(2:end,:);
    handles.maskInitOffset=360*(handles.intsraw(1,2))/512;  
    handles.dataName = name;
    handles.startTR = 1;
    handles.endTR = size(handles.data,4);
    handles.trimState = 1;
    handles.fT = 0;
    handles.dT = 0;
    handles.corr = 0;
    handles.tSNRbut = 0;
    handles.SFSbut = 0;
    handles.mO=0;
    handles.graph = 0;
    set(findobj('Tag','filterToggle'),'Value', 0);
    set(findobj('Tag','detrendTog'),'Value', 0);
    set(findobj('Tag','statusText'),'String','Loaded file and coordinates')% Update handles structure
else
    handles.isCoordsData=0;
    set(findobj('Tag','statusText'),'String','No coordiantes data')% Update handles structure
end
guidata(hObject, handles);



% --- Executes on button press in vidBut.
function vidBut_Callback(hObject, eventdata, handles)
% hObject    handle to vidBut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(findobj('Tag','statusText'),'String','Playing video...')% Update handles structure
delay = 0.2/length(handles.volume);
videoOut(handles.volume, handles.sliceNum,delay);
set(findobj('Tag','statusText'),'String','Video Created!')% Update handles structure
pause(0.01);
close






% --- Executes on button press in exploreIm.
function exploreIm_Callback(hObject, eventdata, handles)
% hObject    handle to exploreIm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(findobj('Tag','statusText'),'String','Loading Data...')% Update handles structure
[handles.volume, handles.dataName, handles.fileNameText] = loadPhanIm;
[handles] = updatePhanIm( handles,1);


%a = dir('*.csv');
handles.ints = [(1:length(handles.volume))', ones(length(handles.volume),3)];
handles.intsraw = handles.ints;
handles.startTR = 1;
handles.endTR = size(handles.volume,4);
handles.trimState = 0;
handles.fT = 0;
handles.dT = 0;
set(findobj('Tag','filterToggle'),'Value', 0);
set(findobj('Tag','detrendTog'),'Value', 0);
guidata(hObject, handles);

function convertIm_Callback(hObject, eventdata, handles)
% this function uses dcim2nii code to convert dicom files to 4d nifti files
directoryname = uigetdir('.','please choose directory containing dicm files');
dicm2nii(directoryname, fullfile(directoryname , 'niiFolder'), '.nii')
set(findobj('Tag','statusText'),'String','Files have been writen into niiFolder');
cd(directoryname);
guidata(hObject, handles);

% --- Executes on button press in compSD.
function compSD_Callback(hObject, eventdata, handles)
% hObject    handle to compSD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = compareSdInnerOuter(handles);
guidata(hObject, handles)


% --- Executes on button press in filterToggle.
function filterToggle_Callback(hObject, eventdata, handles)
% hObject    handle to filterToggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of filterToggle
fT = get(hObject,'Value');
axes(handles.imageAxis);
handles.fT = fT;
try
    if handles.lpcut ~= handles.lpprev || handles.hpcut ~= handles.hpprev  || ~exist(handles.dataf)
        handles.dataf = [];
        set(findobj('Tag','statusText'),'String',['Filter params changed.']);
        pause(.25);
    end
end

if fT == 0
    handles.volume = sq(handles.data(:,:,handles.sliceNum,handles.startTR:handles.endTR));
    handles.ints = handles.intsraw(handles.startTR:handles.endTR,:);
    [image m handles]= imOption(handles);
    axes(handles.imageAxis)
    imshow(image, [0 m])
    if handles.graph == 1
        handles = sliderHelper(handles);
    end
    set(findobj('Tag','statusText'),'String',['Unfiltered!']);
elseif fT == 1
    handles.dT = 0;
    set(findobj('Tag','detrendTog'),'Value', 0);
    try
        dataf = handles.dataf(:,:,:,handles.startTR:handles.endTR);
    end
    if ~exist('dataf','var') || isempty(handles.dataf)
        set(findobj('Tag','statusText'),'String',['Filtering!']);
        pause(0.01);
        handles = phanFilt(handles);
        handles.lpprev = handles.lpcut;
        handles.hpprev = handles.hpcut;
    end
    set(findobj('Tag','statusText'),'String',['Filtered!']);
    [image m handles]= imOption(handles);
    %     axes(handles.imageAxis)
    %     imshow(image, [0 m])
    if handles.graph == 1 %if the graph is up, we should replace it with the filtered version.
        handles = sliderHelper(handles);
    end
end


guidata(hObject,handles);


% --- Executes on button press in detrendTog.
function detrendTog_Callback(hObject, eventdata, handles)
% hObject    handle to detrendTog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of detrendTog
handles.graph = 1;
dT = get(hObject,'Value');
axes(handles.imageAxis);
handles.dT = dT;


if dT == 0
    handles.volume = squeeze(handles.data(:,:,handles.sliceNum,:));
    if handles.graph == 1
        handles = sliderHelper(handles);
    end
    [image m handles]= imOption(handles);
    axes(handles.imageAxis)
    imshow(image, [0 m])
    set(findobj('Tag','statusText'),'String',['Raw data']);
elseif dT == 1
    handles.fT = 0;
    set(findobj('Tag','filterToggle'),'Value', 0);
    try
        datad = handles.datad;
    end
    if ~exist('datad','var') || isempty(handles.datad)
        set(findobj('Tag','statusText'),'String',['Detrending!']);
        pause(0.01);
        handles = phanDetrend(handles);
    end
    [image m handles]= imOption(handles);
    %     axes(handles.imageAxis)
    %     imshow(image, [0 m])
    set(findobj('Tag','statusText'),'String',['Active Data: Detrended.']);
    if handles.graph == 1 %if the graph is up, we should replace it with the filtered version.
        handles = sliderHelper(handles);
    end
end

guidata(hObject, handles)


function lowPassCut_Callback(hObject, eventdata, handles)
% hObject    handle to lowPassCut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lowPassCut as text
%        str2double(get(hObject,'String')) returns contents of lowPassCut as a double
handles.lpcut = str2double(get(hObject,'String'));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function lowPassCut_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lowPassCut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function highPassCut_Callback(hObject, eventdata, handles)
% hObject    handle to highPassCut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of highPassCut as text
%        str2double(get(hObject,'String')) returns contents of highPassCut as a double
handles.hpcut = str2double(get(hObject,'String'));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function highPassCut_CreateFcn(hObject, eventdata, handles)
% hObject    handle to highPassCut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function TR_Callback(hObject, eventdata, handles)
% hObject    handle to TR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TR as text
%        str2double(get(hObject,'String')) returns contents of TR as a double
handles.TR = str2double(get(hObject,'String'));
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function TR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in regressBut.
function regressBut_Callback(hObject, eventdata, handles)
% hObject    handle to regressBut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = phanGLM(handles);

guidata(hObject,handles)


function windowText_Callback(hObject, eventdata, handles)
% hObject    handle to windowText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of windowText as text
%        str2double(get(hObject,'String')) returns contents of windowText as a double


% --- Executes during object creation, after setting all properties.
function windowText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to windowText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in trigAvButt.
function trigAvButt_Callback(hObject, eventdata, handles)
% hObject    handle to trigAvButt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = phanTrigAvg(handles);
guidata(hObject,handles);


% --- Executes on button press in sliceselector.
function sliceselector_Callback(hObject, eventdata, handles)
% hObject    handle to sliceselector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function startSlice_Callback(hObject, eventdata, handles)
% hObject    handle to startSlice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of startSlice as text
%        str2double(get(hObject,'String')) returns contents of startSlice as a double
handles.startSlice = str2double(get(hObject, 'String'));
%handles.trimmed =1 ;

if handles.startSlice>handles.sliceNum
    handles.sliceNum=handles.startSlice;
    handles.currentSlice.String = num2str(handles.sliceNum);
    handles.sliceSlider.Value  = handles.startSlice;
end

handles.rangeNum = handles.startSlice:handles.endSlice;
handles.sliceSlider.Min = handles.startSlice;
handles.slices = handles.endSlice-handles.startSlice+1;
set(findobj('Tag','sliceSlider'), 'SliderStep', [1/handles.slices, 10/handles.slices]);

[image m handles] = imOption(handles);

axes(handles.imageAxis)
% figure;
imshow(image, [0 m])
maskOverlay(handles);

guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function startSlice_CreateFcn(hObject, eventdata, handles)
% hObject    handle to startSlice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in drawROI.
function drawROI_Callback(hObject, eventdata, handles)
% hObject    handle to drawROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.graph = 1;

axes(handles.imageAxis)
% handles.mO = 0;
% maskOverlay(handles);
try
    handles = rmfield(handles, 'mask');
end

handles = sliderHelper(handles);
% handles.mO = 1;
% set(findobj('tag','maskOverlay'),'Value',1)
% maskOverlay(handles);

guidata(hObject, handles);

% --- Executes on button press in generateROI.
function generateROI_Callback(hObject, eventdata, handles)
% hObject    handle to drawROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.graph = 1;

axes(handles.imageAxis)
% handles.mO = 0;
% maskOverlay(handles);
try
    handles = rmfield(handles, 'mask');
end

% create mask for the current slice 
% finder center of cartridge
image2D=handles.volume(:,:,1);
radiiRange=[5 15];

[~, ~, center, radius] = gen3_get_i_cylinder(handles.data(:,:,handles.sliceNum,1), radiiRange);

% create masks and center them
s=floor(size(image2D)/2);
AnguarIdent=pi*0.15;
decentering=[-0.5 -0.5];

[masks,  maskSize_ic , masks_oc, maskSize_oc] = generateMasks5(image2D,4,[radius,s([2 1])],AnguarIdent);
%% align masks to cartridge

masks_oc=imtranslate(masks_oc,center-[s(2) s(1)]+decentering);
im1=zeros(size(masks));
im2=zeros(size(masks));
for ii=1:4
    im=masks(:,:,ii);
    im1(:,:,ii)=imrotate(im,handles.maskAngleDeg+handles.maskInitOffset,'nearest','crop');
    im2(:,:,ii)=imtranslate(im1(:,:,ii),center-[s(2) s(1)]+decentering);
%     if CreateMapFlag
%         im2(:,:,ii) = mask_weights.*im2(:,:,ii);
%     end
%   im2(:,:,ii)=im2(:,:,ii)./sum(sum(im2(:,:,ii)));
end
handles.mask = cat(3,im2 ,masks_oc);
handles.graph = 1;
numMasks = size(handles.mask,3);
for iMask = 1:numMasks
    handles.maskLegend{iMask} = ['Mask' num2str(iMask)];
end

%clear current mask
handles.mO = 0;
maskOverlay(handles);

% overlay new mask
handles.mO = 1;
set(findobj('tag','maskOverlay'),'Value',1)
maskOverlay(handles);

handles = sliderHelper(handles);


guidata(hObject, handles);

function endSlice_Callback(hObject, eventdata, handles)
% hObject    handle to endslice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of endslice as text
%        str2double(get(hObject,'String')) returns contents of endslice as a double


handles.endSlice = str2double(get(hObject, 'String'));
%handles.trimmed =1 ;

if handles.endSlice<handles.sliceNum
    handles.sliceNum=handles.endSlice;
    handles.currentSlice.String = num2str(handles.sliceNum);
    handles.sliceSlider.Value  = handles.endSlice;
end

handles.rangeNum = handles.startSlice:handles.endSlice;
handles.sliceSlider.Max = handles.endSlice;
handles.slices = handles.endSlice-handles.startSlice+1;
set(findobj('Tag','sliceSlider'), 'SliderStep', [1/handles.slices, 10/handles.slices]);

[image m handles] = imOption(handles);

axes(handles.imageAxis)
% figure;
imshow(image, [0 m])
maskOverlay(handles);

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function endSlice_CreateFcn(hObject, eventdata, handles)
% hObject    handle to endslice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in dynFidelity.
function dynFidelity_Callback(hObject, eventdata, handles)
% hObject    handle to dynFidelity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% handles.corr = get(hObject,'Value')
% handles = quadCorrelation(handles);
maskAngle = handles.maskAngleDeg;
sliceRange=handles.rangeNum;
l=length(sliceRange);
tempFiltFlag=0;
imgData=handles.data(:,:,:,handles.startTR:handles.endTR);

if ~isfield(handles,'Results') 
    
    h = waitbar(0,'','Name','','CreateCancelBtn',...
        'setappdata(gcbf,''canceling'',1)');
    setappdata(h,'canceling',0)
    
    
    for ii=1:l
        
        if getappdata(h,'canceling')
            break
        end
        % [mt2star(:,:,ii),innerCylinder, center(:,ii), radius(:,ii)] =getMeanBold(img,staticSlices(ii),angDeg,0,3,CreateMapFlag);
        [mt2star(:,:,ii),sfs(ii,:) , tsnr(ii,:), st2star(ii,:)] =getStatBold3(imgData(:,:,sliceRange(ii),:),maskAngle,0,3,tempFiltFlag,[-0.5 -0.5],pi*0.15);
        waitbar(ii/l,h,sprintf('%.1f %%',ii/l*100))
    end
    
    if ~getappdata(h,'canceling')
        handles.Results.DynFidelity.sfs = sfs;
        handles.Results.DynFidelity.mnts = mt2star;
        handles.Results.DynFidelity.tsnr = tsnr;
        handles.Results.DynFidelity.st2star = st2star;
    end
    
    delete(h);
    
    
    minmt=mean(min(handles.mnts));
    maxmt=mean(max(handles.mnts));
    curPos=handles.ints(:,2)+64;
    boldExpexcted=reverseSeq(curPos,[minmt maxmt],0);
    mnts = handles.Results.DynFidelity.mnts;
    
    
    for ii=1:l
        for kk=1:size(handles.mask,3)
            [cc,pp] = corrcoef(boldExpexcted,mnts(:,kk,ii));
            r(ii,kk)=cc(2);
            p(ii,kk)=pp(2);
        end
    end
    
    handles.Results.DynFidelity.quadCorrRs = r;
    handles.Results.DynFidelity.quadCorrPs = p;
    
end

handles = dynFidelityCorrelation(handles);

handles = sliderHelper(handles);
guidata(hObject, handles);

% --- Executes on slider movement.
function sliceSlider_Callback(hObject, eventdata, handles)
% hObject    handle to sliceSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.sliceNum = round(get(hObject, 'Value'));
if handles.trimmed == 0
    set(findobj('Tag','sliceText'),'String',num2str(handles.sliceNum));
else
    set(findobj('Tag','sliceText'),'String',num2str(handles.sliceNum+handles.startSlice));
end
[image m handles] = imOption(handles);

axes(handles.imageAxis)
% figure;
imshow(image, [0 m])
maskOverlay(handles);

if handles.graph == 1
    handles = sliderHelper(handles);
end
set(findobj('Tag','currentSlice'),'String',handles.sliceNum)% Update handles structure

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function sliceSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliceSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject, 'Value', .3);

% --- Executes on button press in SFS.
function SFS_Callback(hObject, eventdata, handles)
% hObject    handle to SFS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.SFSbut = get(hObject,'Value');
handles= sfs(handles);
guidata(hObject, handles);

% --- Executes on button press in clearGraph.
function clearGraph_Callback(hObject, eventdata, handles)
% hObject    handle to clearGraph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.graphAxis)
cla;
legend('off')
title(' ');
set(findobj('Tag','IntTog'),'Value', 0);
set(findobj('Tag','IntTog'),'Value', 0);
handles.show = 0;
handles.graph = 0;
guidata(hObject,handles);


function startTRtext_Callback(hObject, eventdata, handles)
% hObject    handle to startTRtext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of startTRtext as text
%        str2double(get(hObject,'String')) returns contents of startTRtext as a double
handles.startTR = str2double(get(hObject,'String'));
% handles.volume = handles.volume(:,:,:,[handles.startTR:handles.endTR]);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function startTRtext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to startTRtext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function endTRtext_Callback(hObject, eventdata, handles)
% hObject    handle to endTRtext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of endTRtext as text
%        str2double(get(hObject,'String')) returns contents of endTRtext as a double
handles.endTR = str2double(get(hObject,'String'));
% handles.volume = handles.volume(:,:,:,[handles.startTR:handles.endTR]);
% handles.ints = handles.intsraw([handles.startTR:handles.endTR],:);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function endTRtext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to endTRtext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in trimBut.
function trimBut_Callback(hObject, eventdata, handles)
% hObject    handle to trimBut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of trimBut
trimState = get(hObject,'Value');

switch trimState
    case 0
        handles.startTR = 1;
        handles.endTR = size(handles.data, 4);
        handles = switchDetFilt(handles);
        handles.ints = handles.intsraw;
    case 1
        handles.startTR = str2double(get(findobj('Tag','startTRtext'),'String'));
        handles.startTR = handles.startTR(1);
        handles.endTR = str2double(get(findobj('Tag','endTRtext'),'String'));
        handles.endTR = handles.endTR(1);
        handles.volume = handles.volume(:,:,handles.startTR:handles.endTR);
        handles.mnts= handles.mnts(handles.startTR:handles.endTR);
        handles.ints = handles.ints(handles.startTR:handles.endTR,:);
end

if handles.graph == 1
    handles = sliderHelper(handles);
end
handles.trimState = trimState;
guidata(hObject,handles);

% --- Executes on button press in IntTog.
function IntTog_Callback(hObject, eventdata, handles)
% hObject    handle to IntTog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of IntTog
handles.show = (-1*get(hObject,'Value'))+1;
handles = showIntHelper(handles);
guidata(hObject,handles);

% --- Executes on button press in graphSingleTS.
function graphSingleTS_Callback(hObject, eventdata, handles)
% hObject    handle to graphSingleTS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Uses tsClick2 to load the time series of one voxel

handles.graph = 1;

axes(handles.imageAxis)
% handles.mO = 0;
% maskOverlay(handles);

try
    handles = rmfield(handles, 'mask');
end
handles.mask = 1;

handles = sliderHelper(handles);

% handles.mO = 1;
% set(findobj('tag','maskOverlay'),'Value',1)
% maskOverlay(handles);

guidata(hObject, handles);

% --- Executes on button press in saveGraph.
function saveGraph_Callback(hObject, eventdata, handles)
% hObject    handle to saveGraph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.graphAxis)
% dbstop in saveGraph_Callback
slice = handles.sliceNum;
mask = handles.mask;
mnts = handles.mnts;
volume = sq(handles.volume(:,:,slice, :));
ints = handles.ints;
TR = handles.TR;
name = [handles.dataName, ', Slice ', num2str(slice), ', TR ', num2str(TR)];
save(name, 'mask', 'slice', 'mnts', 'volume', 'ints')

% --- Executes on button press in saveImage.
function saveImage_Callback(hObject, eventdata, handles)
% hObject    handle to saveImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.imageAxis)
dbstop in saveImage_Callback

% --- Executes on button press in saveTSbut.
function saveTSbut_Callback(hObject, eventdata, handles)
% hObject    handle to saveTSbut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ts = handles.mnts';
ints = handles.ints;
newName = handles.dataName;
newName(newName == ' ') = [];
newName(newName == '-') = [];
data.(newName) = [ints,ts];
mask = handles.mask;
uisave(['data'; 'mask'], newName);


% --- Executes on button press in tSNR.
function tSNR_Callback(hObject, eventdata, handles)
% hObject    handle to tSNR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.graph = 1;
handles.tSNRbut = get(hObject,'Value');
handles = tSNR(handles);


% handles.tSNR= tSNR(handles);
% tSNRInt = handles.tSNR;
% set(findobj('Tag','tSNRInt'),'String',['tSNR: ' num2str(tSNRInt)]);
guidata(hObject, handles);

% --- Executes on button press in Correlation.
function Correlation_Callback(hObject, eventdata, handles)
% hObject    handle to Correlation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% handles= correlation_tool(handles);
handles.graph = 1;
handles.corr = get(hObject,'Value');
handles = quadCorrelation(handles);
guidata(hObject, handles);



% --- Executes on button press in loadMaskbut.
function loadMaskbut_Callback(hObject, eventdata, handles)
% hObject    handle to loadMaskbut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in graphBut.
handles.mO = 0;
maskOverlay(handles);

try
    handles = rmfield(handles, 'mask');
end
[handles.mask] = loadMask;

handles.graph = 1;
numMasks = size(handles.mask,3);
for iMask = 1:numMasks
    handles.maskLegend{iMask} = ['Mask' num2str(iMask)];
end
handles.mO = 1;
set(findobj('tag','maskOverlay'),'Value',1)
maskOverlay(handles);

% axes(handles.graphAxis)
% hold off
handles = sliderHelper(handles);

axes(handles.imageAxis);
guidata(hObject, handles);

% --- Executes on button press in maskOverlay.
function maskOverlay_Callback(hObject, eventdata, handles)
% hObject    handle to maskOverlay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Toggle-overlays the image with a transparent mask. handles.mO is used to
% evaluate the state of the button-can interact weirdly in certain
% scenarios. maskOverlay should be called after every update of the primary
% image.
handles.mO = get(hObject,'Value');
maskOverlay(handles);
guidata(hObject,handles);

% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in maskSave.
function maskSave_Callback(hObject, eventdata, handles)
% hObject    handle to maskSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prompt = {'Enter File Name:'};
dlg_title = 'Mask Save';
num_lines = 1;
defaultans = {'Mask'};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
answer = answer{1};
mask = handles.mask;
save( answer, 'mask')

% --- Executes on button press in tSNRMap.
function tSNRMap_Callback(hObject, eventdata, handles)
% hObject    handle to tSNRMap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Changes voxel inteensities to reperesent the tSNR values accross the
% entire image
tSNRSlice=tSNRMap(handles);
axes(handles.imageAxis)
cla
image(tSNRSlice,'CDataMapping','scaled');
try
    if handles.mO == 1
        maskOverlay(handles);
    end
end
guidata(hObject, handles);


% --- Executes on button press in T2tool.
function T2tool_Callback(hObject, eventdata, handles)
% hObject    handle to T2tool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%T2tool2(handles);

set(findobj('Tag','statusText'),'String','Loading Data...')% Update handles structure
[T2Vol, handles.dataName, handles.fileNameText] = loadPhanIm;

T2VolSize = size(T2Vol);
tesNum = size(T2Vol,4);

if tesNum>1
    
    prompt = ['Enter a series of TEs that represent each acquisition parameter, ' tesNum ' entries are required:'];
    TEs = inputdlg(prompt);
    TEs = TEs{1};
    TEs = squeeze(TEs);
    TEs=str2num(TEs); %#ok<ST2NM>
    sizeTEs = size(TEs);
    
    if sizeTEs(1,2) == T2VolSize(1,4)
        T2Map=mapT2star(T2Vol,TEs); %#stg#
        handles.T2Map = T2Map;
        handles.volume = T2Map;
    else
        set(findobj('Tag','statusText'),'String','Incorrect number of TE values!')
    end
else
    handles.T2Map = T2Vol;
    handles.volume = T2Vol;
    
end

% [ betas ] = calcT2beta( handles.T2Vol );

[handles] = updatePhanIm( handles,1);
set(findobj('Tag','statusText'),'String','loaded T2* map')
guidata(hObject, handles);

% --- Executes on button press in T2Load.
function T2Load_Callback(hObject, eventdata, handles)
% hObject    handle to T2Load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% user input for center and radius

set(findobj('Tag','statusText'),'String','please enter phantom inner circle (bouble click to end)')
h = imellipse(handles.imageAxis);
vertices = wait(h);
guiCenter=mean(vertices);
guiRadius=mean(sqrt(sum((vertices-guiCenter).^2,2)));
h.delete
%% caculate angle correction factor

curSlice = str2num(handles.currentSlice.String);
radii=floor([guiRadius*0.8 guiRadius*1.2]);

[t2star_s,cross_mask,angDeg] = registerSpokesT2s( handles.T2Map , curSlice, radii);
%handles.T2Map = t2star_s;
handles.volume = t2star_s;


handles.maskAngleDeg=angDeg+45;

handles.mask=cross_mask;
handles.mO=1;
[handles] = updatePhanIm( handles,0);
maskOverlay(handles);


set(findobj('Tag','statusText'),'String','T2 Star Complete')


guidata(hObject, handles);


% --- Executes on button press in T2Coreg.
function T2Coreg_Callback(hObject, eventdata, handles)
% hObject    handle to T2Coreg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Coregisters the T2* and the Bold image, uses SPM, should use different
% coreg method

handles.coregTransform = modded_spm_coreg(handles.data,handles.T2Map(:,:,:,2));
for x = 1:size(handles.T2Map,1)
    for y = 1:size(handles.T2Map,2)
        for z = 1:size(handles.T2Map,3)
            xyz = [x,y,z];
            handles.T2MapAdjust(handles.coregTransform(1,1:3).* xyz +handles.coregTransform(1,4),...
                handles.coregTransform(2,1:3).*xyz+handles.coregTransform(2,4),...
                handles.coregTransform(3,1:3).*xyz+handles.coregTransform(3,4))...
                = handles.T2Map(x,y,z,2);
        end
    end
end

%The rest of this is just me testing to see if it works, can be used as
%confirmation for the user.
% image(handles.T2MapAdjust(:,:,z/2));
% figure
% image(handles.volume(:,:,z/2));
% figure

% Needs the quadrant overlay to be mutiplied by the transformation matrix
% and resaved, and then applied to all future images of the bold
% (preferably on a toggle)

for i = 1:sizeQuadrantIDMatrix(1,1)
    figure
    SliceNum = i;
    redBack = cat(3, ones(T2VolSize(1,1),T2VolSize(1,2)), zeros(T2VolSize(1,1),T2VolSize(1,2)), zeros(192,192));
    image(handles.T2Map(:,:,SliceNum,2))
    hold on
    overlayBack = imshow(redBack);
    CurrMap = zeros(T2VolSize(1,1),T2VolSize(1,2));
    for armRotation = 0:360/quadrantNum:359
        for x = 1:T2VolSize(1,1)
            x1 = ceil(x*cosd(handles.quadrantIDMatrix(SliceNum,1)+armRotation)+...
                handles.quadrantIDMatrix(SliceNum,2));
            y1 = ceil(x*sind(handles.quadrantIDMatrix(SliceNum,1)+armRotation)+...
                handles.quadrantIDMatrix(SliceNum,3));
            x1 = int16(x1);
            y1 = int16(y1);
            if x1 <= T2VolSize(1,1) && y1 <= T2VolSize(1,2)
                if x1 > 0 && y1 > 0
                    CurrMap(x1,y1) = 1;
                end
            end
        end
    end
    set(overlayBack,'AlphaData',CurrMap*(.3))
end

function maskDelete_Callback(hObject, eventdata, handles)
% hObject    handle to vidBut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~exist('handles.mask', 'var')
    try
        handles = rmfield(handles, 'mask');
        handles = rmfield(handles, 'mnts');
        handles = rmfield(handles, 'tSNR');
        handles.graph = 0;
    end
    handles.corr = 0;
    handles.SFSbut = 0;
    handles.tSNRbut = 0;
    sfs(handles);
    tSNR(handles);
    quadCorrelation(handles);
    axes(handles.graphAxis);
    legend('off')
    cla;
    handles.mO = 0;
    maskOverlay(handles);
end
guidata(hObject, handles);