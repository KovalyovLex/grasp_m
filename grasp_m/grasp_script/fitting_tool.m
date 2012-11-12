function varargout = fitting_tool(varargin)
% FITTING_TOOL MATLAB code for fitting_tool.fig
%      FITTING_TOOL, by itself, creates a new FITTING_TOOL or raises the existing
%      singleton*.
%
%      H = FITTING_TOOL returns the handle to a new FITTING_TOOL or the handle to
%      the existing singleton*.
%
%      FITTING_TOOL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FITTING_TOOL.M with the given input arguments.
%
%      FITTING_TOOL('Property','Value',...) creates a new FITTING_TOOL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before fitting_tool_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to fitting_tool_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help fitting_tool

% Last Modified by GUIDE v2.5 06-Nov-2012 19:49:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fitting_tool_OpeningFcn, ...
                   'gui_OutputFcn',  @fitting_tool_OutputFcn, ...
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

var FileName PathName
% End initialization code - DO NOT EDIT

% --- Executes just before fitting_tool is made visible.
function fitting_tool_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to fitting_tool (see VARARGIN)

% Choose default command line output for fitting_tool
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes fitting_tool wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = fitting_tool_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tset = findobj('Tag','radiobutton1');
treg = findobj('Tag','radiobutton2');
temp = findobj('Tag','radiobutton3');
h = findobj('Tag','edit1');

tepVal = 0;
if (get(tset,'Value') == 1)
    tepVal = 1;
end
if (get(treg,'Value') == 1)
    tepVal = 2;
end
if (get(temp,'Value') == 1)
    tepVal = 3;
end

auto_fit(get(h,'String'), tepVal);


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = findobj('Tag','edit1');

[FileName,PathName,FilterIndex] = uigetfile('*.txt');

set(h,'String', [PathName FileName]);