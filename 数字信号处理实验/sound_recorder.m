function varargout = sound_recorder(varargin)
% SOUND_RECORDER MATLAB code for sound_recorder.fig
%      SOUND_RECORDER, by itself, creates a new SOUND_RECORDER or raises the existing
%      singleton*.
%
%      H = SOUND_RECORDER returns the handle to a new SOUND_RECORDER or the handle to
%      the existing singleton*.
%
%      SOUND_RECORDER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SOUND_RECORDER.M with the given input arguments.
%
%      SOUND_RECORDER('Property','Value',...) creates a new SOUND_RECORDER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sound_recorder_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sound_recorder_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sound_recorder

% Last Modified by GUIDE v2.5 17-Sep-2023 17:49:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sound_recorder_OpeningFcn, ...
                   'gui_OutputFcn',  @sound_recorder_OutputFcn, ...
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


% --- Executes just before sound_recorder is made visible.
function sound_recorder_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sound_recorder (see VARARGIN)

% Choose default command line output for sound_recorder
handles.output = hObject;
handles.recObj = audiorecorder(48000, 16, 2, -1);%(频率，位数，频道，录音机代号)
handles.recObj.TimerFcn = {@RecDisplay,handles};
handles.recObj.TimerPeriod = 0.25;
handles.playSpeed = 1;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes sound_recorder wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = sound_recorder_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function pushbutton1_Callback(hObject,eventdata,handles)
record(handles.recObj);

function pushbutton2_Callback(hObject,eventdata,handles)
stop(handles.recObj)

function pushbutton3_Callback(hObject,eventdata,handles)
handles.myRecording = getaudiodata(handles.recObj);
handles.playObj = audioplayer(handles.myRecording,handles.playSpeed*handles.recObj.SampleRate);
play(handles.playObj);
guidata(hObject,handles);

function pushbutton4_Callback(hObject,eventdata,handles)
[file,path] = uiputfile(['soundDemo_Speed' num2str(handles.playSpeed) '.wav'] ,'Save recorded sound');
if file
    audiowrite([path '\' file],handles.myRecording,handles.playSpeed*handles.recObj.SampleRate)
end

function RecDisplay(hObject,eventdata,handles)
handles.myRecording = getaudiodata(handles.recObj);
plot(handles.axes1,(1:length(handles.myRecording))/handles.recObj.SampleRate,handles.myRecording)
drawnow;

function edit1_Callback(hObject,eventdata,handles)
handles.playSpeed = str2double(get(hObject,'String'));
guidata(hObject,handles);

function edit1_CreateFcn(hObject,eventdata,handles)
if ispc && isequal(get(hObject,'BackgroundColor'),get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
