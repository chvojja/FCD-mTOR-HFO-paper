

% Tsubset = outerjoin(Tsubset,c.VKJeeg,'LeftKeys',{'VKJeeg_ID'},'RightKeys',{'ID'},'Type','Left','RightVariables', {'Tdat_ID','FileName','FilePath'});
% Tsubset = outerjoin(Tsubset,c.Tdat,'LeftKeys',{'Tdat_ID'},'RightKeys',{'ID'},'Type','Left','RightVariables', {'RootDir','Folder'})
% %save(a.ptmp,'Tsubset','-append');

unpack_var = 'c'; unpack; clear c

%% Load IED detections and extract IEDs, FR, and R 



rowfunt(Table=VKJlbl, Fun = @computeFeatures_row);


% detectorSettings =  a.jancaSpikeSettings.IED_strict5000Hz;
% rowfun(@(x1,x2,x3,x4,y1,y2) computeFeatures_row(x1,x2,x3,x4,a.labelFolder,detectorSettings) ,Tsubset,'InputVariables',{'ID','VKJeeg_ID','FilePath','RootDir'},'NumOutputs', 0);
% 
Tlbl = leftjoinsorted(VKJlbl,VKJeeg,'LeftKeys',{'VKJeeg_ID'},'RightKeys',{'ID'});


% %% Functions
function computeFeatures_row(Tlbl) 
         lbl = load2(Tlbl.FilePath_left);
         eeg = load2(Tlbl.FilePath_right);
         s;



end
% function computeFeatures_row(ID_lbl,FilePath,RootDir,labelFolder,detectorSettings) 
% 
%     label = VKJ_jancaSpikeDetector_eegFile2lblStruct(FilePath = FilePath, Name = detectorSettings.VKJlabelsName , Color =detectorSettings.VKJlabelsColor, Settings = detectorSettings.settingsStr);
%     % Save a label file
%     %filePathForLabelFile = [char(RootDir) filesep char(Folder) filesep labelFolder filesep VKJ_eegFileName2lblFileName(  filePath2fileName(  char(FilePath)   )     ) ];
%     filePathForLabelFile = fullfile ( a.pwd('lbl2')  ,   VKJ_eegFileName2lblFileName(  filePath2fileName(  char(FilePath)   )     )       );
%     VKJ_updateLabelFile(FilePath = filePathForLabelFile, LabelStruct = label);
% 
%     % Put a copy of eeg to temp for examination
%     %copyfile(char(FilePath),   changePath(Old=FilePath, New =a.pwd('eeg1'))    );
%     %copyfile(char(pathForLabelFile),changePath(Old=pathForLabelFile, New =pwd2));
%    
% end
% 
% 
% function y  = subsetOfFiles_rowGroup(IDs)
% 
% Nids = numel(IDs);
% percHowMuch = 2;
% NhowMuch = ceil(Nids*percHowMuch/100);
% NhowMuch = 2;
% 
% selIdx = randperm(Nids,NhowMuch);
% npercentIDs = IDs(selIdx);
% 
% y = npercentIDs;
% 
% end