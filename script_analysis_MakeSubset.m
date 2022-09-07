% % 
% % %% This script can be called only once since it generates random files. The second call would yeld different files
% % select subset
VKJeegSubsetIDs = rowfun(@subsetOfFiles_rowGroup,VKJeeg,'GroupingVariable','Subject','InputVariables',{'ID'},'OutputVariableNames',{'ID'});
save7fp = a.pwd('VKJeegSubsetIDs.mat'); save7

% 
% % % link subset of IDs to rest of important variables
% % VKJeeg = outerjoin(VKJeegSubsetIDs,VKJeeg,'LeftKeys',{'ID'},'RightKeys',{'ID'},'Type','Left','RightVariables', {'Tdat_ID','FileName','FilePath'});
% VKJeeg = outerjoin(VKJeeg,Tdat,'LeftKeys',{'Tdat_ID'},'RightKeys',{'ID'},'Type','Left','RightVariables', {'RootDir','Folder'});
% % save7fp = 'D:\temp_FCD_analyza_1\VKJeegSubset.mat'; save7
% 


% %% Testing IEDs
% detectorSettings =  a.jancaSpikeSettings.IED_strict5000Hz;
% rowfun(@(x1,x2,x3,x4,y,y2) detectIEDs_row(x1,x2,x3,x4,a.labelFolder,detectorSettings) ,c.VKJeeg2,'InputVariables',{'VKJeeg_ID','FilePath','RootDir','Folder'},'NumOutputs', 0);




function y  = subsetOfFiles_rowGroup(IDs)

    Nids = numel(IDs);
    percHowMuch = 2;
    NhowMuch = ceil(Nids*percHowMuch/100);
    NhowMuch = 3;
    
    selIdx = randperm(Nids,NhowMuch);
    npercentIDs = IDs(selIdx);
    
    y = npercentIDs;

end