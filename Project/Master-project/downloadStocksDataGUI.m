function varargout = downloadStocksDataGUI(varargin)
% Created by Fernando Esteves on March 10, 2018.
%This file is the graphical user interface (GUI) for download stocks
%data using Josiah's "hist_stock-data.m" file. You can find it in Matlab's file exchange:
%https://la.mathworks.com/matlabcentral/fileexchange/18458-hist-stock-data-start-date--end-date--varargin-
% DOWNLOADSTOCKSDATAGUI MATLAB code for downloadStocksDataGUI.fig
%      DOWNLOADSTOCKSDATAGUI, by itself, creates a new DOWNLOADSTOCKSDATAGUI or raises the existing
%      singleton*.
%
%      H = DOWNLOADSTOCKSDATAGUI returns the handle to a new DOWNLOADSTOCKSDATAGUI or the handle to
%      the existing singleton*.
%
%      DOWNLOADSTOCKSDATAGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DOWNLOADSTOCKSDATAGUI.M with the given input arguments.
%
%      DOWNLOADSTOCKSDATAGUI('Property','Value',...) creates a new DOWNLOADSTOCKSDATAGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before downloadStocksDataGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to downloadStocksDataGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
% Edit the above text to modify the response to help downloadStocksDataGUI
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @downloadStocksDataGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @downloadStocksDataGUI_OutputFcn, ...
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
% OpeningFcn Executes just before downloadStocksDataGUI is made visible.
function downloadStocksDataGUI_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
% Import settings parameters 
tickersSelection=table2cell(readtable('tickersSelection.csv'));
% Today date 
date=clock;
day=num2str(sprintf('%02d',date(3)));  %Actual day 
month=num2str(sprintf('%02d',date(2))); %Actual month
year=num2str(date(1)); %Actual year
handles.editUntilDate.String=strcat(day,month,year); %Date in format ddmmyyyy
handles.editSinceDate.String=cell2mat(tickersSelection(2,3)); %Date stored in tickersSelection.csv
% Assigned parameters stored in settings.csv
handles.radiobuttonDownloadDailyData.Value=cell2mat(tickersSelection(4,4));
handles.radiobuttonDownloadWeeklyData.Value=cell2mat(tickersSelection(5,4));
handles.radiobuttonDownloadMonthlyData.Value=cell2mat(tickersSelection(6,4));
% Tickers panel
handles.uipanelTickers=uipanel(gcf,'Tag', 'uipanelTickers','Units','pixels',...
    'Position',[0 20 1080 540],'BackgroundColor',[0 0 .2], 'BorderType', 'none');
% Slider
handles.slider=uicontrol(gcf,'Tag', 'slider','Style','slider','Units','pixels','Position',[0 0 909 20],'Callback', {@slider_Callback, handles},...
    'BackgroundColor', [0 0 .2], 'ForegroundColor', [.83 .82 .78]);
