function varargout = MasterGUI(varargin)
% MASTERGUI MATLAB code for MasterGUI.fig
%      MASTERGUI, by itself, creates a new MASTERGUI or raises the existing
%      singleton*.
%
%      H = MASTERGUI returns the handle to a new MASTERGUI or the handle to
%      the existing singleton*.
%
%      MASTERGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MASTERGUI.M with the given input arguments.
%
%      MASTERGUI('Property','Value',...) creates a new MASTERGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MasterGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MasterGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MasterGUI

% Last Modified by GUIDE v2.5 05-Jun-2016 14:12:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;

gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ... % 1
                   'gui_OpeningFcn', @MasterGUI_OpeningFcn, ... % gui_OpeningFcn peker til funksjonen MasterGUI_OpeningFcn
                   'gui_OutputFcn',  @MasterGUI_OutputFcn, ... % gui_OutputFcn peker til funksjonen MasterGUI_OutputFcn
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
%  % https://se.mathworks.com/help/matlab/ref/function_handle.html
if nargin && ischar(varargin{1}) % hvis MasterGUI inneholder input argument og første arg er av type char
    % nargin: Number of function input arguments
    % varargin{1}: første index i varargin : er denne av type char
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    % % Number of function output arguments
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

end

% --- Executes just before MasterGUI is made visible.
function MasterGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MasterGUI (see VARARGIN)

% Choose default command line output for MasterGUI
handles.output = hObject;

% ---------------------------------------------------------------------
% Main setup
% ---------------------------------------------------------------------


% Selected portfolio
% Note: handles.selection is the marker handle. for the portfolio
handles.model  = PortObj();

% Date string format (used to convert string into serial dates)
handles.datestringformat = 'dd.mm.yyyy';





    % Set renderer
    set(handles.mainFig,'Renderer','OpenGL')

    % ---------------------------------------------------------------------
    % Tab setup
    % ---------------------------------------------------------------------
    % Create custom tabs
    tab_labels = {'Data Import','Portfolio settings','Optimization settings','Portfolio Optimization'};
    handles.tabcount = length(tab_labels);  % Number of tabs
    for i = 1:handles.tabcount
        eval(['h = handles.axes_tab_',num2str(i),';']);  
        axes(h);
        pos = get(h,'Position');
        set(h,'XLim',[0,pos(3)]);
        set(h,'YLim',[0,pos(4)]);
        set(h,'XTick',[]);
        set(h,'YTick',[]);
        set(h,'XTickLabel',{});
        set(h,'YTickLabel',{});
        patch([0,5,pos(3)-5,pos(3),0],[0,pos(4),pos(4),0,0],[1,1,1]);
        text(pos(3)/2,pos(4)/2+2,tab_labels{i},'HorizontalAlignment','center','FontSize',8,'FontName','Helvetica','Units','pixels');
        c = get(h,'Children');   % make sure we can always click on axes object
        for j = 1:length(c)  
            set(c(j),'HitTest','off');
        end
    end
    

% Make data import page current
    tab_handler(1,handles);
% Set default values and hide menus

% Update handles structure
guidata(hObject, handles);
end





% --- Outputs from this function are returned to the command line.
function varargout = MasterGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

%-------------------%
%Tab handling
%-------------------%

% --- Make selected tab and panel active (visible).
function tab_handler(active_tab,handles)
    % activate selected tab and disable all others
    for i = 1:handles.tabcount
        h = eval(['handles.axes_tab_',num2str(i)]);
        p = findobj(h,'Type','patch');
        if ~isempty(p)
            if i==active_tab
                set(p,'FaceColor',[1,1,1]);
                eval(['set(handles.uipanel_tab',num2str(i),',''Visible'',''on'');']);
            else
                %set(p,'FaceColor',[0.9,0.95,1]);
                set(p,'FaceColor',[0.8,0.85,1]);
                eval(['set(handles.uipanel_tab',num2str(i),',''Visible'',''off'');']);
            end
        end
    end
end



% --- Executes on mouse press over axes background.
function axes_tab_1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes_tab_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    tab_handler(1,handles);
end


% --- Executes on mouse press over axes background.
function axes_tab_2_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes_tab_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    tab_handler(2,handles);
end


% --- Executes on mouse press over axes background.
function axes_tab_3_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes_tab_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    tab_handler(3,handles);
end


% --- Executes on mouse press over axes background.
function axes_tab_4_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes_tab_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    tab_handler(4,handles);
end

%----------------------------------
% Tab 1 - data import 
%----------------------------------


% --- Executes on selection change in popupmenu_dataimport_selectsource.
function popupmenu_dataimport_selectsource_Callback(hObject, eventdata, handles)

switch get(hObject,'Value')
    case 1
        set(handles.uipanel_dataimport_datafeed,'Visible','on')
        set(handles.uipanel_dataimport_xlsfile,'Visible','off')        
    case 2
        set(handles.uipanel_dataimport_datafeed,'Visible','off')
        set(handles.uipanel_dataimport_xlsfile,'Visible','on')
end
        
end
% --- Executes during object creation, after setting all properties.
function popupmenu_dataimport_selectsource_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_dataimport_selectsource (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit_duration_Callback(hObject, eventdata, handles)
% hObject    handle to edit_duration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_duration as text
%        str2double(get(hObject,'String')) returns contents of edit_duration as a double
duration=str2double(get(handles.edit_duration,'String'));
if isnan(duration) || isempty(duration) || (duration <= 0) || (duration > 10)
    duration = 5
    set(handles.edit_duration,'String','5');
    set(handles.edit_stop,'String',datestr(today,24));
    set(handles.edit_start,'String',datestr(today-365.25*duration,24));
else
    set(handles.edit_stop,'String',datestr(today,24));
    set(handles.edit_start,'String',datestr(today-365.25*duration,24));
end
end

% --- Executes during object creation, after setting all properties.
function edit_duration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_duration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
    set(handles.start,'String',datestr(today,24));
end
end


function edit_start_Callback(hObject, eventdata, handles)
% hObject    handle to edit_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_start as text
%        str2double(get(hObject,'String')) returns contents of edit_start as a double
start=get(handles.edit_start,'String');

try
    start=datenum(start,'dd/mm/yyyy');
    
catch ME
    h = msgbox('Please type date in format dd/mm/yyyy, for instance 01/04/2016 for 1. of April 2016', 'Error','error');
    set(handles.edit_start,'String',datestr(today-5*365.25,24))
end
stop=datenum(get(handles.edit_stop,'String'),'dd/mm/yyyy');
set(handles.edit_duration,'String',yearfrac(start,stop,1));
end

% --- Executes during object creation, after setting all properties.
function edit_start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject,'String',datestr(today-5*365.25,24));
end


