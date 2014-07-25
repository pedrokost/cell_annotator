function varargout = TrackletViewer(varargin)
% TRACKLETVIEWER MATLAB code for TrackletViewer.fig
%      TRACKLETVIEWER, by itself, creates a new TRACKLETVIEWER or raises the existing
%      singleton*.
%
%      H = TRACKLETVIEWER returns the handle to a new TRACKLETVIEWER or the handle to
%      the existing singleton*.
%
%      TRACKLETVIEWER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRACKLETVIEWER.M with the given input arguments.
%
%      TRACKLETVIEWER('Property','Value',...) creates a new TRACKLETVIEWER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TrackletViewer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TrackletViewer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TrackletViewer

% Last Modified by GUIDE v2.5 25-Jul-2014 12:34:06

% Begin initialization code - DO NOT EDIT

global DSIN foldn;

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TrackletViewer_OpeningFcn, ...
                   'gui_OutputFcn',  @TrackletViewer_OutputFcn, ...
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

% --- Executes just before TrackletViewer is made visible.


function TrackletViewer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TrackletViewer (see VARARGIN)

% Choose default command line output for TrackletViewer
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using TrackletViewer.
if strcmp(get(hObject,'Visible'),'off')
end

% UIWAIT makes TrackletViewer wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function CloseRequestFcn(hObject, eventdata, handles)
  delete(gcf);

% --- Outputs from this function are returned to the command line.
function varargout = TrackletViewer_OutputFcn(hObject, eventdata, handles)
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
global foldn DSIN;

if ~strcmp(foldn, '') && ~(strcmp(class(foldn),'double'))
  clear DSIN;
  DSIN = DataStore(foldn, false);
  showTracklets(handles)
end


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global foldn DSIN;

foldn = uigetdir(pwd, 'Select folder with annotations');

if ~strcmp(foldn, '') && ~(strcmp(class(foldn),'double'))
  clear DSIN;
  global DSIN;
  DSIN = DataStore(foldn, false);
  showTracklets(handles)
end


function showTracklets(handles)
  cla;
	tracklets = generateTracklets3D('in', struct('withAnnotations', true));
	trackletViewer3D(tracklets, 'in', struct('animate', false, 'showLabels', false));
  axis tight; 
  rotate3d on
