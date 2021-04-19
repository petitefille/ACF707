function varargout = Visualize_price(varargin)
% VISUALIZE_PRICE MATLAB code for Visualize_price.fig
%      VISUALIZE_PRICE, by itself, creates a new VISUALIZE_PRICE or raises the existing
%      singleton*.
%
%      H = VISUALIZE_PRICE returns the handle to a new VISUALIZE_PRICE or the handle to
%      the existing singleton*.
%
%      VISUALIZE_PRICE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VISUALIZE_PRICE.M with the given input arguments.
%
%      VISUALIZE_PRICE('Property','Value',...) creates a new VISUALIZE_PRICE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Visualize_price_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Visualize_price_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Visualize_price

% Last Modified by GUIDE v2.5 26-Feb-2016 13:08:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Visualize_price_OpeningFcn, ...
                   'gui_OutputFcn',  @Visualize_price_OutputFcn, ...
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


% --- Executes just before Visualize_price is made visible.
function Visualize_price_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Visualize_price (see VARARGIN)

% Choose default command line output for Visualize_price
handles.output = hObject;
handles.P=varargin{1};
handles.legend1=[];
handles.legend2=[];
handles.I=1;


% Update handles structure

plotfunc(hObject,handles);
stock_list=[handles.P.benchmarklabel; handles.P.priceslabels];

set(handles.popupmenu_stock,'String',stock_list);
assignin('base','handles',handles);
guidata(hObject, handles);


% UIWAIT makes Visualize_price wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Visualize_price_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function plotfunc(hObject,handles,varargin)

if nargin == 3
     lag=varargin{1};
     clax=[];
     I=handles.I;
 elseif nargin ==4
     lag=varargin{1};
     clax=varargin{2};
     I=handles.I;
elseif nargin == 5
    lag=varargin{1};
    clax=varargin{2};
    I=varargin{3};
else
    lag=1;
    clax=[];
    I=handles.I;
end

ax=handles.uipanel_axes; % ??

prices=[handles.P.benchmark handles.P.prices]; 
stocks=[handles.P.benchmarklabel; handles.P.priceslabels];

lrets=handles.P.getReturns;
ax1=subplot(2,1,1,'Parent',ax);

if strcmp(clax,'ax1') || strcmp(clax,'ax')
    cla(ax1)
    cla(ax1,'reset')
end


handles.ax1=ax1;
plot(handles.P.dates(lag:end),prices(lag:end,I),'b','LineWidth',2)
datetick(gca,'x','yyyy')

ylabel('Prices');
title('Price series');
box('on')
grid('on')

ax2=subplot(2,1,2,'Parent',ax);
if strcmp(clax,'ax2') 
    cla(ax2)
    cla(ax2,'reset')
end


plot(handles.P.dates(lag:end-1),tick2ret(prices(lag:end,I),handles.P.dates(lag:end),'Continuous'),'b')
ylabel('Returns')
xlabel('Dates')
xlim(ax2,[734436.48 736397.52]);
datetick(gca,'x','yyyy')


title('Return series')
box('on')
grid('on')



% --- Executes during object creation, after setting all properties.  % her
% er jeg
function axes_price_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_price (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% Hint: place code in OpeningFcn to populate axes_price


% --- Executes on button press in pushbutton_ma2.
function pushbutton_ma2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ma2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ax=handles.uipanel_axes;

lag=str2num(get(handles.edit_lag2,'string'));
plotfunc(hObject,handles,lag)

hold 'on'
ma_rets=movavg(tick2ret(handles.P.benchmark,handles.P.dates),lag);

ax1=subplot(2,1,2,'Parent',ax)
hold 'on'
plot(handles.P.dates(lag+1:end),ma_rets,'r','LineWidth',1.5)

% --- Executes on button press in pushbutton_ewma2.
function pushbutton_ewma2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ewma2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ax=handles.uipanel_axes;

hold 'on'
lag=str2num(get(handles.edit_lag2,'string'));
ewma_rets=emovavg(tick2ret(handles.P.benchmark,handles.P.dates),lag);

ax1=subplot(2,1,2,'Parent',ax)
hold 'on'
plot(handles.P.dates(2:end),ewma_rets,'g--','LineWidth',1.5)


function edit_lag2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_lag2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_lag2 as text
%        str2double(get(hObject,'String')) returns contents of edit_lag2 as a double


% --- Executes during object creation, after setting all properties.
function edit_lag2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_lag2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_ma1.
function pushbutton_ma1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ma1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ax=handles.uipanel_axes;
lag=str2num(get(handles.edit_lag1,'string'));
plotfunc(hObject,handles,lag)

ma_prices=movavg(handles.P.benchmark,lag);
ax1=subplot(2,1,1,'Parent',ax)
hold 'on'
plot(handles.P.dates(lag:end),ma_prices,'r','LineWidth',1.5)






% --- Executes on button press in pushbutton_ewma1.
function pushbutton_ewma1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ewma1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ax=handles.uipanel_axes;
lag=str2num(get(handles.edit_lag1,'string'));
ewma_prices=emovavg(handles.P.benchmark,lag);


ax1=subplot(2,1,1,'Parent',ax)
hold 'on'
plot(handles.P.dates(1:end),ewma_prices,'g','LineWidth',1.5)



function edit_lag1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_lag1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_lag1 as text
%        str2double(get(hObject,'String')) returns contents of edit_lag1 as a double


% --- Executes during object creation, after setting all properties.
function edit_lag1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_lag1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_remove2.
function pushbutton_remove2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_remove2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plotfunc(hObject,handles,1,'ax2')

% --- Executes on button press in pushbutton_remove1.
function pushbutton_remove1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_remove1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plotfunc(hObject,handles,1,'ax1')


% --- Executes on selection change in popupmenu_stock.
function popupmenu_stock_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_stock (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I=get(hObject,'Value');
handles.I=I;
plotfunc(hObject,handles,1,'ax',I)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_stock contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_stock


% --- Executes during object creation, after setting all properties.
function popupmenu_stock_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_stock (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