function edit_stop_Callback(hObject, eventdata, handles)
% hObject    handle to edit_stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_stop as text
%        str2double(get(hObject,'String')) returns contents of edit_stop as a double
stop=get(handles.edit_stop,'String');

try
    stop=datenum(stop,'dd/mm/yyyy');
    
catch ME
    h = msgbox('Please type date in format dd/mm/yyyy, for instance 01/04/2016 for 1. of April 2016', 'Error','error');
    set(handles.edit_stop,'String',datestr(today,24))
end
start=datenum(get(handles.edit_start,'String'),'dd/mm/yyyy');
set(handles.edit_duration,'String',yearfrac(start,stop,1));
end
% --- Executes during object creation, after setting all properties.
function edit_stop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');

end
set(hObject,'String',datestr(today,24));
end
% --- Executes on selection change in popupmenu_index.
function popupmenu_index_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_index (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_index contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_index
I=get(hObject,'Value');
switch I
    case 2
        m=29;
    case 3
        m=98;
    case 4
        m=500;
end
set(handles.edit_m,'String',m)
end
% --- Executes during object creation, after setting all properties.
function popupmenu_index_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_index (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in listbox_frequence.
function listbox_frequence_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_frequence (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_frequence contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_frequence
I=get(hObject,'Value')
switch I
    case 1
        handles.model.setFrequence('d')
    case 2
        handles.model.setFrequence('w')
    case 3
        handles.model.setFrequence('m')
end
end
% --- Executes during object creation, after setting all properties.
function listbox_frequence_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_frequence (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in togglebutton_download.
function togglebutton_download_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_download (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of togglebutton_download


done=0;

while ~done
    set(handles.text_downloading,'String','Downloading')
    
    duration=str2double(get(handles.edit_duration,'String'));
    frequence=get(handles.listbox_frequence,'Value');
    switch frequence
        case 1
            frequence='d';
        case 2
            frequence='w';
        case 3
            frequence='m';
    end
    I=get(handles.popupmenu_index,'Value');
    Ind=get(handles.popupmenu_index,'String');
    
    if I==1
        h = msgbox('Please choose an index', 'Error','error');
    else
        index_T=Ind(I);
    end
    if get(handles.popupmenu_MissingData,'Value')==4
        NAN=1; % nan_method='intersection';
    else
        NAN=0; % nan_method='union';
    end
    
    set(handles.text_downloading,'Visible','On')
    [AC,stock_names]=collectSP(duration,frequence,str2double(get(handles.edit_m,'String')),index_T,NAN);
    N=get(handles.popupmenu_MissingData,'Value');
    switch N
        case 1
            AC=fillts(AC,'le');
        case 2
            AC=fillts(AC,'ce');
            
        case 3
            AC=fillts(AC,'se');
    end
    
    dates=AC.Properties.RowTimes;
    prices=fts2mat(AC);
    S = vartype('numeric');
    mat = AC(:,S);
    prices = mat.Variables;
    benchmark=prices(:,1);
    
    prices(:,1)=[];% ?? jeg tror dette betyr at første kolonne
    % som benchmarks slettes
    
    assignin('base','dates_Y',dates)

    updateImportDataPage(handles,prices,benchmark,dates,stock_names,index_T);
 done=1;
end

set(handles.text_downloading,'String','Download finished')
end
% --- Executes on selection change in popupmenu_MissingData.
function popupmenu_MissingData_Callback(hObject, eventdata, handles)
end

function popupmenu_MissingData_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_MissingData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function edit_m_Callback(hObject, eventdata, handles)
% hObject    handle to edit_m (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_m as text
%        str2double(get(hObject,'String')) returns contents of edit_m as a double
end

% --- Executes during object creation, after setting all properties.
function edit_m_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_m (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% ---------------------------------
%Excel import 

function pushbutton_choose_Callback(hObject, eventdata,handles)
    [filename,pathname] = uigetfile({'*.xlsx;*.xls','Excel File'},'Please select file');
        if ~isequal(filename,0)
            set(handles.edit_filename,'String',fullfile(pathname,filename));
        end
end

function pushbutton_importExcel_Callback(hObject, eventdata, handles)
% hObject    handle to push_opt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename=get(handles.edit_filename,'String');
[~,~,rawdata] = xlsread(filename);
% update status and return
if isempty(rawdata)
    % update status and return
    h = msgbox('File is empty', 'Error','error');
    
    return
end
if (size(rawdata,1) < 10) || (size(rawdata,2) < 4)
    % update status and return
    h = msgbox('Too little data for analysis', 'Error','error');
    return
end

date=get(handles.checkbox_dates,'Value');
date_I=get(handles.popupmenu_dateFormat,'Value'); % index
date_format=get(handles.popupmenu_dateFormat,'String'); % vector of all
% possible date formats
date_format=date_format{date_I}

if date % if dates are included
    dates = rawdata(2:end,1); % extract dates from excel sheets
    assignin('base','dates',dates)
    try
        dates = x2mdate(cell2mat(dates));
    catch ME
        h=msgbox('Date failed, probably wrong dateformat','Error','error');
    end
%    
    rawdata(:,1)=[]; % delate first column 
                      % so first column is now benchmark (if included)
else
    dates = [] % empty
end

if isa(rawdata(1,:),'numeric') % first row containing name of companies
    % if empty (because it consists of numbers
    priceslabels=[]; % price labels will be empty
    % pricelabels is name of companies
else
    priceslabels=rawdata(1,:); % else assign name of companies (first row)
    % to pricelabels var
end
       

if get(handles.checkbox_bench,'Value') % are benchmarks included
    benchmark=cell2mat(rawdata(2:end,1));
    benchmarklab=priceslabels(1);
    priceslabels=priceslabels(2:end);% prices do not include benchmark
    prices=cell2mat(rawdata(2:end,2:end));% benchmarks not included 
    updateImportDataPage(handles,prices,benchmark,dates,priceslabels,benchmarklab);
else % benchmark not included
    prices=cell2mat(rawdata(2:end,2:end));% ?? missing first column 
    updateImportDataPage(handles,prices,[],dates,priceslabels,[]);
end


end

function checkbox_dates_Callback(hObject, eventdata, handles)
set(handles.popupmenu_dateFormat,'Enable','on')

end

function checkbox_bench_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_bench (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_bench
end

% updateImportDataPage(handles,prices,benchmark,dates,stock_names,index_T);
function updateImportDataPage(handles,prices,benchmark,dates,priceslabels,benchmarklabel)
% prices:          prices series
% benchmark:       benchmark series
% dates:           dates series
% priceslabels:    asset labels
% benchmarklabel:  benchmark label
    % add data to table
    if ~isempty(benchmark) % benchmark is included
        series = [benchmark(:),prices];
        serieslabels = [benchmarklabel,priceslabels(:)'];
        %set(handles.benchmark,'Value',1);  % valid benchmark as first column
 

    else % benchmark not included
        benchmark=[];
        series = prices;
        serieslabels = priceslabels;
        %set(handles.benchmark,'Value',0);  % no benchmark

    end
    if ~isempty(dates) % dates are included
        datesstr = cellstr(datestr(dates,handles.datestringformat));
        set(handles.uitable_importedData,'RowName',datesstr);
    else % dates not included
        dates=[]; % dates will be empty
        set(handles.uitable_importedData,'RowName',[]);
        
    end
    %Set dataseries
    set(handles.uitable_importedData,'ColumnName',serieslabels,'Data',series);
    % enable controls
    % serieslabels inneholder navnene på både benchmark og companies
    % series inneholder prisene til benchmark + companies
    

    handles.model.importData(prices,benchmark,dates,priceslabels,benchmarklabel)    
end   
 

% --- Executes on button press in pushbutton_pricePlot.
function pushbutton_pricePlot_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_pricePlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Visualize_price(handles.model); % function Visualize_price
end
% --- Executes on button press in pushbutton_retHist.
function pushbutton_retHist_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_retHist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Visualize_FitDist(handles.model); % function Visualize_FitDist
% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over togglebutton_download.
end
function togglebutton_download_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to togglebutton_download (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in pushbutton_showResults.
function pushbutton_accept_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_showResults (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tab_handler(2,handles);
end

%----------------------------------
% Tab 2 Model settings
%----------------------------------



% --- Executes on button press in radiobutton_parametric.
function radiobutton_parametric_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_parametric (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_parametric

set(handles.uibuttongroup_para,'Visible','on')
set(handles.uibuttongroup_non,'Visible','off')
end
function edit_decay_Callback(hObject, eventdata, handles)
% hObject    handle to edit_decay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_decay as text
%        str2double(get(hObject,'String')) returns contents of edit_decay as a double
end

% --- Executes during object creation, after setting all properties.
function edit_decay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_decay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
% --- Executes when selected object is changed in uibuttongroup_return.

function uibuttongroup_return_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup_return 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I=get(hObject,'tag');
switch I
    case 'radiobutton_simple'
        handles.model.setReturnType('s')
    case 'radiobutton_log'
        handles.model.setReturnType('l')        
    case 'radiobutton_exp'
        handles.model.setReturnType('e')
end
end
% --- Executes on button press in radiobutton_nonpara.
function radiobutton_nonpara_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_nonpara (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_nonpara
set(handles.uibuttongroup_para,'Visible','off')
set(handles.uibuttongroup_non,'Visible','on')
end

% --- Executes when selected object is changed in uibuttongroup_risk.
function uibuttongroup_risk_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup_risk 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I=get(hObject,'tag');
switch I
    case 'radiobutton_variance'
        handles.model.setRiskType('MV')
    case 'radiobutton_cvar'
        handles.model.setRiskType('CVAR')        
    case 'radiobutton_both'
        handles.model.setRiskType('both')
end
end
% --- Executes on button press in pushbutton_inspect.
function pushbutton_inspect_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_inspect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in pushbutton_assignScen.
function pushbutton_assignScen_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_assignScen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
S=handles.model.getScenarios;
N=strcat('Scenario_',handles.model.scenarioMethod);
assignin('base',N,S)
end

% --- Executes on button press in pushbutton_assignAll.
function pushbutton_assignAll_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_assignAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
assignin('base','Model',handles.model)
end

% --- Executes on button press in pushbutton_const.
function pushbutton_const_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_const (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


% --- Executes on selection change in popupmenu_constraintType.
function popupmenu_constraintType_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_constraintType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_constraintType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_constraintType


% --- Executes during object creation, after setting all properties.
function popupmenu_constraintType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_constraintType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',{'Turnover Constraints','Tracking error constraints','Boundry constraints'})
end

% --- Executes on button press in pushbutton_equally.
function pushbutton_equally_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_equally (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
N=handles.model.getN;
set(handles.uitable_turnOver,'Data',ones(N,1)./N)
end
% --- Executes on button press in pushbutton_riskParity.
function pushbutton_riskParity_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_riskParity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Sigma=diag(handles.model.getCovariance);
sumSigma=sum(Sigma);
RP=Sigma./sumSigma;
set(handles.uitable_turnOver,'Data',RP)
end

function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double
end

% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in pushbutton_RP2.
function pushbutton_RP2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_RP2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double
end

% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end
% --- Executes on button press in pushbutton_TEbench.
function pushbutton_TEbench_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_TEbench (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

end
% --- Executes on button press in checkbox_activateConst.
function checkbox_activateConst_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_activateConst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_activateConst
if (get(hObject,'Value'))
    set(findall(handles.uipanel_const, '-property', 'enable'), 'enable', 'on');
    set(handles.uipanel_const,'Visible','on')
else
    set(findall(handles.uipanel_const, '-property', 'enable'), 'enable', 'off');
    set(handles.uipanel_const,'Visible','off')

end

end
% --- Executes on button press in pushbutton_equally2.
function pushbutton_equally2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_equally2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
N=handles.model.getN;
set(handles.uitable_initial,'Data',ones(N,1)./N)

end
function edit_TE_Callback(hObject, eventdata, handles)
% hObject    handle to edit_TE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_TE as text
%        str2double(get(hObject,'String')) returns contents of edit_TE as a double
end

% --- Executes during object creation, after setting all properties.
function edit_TE_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_TE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in pushbutton_followBench.
function pushbutton_followBench_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_followBench (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

end

function edit_LB_Callback(hObject, eventdata, handles)
% hObject    handle to edit_LB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end
% Hints: get(hObject,'String') returns contents of edit_LB as text
%        str2double(get(hObject,'String')) returns contents of edit_LB as a double


% --- Executes during object creation, after setting all properties.
function edit_LB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_LB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function edit_UB_Callback(hObject, eventdata, handles)
% hObject    handle to edit_UB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_UB as text
%        str2double(get(hObject,'String')) returns contents of edit_UB as a double

UB=str2num(get(hObject,'String'))/100;
LB=str2num(get(handles.edit_LB,'String'))/100;

N=handles.model.getN;


if UB < (1/N)
    h = msgbox('The upper bound is to low. Asset weights should be able to sum to 1. Set bound bigger than 1/number of assets', 'Error','error');
    set(hObject,'String',(1/N)*100);
elseif UB <= LB
    h = msgbox('Upper bound is lower or equal the lower bound', 'Error','error');
    set(hObject,'String',(LB+0.1)*100);
end
end        
% --- Executes during object creation, after setting all properties.
function edit_UB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_UB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes during object creation, after setting all properties.
function uipanel_const_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel_const (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
    set(findall(hObject, '-property', 'enable'), 'enable', 'off');
end

% --- Executes during object creation, after setting all properties.
function uipanel18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(findall(hObject, '-property', 'enable'), 'enable', 'off');
end

% --- Executes on button press in pushbutton_set.
function pushbutton_set_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_set (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(findall(handles.uipanel18, '-property', 'enable'), 'enable', 'on');
handles.model.setModel;
end
% --- Executes on button press in radiobutton_boot.
function radiobutton_boot_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_boot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_boot
if get(hObject,'Value')
    handles.model.setScenarioMethod('boot');
end
end


function radiobutton_student_Callback(hObject, eventdata, handles)
if get(hObject,'Value')
    handles.model.setScenarioMethod('studT');
end
end

% --- Executes on button press in radiobutton_normal.
function radiobutton_normal_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_normal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_normal
if get(hObject,'Value')
    handles.model.setScenarioMethod('norm');
end
end

% --- Executes on button press in radiobutton_hist.
function radiobutton_hist_Callback(hObject, eventdata, handles)
if get(hObject,'Value')
    handles.model.setScenarioMethod('hist');
end
end

function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double
end

% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in pushbutton_acceptTab2.
function pushbutton_acceptTab2_Callback(hObject, eventdata, handles)
tab_handler(3,handles)
end

%--------------------------------------------------------------------
%TAB 3  - Optimization settings
%--------------------------------------------------------------------


% --- Executes when selected object is changed in uibuttongroup_solver.
function uibuttongroup_solver_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup_solver 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I=get(hObject,'tag');
switch I
    case 'radiobutton_fmincon'
        solv='fmincon';
        set(findall(handles.uipanel_algorithm, '-property', 'enable'), 'enable', 'on');
        set(handles.uibuttongroup_fmincon,'Visible','on')
        set(handles.uibuttongroup_quadprog,'Visible','off')
        set(handles.uibuttongroup_linprog,'Visible','off')

    case 'radiobutton_quadprog'
        solv='quadprog';
        set(findall(handles.uipanel_algorithm, '-property', 'enable'), 'enable', 'on');
        set(handles.uibuttongroup_quadprog,'Visible','on') 
        set(handles.uibuttongroup_fmincon,'Visible','off')
        set(handles.uibuttongroup_linprog,'Visible','off')
        
    case 'radiobutton_linprog'
        solv='linprog';
        set(findall(handles.uipanel_algorithm, '-property', 'enable'), 'enable', 'on');
        set(handles.uibuttongroup_quadprog,'Visible','off') 
        set(handles.uibuttongroup_fmincon,'Visible','off')
        set(handles.uibuttongroup_linprog,'Visible','on')
        
end 
end

% --- Executes during object creation, after setting all properties.
function uipanel_algorithm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel_algorithm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(findall(handles.uipanel_algorithm, '-property', 'enable'), 'enable', 'off');
end

% --- Executes when selected object is changed in uibuttongroup_linprog.
function uibuttongroup_linprog_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup_linprog 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switch get(hObject,'tag');

    case 'radiobutton_simp'
    case 'radiobutton_IP'
    case 'radiobutton_cmpLP'
end
end

% --- Executes on button press in pushbutton_optim.
function pushbutton_optim_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_optim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Solver=get(handles.uibuttongroup_solver.SelectedObject,'tag');
switch Solver
    case 'radiobutton_fmincon'
        solv='fmincon';
        switch get(handles.uibuttongroup_fmincon.SelectedObject,'tag');
            case 'radiobutton_trr'
                algo={'trust-region-reflective'};
            case 'radiobutton_sqp'
                algo={'sqp'};
            case 'radiobutton_interior'
                algo={'interior-point'};
            case 'radiobutton_cmpF'
                algo={'interior-point','trust-region-reflective','sqp'};
        end
    case 'radiobutton_quadprog'
        solv='quadprog';
        switch get(handles.uibuttongroup_quadprog.SelectedObject,'tag');
            case 'radiobutton_CIP'
                algo={'interior-point-convex'}
            case 'radiobutton_TRRQ'
                algo={'trust-region-reflective'}
            case 'radiobutton_cmpQ'
                algo={'interior-point-convex','trust-region-reflective'}

        end
        
    case 'radiobutton_linprog'
        solv='linprog';
        switch get(handles.uibuttongroup_linprog.SelectedObject,'tag');
            case 'radiobutton_simp'
                algo={'dual-simplex'};
            case 'radiobutton_IP'
                algo={'interior-point'};
            case 'radiobutton_cmpLP'
                algo={'dual-simplex','interior-point'};
        end
        
end

%set(handles.uitable_time,'Data',[],'RowName',[])
t=handles.model.computeFrontier(solv,algo);
RowN=get(handles.uitable_time,'RowName');

set(handles.uitable_time,'RowName',RowN)
data=get(handles.uitable_time,'Data');
i=length(data);
data=[data;algo' t'];
RowN{i+1}=solv;
set(handles.uitable_time,'Data',data,'RowName',RowN)
end

% --- Executes during object creation, after setting all properties.
function uitable_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uitable_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'Data',{},'RowName',{})
end

% --- Executes on button press in pushbutton28.
function pushbutton28_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


% --- Executes during object creation, after setting all properties.
function edit_results_confidencelevel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_results_confidencelevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in popupmenu_results_valueatrisk.
function popupmenu_results_valueatrisk_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_results_valueatrisk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 edit_results_confidencelevel_Callback(handles.edit_results_confidencelevel, [], handles);

end


% --- Executes during object creation, after setting all properties.
function popupmenu_results_valueatrisk_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_results_valueatrisk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

function pushbutton_showResults_Callback(hObject, eventdata, handles)
    updateResultsPage(handles)
    
    tab_handler(4,handles)
end
%--------------------------------------------------------------------
%TAB 4  - result page
%--------------------------------------------------------------------


function updateResultsPage(handles)
% handles    structure with handles and user data (see GUIDATA)

    % First clear page to remove all prior allocation details
    clearResultsPage(handles);
    handles.selection = [];
    guidata(handles.mainFig, handles);

    % Enable controls
%    set(handles.edit_results_confidencelevel,'Enable','on');
    set(handles.edit_results_riskfreerate,'Enable','on');
 %   set(handles.popupmenu_results_valueatrisk,'Enable','on');
  
    
    % Get statistics and optimization results
    % Note: use annualized values for visualization
    [~,~,annualized_ret,annualized_rsk] = handles.model.getStatistics;
    [~,~,annualized_benchmark_ret,annualized_benchmark_rsk] = handles.model.getBenchmarkStatistics;
    [MV_ret,MV_rsk,CVAR_ret,CVAR_rsk,CVAR_std,w_MV,w_CVAR] = handles.model.getOptimizationResults;
    
    % use percentages
    MV_ret=MV_ret*100; MV_rsk=MV_rsk*100; 
    CVAR_ret=CVAR_ret*100;CVAR_rsk=CVAR_rsk*100;CVAR_std=CVAR_std*100;
        
    if strcmp(handles.model.getRiskType,'CVAR')
            [~,annualized_rsk]=handles.model.computeAssetCVaR;
            [~,annualized_benchmark_rsk]=handles.model.computeBenchCVaR;
    end
    
    annualized_ret=annualized_ret*100; annualized_rsk=annualized_rsk*100;
    annualized_benchmark_ret = annualized_benchmark_ret*100;
    annualized_benchmark_rsk = annualized_benchmark_rsk*100;
    
    axes(handles.axes_results_efficientfrontier);
    set(handles.axes_results_efficientfrontier,'Visible','on');
    hold('on');
    handles.model.getRiskType
    switch handles.model.getRiskType
        case 'MV'
            % Plot efficient frontier and individual assets

            plot(MV_rsk,MV_ret,'-o','Color','b','MarkerSize',8);
            plot(annualized_rsk,annualized_ret,'*','Color','r','MarkerSize',5);
            legend_str = {'MV Efficient Portfolios','Individual Assets'};
            if ~isempty(annualized_benchmark_rsk)
                plot(annualized_benchmark_rsk,annualized_benchmark_ret,'^','Color','k')
                legend_str = [legend_str,'Benchmark Portfoliio'];
            end
        case 'CVAR'
            plot(CVAR_rsk,CVAR_ret,'-o','Color','b','MarkerSize',8);
            plot(annualized_rsk,annualized_ret,'*','Color','r','MarkerSize',5);
            legend_str = {'CVaR Efficient Portfolios','Individual Assets'};
            if ~isempty(annualized_benchmark_rsk)
                plot(annualized_benchmark_rsk,annualized_benchmark_ret,'^','Color','k')
                legend_str = [legend_str,'Benchmark Portfoliio'];
            end
            
        case 'both'
            plot(MV_rsk,MV_ret,'-o','Color','b','MarkerSize',8);
            plot(CVAR_std,CVAR_ret,'-o','Color','r       ','MarkerSize',8);
            plot(annualized_rsk,annualized_ret,'*','Color','r','MarkerSize',5);
            legend_str = {'MV Efficient Portfolios','CVaR Efficient Portfolios','Individual Assets'};
            if ~isempty(annualized_benchmark_rsk)
                plot(annualized_benchmark_rsk,annualized_benchmark_ret,'^','Color','k')
                legend_str = [legend_str,'Benchmark Portfoliio'];
            end
    end
    grid('on');
    title('Select Portfolio');
    xlabel('Risk [%]');
    ylabel('Return [%]');
    % add legend, disable interactivity
    h = legend(legend_str,'Location','SouthEast');
    set(h,'UIContextMenu',[]);
    set(h,'HitTest','off');
    set(h,'Box','off')
    el = get(h,'Children');
    for i = 1:length(el)  %change text backgrounds to white
        if strcmp(get(el(i),'Type'),'text')
            set(el(i),'BackgroundColor',[1,1,1]);
        end
    end

    % save legend handle
    handles.axes_results_efficientfrontier_legend = h;
    guidata(handles.mainFig, handles);
    
    % Add marker and marker text to highlight individual assets (not visible right now)
   switch handles.model.getRiskType
       case 'MV'
           po = plot(MV_rsk(1),MV_ret(1),'s','MarkerSize',8,'Color','r','MarkerFaceColor','y');
           set(po,'Visible','off');
           set(po,'Userdata',-1);  % use -1 to find object later
           po = text(MV_rsk(1),MV_ret(1),'');
       case 'CVAR'
           po = plot(CVAR_rsk(1),CVAR_ret(1),'s','MarkerSize',8,'Color','r','MarkerFaceColor','y');
           set(po,'Visible','off');
           set(po,'Userdata',-1);  % use -1 to find object later
           po = text(CVAR_rsk(1),CVAR_ret(1),'');           
       case 'both'
           po = plot(MV_rsk(1),MV_ret(1),'s','MarkerSize',8,'Color','r','MarkerFaceColor','y');
           set(po,'Visible','off');
           set(po,'Userdata',-1);  % use -1 to find object later
           po = text(MV_rsk(1),MV_ret(1),'');
   end
    set(po,'FontSize',8);
    set(po,'BackgroundColor',[1,1,1]);
    set(po,'EdgeColor',[0.8,0.8,0.8])
    set(po,'Visible','off');
    set(po,'Userdata',-2);  % use -2 to find object later
    % Add callback for interactive portfolio selection
    switch handles.model.getRiskType
        case 'MV'
            for i = 1:length(MV_rsk)
                po = plot(MV_rsk(i),MV_ret(i),'bo','MarkerFaceColor','w','MarkerSize',8);
                set(po,'Userdata',i);  % portfolio number
                set(po,'ButtonDownFcn',@portfolioselection_callback);
            end
        case 'CVAR'
            for i = 1:length(CVAR_rsk)
                po = plot(CVAR_rsk(i),CVAR_ret(i),'bo','MarkerFaceColor','w','MarkerSize',8);
                set(po,'Userdata',i);  % portfolio number
                set(po,'ButtonDownFcn',@portfolioselection_callback);
            end
        case 'both'
            for i = 1:length(MV_rsk)
                po = plot(MV_rsk(i),MV_ret(i),'bo','MarkerFaceColor','w','MarkerSize',8);
                set(po,'Userdata',i);  % portfolio number
                set(po,'ButtonDownFcn',@portfolioselection_callback);
            end
    end                      
    % Add callback for interactive selection of individual assets
    for i = 1:length(annualized_rsk)
        po = plot(annualized_rsk(i),annualized_ret(i),'*','Color','r','MarkerSize',5);
        set(po,'Userdata',i);  % asset number
        set(po,'ButtonDownFcn',@assetselection_callback);
    end

        % Callback function (nested) for portfolio selection callback
        function portfolioselection_callback(hObject,event)
            % Select active portfolio
            if ~isempty(handles.selection)
                set(handles.selection,'MarkerFaceColor','none')
                set(handles.selection,'MarkerSize',8)
            end
            set(hObject,'MarkerFaceColor',[0,0.3,0.7])
            set(hObject,'MarkerSize',8)
            handles.selection = hObject; 
            guidata(handles.mainFig,handles);
            
            % Hide marker & markertext
            po = get(handles.axes_results_efficientfrontier,'Children');
            for j = 1:length(po)
                % marker has userdata "-1"
                if get(po(j),'Userdata') == -1
                    set(po(j),'Visible','off');
                end
                % markertext has userdata "-2"
                if get(po(j),'Userdata') == -2
                    set(po(j),'Visible','off');
                end
            end
            
            % Get selected portfolio number
            sel = get(handles.selection,'Userdata');
            
            % Update allocation chart
            switch handles.model.getRiskType
                case 'MV'
                    weights = w_MV(:,sel);
                case 'CVAR'
                    weights=w_CVAR(:,sel);
                case 'both'
                    weights = w_MV(:,sel);
            end
            
            labels  = handles.model.getPricesLabels;
            weights = weights(:);     % use column vectors
            labels  = labels(:);
            
            % collect all components with weight < 1% as "others"
            ind = abs(weights) > 0.01;
            
            alloc        = [weights(ind);sum(weights(~ind))];
            alloc_labels = [labels(ind);{'Others'}];
            % remove others if zero
            if abs(alloc(end)) < 1e-3
                alloc(end) = [];
                alloc_labels(end) = [];
            end
            % add weights to labels
            alloc_labels_weights = [];
            for j = 1:length(alloc_labels)
                alloc_labels_weights{j} = [alloc_labels{j},char(10),num2str(round(alloc(j)*10000)/100),'%'];
            end
            % Visualize allocation summary as pie chart (pie plot only accepts positive entries)
            axes(handles.axes_results_allocation);
           
            h = pie(abs(alloc),alloc_labels_weights);
            for j = 1:length(h)
                if strcmp(get(h(j),'Type'),'text')
                    set(h(j),'FontSize',7);
                end
                if strcmp(get(h(j),'Type'),'patch')
                    set(h(j),'FaceAlpha',0.7);
                    set(h(j),'EdgeAlpha',0.2);
                end
            end

            % Show weights details in table
            [alloc,ind] = sort(alloc,'descend');  % sort alloc and labels in descending order
            alloc_labels = alloc_labels(ind);
            data = {};
            for j = 1:length(alloc)
                data = [data;[alloc_labels{j},'  (',sprintf('%2.2f',alloc(j)*100),'%)']];
            end
            set(handles.uitable_results_weights,'Data',data);
            % Set column width
            pos = get(handles.uitable_results_weights,'Position');
            if length(alloc) > 14
                tablewidth = pos(3) - 4 - 16;  % border + slider
            else
                tablewidth = pos(3) - 4;  % border only
            end
            set(handles.uitable_results_weights,'ColumnWidth',num2cell(tablewidth));


            % Visualize portfolio performance, compare to benchmark
            axes(handles.axes_results_performance);
            set(handles.axes_results_performance,'Visible','on');
            hold('off')
            dates = handles.model.getDates;
            prices = handles.model.getPrices;
            pf_prices = prices*weights;
            pf_prices = 100*pf_prices/abs(pf_prices(1));  % normalize
            if pf_prices(1) < 0
                pf_prices = pf_prices + 200;   % shift up if first val = -100
            end
            legend_str = {'Selected Portfolio'};
            if ~isempty(dates)
                plot(dates,pf_prices);
                axis('tight');
                datetick('x','keeplimits');
            else
                plot(pf_prices);
            end
            grid('on');
            box('off');
            ylabel('Relative Performance [%]');
            xlabel('Dates');
            hold('on');
            benchmark = handles.model.getBenchmark;
            if ~isempty(benchmark)
                legend_str = [legend_str,handles.model.getBenchmarkLabel];
                benchmark = 100*benchmark/benchmark(1);   % normalize
                if ~isempty(dates)
                    plot(dates,benchmark,'r');
                    axis('tight');
                    datetick('x','keeplimits');
                else
                    plot(benchmark,'r');
                end
            end
            h = legend(legend_str,'Location','NorthWest');
            set(h,'UIContextMenu',[]);
            set(h,'HitTest','off');
            set(h,'Box','off')
            el = get(h,'Children');
            for j = 1:length(el)  %change text backgrounds to white
                if strcmp(get(el(j),'Type'),'text')
                    set(el(j),'BackgroundColor',[1,1,1]);
                end
            end
            % save legend handle
            handles.axes_results_performance_legend = h;
            guidata(handles.mainFig, handles);

            % Update performance metrics (fire event to riskfree rate edit box)
            edit_results_riskfreerate_Callback(handles.edit_results_riskfreerate, [], handles)
            
            % Update value at risk (fire event to confidence level edit box)
            set(handles.axes_results_valueatrisk,'Visible','on');
            edit_results_confidencelevel_Callback(handles.edit_results_confidencelevel, [], handles);
          end  
        
    
        % Callback function (nested) for asset selection callback
        function assetselection_callback(hObject,event)

            % get selected item
            selection = get(hObject,'Userdata');

            % update marker
            showMarker(handles,selection)
        end
end


function showMarker(handles,selection)
% selection    Selected asset number or asset label

    % get marker/markertext handle
    po = get(handles.axes_results_efficientfrontier,'Children');
    marker = [];
    markertext = [];
    for i = 1:length(po)
        % marker has userdata "-1"
        if get(po(i),'Userdata') == -1
            marker = po(i);
        end
        % markertext has userdata "-2"
        if get(po(i),'Userdata') == -2
            markertext = po(i);
        end
    end
    if isempty(marker) || isempty(markertext)
        return
    end
    
    % get statistics and extract corresponding asset
    S=handles.model.getScenarios;
    [~,~,annualized_ret,annualized_rsk]=handles.model.getStatistics;
            
    if strcmp(handles.model.getRiskType,'CVAR')
            [~,annualized_rsk]=handles.model.computeAssetCVaR;
    end
    
    handles.model.getRiskType
    % use percentages
    annualized_ret           = annualized_ret*100;
    annualized_rsk           = annualized_rsk*100;
    
    
    labels      = handles.model.getPricesLabels;
    if ischar(selection)
        ind = find(strcmp(labels,selection));
    else
        ind = selection;
    end
    
    % update marker / markertext
    if ~isempty(ind) && isscalar(ind)
        % update marker data
        set(marker,'XData',annualized_rsk(ind),'YData',annualized_ret(ind)); 
        set(marker,'Visible','on');
        % update marker text
        set(markertext,'String',labels{ind});
        % find good position
        m_extend = get(markertext,'Extent');
        a_xlim = get(handles.axes_results_efficientfrontier,'XLim');
        final_pos = zeros(1,2);  % place text to the right of marker
        final_pos(1) = annualized_rsk(ind) + range(a_xlim)/40; 
        final_pos(2) = annualized_ret(ind);
        if a_xlim(2) - (final_pos(1) + m_extend(3)) < 0
            % not enough space, move it to left side
            final_pos(1) = annualized_rsk(ind) - range(a_xlim)/40 - m_extend(3);
        end
        set(markertext,'Position',final_pos);
        set(markertext,'Visible','on');
    else
        set(marker,'Visible','off');
        set(markertext,'Visible','off');
    end    
end


function edit_results_confidencelevel_Callback(hObject, eventdata, handles)
% hObject    handle to edit_results_confidencelevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Update Value at Risk
    
    % get portfolio number
    selection = get(handles.selection,'Userdata');  
    if isempty(selection)
        return
    end

    % get confidence level
    confidence_level = str2double(get(handles.edit_results_confidencelevel,'String'));
    if isnan(confidence_level)
        confidence_level = 95;
        set(handles.edit_results_confidencelevel,'String','95');
    end

    % Compute VaR depending on selected option
    option = get(handles.popupmenu_results_valueatrisk,'Value');
    if option == 1
        handles.model.computeHistoricalVaR(selection,confidence_level/100,handles.axes_results_valueatrisk);
    else
        handles.model.computeParameticVaR(selection,confidence_level/100,handles.axes_results_valueatrisk);
    end

end


function edit_results_riskfreerate_Callback(hObject, eventdata, handles)
% hObject    handle to edit_results_riskfreerate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_results_riskfreerate as text
%        str2double(get(hObject,'String')) returns contents of edit_results_riskfreerate as a double

    % Update risk metrics
    
    % get portfolio number
    selection = get(handles.selection,'Userdata');  
    if isempty(selection)
        return
    end

    % get risk-free rate
    riskfreerate = str2double(get(handles.edit_results_riskfreerate,'String'));
    if isnan(riskfreerate)
        riskfreerate = 2;
        set(handles.edit_results_riskfreerate,'String','2');
    end
    
    % get key metrics
    metrics = handles.model.getPerformanceMetrics(selection, riskfreerate/100);
    if isempty(metrics)
        return
    end
    
    % collect data
    % some fiels are not useful without benchmark index
    if isempty(handles.model.getBenchmark)
        data = {'Annualized Volatility',[sprintf('%2.2f',100*metrics.annualizedvolatility),'%']; ...
                'Annualized Return',[sprintf('%2.2f',100*metrics.annualizedreturn),'%']; ...
                'CVaR',[sprintf('%2.2f',100*metrics.CVaR),'%']; ...
                'Correlation','-'; ...
                'Sharpe Ratio',sprintf('%2.2f',metrics.sharperatio); ...
                'STARR',[sprintf('%2.2f',metrics.STARR)]; ...
                'Sortino Ratio',[sprintf('%2.2f',metrics.Sortion)]; ...
                'Alpha','-'; ...
                'Risk-adjusted Return','-'; ...
                'Information Ratio','-'; ...
                'Tracking Error','-'; ...
                'Max. Drawdown',[sprintf('%2.2f',100*metrics.maxdrawdown),'%']};
    else
        data = {'Annualized Volatility',[sprintf('%2.2f',100*metrics.annualizedvolatility),'%']; ...
                'Annualized Return',[sprintf('%2.2f',100*metrics.annualizedreturn),'%']; ...
                'CVaR',[sprintf('%2.2f',100*metrics.CVaR),'%']; ...
                'Correlation',sprintf('%2.2f',metrics.correlation); ...
                'Sharpe Ratio',sprintf('%2.2f',metrics.sharperatio); ...
                'STARR',[sprintf('%2.2f',metrics.STARR)]; ...
                'Sortino Ratio',[sprintf('%2.2f',metrics.Sortino)]; ...
                'Alpha',[sprintf('%2.2f',100*metrics.alpha),'%']; ...
                'Risk-adjusted Return',[sprintf('%2.2f',100*metrics.riskadjusted_return),'%']; ...
                'Information Ratio',[sprintf('%2.2f',100*metrics.inforatio),'%']; ...
                'Tracking Error',[sprintf('%2.2f',100*metrics.trackingerror),'%']; ...
                'Max. Drawdown',[sprintf('%2.2f',100*metrics.maxdrawdown),'%']};
    end    
    
    % Add all metrics to table
    set(handles.uitable_results_metrics,'Data',data,'ColumnName',[]);
    
end

%--------------------------------------------------------------------
%Clear functions
%--------------------------------------------------------------------

function clearTime(handles)

    set(handles.uitable_time,'Data',[],'RowName',[])
end  
function clearResultsPage(handles)
% handles    structure with handles and user data (see GUIDATA)

    % For performance reasons, first check if page is already cleared
    
    % Clear results page
    cla(handles.axes_results_efficientfrontier);
    legend(handles.axes_results_efficientfrontier,'off')
    set(handles.axes_results_efficientfrontier,'Visible','off');
    cla(handles.axes_results_performance);
    legend(handles.axes_results_performance,'off');
    set(handles.axes_results_performance,'Visible','off');
    cla(handles.axes_results_valueatrisk);
    set(handles.axes_results_valueatrisk,'Visible','off');
    axes(handles.axes_results_allocation);
    h = pie(1,{'Select portfolio from efficient frontier'});
    for i = 1:length(h)
        if strcmp(get(h(i),'Type'),'patch')
            set(h(i),'Visible','off')
        end
    end
    set(handles.uitable_results_weights,'Data',[]);
    set(handles.uitable_results_weights,'ColumnName',[]);
    set(handles.uitable_results_metrics,'Data',[]);
    set(handles.uitable_results_metrics,'ColumnFormat',{'char','char'});
    pos = get(handles.uitable_results_metrics,'Position');
    set(handles.uitable_results_metrics,'ColumnWidth',{135,pos(3)-135-4});
    % No portfolio selected
    handles.selection = [];
    guidata(handles.mainFig,handles);
    
    % Disable controls
    %set(handles.edit_results_confidencelevel,'Enable','off');
    set(handles.edit_results_riskfreerate,'Enable','off');
    %set(handles.popupmenu_results_valueatrisk,'Enable','off');
end  

% --- Executes on button press in pushbutton_clear.
function pushbutton_clear_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.uitable_time,'Data',[],'RowName',[])
end





%---------------------------------------------------------------------
%Menu Bar
% --------------------------------------------------------------------
function Menu_clear_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.model=PortObj();
guidata(handles.mainFig,handles)
end



function edit_filename_Callback(hObject, eventdata, handles)
% hObject    handle to edit_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_filename as text
%        str2double(get(hObject,'String')) returns contents of edit_filename as a double
end

% --- Executes during object creation, after setting all properties.
function edit_filename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end



% --- Executes on selection change in popupmenu_dateFormat.
function popupmenu_dateFormat_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_dateFormat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_dateFormat contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_dateFormat
end

% --- Executes during object creation, after setting all properties.
function popupmenu_dateFormat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_dateFormat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end
