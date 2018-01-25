function varargout = T2tool2(varargin)
% T2TOOL2 MATLAB code for T2tool2.fig
%      T2TOOL2, by itself, creates a new T2TOOL2 or raises the existing
%      singleton*.
%
%      H = T2TOOL2 returns the handle to a new T2TOOL2 or the handle to
%      the existing singleton*.
%
%      T2TOOL2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in T2TOOL2.M with the given input arguments.
%
%      T2TOOL2('Property','Value',...) creates a new T2TOOL2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before T2tool2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to T2tool2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help T2tool2

% Last Modified by GUIDE v2.5 06-Feb-2015 17:17:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @T2tool2_OpeningFcn, ...
                   'gui_OutputFcn',  @T2tool2_OutputFcn, ...
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


% --- Executes just before T2tool2 is made visible.
function T2tool2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to T2tool2 (see VARARGIN)

% Choose default command line output for T2tool2
handles.output = hObject;


try
    sliceNum = varargin{1,1}.sliceNum;
end

if(isempty(sliceNum) == 1)
    sliceNum = 7;
end

sliceNum = 7;

vol = loadPhanIm;
size(vol)
actDat = squeeze(vol(:,:,sliceNum,:));
axes(handles.imAxis)
% imshow(actDat(:,:,5),[0 500]);



sz = size(actDat);
ly = reshape(log(actDat+1), [sz(1)*sz(2), sz(3)]);
%%subtract the minimum value from the data to remove the offset
for i = 1:size(ly,2)
    lyN(:,i) = ly(:,i) - min(ly')';
end

%% fit to model of exponentoial decay
lx = repmat(([1:12]),[length(lyN) 1]);    
mx2 = mean(lx.^2,2);
mx  = mean(lx,2);
mxy = mean(lx.*lyN,2);
my = mean(lyN,2);
covxy = (mxy-mx.*my);
vx = (mx2-mx.^2);
betas = (-1*covxy./vx);  % slope = cov(X,Y)/var(X)
betas = reshape(betas, [sz(1), sz(2)]);
imshow(betas, [0, max(max(betas))])

handles.betas = betas;
handles.actDat = actDat;


%% Right way to do it:
loopDat = reshape(actDat+1, [sz(1)*sz(2), sz(3)]);
% 
% tic
% for i = 1:length(loopDat)
%     f = fit([1:12]', loopDat(i,:)', 'exp2');
%     b(i) = f.b;
% end
% toc
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes T2tool2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = T2tool2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in graph.
function graph_Callback(hObject, eventdata, handles)
% hObject    handle to graph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%[x y] = ginput(1);
[y , x] = ginput(1);
axes(handles.graphAxis)
x = round(x);
y = round(y);
data=squeeze(handles.actDat(x, y,:));
b = handles.betas(x,y);
a = handles.actDat(x, y,1);
xs = (0:11);
f = fit(xs', data,'exp1');
plot(f,xs,data)
title(sprintf(' f(x) = %u*exp(-%.3f*x) ' , a,b))  
% hold on; plot(nothing)

