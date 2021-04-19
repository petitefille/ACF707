function varargout = Visualize_FitDist(varargin)
% VISUALIZE_FITDIST MATLAB code for Visualize_FitDist.fig
%      VISUALIZE_FITDIST, by itself, creates a new VISUALIZE_FITDIST or raises the existing
%      singleton*.
%
%      H = VISUALIZE_FITDIST returns the handle to a new VISUALIZE_FITDIST or the handle to
%      the existing singleton*.
%
%      VISUALIZE_FITDIST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VISUALIZE_FITDIST.M with the given input arguments.
%
%      VISUALIZE_FITDIST('Property','Value',...) creates a new VISUALIZE_FITDIST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Visualize_FitDist_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Visualize_FitDist_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Visualize_FitDist

% Last Modified by GUIDE v2.5 24-Apr-2016 12:55:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Visualize_FitDist_OpeningFcn, ...
                   'gui_OutputFcn',  @Visualize_FitDist_OutputFcn, ...
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


% --- Executes just before Visualize_FitDist is made visible.
function Visualize_FitDist_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Visualize_FitDist (see VARARGIN)

% Choose default command line output for Visualize_FitDist
handles.output = hObject;
handles.P=varargin{1};

list=['all';handles.P.benchmarklabel; handles.P.priceslabels];
set(handles.popupmenu_chooseStock,'String',list)
handles.I=1;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Visualize_FitDist wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Visualize_FitDist_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu_chooseStock.
function popupmenu_chooseStock_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_chooseStock (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_chooseStock contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_chooseStock

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes during object creation, after setting all properties.
function popupmenu_chooseStock_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_chooseStock (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_fit.
function pushbutton_fit_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_fit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I=get(handles.popupmenu_chooseStock,'Value');
h=handles.uibuttongroup_rets.SelectedObject.Tag;

prices=handles.P.prices;
switch h
    case 'radiobutton_simple'
        rets=handles.P.computeReturns(prices,'s');
        
    case 'radiobutton_log'
        rets=handles.P.computeReturns(prices,'l');
        
    case 'radiobutton_exp'
        rets=handles.P.computeReturns(prices,'e');
end

cla; D=[];P=[];

axes(handles.axes_retDist);
set(handles.axes_retDist,'Visible','on')
assignin('base','Hdist',handles)
assignin('base','Returns',rets)
if I== 1
    [D PD]=allfitdist(deleteoutliers(rets),'PDF');
else
    [D PD]=allfitdist(deleteoutliers(rets(:,I-1)),'PDF');
    display(D,'D=')
end
assignin('base','D',D)

data=[[D.NLogL]' [D.AIC]' [D.BIC]'];
names=fieldnames(D);
names=names(2:4);
for i =1:length([D.NLogL])
    Rnames{i}=D(i).DistName;
end
    
set(handles.uitable_retDist,'Data',data)
set(handles.uitable_retDist,'ColumnName',names)
set(handles.uitable_retDist,'RowName',Rnames)

