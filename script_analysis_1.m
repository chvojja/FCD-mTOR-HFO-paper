%% Load parts of analysis
c = load2(a.pwd('cohort.mat'));
labelFolder = 'IEDFRRfinal1';
%%
Tsubset = rowfun(@subsetOfFiles_rowGroup,c.VKJeeg,'GroupingVariable','Subject','InputVariables',{'ID'},'OutputVariableNames',{'VKJeeg_ID'})


% rows =   ismember(c.VKJeeg.ID,Tsubset.VKJeeg_ID);
% VKJeegSubset = c.VKJeeg(rows,:)

Tsubset = outerjoin(Tsubset,c.VKJeeg,'LeftKeys',{'VKJeeg_ID'},'RightKeys',{'ID'},'Type','Left','RightVariables', {'Tdat_ID','FileName','FilePath'});
Tsubset = outerjoin(Tsubset,c.Tdat,'LeftKeys',{'Tdat_ID'},'RightKeys',{'ID'},'Type','Left','RightVariables', {'RootDir','Folder'})
%% Detect IEDs
IEDs = rowfun(@(x1,x2,x3,x4,y) detectIEDs_row(x1,x2,x3,x4,labelFolder) ,Tsubset,'InputVariables',{'VKJeeg_ID','FilePath','RootDir','Folder'},'OutputVariableNames',{'IEDs'});



        %%%%%%%%%%%%%%%create label

%% Functions
function y = detectIEDs_row(ID,FilePath,RootDir,Folder,labelFolder) 

    label = VKJ_jancaSpikeDetector_eegFile2lblStruct(FilePath = FilePath, Name = 'IED1' , Color ='0 0 1', Settings = []);
    % Save a label file
    filePathForLabelFile = [char(RootDir) filesep char(Folder) filesep labelFolder filesep VKJ_eegFileName2lblFileName(  filePath2fileName(  char(FilePath)   )     ) ];
    filePathForLabelFile = fullfile ( a.pwd('lbl1') )
    VKJ_updateLabelFile(FilePath = filePathForLabelFile, LabelStruct = label);

    % Put a copy of eeg to temp
    copyfile(char(FilePath),   changePath(Old=FilePath, New =a.pwd('eeg1'))    );
    %copyfile(char(pathForLabelFile),changePath(Old=pathForLabelFile, New =pwd2));

end


function y  = subsetOfFiles_rowGroup(IDs)

Nids = numel(IDs);
percHowMuch = 2;
NhowMuch = ceil(Nids*percHowMuch/100);
NhowMuch = 2;

selIdx = randperm(Nids,NhowMuch);
npercentIDs = IDs(selIdx);

y = npercentIDs;

end