%% 1-20
height=530;
dif=25;
left1=10;
left2=45;
% Ticker 1
height=height-dif;
handles.checkBoxTicker1=uicontrol('Style','checkbox','Tag', 'checkBoxTicker1','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker1_Callback, 'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '1');
handles.edit1=uicontrol('Style','edit','Tag', 'edit1','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit1_Callback);
% Ticker 2
height=height-dif;
handles.checkBoxTicker2=uicontrol('Style','checkbox','Tag', 'checkBoxTicker2','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker2_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '2');
handles.edit2=uicontrol('Style','edit','Tag', 'edit2','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit2_Callback);
% Ticker 3
height=height-dif;
handles.checkBoxTicker3=uicontrol('Style','checkbox','Tag', 'checkBoxTicker3','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker3_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '3');
handles.edit3=uicontrol('Style','edit','Tag', 'edit3','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit3_Callback);
% Ticker 4
height=height-dif;
handles.checkBoxTicker4=uicontrol('Style','checkbox','Tag', 'checkBoxTicker4','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker4_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '4');
handles.edit4=uicontrol('Style','edit','Tag', 'edit4','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit4_Callback);
% Ticker 5
height=height-dif;
handles.checkBoxTicker5=uicontrol('Style','checkbox','Tag', 'checkBoxTicker5','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker5_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '5');
handles.edit5=uicontrol('Style','edit','Tag', 'edit5','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit5_Callback);
% Ticker 6
height=height-dif;
handles.checkBoxTicker6=uicontrol('Style','checkbox','Tag', 'checkBoxTicker6','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker6_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '6');
handles.edit6=uicontrol('Style','edit','Tag', 'edit6','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit6_Callback);
% Ticker 7
height=height-dif;
handles.checkBoxTicker7=uicontrol('Style','checkbox','Tag', 'checkBoxTicker7','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker7_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '7');
handles.edit7=uicontrol('Style','edit','Tag', 'edit7','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit7_Callback);
% Ticker 8
height=height-dif;
handles.checkBoxTicker8=uicontrol('Style','checkbox','Tag', 'checkBoxTicker8','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker8_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '8');
handles.edit8=uicontrol('Style','edit','Tag', 'edit8','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit8_Callback);
% Ticker 9
height=height-dif;
handles.checkBoxTicker9=uicontrol('Style','checkbox','Tag', 'checkBoxTicker9','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker9_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '9');
handles.edit9=uicontrol('Style','edit','Tag', 'edit9','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit9_Callback);
% Ticker 10
height=height-dif;
handles.checkBoxTicker10=uicontrol('Style','checkbox','Tag', 'checkBoxTicker10','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker10_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '10');
handles.edit10=uicontrol('Style','edit','Tag', 'edit10','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit10_Callback);
% Ticker 11
height=height-dif;
handles.checkBoxTicker11=uicontrol('Style','checkbox','Tag', 'checkBoxTicker11','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker11_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '11');
handles.edit11=uicontrol('Style','edit','Tag', 'edit11','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit11_Callback);
% Ticker 12
height=height-dif;
handles.checkBoxTicker12=uicontrol('Style','checkbox','Tag', 'checkBoxTicker12','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker12_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '12');
handles.edit12=uicontrol('Style','edit','Tag', 'edit12','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit12_Callback);
% Ticker 13
height=height-dif;
handles.checkBoxTicker13=uicontrol('Style','checkbox','Tag', 'checkBoxTicker13','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker13_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '13');
handles.edit13=uicontrol('Style','edit','Tag', 'edit13','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit13_Callback);
% Ticker 14
height=height-dif;
handles.checkBoxTicker14=uicontrol('Style','checkbox','Tag', 'checkBoxTicker14','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker14_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '14');
handles.edit14=uicontrol('Style','edit','Tag', 'edit14','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit14_Callback);
% Ticker 15
height=height-dif;
handles.checkBoxTicker15=uicontrol('Style','checkbox','Tag', 'checkBoxTicker15','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker15_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '15');
handles.edit15=uicontrol('Style','edit','Tag', 'edit15','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit15_Callback);
% Ticker 16
height=height-dif;
handles.checkBoxTicker16=uicontrol('Style','checkbox','Tag', 'checkBoxTicker16','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker16_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '16');
handles.edit16=uicontrol('Style','edit','Tag', 'edit16','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit16_Callback);
% Ticker 17
height=height-dif;
handles.checkBoxTicker17=uicontrol('Style','checkbox','Tag', 'checkBoxTicker17','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker17_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '17');
handles.edit17=uicontrol('Style','edit','Tag', 'edit17','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit17_Callback);
% Ticker 18
height=height-dif;
handles.checkBoxTicker18=uicontrol('Style','checkbox','Tag', 'checkBoxTicker18','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker18_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '18');
handles.edit18=uicontrol('Style','edit','Tag', 'edit18','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit18_Callback);
% Ticker 19
height=height-dif;
handles.checkBoxTicker19=uicontrol('Style','checkbox','Tag', 'checkBoxTicker19','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker19_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '19');
handles.edit29=uicontrol('Style','edit','Tag', 'edit19','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit19_Callback);
% Ticker 20
height=height-dif;
handles.checkBoxTicker20=uicontrol('Style','checkbox','Tag', 'checkBoxTicker20','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker20_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '20');
handles.edit20=uicontrol('Style','edit','Tag', 'edit20','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit20_Callback);
height=height-dif;
%Button select column 1-20
handles.pushbuttonSelectColumn1=uicontrol('Style','pushbutton','Tag', 'pushbuttonSelectColumn1','Parent',handles.uipanelTickers,'Units','pixels',...
    'BackgroundColor', [.83 .82 .78],'Position', [left1 height 136 20],'Callback', @pushbuttonSelectColumn1_Callback,...
    'String', 'Select/Unselect column','UserData', 1);
%% 21-40
height=530;
dif=25;
left1=160;
left2=195;
% Ticker 21
height=height-dif;
handles.checkBoxTicker21=uicontrol('Style','checkbox','Tag', 'checkBoxTicker21','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker21_Callback, 'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '21');
handles.edit21=uicontrol('Style','edit','Tag', 'edit21','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit21_Callback);
% Ticker 22
height=height-dif;
handles.checkBoxTicker22=uicontrol('Style','checkbox','Tag', 'checkBoxTicker22','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker22_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '22');
handles.edit22=uicontrol('Style','edit','Tag', 'edit22','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit22_Callback);
% Ticker 23
height=height-dif;
handles.checkBoxTicker23=uicontrol('Style','checkbox','Tag', 'checkBoxTicker23','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker23_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '23');
handles.edit23=uicontrol('Style','edit','Tag', 'edit23','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit23_Callback);
% Ticker 24
height=height-dif;
handles.checkBoxTicker24=uicontrol('Style','checkbox','Tag', 'checkBoxTicker24','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker24_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '24');
handles.edit24=uicontrol('Style','edit','Tag', 'edit24','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit24_Callback);
% Ticker 25
height=height-dif;
handles.checkBoxTicker25=uicontrol('Style','checkbox','Tag', 'checkBoxTicker25','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker25_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '25');
handles.edit25=uicontrol('Style','edit','Tag', 'edit25','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit25_Callback);
% Ticker 26
height=height-dif;
handles.checkBoxTicker26=uicontrol('Style','checkbox','Tag', 'checkBoxTicker26','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker26_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '26');
handles.edit26=uicontrol('Style','edit','Tag', 'edit26','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit26_Callback);
% Ticker 27
height=height-dif;
handles.checkBoxTicker27=uicontrol('Style','checkbox','Tag', 'checkBoxTicker27','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker27_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '27');
handles.edit27=uicontrol('Style','edit','Tag', 'edit27','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit27_Callback);
% Ticker 28
height=height-dif;
handles.checkBoxTicker28=uicontrol('Style','checkbox','Tag', 'checkBoxTicker28','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker28_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '28');
handles.edit28=uicontrol('Style','edit','Tag', 'edit28','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit28_Callback);
% Ticker 29
height=height-dif;
handles.checkBoxTicker29=uicontrol('Style','checkbox','Tag', 'checkBoxTicker29','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker29_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '29');
handles.edit29=uicontrol('Style','edit','Tag', 'edit29','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit29_Callback);
% Ticker 30
height=height-dif;
handles.checkBoxTicker30=uicontrol('Style','checkbox','Tag', 'checkBoxTicker30','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker30_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '30');
handles.edit30=uicontrol('Style','edit','Tag', 'edit30','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit30_Callback);
% Ticker 31
height=height-dif;
handles.checkBoxTicker31=uicontrol('Style','checkbox','Tag', 'checkBoxTicker31','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker31_Callback, 'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '31');
handles.edit31=uicontrol('Style','edit','Tag', 'edit31','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit31_Callback);
% Ticker 32
height=height-dif;
handles.checkBoxTicker32=uicontrol('Style','checkbox','Tag', 'checkBoxTicker32','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker32_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '32');
handles.edit32=uicontrol('Style','edit','Tag', 'edit32','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit32_Callback);
% Ticker 33
height=height-dif;
handles.checkBoxTicker33=uicontrol('Style','checkbox','Tag', 'checkBoxTicker33','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker33_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '33');
handles.edit33=uicontrol('Style','edit','Tag', 'edit33','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit33_Callback);
% Ticker 34
height=height-dif;
handles.checkBoxTicker34=uicontrol('Style','checkbox','Tag', 'checkBoxTicker34','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker34_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '34');
handles.edit34=uicontrol('Style','edit','Tag', 'edit34','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit34_Callback);
% Ticker 35
height=height-dif;
handles.checkBoxTicker35=uicontrol('Style','checkbox','Tag', 'checkBoxTicker35','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker35_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '35');
handles.edit35=uicontrol('Style','edit','Tag', 'edit35','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit35_Callback);
% Ticker 36
height=height-dif;
handles.checkBoxTicker36=uicontrol('Style','checkbox','Tag', 'checkBoxTicker36','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker36_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '36');
handles.edit36=uicontrol('Style','edit','Tag', 'edit36','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit36_Callback);
% Ticker 37
height=height-dif;
handles.checkBoxTicker37=uicontrol('Style','checkbox','Tag', 'checkBoxTicker37','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker37_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '37');
handles.edit37=uicontrol('Style','edit','Tag', 'edit37','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit37_Callback);
% Ticker 38
height=height-dif;
handles.checkBoxTicker38=uicontrol('Style','checkbox','Tag', 'checkBoxTicker38','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker38_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '38');
handles.edit38=uicontrol('Style','edit','Tag', 'edit38','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit38_Callback);
% Ticker 39
height=height-dif;
handles.checkBoxTicker39=uicontrol('Style','checkbox','Tag', 'checkBoxTicker39','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker39_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '39');
handles.edit39=uicontrol('Style','edit','Tag', 'edit39','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit39_Callback);
% Ticker 40
height=height-dif;
handles.checkBoxTicker40=uicontrol('Style','checkbox','Tag', 'checkBoxTicker40','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker40_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '40');
handles.edit40=uicontrol('Style','edit','Tag', 'edit40','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit40_Callback);
%Button select column 21-40
height=height-dif;
handles.pushbuttonSelectColumn21=uicontrol('Style','pushbutton','Tag', 'pushbuttonSelectColumn21','Parent',handles.uipanelTickers,'Units','pixels',...
    'BackgroundColor', [.83 .82 .78],'Position', [left1 height 136 20],'Callback', @pushbuttonSelectColumn21_Callback,...
    'String', 'Select/Unselect column','UserData', 1);
%% 41-60
height=530;
dif=25;
left1=310; %+150
left2=345; %left1+35
% Ticker 41
height=height-dif;
handles.checkBoxTicker41=uicontrol('Style','checkbox','Tag', 'checkBoxTicker41','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker41_Callback, 'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '41');
handles.edit41=uicontrol('Style','edit','Tag', 'edit41','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit41_Callback);
% Ticker 42
height=height-dif;
handles.checkBoxTicker42=uicontrol('Style','checkbox','Tag', 'checkBoxTicker42','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker42_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '42');
handles.edit42=uicontrol('Style','edit','Tag', 'edit42','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit42_Callback);
% Ticker 43
height=height-dif;
handles.checkBoxTicker43=uicontrol('Style','checkbox','Tag', 'checkBoxTicker43','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker43_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '43');
handles.edit43=uicontrol('Style','edit','Tag', 'edit43','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit43_Callback);
% Ticker 44
height=height-dif;
handles.checkBoxTicker44=uicontrol('Style','checkbox','Tag', 'checkBoxTicker44','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker44_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '44');
handles.edit44=uicontrol('Style','edit','Tag', 'edit44','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit44_Callback);
% Ticker 45
height=height-dif;
handles.checkBoxTicker45=uicontrol('Style','checkbox','Tag', 'checkBoxTicker45','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker45_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '45');
handles.edit45=uicontrol('Style','edit','Tag', 'edit45','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit45_Callback);
% Ticker 46
height=height-dif;
handles.checkBoxTicker46=uicontrol('Style','checkbox','Tag', 'checkBoxTicker46','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker46_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '46');
handles.edit46=uicontrol('Style','edit','Tag', 'edit46','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit46_Callback);
% Ticker 47
height=height-dif;
handles.checkBoxTicker47=uicontrol('Style','checkbox','Tag', 'checkBoxTicker47','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker47_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '47');
handles.edit47=uicontrol('Style','edit','Tag', 'edit47','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit47_Callback);
% Ticker 48
height=height-dif;
handles.checkBoxTicker48=uicontrol('Style','checkbox','Tag', 'checkBoxTicker48','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker48_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '48');
handles.edit48=uicontrol('Style','edit','Tag', 'edit48','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit48_Callback);
% Ticker 49
height=height-dif;
handles.checkBoxTicker49=uicontrol('Style','checkbox','Tag', 'checkBoxTicker49','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker49_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '49');
handles.edit49=uicontrol('Style','edit','Tag', 'edit49','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit49_Callback);
% Ticker 50
height=height-dif;
handles.checkBoxTicker50=uicontrol('Style','checkbox','Tag', 'checkBoxTicker50','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker50_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '50');
handles.edit50=uicontrol('Style','edit','Tag', 'edit50','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit50_Callback);
% Ticker 51
height=height-dif;
handles.checkBoxTicker51=uicontrol('Style','checkbox','Tag', 'checkBoxTicker51','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker51_Callback, 'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '51');
handles.edit51=uicontrol('Style','edit','Tag', 'edit51','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit51_Callback);
% Ticker 52
height=height-dif;
handles.checkBoxTicker52=uicontrol('Style','checkbox','Tag', 'checkBoxTicker52','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker52_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '52');
handles.edit52=uicontrol('Style','edit','Tag', 'edit52','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit52_Callback);
% Ticker 53
height=height-dif;
handles.checkBoxTicker53=uicontrol('Style','checkbox','Tag', 'checkBoxTicker53','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker53_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '53');
handles.edit53=uicontrol('Style','edit','Tag', 'edit53','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit53_Callback);
% Ticker 54
height=height-dif;
handles.checkBoxTicker54=uicontrol('Style','checkbox','Tag', 'checkBoxTicker54','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker54_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '54');
handles.edit54=uicontrol('Style','edit','Tag', 'edit54','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit54_Callback);
% Ticker 55
height=height-dif;
handles.checkBoxTicker55=uicontrol('Style','checkbox','Tag', 'checkBoxTicker55','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker55_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '55');
handles.edit55=uicontrol('Style','edit','Tag', 'edit55','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit55_Callback);
% Ticker 56
height=height-dif;
handles.checkBoxTicker56=uicontrol('Style','checkbox','Tag', 'checkBoxTicker56','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker56_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '56');
handles.edit56=uicontrol('Style','edit','Tag', 'edit56','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit56_Callback);
% Ticker 57
height=height-dif;
handles.checkBoxTicker57=uicontrol('Style','checkbox','Tag', 'checkBoxTicker57','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker57_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '57');
handles.edit57=uicontrol('Style','edit','Tag', 'edit57','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit57_Callback);
% Ticker 58
height=height-dif;
handles.checkBoxTicker58=uicontrol('Style','checkbox','Tag', 'checkBoxTicker58','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker58_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '58');
handles.edit58=uicontrol('Style','edit','Tag', 'edit58','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit58_Callback);
% Ticker 59
height=height-dif;
handles.checkBoxTicker59=uicontrol('Style','checkbox','Tag', 'checkBoxTicker59','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker59_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '59');
handles.edit59=uicontrol('Style','edit','Tag', 'edit59','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit59_Callback);
% Ticker 60
height=height-dif;
handles.checkBoxTicker60=uicontrol('Style','checkbox','Tag', 'checkBoxTicker60','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker60_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '60');
handles.edit60=uicontrol('Style','edit','Tag', 'edit60','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit60_Callback);
%Button select column 41-60
height=height-dif;
handles.pushbuttonSelectColumn41=uicontrol('Style','pushbutton','Tag', 'pushbuttonSelectColumn41','Parent',handles.uipanelTickers,'Units','pixels',...
    'BackgroundColor', [.83 .82 .78],'Position', [left1 height 136 20],'Callback', @pushbuttonSelectColumn41_Callback,...
    'String', 'Select/Unselect column','UserData', 1);
%% 61-80
height=530;
dif=25;
left1=460; %+150
left2=495; %left1+35
% Ticker 61
height=height-dif;
handles.checkBoxTicker61=uicontrol('Style','checkbox','Tag', 'checkBoxTicker61','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker61_Callback, 'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '61');
handles.edit61=uicontrol('Style','edit','Tag', 'edit61','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit61_Callback);
% Ticker 62
height=height-dif;
handles.checkBoxTicker62=uicontrol('Style','checkbox','Tag', 'checkBoxTicker62','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker62_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '62');
handles.edit62=uicontrol('Style','edit','Tag', 'edit62','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit62_Callback);
% Ticker 63
height=height-dif;
handles.checkBoxTicker63=uicontrol('Style','checkbox','Tag', 'checkBoxTicker63','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker63_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '63');
handles.edit63=uicontrol('Style','edit','Tag', 'edit63','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit63_Callback);
% Ticker 64
height=height-dif;
handles.checkBoxTicker64=uicontrol('Style','checkbox','Tag', 'checkBoxTicker64','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker64_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '64');
handles.edit64=uicontrol('Style','edit','Tag', 'edit64','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit64_Callback);
% Ticker 65
height=height-dif;
handles.checkBoxTicker65=uicontrol('Style','checkbox','Tag', 'checkBoxTicker65','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker65_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '65');
handles.edit65=uicontrol('Style','edit','Tag', 'edit65','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit65_Callback);
% Ticker 66
height=height-dif;
handles.checkBoxTicker66=uicontrol('Style','checkbox','Tag', 'checkBoxTicker66','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker66_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '66');
handles.edit66=uicontrol('Style','edit','Tag', 'edit66','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit66_Callback);
% Ticker 67
height=height-dif;
handles.checkBoxTicker67=uicontrol('Style','checkbox','Tag', 'checkBoxTicker67','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker67_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '67');
handles.edit67=uicontrol('Style','edit','Tag', 'edit67','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit67_Callback);
% Ticker 68
height=height-dif;
handles.checkBoxTicker68=uicontrol('Style','checkbox','Tag', 'checkBoxTicker68','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker68_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '68');
handles.edit68=uicontrol('Style','edit','Tag', 'edit68','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit68_Callback);
% Ticker 69
height=height-dif;
handles.checkBoxTicker69=uicontrol('Style','checkbox','Tag', 'checkBoxTicker69','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker69_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '69');
handles.edit69=uicontrol('Style','edit','Tag', 'edit69','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit69_Callback);
% Ticker 70
height=height-dif;
handles.checkBoxTicker70=uicontrol('Style','checkbox','Tag', 'checkBoxTicker70','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker70_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '70');
handles.edit70=uicontrol('Style','edit','Tag', 'edit70','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit70_Callback);
% Ticker 71
height=height-dif;
handles.checkBoxTicker71=uicontrol('Style','checkbox','Tag', 'checkBoxTicker71','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker71_Callback, 'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '71');
handles.edit71=uicontrol('Style','edit','Tag', 'edit71','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit71_Callback);
% Ticker 72
height=height-dif;
handles.checkBoxTicker72=uicontrol('Style','checkbox','Tag', 'checkBoxTicker72','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker72_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '72');
handles.edit72=uicontrol('Style','edit','Tag', 'edit72','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit72_Callback);
% Ticker 73
height=height-dif;
handles.checkBoxTicker73=uicontrol('Style','checkbox','Tag', 'checkBoxTicker73','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker73_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '73');
handles.edit73=uicontrol('Style','edit','Tag', 'edit73','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit73_Callback);
% Ticker 74
height=height-dif;
handles.checkBoxTicker74=uicontrol('Style','checkbox','Tag', 'checkBoxTicker74','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker74_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '74');
handles.edit74=uicontrol('Style','edit','Tag', 'edit74','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit74_Callback);
% Ticker 75
height=height-dif;
handles.checkBoxTicker75=uicontrol('Style','checkbox','Tag', 'checkBoxTicker75','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker75_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '75');
handles.edit75=uicontrol('Style','edit','Tag', 'edit75','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit75_Callback);
% Ticker 76
height=height-dif;
handles.checkBoxTicker76=uicontrol('Style','checkbox','Tag', 'checkBoxTicker76','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker76_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '76');
handles.edit76=uicontrol('Style','edit','Tag', 'edit76','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit76_Callback);
% Ticker 77
height=height-dif;
handles.checkBoxTicker77=uicontrol('Style','checkbox','Tag', 'checkBoxTicker77','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker77_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '77');
handles.edit77=uicontrol('Style','edit','Tag', 'edit77','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit77_Callback);
% Ticker 78
height=height-dif;
handles.checkBoxTicker78=uicontrol('Style','checkbox','Tag', 'checkBoxTicker78','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker78_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '78');
handles.edit78=uicontrol('Style','edit','Tag', 'edit78','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit78_Callback);
% Ticker 79
height=height-dif;
handles.checkBoxTicker79=uicontrol('Style','checkbox','Tag', 'checkBoxTicker79','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker79_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '79');
handles.edit79=uicontrol('Style','edit','Tag', 'edit79','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit79_Callback);
% Ticker 80
height=height-dif;
handles.checkBoxTicker80=uicontrol('Style','checkbox','Tag', 'checkBoxTicker80','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker80_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '80');
handles.edit80=uicontrol('Style','edit','Tag', 'edit80','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit80_Callback);
%Button select column 61-80
height=height-dif;
handles.pushbuttonSelectColumn61=uicontrol('Style','pushbutton','Tag', 'pushbuttonSelectColumn61','Parent',handles.uipanelTickers,'Units','pixels',...
    'BackgroundColor', [.83 .82 .78],'Position', [left1 height 136 20],'Callback', @pushbuttonSelectColumn61_Callback,...
    'String', 'Select/Unselect column','UserData', 1);
%% 81-100
height=530;
dif=25;
left1=610; %+150
left2=645; %left1+35
% Ticker 81
height=height-dif;
handles.checkBoxTicker81=uicontrol('Style','checkbox','Tag', 'checkBoxTicker81','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker81_Callback, 'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '81');
handles.edit81=uicontrol('Style','edit','Tag', 'edit81','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit81_Callback);
% Ticker 82
height=height-dif;
handles.checkBoxTicker82=uicontrol('Style','checkbox','Tag', 'checkBoxTicker82','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker82_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '82');
handles.edit82=uicontrol('Style','edit','Tag', 'edit82','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit82_Callback);
% Ticker 83
height=height-dif;
handles.checkBoxTicker83=uicontrol('Style','checkbox','Tag', 'checkBoxTicker83','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker83_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '83');
handles.edit83=uicontrol('Style','edit','Tag', 'edit83','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit83_Callback);
% Ticker 84
height=height-dif;
handles.checkBoxTicker84=uicontrol('Style','checkbox','Tag', 'checkBoxTicker84','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker84_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '84');
handles.edit84=uicontrol('Style','edit','Tag', 'edit84','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit84_Callback);
% Ticker 85
height=height-dif;
handles.checkBoxTicker85=uicontrol('Style','checkbox','Tag', 'checkBoxTicker85','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker85_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '85');
handles.edit85=uicontrol('Style','edit','Tag', 'edit85','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit85_Callback);
% Ticker 86
height=height-dif;
handles.checkBoxTicker86=uicontrol('Style','checkbox','Tag', 'checkBoxTicker86','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker86_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '86');
handles.edit86=uicontrol('Style','edit','Tag', 'edit86','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit86_Callback);
% Ticker 87
height=height-dif;
handles.checkBoxTicker87=uicontrol('Style','checkbox','Tag', 'checkBoxTicker87','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker87_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '87');
handles.edit87=uicontrol('Style','edit','Tag', 'edit87','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit87_Callback);
% Ticker 88
height=height-dif;
handles.checkBoxTicker88=uicontrol('Style','checkbox','Tag', 'checkBoxTicker88','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker88_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '88');
handles.edit88=uicontrol('Style','edit','Tag', 'edit88','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit88_Callback);
% Ticker 89
height=height-dif;
handles.checkBoxTicker89=uicontrol('Style','checkbox','Tag', 'checkBoxTicker89','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker89_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '89');
handles.edit89=uicontrol('Style','edit','Tag', 'edit89','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit89_Callback);
% Ticker 90
height=height-dif;
handles.checkBoxTicker90=uicontrol('Style','checkbox','Tag', 'checkBoxTicker90','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker90_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '90');
handles.edit90=uicontrol('Style','edit','Tag', 'edit90','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit90_Callback);
% Ticker 91
height=height-dif;
handles.checkBoxTicker91=uicontrol('Style','checkbox','Tag', 'checkBoxTicker91','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker91_Callback, 'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '91');
handles.edit91=uicontrol('Style','edit','Tag', 'edit91','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit91_Callback);
% Ticker 92
height=height-dif;
handles.checkBoxTicker92=uicontrol('Style','checkbox','Tag', 'checkBoxTicker92','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker92_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '92');
handles.edit92=uicontrol('Style','edit','Tag', 'edit92','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit92_Callback);
% Ticker 93
height=height-dif;
handles.checkBoxTicker93=uicontrol('Style','checkbox','Tag', 'checkBoxTicker93','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker93_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '93');
handles.edit93=uicontrol('Style','edit','Tag', 'edit93','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit93_Callback);
% Ticker 94
height=height-dif;
handles.checkBoxTicker94=uicontrol('Style','checkbox','Tag', 'checkBoxTicker94','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker94_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '94');
handles.edit94=uicontrol('Style','edit','Tag', 'edit94','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit94_Callback);
% Ticker 95
height=height-dif;
handles.checkBoxTicker95=uicontrol('Style','checkbox','Tag', 'checkBoxTicker95','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker95_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '95');
handles.edit95=uicontrol('Style','edit','Tag', 'edit95','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit95_Callback);
% Ticker 96
height=height-dif;
handles.checkBoxTicker96=uicontrol('Style','checkbox','Tag', 'checkBoxTicker96','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker96_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '96');
handles.edit96=uicontrol('Style','edit','Tag', 'edit96','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit96_Callback);
% Ticker 97
height=height-dif;
handles.checkBoxTicker97=uicontrol('Style','checkbox','Tag', 'checkBoxTicker97','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker97_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '97');
handles.edit97=uicontrol('Style','edit','Tag', 'edit97','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit97_Callback);
% Ticker 98
height=height-dif;
handles.checkBoxTicker98=uicontrol('Style','checkbox','Tag', 'checkBoxTicker98','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker98_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '98');
handles.edit98=uicontrol('Style','edit','Tag', 'edit98','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit98_Callback);
% Ticker 99
height=height-dif;
handles.checkBoxTicker99=uicontrol('Style','checkbox','Tag', 'checkBoxTicker99','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker99_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '99');
handles.edit99=uicontrol('Style','edit','Tag', 'edit99','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit99_Callback);
% Ticker 100
height=height-dif;
handles.checkBoxTicker100=uicontrol('Style','checkbox','Tag', 'checkBoxTicker100','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker100_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '100');
handles.edit100=uicontrol('Style','edit','Tag', 'edit100','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit100_Callback);
%Button select column 81-100
height=height-dif;
handles.pushbuttonSelectColumn81=uicontrol('Style','pushbutton','Tag', 'pushbuttonSelectColumn81','Parent',handles.uipanelTickers,'Units','pixels',...
    'BackgroundColor', [.83 .82 .78],'Position', [left1 height 136 20],'Callback', @pushbuttonSelectColumn81_Callback,...
    'String', 'Select/Unselect column','UserData', 1);
%% 101-120
height=530;
dif=25;
left1=760; %+150
left2=800; %left1+40
% Ticker 101
height=height-dif;
handles.checkBoxTicker101=uicontrol('Style','checkbox','Tag', 'checkBoxTicker101','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker101_Callback, 'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '101');
handles.edit101=uicontrol('Style','edit','Tag', 'edit101','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit101_Callback);
% Ticker 102
height=height-dif;
handles.checkBoxTicker102=uicontrol('Style','checkbox','Tag', 'checkBoxTicker102','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker102_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '102');
handles.edit102=uicontrol('Style','edit','Tag', 'edit102','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit102_Callback);
% Ticker 103
height=height-dif;
handles.checkBoxTicker103=uicontrol('Style','checkbox','Tag', 'checkBoxTicker103','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker103_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '103');
handles.edit103=uicontrol('Style','edit','Tag', 'edit103','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit103_Callback);
% Ticker 104
height=height-dif;
handles.checkBoxTicker104=uicontrol('Style','checkbox','Tag', 'checkBoxTicker104','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker104_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '104');
handles.edit104=uicontrol('Style','edit','Tag', 'edit104','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit104_Callback);
% Ticker 105
height=height-dif;
handles.checkBoxTicker105=uicontrol('Style','checkbox','Tag', 'checkBoxTicker105','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker105_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '105');
handles.edit105=uicontrol('Style','edit','Tag', 'edit105','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit105_Callback);
% Ticker 106
height=height-dif;
handles.checkBoxTicker106=uicontrol('Style','checkbox','Tag', 'checkBoxTicker106','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker106_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '106');
handles.edit106=uicontrol('Style','edit','Tag', 'edit106','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit106_Callback);
% Ticker 107
height=height-dif;
handles.checkBoxTicker107=uicontrol('Style','checkbox','Tag', 'checkBoxTicker107','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker107_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '107');
handles.edit107=uicontrol('Style','edit','Tag', 'edit107','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit107_Callback);
% Ticker 108
height=height-dif;
handles.checkBoxTicker108=uicontrol('Style','checkbox','Tag', 'checkBoxTicker108','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker108_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '108');
handles.edit108=uicontrol('Style','edit','Tag', 'edit108','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit108_Callback);
% Ticker 109
height=height-dif;
handles.checkBoxTicker109=uicontrol('Style','checkbox','Tag', 'checkBoxTicker109','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker109_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '109');
handles.edit109=uicontrol('Style','edit','Tag', 'edit109','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit109_Callback);
% Ticker 110
height=height-dif;
handles.checkBoxTicker110=uicontrol('Style','checkbox','Tag', 'checkBoxTicker110','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker110_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '110');
handles.edit110=uicontrol('Style','edit','Tag', 'edit110','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit110_Callback);
% Ticker 111
height=height-dif;
handles.checkBoxTicker111=uicontrol('Style','checkbox','Tag', 'checkBoxTicker111','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker111_Callback, 'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '111');
handles.edit111=uicontrol('Style','edit','Tag', 'edit111','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit111_Callback);
% Ticker 112
height=height-dif;
handles.checkBoxTicker112=uicontrol('Style','checkbox','Tag', 'checkBoxTicker112','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker112_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '112');
handles.edit112=uicontrol('Style','edit','Tag', 'edit112','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit112_Callback);
% Ticker 113
height=height-dif;
handles.checkBoxTicker113=uicontrol('Style','checkbox','Tag', 'checkBoxTicker113','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker113_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '113');
handles.edit113=uicontrol('Style','edit','Tag', 'edit113','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit113_Callback);
% Ticker 114
height=height-dif;
handles.checkBoxTicker114=uicontrol('Style','checkbox','Tag', 'checkBoxTicker114','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker114_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '114');
handles.edit114=uicontrol('Style','edit','Tag', 'edit114','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit114_Callback);
% Ticker 115
height=height-dif;
handles.checkBoxTicker115=uicontrol('Style','checkbox','Tag', 'checkBoxTicker115','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker115_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '115');
handles.edit115=uicontrol('Style','edit','Tag', 'edit115','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit115_Callback);
% Ticker 116
height=height-dif;
handles.checkBoxTicker116=uicontrol('Style','checkbox','Tag', 'checkBoxTicker116','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker116_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '116');
handles.edit116=uicontrol('Style','edit','Tag', 'edit116','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit116_Callback);
% Ticker 117
height=height-dif;
handles.checkBoxTicker117=uicontrol('Style','checkbox','Tag', 'checkBoxTicker117','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker117_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '117');
handles.edit117=uicontrol('Style','edit','Tag', 'edit117','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit117_Callback);
% Ticker 118
height=height-dif;
handles.checkBoxTicker118=uicontrol('Style','checkbox','Tag', 'checkBoxTicker118','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker118_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '118');
handles.edit118=uicontrol('Style','edit','Tag', 'edit118','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit118_Callback);
% Ticker 119
height=height-dif;
handles.checkBoxTicker119=uicontrol('Style','checkbox','Tag', 'checkBoxTicker119','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker119_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '119');
handles.edit119=uicontrol('Style','edit','Tag', 'edit119','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit119_Callback);
% Ticker 120
height=height-dif;
handles.checkBoxTicker120=uicontrol('Style','checkbox','Tag', 'checkBoxTicker120','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker120_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '120');
handles.edit120=uicontrol('Style','edit','Tag', 'edit120','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit120_Callback);
%Button select column 101-120
height=height-dif;
handles.pushbuttonSelectColumn101=uicontrol('Style','pushbutton','Tag', 'pushbuttonSelectColumn101','Parent',handles.uipanelTickers,'Units','pixels',...
    'BackgroundColor', [.83 .82 .78],'Position', [left1 height 136 20],'Callback', @pushbuttonSelectColumn101_Callback,...
    'String', 'Select/Unselect column','UserData', 1);
% % % %% 121 -140
height=530;
dif=25;
left1=910; %+150
left2=950; %left1+40
% Ticker 121
height=height-dif;
handles.checkBoxTicker121=uicontrol('Style','checkbox','Tag', 'checkBoxTicker121','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker121_Callback, 'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '121');
handles.edit121=uicontrol('Style','edit','Tag', 'edit121','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit121_Callback);
% Ticker 122
height=height-dif;
handles.checkBoxTicker122=uicontrol('Style','checkbox','Tag', 'checkBoxTicker122','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker122_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '122');
handles.edit122=uicontrol('Style','edit','Tag', 'edit122','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit122_Callback);
% Ticker 123
height=height-dif;
handles.checkBoxTicker123=uicontrol('Style','checkbox','Tag', 'checkBoxTicker123','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker123_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '123');
handles.edit123=uicontrol('Style','edit','Tag', 'edit123','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit123_Callback);
% Ticker 124
height=height-dif;
handles.checkBoxTicker124=uicontrol('Style','checkbox','Tag', 'checkBoxTicker124','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker124_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '124');
handles.edit124=uicontrol('Style','edit','Tag', 'edit124','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit124_Callback);
% Ticker 125
height=height-dif;
handles.checkBoxTicker125=uicontrol('Style','checkbox','Tag', 'checkBoxTicker125','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker125_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '125');
handles.edit125=uicontrol('Style','edit','Tag', 'edit125','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit125_Callback);
% Ticker 126
height=height-dif;
handles.checkBoxTicker126=uicontrol('Style','checkbox','Tag', 'checkBoxTicker126','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker126_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '126');
handles.edit126=uicontrol('Style','edit','Tag', 'edit126','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit126_Callback);
% Ticker 127
height=height-dif;
handles.checkBoxTicker127=uicontrol('Style','checkbox','Tag', 'checkBoxTicker127','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker127_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '127');
handles.edit127=uicontrol('Style','edit','Tag', 'edit127','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit127_Callback);
% Ticker 128
height=height-dif;
handles.checkBoxTicker128=uicontrol('Style','checkbox','Tag', 'checkBoxTicker128','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker128_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '128');
handles.edit128=uicontrol('Style','edit','Tag', 'edit128','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit128_Callback);
% Ticker 129
height=height-dif;
handles.checkBoxTicker129=uicontrol('Style','checkbox','Tag', 'checkBoxTicker129','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker129_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '129');
handles.edit129=uicontrol('Style','edit','Tag', 'edit129','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit129_Callback);
% Ticker 130
height=height-dif;
handles.checkBoxTicker130=uicontrol('Style','checkbox','Tag', 'checkBoxTicker130','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker130_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '130');
handles.edit130=uicontrol('Style','edit','Tag', 'edit130','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit130_Callback);
% Ticker 131
height=height-dif;
handles.checkBoxTicker131=uicontrol('Style','checkbox','Tag', 'checkBoxTicker131','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker131_Callback, 'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '131');
handles.edit131=uicontrol('Style','edit','Tag', 'edit131','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit131_Callback);
% Ticker 132
height=height-dif;
handles.checkBoxTicker132=uicontrol('Style','checkbox','Tag', 'checkBoxTicker132','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker132_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '132');
handles.edit132=uicontrol('Style','edit','Tag', 'edit132','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit132_Callback);
% Ticker 133
height=height-dif;
handles.checkBoxTicker133=uicontrol('Style','checkbox','Tag', 'checkBoxTicker133','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker133_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '133');
handles.edit133=uicontrol('Style','edit','Tag', 'edit133','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit133_Callback);
% Ticker 134
height=height-dif;
handles.checkBoxTicker134=uicontrol('Style','checkbox','Tag', 'checkBoxTicker134','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker134_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '134');
handles.edit134=uicontrol('Style','edit','Tag', 'edit134','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit134_Callback);
% Ticker 135
height=height-dif;
handles.checkBoxTicker135=uicontrol('Style','checkbox','Tag', 'checkBoxTicker135','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker135_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '135');
handles.edit135=uicontrol('Style','edit','Tag', 'edit135','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit135_Callback);
% Ticker 136
height=height-dif;
handles.checkBoxTicker136=uicontrol('Style','checkbox','Tag', 'checkBoxTicker136','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker136_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '136');
handles.edit136=uicontrol('Style','edit','Tag', 'edit136','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit136_Callback);
% Ticker 137
height=height-dif;
handles.checkBoxTicker137=uicontrol('Style','checkbox','Tag', 'checkBoxTicker137','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker137_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '137');
handles.edit137=uicontrol('Style','edit','Tag', 'edit137','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit137_Callback);
% Ticker 138
height=height-dif;
handles.checkBoxTicker138=uicontrol('Style','checkbox','Tag', 'checkBoxTicker138','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker138_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '138');
handles.edit138=uicontrol('Style','edit','Tag', 'edit138','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit138_Callback);
% Ticker 139
height=height-dif;
handles.checkBoxTicker139=uicontrol('Style','checkbox','Tag', 'checkBoxTicker139','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker139_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '139');
handles.edit139=uicontrol('Style','edit','Tag', 'edit139','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit139_Callback);
% Ticker 140
height=height-dif;
handles.checkBoxTicker140=uicontrol('Style','checkbox','Tag', 'checkBoxTicker140','Parent',handles.uipanelTickers,'Units','pixels',...
    'Position', [left1 height 40 20],'Callback', @checkBoxTicker140_Callback,'BackgroundColor', [0 0 .2],'ForegroundColor',[0 1 1],'String', '140');
handles.edit140=uicontrol('Style','edit','Tag', 'edit140','Parent',handles.uipanelTickers,'Units','pixels','BackgroundColor', [.83 .82 .78],...
    'Position', [left2 height 100 20],'Callback', @edit140_Callback);
%Button select column 121-140
height=height-dif;
handles.pushbuttonSelectColumn121=uicontrol('Style','pushbutton','Tag', 'pushbuttonSelectColumn121','Parent',handles.uipanelTickers,'Units','pixels',...
    'BackgroundColor', [.83 .82 .78],'Position', [left1 height 136 20],'Callback', @pushbuttonSelectColumn121_Callback,...
    'String', 'Select/Unselect column','UserData', 1);
%%
% import selection and stored tickers (loop)
tikersSelection=table2cell(readtable('tickersSelection.csv'));
% % Activa los botones utilizados
for i=1:140
    %Checa si cada casilla va activada o no 
    if (cell2mat(tikersSelection(i,1))==1)==1
        activar=findobj('Tag',['checkBoxTicker' num2str(i)]);
        set(activar,'Value',1);
    end
    % Write ticker name on each box
    emisora=findobj('Tag',['edit' num2str(i)]);
    set(emisora,'String',tikersSelection(i,2));
end
% Update handles structure
guidata(hObject, handles);
% --- Outputs from this function are returned to the command line.
function varargout = downloadStocksDataGUI_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%% pushbuttonDownloadData.
function pushbuttonDownloadData_Callback(hObject, eventdata, handles)
tickers=fopen('tickers.txt','wt'); %Open the txt file with all the stored tickers 
    for i=1:140 %This loop store all the tickers selected in the UI
         evaluar=findobj('Tag',['checkBoxTicker' num2str(i)]);
        if get(evaluar,'Value')==1 %Check if every ticker is selected
            try
           escribir=findobj('Tag',['edit' num2str(i)]);
           fprintf(tickers,'%s\n',char(get(escribir, 'String')));%Write the ticker name into tickers.txt  
            end
        end
    end
fprintf(tickers,'%s\n',''); 
fclose(tickers);
% Update tickersSelection.csv with the last data added
tickersSelection=table2cell(readtable('tickersSelection.csv'));
for i=1:140
    try
        checkBoxTicker=findobj('Tag',['checkBoxTicker' num2str(i)]);
        tickersSelection(i,1)=num2cell(get(checkBoxTicker,'Value'));
        edit=findobj('Tag',['edit' num2str(i)]);
        tickersSelection(i,2)=cellstr(get(edit,'String'));
    catch
    end
end
tickersSelection(4,4)=num2cell(handles.radiobuttonDownloadDailyData.Value);
tickersSelection(5,4)=num2cell(handles.radiobuttonDownloadWeeklyData.Value);
tickersSelection(6,4)=num2cell(handles.radiobuttonDownloadMonthlyData.Value);
tickersSelection(2,3)=cellstr(handles.editSinceDate.String);
writetable(cell2table(tickersSelection),'tickersSelection.csv') %Store in tickersSelection.csv the updated data
% Download stocks data with the hist_stock_data function by Josiah Renfree: https://la.mathworks.com/matlabcentral/fileexchange/18458-hist-stock-data-start-date--end-date--varargin-
if handles.radiobuttonDownloadDailyData.Value==1
    dailyData = hist_stock_data(handles.editSinceDate.String, handles.editUntilDate.String,'tickers.txt','frequency','d');
    assignin('base', 'DailyData', dailyData)
end
if handles.radiobuttonDownloadWeeklyData.Value==1
weeklyData = hist_stock_data(handles.editSinceDate.String, handles.editUntilDate.String,'tickers.txt','frequency','wk');
assignin('base', 'WeeklyData', weeklyData)
end
if handles.radiobuttonDownloadMonthlyData.Value==1
monthlyData = hist_stock_data(handles.editSinceDate.String, handles.editUntilDate.String,'tickers.txt','frequency','mo');
assignin('base', 'MonthlyData', monthlyData)
end
   
guidata(hObject, handles);
%% editSinceDate Callback
function editSinceDate_Callback(hObject, eventdata, handles)
function editSinceDate_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%% editUntilDate Callback
function editUntilDate_Callback(hObject, eventdata, handles)
function editUntilDate_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%% radiobuttonDownloadData.
function radiobuttonDownloadDailyData_Callback(hObject, eventdata, handles)
function radiobuttonDownloadWeeklyData_Callback(hObject, eventdata, handles)
function radiobuttonDownloadMonthlyData_Callback(hObject, eventdata, handles)
%% Slider Callback 
function slider_Callback(hObject, eventdata, handles)
sl_pos = get(hObject, 'Value');
panel_pos = get(handles.uipanelTickers, 'Position');
fig_pos = get(handles.figure1, 'Position');
set(handles.uipanelTickers, 'Position', [-sl_pos*(panel_pos(3) - 5*fig_pos(3)), panel_pos(2), panel_pos(3), panel_pos(4)]); % Move the uipanelTickers position
%% Select column button
% Select column push button Tickers 1-20
function pushbuttonSelectColumn1_Callback(hObject, eventdata, handles)
if hObject.UserData==1
    for i=1:20
        check=findobj('Tag',['checkBoxTicker' num2str(i)]);
        set(check,'Value',0);
    end
    hObject.UserData=0; 
else 
    for i=1:20
        check=findobj('Tag',['checkBoxTicker' num2str(i)]);
        set(check,'Value',1);
    end
    hObject.UserData=1; 
end
% Select column push button Tickers 21-40
function pushbuttonSelectColumn21_Callback(hObject, eventdata, handles)
if hObject.UserData==1
    for i=21:40
        check=findobj('Tag',['checkBoxTicker' num2str(i)]);
        set(check,'Value',0);
    end
    hObject.UserData=0; 
else 
    for i=21:40
        check=findobj('Tag',['checkBoxTicker' num2str(i)]);
        set(check,'Value',1);
    end
    hObject.UserData=1; 
end
% Select column push button Tickers 41-60
function pushbuttonSelectColumn41_Callback(hObject, eventdata, handles)
if hObject.UserData==1
    for i=41:60
        check=findobj('Tag',['checkBoxTicker' num2str(i)]);
        set(check,'Value',0);
    end
    hObject.UserData=0; 
else 
    for i=41:60
        check=findobj('Tag',['checkBoxTicker' num2str(i)]);
        set(check,'Value',1);
    end
    hObject.UserData=1; 
end
% Select column push button Tickers 61-80
function pushbuttonSelectColumn61_Callback(hObject, eventdata, handles)
if hObject.UserData==1
    for i=61:80
        check=findobj('Tag',['checkBoxTicker' num2str(i)]);
        set(check,'Value',0);
    end
    hObject.UserData=0; 
else 
    for i=61:80
        check=findobj('Tag',['checkBoxTicker' num2str(i)]);
        set(check,'Value',1);
    end
    hObject.UserData=1; 
end
% Select column push button Tickers 81-100
function pushbuttonSelectColumn81_Callback(hObject, eventdata, handles)
if hObject.UserData==1
    for i=81:100
        check=findobj('Tag',['checkBoxTicker' num2str(i)]);
        set(check,'Value',0);
    end
    hObject.UserData=0; 
else 
    for i=81:100
        check=findobj('Tag',['checkBoxTicker' num2str(i)]);
        set(check,'Value',1);
    end
    hObject.UserData=1; 
end
% Select column push button Tickers 101-120
function pushbuttonSelectColumn101_Callback(hObject, eventdata, handles)
if hObject.UserData==1
    for i=101:120
        check=findobj('Tag',['checkBoxTicker' num2str(i)]);
        set(check,'Value',0);
    end
    hObject.UserData=0; 
else 
    for i=101:120
        check=findobj('Tag',['checkBoxTicker' num2str(i)]);
        set(check,'Value',1);
    end
    hObject.UserData=1; 
end
% Select column push button Tickers 121-140
function pushbuttonSelectColumn121_Callback(hObject, eventdata, handles)
if hObject.UserData==1
    for i=121:140
        check=findobj('Tag',['checkBoxTicker' num2str(i)]);
        set(check,'Value',0);
    end
    hObject.UserData=0; 
else 
    for i=121:140
        check=findobj('Tag',['checkBoxTicker' num2str(i)]);
        set(check,'Value',1);
    end
    hObject.UserData=1; 
end
%% 1-20
% Ticker 1 Callback
function checkBoxTicker1_Callback(hObject, eventdata, handles)
function edit1_Callback(hObject, eventdata, handles)
% Ticker 2 Callback
function checkBoxTicker2_Callback(hObject, eventdata, handles)
function edit2_Callback(hObject, eventdata, handles)
% Ticker 3 Callback
function checkBoxTicker3_Callback(hObject, eventdata, handles)
function edit3_Callback(hObject, eventdata, handles)
% Ticker 4 Callback
function checkBoxTicker4_Callback(hObject, eventdata, handles)
function edit4_Callback(hObject, eventdata, handles)
% Ticker 5 Callback
function checkBoxTicker5_Callback(hObject, eventdata, handles)
function edit5_Callback(hObject, eventdata, handles)
% Ticker 6 Callback
function checkBoxTicker6_Callback(hObject, eventdata, handles)
function edit6_Callback(hObject, eventdata, handles)
% Ticker 7 Callback
function checkBoxTicker7_Callback(hObject, eventdata, handles)
function edit7_Callback(hObject, eventdata, handles)
% Ticker 8 Callback
function checkBoxTicker8_Callback(hObject, eventdata, handles)
function edit8_Callback(hObject, eventdata, handles)
% Ticker 9 Callback
function checkBoxTicker9_Callback(hObject, eventdata, handles)
function edit9_Callback(hObject, eventdata, handles)
% Ticker 10 Callback
function checkBoxTicker10_Callback(hObject, eventdata, handles)
function edit10_Callback(hObject, eventdata, handles)
% Ticker 11 Callback
function checkBoxTicker11_Callback(hObject, eventdata, handles)
function edit11_Callback(hObject, eventdata, handles)
% Ticker 12 Callback
function checkBoxTicker12_Callback(hObject, eventdata, handles)
function edit12_Callback(hObject, eventdata, handles)
% Ticker 13 Callback
function checkBoxTicker13_Callback(hObject, eventdata, handles)
function edit13_Callback(hObject, eventdata, handles)
% Ticker 14 Callback
function checkBoxTicker14_Callback(hObject, eventdata, handles)
function edit14_Callback(hObject, eventdata, handles)
% Ticker 15 Callback
function checkBoxTicker15_Callback(hObject, eventdata, handles)
function edit15_Callback(hObject, eventdata, handles)
% Ticker 16 Callback
function checkBoxTicker16_Callback(hObject, eventdata, handles)
function edit16_Callback(hObject, eventdata, handles)
% Ticker 17 Callback
function checkBoxTicker17_Callback(hObject, eventdata, handles)
function edit17_Callback(hObject, eventdata, handles)
% Ticker 18 Callback
function checkBoxTicker18_Callback(hObject, eventdata, handles)
function edit18_Callback(hObject, eventdata, handles)
% Ticker 19 Callback
function checkBoxTicker19_Callback(hObject, eventdata, handles)
function edit19_Callback(hObject, eventdata, handles)
% Ticker 20 Callback
function checkBoxTicker20_Callback(hObject, eventdata, handles)
function edit20_Callback(hObject, eventdata, handles)
%% 21-40
% Ticker 21 Callback
function checkBoxTicker21_Callback(hObject, eventdata, handles)
function edit21_Callback(hObject, eventdata, handles)
% Ticker 22 Callback
function checkBoxTicker22_Callback(hObject, eventdata, handles)
function edit22_Callback(hObject, eventdata, handles)
% Ticker 23 Callback
function checkBoxTicker23_Callback(hObject, eventdata, handles)
function edit23_Callback(hObject, eventdata, handles)
% Ticker 24 Callback
function checkBoxTicker24_Callback(hObject, eventdata, handles)
function edit24_Callback(hObject, eventdata, handles)
% Ticker 25 Callback
function checkBoxTicker25_Callback(hObject, eventdata, handles)
function edit25_Callback(hObject, eventdata, handles)
% Ticker 26 Callback
function checkBoxTicker26_Callback(hObject, eventdata, handles)
function edit26_Callback(hObject, eventdata, handles)
% Ticker 27 Callback
function checkBoxTicker27_Callback(hObject, eventdata, handles)
function edit27_Callback(hObject, eventdata, handles)
% Ticker 28 Callback
function checkBoxTicker28_Callback(hObject, eventdata, handles)
function edit28_Callback(hObject, eventdata, handles)
% Ticker 29 Callback
function checkBoxTicker29_Callback(hObject, eventdata, handles)
function edit29_Callback(hObject, eventdata, handles)
% Ticker 30 Callback
function checkBoxTicker30_Callback(hObject, eventdata, handles)
function edit30_Callback(hObject, eventdata, handles)
% Ticker 31 Callback
function checkBoxTicker31_Callback(hObject, eventdata, handles)
function edit31_Callback(hObject, eventdata, handles)
% Ticker 32 Callback
function checkBoxTicker32_Callback(hObject, eventdata, handles)
function edit32_Callback(hObject, eventdata, handles)
% Ticker 33 Callback
function checkBoxTicker33_Callback(hObject, eventdata, handles)
function edit33_Callback(hObject, eventdata, handles)
% Ticker 34 Callback
function checkBoxTicker34_Callback(hObject, eventdata, handles)
function edit34_Callback(hObject, eventdata, handles)
% Ticker 35 Callback
function checkBoxTicker35_Callback(hObject, eventdata, handles)
function edit35_Callback(hObject, eventdata, handles)
% Ticker 36 Callback
function checkBoxTicker36_Callback(hObject, eventdata, handles)
function edit36_Callback(hObject, eventdata, handles)
% Ticker 37 Callback
function checkBoxTicker37_Callback(hObject, eventdata, handles)
function edit37_Callback(hObject, eventdata, handles)
% Ticker 38 Callback
function checkBoxTicker38_Callback(hObject, eventdata, handles)
function edit38_Callback(hObject, eventdata, handles)
% Ticker 39 Callback
function checkBoxTicker39_Callback(hObject, eventdata, handles)
function edit39_Callback(hObject, eventdata, handles)
% Ticker 40 Callback
function checkBoxTicker40_Callback(hObject, eventdata, handles)
function edit40_Callback(hObject, eventdata, handles)
%41-60
% Ticker 41 Callback
function checkBoxTicker41_Callback(hObject, eventdata, handles)
function edit41_Callback(hObject, eventdata, handles)
% Ticker 42 Callback
function checkBoxTicker42_Callback(hObject, eventdata, handles)
function edit42_Callback(hObject, eventdata, handles)
% Ticker 43 Callback
function checkBoxTicker43_Callback(hObject, eventdata, handles)
function edit43_Callback(hObject, eventdata, handles)
% Ticker 44 Callback
function checkBoxTicker44_Callback(hObject, eventdata, handles)
function edit44_Callback(hObject, eventdata, handles)
% Ticker 45 Callback
function checkBoxTicker45_Callback(hObject, eventdata, handles)
function edit45_Callback(hObject, eventdata, handles)
% Ticker 46 Callback
function checkBoxTicker46_Callback(hObject, eventdata, handles)
function edit46_Callback(hObject, eventdata, handles)
% Ticker 47 Callback
function checkBoxTicker47_Callback(hObject, eventdata, handles)
function edit47_Callback(hObject, eventdata, handles)
% Ticker 48 Callback
function checkBoxTicker48_Callback(hObject, eventdata, handles)
function edit48_Callback(hObject, eventdata, handles)
% Ticker 49 Callback
function checkBoxTicker49_Callback(hObject, eventdata, handles)
function edit49_Callback(hObject, eventdata, handles)
% Ticker 50 Callback
function checkBoxTicker50_Callback(hObject, eventdata, handles)
function edit50_Callback(hObject, eventdata, handles)
% Ticker 51 Callback
function checkBoxTicker51_Callback(hObject, eventdata, handles)
function edit51_Callback(hObject, eventdata, handles)
% Ticker 52 Callback
function checkBoxTicker52_Callback(hObject, eventdata, handles)
function edit52_Callback(hObject, eventdata, handles)
% Ticker 53 Callback
function checkBoxTicker53_Callback(hObject, eventdata, handles)
function edit53_Callback(hObject, eventdata, handles)
% Ticker 54 Callback
function checkBoxTicker54_Callback(hObject, eventdata, handles)
function edit54_Callback(hObject, eventdata, handles)
% Ticker 55 Callback
function checkBoxTicker55_Callback(hObject, eventdata, handles)
function edit55_Callback(hObject, eventdata, handles)
% Ticker 56 Callback
function checkBoxTicker56_Callback(hObject, eventdata, handles)
function edit56_Callback(hObject, eventdata, handles)
% Ticker 57 Callback
function checkBoxTicker57_Callback(hObject, eventdata, handles)
function edit57_Callback(hObject, eventdata, handles)
% Ticker 58 Callback
function checkBoxTicker58_Callback(hObject, eventdata, handles)
function edit58_Callback(hObject, eventdata, handles)
% Ticker 59 Callback
function checkBoxTicker59_Callback(hObject, eventdata, handles)
function edit59_Callback(hObject, eventdata, handles)
% Ticker 60 Callback
function checkBoxTicker60_Callback(hObject, eventdata, handles)
function edit60_Callback(hObject, eventdata, handles)
%% 81-100
% Ticker 81 Callback
function checkBoxTicker81_Callback(hObject, eventdata, handles)
function edit81_Callback(hObject, eventdata, handles)
% Ticker 82 Callback
function checkBoxTicker82_Callback(hObject, eventdata, handles)
function edit82_Callback(hObject, eventdata, handles)
% Ticker 83 Callback
function checkBoxTicker83_Callback(hObject, eventdata, handles)
function edit83_Callback(hObject, eventdata, handles)
% Ticker 84 Callback
function checkBoxTicker84_Callback(hObject, eventdata, handles)
function edit84_Callback(hObject, eventdata, handles)
% Ticker 85 Callback
function checkBoxTicker85_Callback(hObject, eventdata, handles)
function edit85_Callback(hObject, eventdata, handles)
% Ticker 86 Callback
function checkBoxTicker86_Callback(hObject, eventdata, handles)
function edit86_Callback(hObject, eventdata, handles)
% Ticker 87 Callback
function checkBoxTicker87_Callback(hObject, eventdata, handles)
function edit87_Callback(hObject, eventdata, handles)
% Ticker 88 Callback
function checkBoxTicker88_Callback(hObject, eventdata, handles)
function edit88_Callback(hObject, eventdata, handles)
% Ticker 89 Callback
function checkBoxTicker89_Callback(hObject, eventdata, handles)
function edit89_Callback(hObject, eventdata, handles)
% Ticker 90 Callback
function checkBoxTicker90_Callback(hObject, eventdata, handles)
function edit90_Callback(hObject, eventdata, handles)
% Ticker 91 Callback
function checkBoxTicker91_Callback(hObject, eventdata, handles)
function edit91_Callback(hObject, eventdata, handles)
% Ticker 92 Callback
function checkBoxTicker92_Callback(hObject, eventdata, handles)
function edit92_Callback(hObject, eventdata, handles)
% Ticker 93 Callback
function checkBoxTicker93_Callback(hObject, eventdata, handles)
function edit93_Callback(hObject, eventdata, handles)
% Ticker 94 Callback
function checkBoxTicker94_Callback(hObject, eventdata, handles)
function edit94_Callback(hObject, eventdata, handles)
% Ticker 95 Callback
function checkBoxTicker95_Callback(hObject, eventdata, handles)
function edit95_Callback(hObject, eventdata, handles)
% Ticker 96 Callback
function checkBoxTicker96_Callback(hObject, eventdata, handles)
function edit96_Callback(hObject, eventdata, handles)
% Ticker 97 Callback
function checkBoxTicker97_Callback(hObject, eventdata, handles)
function edit97_Callback(hObject, eventdata, handles)
% Ticker 98 Callback
function checkBoxTicker98_Callback(hObject, eventdata, handles)
function edit98_Callback(hObject, eventdata, handles)
% Ticker 99 Callback
function checkBoxTicker99_Callback(hObject, eventdata, handles)
function edit99_Callback(hObject, eventdata, handles)
% Ticker 100 Callback
function checkBoxTicker100_Callback(hObject, eventdata, handles)
function edit100_Callback(hObject, eventdata, handles)
%% 101-120
% Ticker 101 Callback
function checkBoxTicker101_Callback(hObject, eventdata, handles)
function edit101_Callback(hObject, eventdata, handles)
% Ticker 102 Callback
function checkBoxTicker102_Callback(hObject, eventdata, handles)
function edit102_Callback(hObject, eventdata, handles)
% Ticker 103 Callback
function checkBoxTicker103_Callback(hObject, eventdata, handles)
function edit103_Callback(hObject, eventdata, handles)
% Ticker 104 Callback
function checkBoxTicker104_Callback(hObject, eventdata, handles)
function edit104_Callback(hObject, eventdata, handles)
% Ticker 105 Callback
function checkBoxTicker105_Callback(hObject, eventdata, handles)
function edit105_Callback(hObject, eventdata, handles)
% Ticker 106 Callback
function checkBoxTicker106_Callback(hObject, eventdata, handles)
function edit106_Callback(hObject, eventdata, handles)
% Ticker 107 Callback
function checkBoxTicker107_Callback(hObject, eventdata, handles)
function edit107_Callback(hObject, eventdata, handles)
% Ticker 108 Callback
function checkBoxTicker108_Callback(hObject, eventdata, handles)
function edit108_Callback(hObject, eventdata, handles)
% Ticker 109 Callback
function checkBoxTicker109_Callback(hObject, eventdata, handles)
function edit109_Callback(hObject, eventdata, handles)
% Ticker 110 Callback
function checkBoxTicker110_Callback(hObject, eventdata, handles)
function edit110_Callback(hObject, eventdata, handles)
% Ticker 111 Callback
function checkBoxTicker111_Callback(hObject, eventdata, handles)
function edit111_Callback(hObject, eventdata, handles)
% Ticker 112 Callback
function checkBoxTicker112_Callback(hObject, eventdata, handles)
function edit112_Callback(hObject, eventdata, handles)
% Ticker 113 Callback
function checkBoxTicker113_Callback(hObject, eventdata, handles)
function edit113_Callback(hObject, eventdata, handles)
% Ticker 114 Callback
function checkBoxTicker114_Callback(hObject, eventdata, handles)
function edit114_Callback(hObject, eventdata, handles)
% Ticker 115 Callback
function checkBoxTicker115_Callback(hObject, eventdata, handles)
function edit115_Callback(hObject, eventdata, handles)
% Ticker 116 Callback
function checkBoxTicker116_Callback(hObject, eventdata, handles)
function edit116_Callback(hObject, eventdata, handles)
% Ticker 117 Callback
function checkBoxTicker117_Callback(hObject, eventdata, handles)
function edit117_Callback(hObject, eventdata, handles)
% Ticker 118 Callback
function checkBoxTicker118_Callback(hObject, eventdata, handles)
function edit118_Callback(hObject, eventdata, handles)
% Ticker 119 Callback
function checkBoxTicker119_Callback(hObject, eventdata, handles)
function edit119_Callback(hObject, eventdata, handles)
% Ticker 120 Callback
function checkBoxTicker120_Callback(hObject, eventdata, handles)
function edit120_Callback(hObject, eventdata, handles)
%% 121-140
% Ticker 121 Callback
function checkBoxTicker121_Callback(hObject, eventdata, handles)
function edit121_Callback(hObject, eventdata, handles)
% Ticker 122 Callback
function checkBoxTicker122_Callback(hObject, eventdata, handles)
function edit122_Callback(hObject, eventdata, handles)
% Ticker 123 Callback
function checkBoxTicker123_Callback(hObject, eventdata, handles)
function edit123_Callback(hObject, eventdata, handles)
% Ticker 124 Callback
function checkBoxTicker124_Callback(hObject, eventdata, handles)
function edit124_Callback(hObject, eventdata, handles)
% Ticker 125 Callback
function checkBoxTicker125_Callback(hObject, eventdata, handles)
function edit125_Callback(hObject, eventdata, handles)
% Ticker 126 Callback
function checkBoxTicker126_Callback(hObject, eventdata, handles)
function edit126_Callback(hObject, eventdata, handles)
% Ticker 127 Callback
function checkBoxTicker127_Callback(hObject, eventdata, handles)
function edit127_Callback(hObject, eventdata, handles)
% Ticker 128 Callback
function checkBoxTicker128_Callback(hObject, eventdata, handles)
function edit128_Callback(hObject, eventdata, handles)
% Ticker 129 Callback
function checkBoxTicker129_Callback(hObject, eventdata, handles)
function edit129_Callback(hObject, eventdata, handles)
% Ticker 130 Callback
function checkBoxTicker130_Callback(hObject, eventdata, handles)
function edit130_Callback(hObject, eventdata, handles)
% Ticker 131 Callback
function checkBoxTicker131_Callback(hObject, eventdata, handles)
function edit131_Callback(hObject, eventdata, handles)
% Ticker 132 Callback
function checkBoxTicker132_Callback(hObject, eventdata, handles)
function edit132_Callback(hObject, eventdata, handles)
% Ticker 133 Callback
function checkBoxTicker133_Callback(hObject, eventdata, handles)
function edit133_Callback(hObject, eventdata, handles)
% Ticker 134 Callback
function checkBoxTicker134_Callback(hObject, eventdata, handles)
function edit134_Callback(hObject, eventdata, handles)
% Ticker 135 Callback
function checkBoxTicker135_Callback(hObject, eventdata, handles)
function edit135_Callback(hObject, eventdata, handles)
% Ticker 136 Callback
function checkBoxTicker136_Callback(hObject, eventdata, handles)
function edit136_Callback(hObject, eventdata, handles)
% Ticker 137 Callback
function checkBoxTicker137_Callback(hObject, eventdata, handles)
function edit137_Callback(hObject, eventdata, handles)
% Ticker 138 Callback
function checkBoxTicker138_Callback(hObject, eventdata, handles)
function edit138_Callback(hObject, eventdata, handles)
% Ticker 139 Callback
function checkBoxTicker139_Callback(hObject, eventdata, handles)
function edit139_Callback(hObject, eventdata, handles)
% Ticker 140 Callback
function checkBoxTicker140_Callback(hObject, eventdata, handles)
function edit140_Callback(hObject, eventdata, handles)
