clear
%clc

%% 1.Load Timestamp, RSSI and Meter Values

%Load Timestamps
F_ts=readtable("WiFi Multi 1.xlsx",'Sheet',"Fermi",'Range',"A:A");
M_ts=readtable("WiFi Multi 1.xlsx",'sheet',"Majorana",'Range',"A:A");
P_ts=readtable("WiFi Multi 1.xlsx",'sheet',"Pontecorvo",'Range',"A:A");
A_ts=readtable("WiFi Multi 1.xlsx",'sheet',"Amaldi",'Range',"A:A");
D_ts=readtable("WiFi Multi 1.xlsx",'sheet',"D Agostino",'Range',"A:A");
R_ts=readtable("WiFi Multi 1.xlsx",'sheet',"Rasetti",'Range',"A:A");
S_ts=readtable("WiFi Multi 1.xlsx",'sheet',"Segre",'Range',"A:A");

%Convert table to datetime arrays
Fts=table2cell(F_ts);
Fts=string(Fts);
Fts=datetime(Fts,'InputFormat','dd/MM/yyyy HH:mm:ss');
Mts=table2cell(M_ts);
Mts=string(Mts);
Mts=datetime(Mts,'InputFormat','dd/MM/yyyy HH:mm:ss');
Pts=table2cell(P_ts);
Pts=string(Pts);
Mts=datetime(Mts,'InputFormat','dd/MM/yyyy HH:mm:ss');

%Load RSSI values
F_rssi=xlsread("WiFi Multi 1.xlsx","Fermi","B:B");
M_rssi=xlsread("WiFi Multi 1.xlsx","Majorana","B:B");
P_rssi=xlsread("WiFi Multi 1.xlsx","Pontecorvo","B:B");
A_rssi=xlsread("WiFi Multi 1.xlsx","Amaldi","B:B");
D_rssi=xlsread("WiFi Multi 1.xlsx","D Agostino","B:B");
R_rssi=xlsread("WiFi Multi 1.xlsx","Rasetti","B:B");
S_rssi=xlsread("WiFi Multi 1.xlsx","Segre","B:B");

%Change every RSSI=0 Value to 250
for i = 1:length(F_rssi)
    if F_rssi(i)==0
        F_rssi(i)=250;
    end
    if M_rssi(i)==0
        M_rssi(i)=250;
    end
    if P_rssi(i)==0
        P_rssi(i)=250;
    end
    if A_rssi(i)==0
        A_rssi(i)=250;
    end
    if D_rssi(i)==0
        D_rssi(i)=250;
    end
    if R_rssi(i)==0
        R_rssi(i)=250;
    end
    if S_rssi(i)==0
        S_rssi(i)=250;
    end
end

%Convert RSSI Values to Meters
F_cm=exp(-0.027*F_rssi-0.808)*100; %Divide by 100 if you want to convert cm to meters
M_cm=exp(-0.027*M_rssi-0.808)*100;
P_cm=exp(-0.027*P_rssi-0.808)*100;
A_cm=exp(-0.027*A_rssi-0.808)*100;
D_cm=exp(-0.027*D_rssi-0.808)*100;
R_cm=exp(-0.027*R_rssi-0.808)*100;
S_cm=exp(-0.027*S_rssi-0.808)*100;

%Load the bg img and specify destination folder
fileName = strcat('garden - 7 red.png'); %kitchen's roof plan
fileNameStr = char(fileName);
trilat{1} = imread(fileNameStr);
C={}; %array to store the figures
myFolder = 'C:\Users\Panos\Desktop\WiFi'; %specify my folder

