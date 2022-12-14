

%load(a.pwd('VKJeeg.mat'));
%% Add some necessary fields for rowfun
VKJeeg = outerjoin(VKJeeg,Tdat,'LeftKeys',{'Tdat_ID'},'RightKeys',{'ID'},'Type','Left','RightVariables', {'RootDir','Folder'});



% %% Detect IEDs
% tic
% rowfun(@(x1,x2,x3,x4) detectIEDs_row(x1,x2,x3,x4),VKJeeg,'InputVariables',{'ID','FilePath','RootDir','Folder'},'NumOutputs', 0);
% toc

%% Detect IEDs
tic
names =            { a.jancaSpikeSettings.IED_strict5000Hz.VKJlabelsName    a.jancaSpikeSettings.IED_dontmiss5000Hz.VKJlabelsName  };
colors =           { a.jancaSpikeSettings.IED_strict5000Hz.VKJlabelsColor   a.jancaSpikeSettings.IED_dontmiss5000Hz.VKJlabelsColor };
jancaStrings =     { a.jancaSpikeSettings.IED_strict5000Hz.settingsStr      a.jancaSpikeSettings.IED_dontmiss5000Hz.settingsStr };

rows = size(VKJeeg,1);
for i = 1:rows
 
    FilePath = VKJeeg.FilePath(i);
    RootDir = VKJeeg.RootDir(i);
    Folder = VKJeeg.Folder(i);

    [label,fileInfo] = VKJ_jancaSpikeDetector_eegFile2lblStruct(FilePath = FilePath, Name = names, Color = colors, Settings = jancaStrings );
    % Save a label file
    filePathForLabelFile = [char(RootDir) filesep char(Folder) filesep a.labelFolder filesep VKJ_eegFileName2lblFileName(  filePath2fileName(  char(FilePath)   )     ) ];
    %filePathForLabelFile = fullfile ( a.pwd('lbl2')  ,   VKJ_eegFileName2lblFileName(  filePath2fileName(  char(FilePath)   )     )       );
    VKJ_updateLabelFile(FilePath = filePathForLabelFile, LabelStruct = label);

    % Put a copy of eeg to temp for examination
    %copyfile(char(FilePath),   changePath(Old=FilePath, New =a.pwd('eeg1'))    );
    %copyfile(char(pathForLabelFile),changePath(Old=pathForLabelFile, New =pwd2));
 
    %
    VKJeeg.End{i} = fileInfo.fileEnd;
    VKJeeg.DurationMin(i) = dn2sec(fileInfo.fileDurDn)/60;

    a.verboser.sprintf2('ProgressPerc',round(100*i/rows),'IED detection');

end

VKJeeg.End = categorical(VKJeeg.End );

VKJeeg = renamevars(VKJeeg,{'SubFold1'},{'Fs'});

save7fp = a.pwd('VKJeeg.mat'); save7

toc


%% Support functions
function detectIEDs_row(ID,FilePath,RootDir,Folder) 

    names =            { a.jancaSpikeSettings.IED_strict5000Hz.VKJlabelsName    a.jancaSpikeSettings.IED_dontmiss5000Hz.VKJlabelsName  };
    colors =           { a.jancaSpikeSettings.IED_strict5000Hz.VKJlabelsColor   a.jancaSpikeSettings.IED_dontmiss5000Hz.VKJlabelsColor };
    jancaStrings =     { a.jancaSpikeSettings.IED_strict5000Hz.settingsStr      a.jancaSpikeSettings.IED_dontmiss5000Hz.settingsStr };

%     setCells = [struct2cell(a.jancaSpikeSettings.IED_strict5000Hz) struct2cell(a.jancaSpikeSettings.IED_dontmiss5000Hz) ];
%     names =         setCells(2,[1 2]); 
%     colors =        setCells(3,[1 2]); 
%     jancaStrings =  setCells(1,[1 2]); 

    label = VKJ_jancaSpikeDetector_eegFile2lblStruct(FilePath = FilePath, Name = names, Color = colors, Settings = jancaStrings );
    % Save a label file
    filePathForLabelFile = [char(RootDir) filesep char(Folder) filesep a.labelFolder filesep VKJ_eegFileName2lblFileName(  filePath2fileName(  char(FilePath)   )     ) ];
    %filePathForLabelFile = fullfile ( a.pwd('lbl2')  ,   VKJ_eegFileName2lblFileName(  filePath2fileName(  char(FilePath)   )     )       );
    VKJ_updateLabelFile(FilePath = filePathForLabelFile, LabelStruct = label);

    % Put a copy of eeg to temp for examination
    %copyfile(char(FilePath),   changePath(Old=FilePath, New =a.pwd('eeg1'))    );
    %copyfile(char(pathForLabelFile),changePath(Old=pathForLabelFile, New =pwd2));

    a.verboser.sprintf2('ProgressPerc',round(100*ID/rows),'IED detection');
   
end