%Apply trilat method using RSSI values and save figs
for k = 1:length(F_cm)
    B=figure();set(gcf,'Visible', 'off'); %Create a figure and prevent it from popping up
    imshow(trilat{1});
    hold on
    axis on
    grid on
    grid minor
    set(gca,'units','centimeters'); %set axis' unit
    cplot(F_cm(k),533,163); %apply trilat method
    cplot(M_cm(k),384,346);
    cplot(P_cm(k),371,22);
    cplot(A_cm(k),129,295);
    cplot(D_cm(k),703,351);
    cplot(R_cm(k),1045,297);
    cplot(S_cm(k),954,20);
    legend('#1','#2','#3','#4',"#5",'#6','#7');
    txt = 'Timestamp: ' + string(Fts(k,1)); %convert timestamp of Peleus' Esp32 into a string
    title(txt, 'FontSize',11, 'FontName', 'Calibri'); %set figure's title
    xlim([0 1069]) %set xlim to zoom into the bg img
    ylim([0 372]) %set ylim to zoom into the bg img
    saveas(B,fullfile(myFolder,['FIG_' num2str(k) '.fig'])); %save the figures in specified folder 
                                                             %with specified name
    saveas(B,fullfile(myFolder,['FIG__' num2str(k) '.png']));                                                         
end

%% 2.Load the figs and save them in an array C{}
myFolder = 'C:\Users\Panos\Desktop\WiFi' ;% Specify the folder where the files live.
% Check to make sure that folder actually exists.  Warn user if it doesn't.
if ~isfolder(myFolder)
    errorMessage = sprintf('Error: The following folder does not exist:\n%s\nPlease specify a new folder.', myFolder);
    uiwait(warndlg(errorMessage));
    myFolder = uigetdir(); % Ask for a new one.
    if myFolder == 0
         % User clicked Cancel
         return;
    end
end
% Get a list of all files in the folder with the desired file name pattern.
filePattern = fullfile(myFolder, '*.fig'); % Change to whatever pattern you need.
theFiles = dir(filePattern);
for k = 1 : length(theFiles)
    baseFileName = theFiles(k).name;
    fullFileName = fullfile(theFiles(k).folder, baseFileName);
    C{k}=fullFileName;
end

%set(gcf,'Visible', 'on'); %Switch visuals on

%% 3.Create .gif File
prompt='Do you want to create a gif now? y/n: ';
a=input(prompt,'s');
if a=='y'
    [file_name file_path]=uigetfile({'*.jpeg;*.jpg;*.fig;*.bmp;*.tif;*.tiff;*.png;*.gif','Image Files (JPEG, FIG, BMP, TIFF, PNG and GIF)'},'Select Images','multiselect','on');
    file_name=sort(file_name);
    [file_name2 file_path2]=uiputfile('*.gif','Save as animated GIF',file_path);
    lps=questdlg('How many loops?','Loops','Forever','None','Other','Forever');
    switch lps
        case 'Forever'
            loops=65535;
        case 'None'
            loops=1;
        case 'Other'
            loops=inputdlg('Enter number of loops? (must be an integer between 1-65535)        .','Loops');
            loops=str2num(loops{1});
    end
    delay=inputdlg('What is the delay time? (in seconds)        .','Delay');
    delay=str2num(delay{1});
    dly=questdlg('Different delay for the first image?','Delay','Yes','No','No');
    if strcmp(dly,'Yes')
        delay1=inputdlg('What is the delay time for the first image? (in seconds)        .','Delay');
        delay1=str2num(delay1{1});
    else
        delay1=delay;
    end
    dly=questdlg('Different delay for the last image?','Delay','Yes','No','No');
    if strcmp(dly,'Yes')
        delay2=inputdlg('What is the delay time for the last image? (in seconds)        .','Delay');
        delay2=str2num(delay2{1});
    else
        delay2=delay;
    end
    h = waitbar(0,['0% done'],'name','Progress') ;
    for i=1:length(file_name)
        if strcmpi('gif',file_name{i}(end-2:end))
            [M  c_map]=imread([file_path,file_name{i}]);
        else
            a=imread([file_path,file_name{i}]);
            [M  c_map]= rgb2ind(a,256);
        end
        if i==1
            imwrite(M,c_map,[file_path2,file_name2],'gif','LoopCount',loops,'DelayTime',delay1)
        elseif i==length(file_name)
            imwrite(M,c_map,[file_path2,file_name2],'gif','WriteMode','append','DelayTime',delay2)
        else
            imwrite(M,c_map,[file_path2,file_name2],'gif','WriteMode','append','DelayTime',delay)
        end
        waitbar(i/length(file_name),h,[num2str(round(100*i/length(file_name))),'% done']) ;
    end
    close(h);
    msgbox('Finished Successfully!')
end