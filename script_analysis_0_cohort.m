%% Create cohort and gather info about subjects

c = MEcohort(Name = 'FCD_MTORvsGFP_Naty_5el_2020_2022',Verbose=true,FileFilter = {'SubFold1','5000HZ','SubFold1',a.labelFolder});

root_treat = 'D:\tempPremek'; %% Beware! I have to put here only mice with no bilateral lesion!!!!!!
c.addData(Format = 'VKJ', RootDir = root_treat, Folder = 'PremekMysExtractedJoinedChanCorrect', Treatment = 'MUT',Number = 339); % , 

c.addData(Format = 'VKJ', RootDir = root_treat, Folder = 'Naty419ExtractedJoined', Treatment = 'MUT');

% c.addData(Format = 'VKJ', RootDir = root_treat, Folder = 'TryskoMysExtractedJoined', Treatment = 'MUT');  % Bilateral lesion, put out
c.addData(Format = 'VKJ', RootDir = root_treat, Folder = 'TykravoMysExtractedJoined', Treatment = 'MUT', Number = 343);
c.addData(Format = 'VKJ', RootDir = root_treat, Folder = 'Naty413ExtractedJoined', Treatment = 'MUT');
% c.addData(Format = 'VKJ', RootDir = root_treat, Folder = 'Naty338ExtractedJoined', Treatment = 'MUT');  Bilateral lesion, put out
c.addData(Format = 'VKJ', RootDir = root_treat, Folder = 'Naty341ExtractedJoined', Treatment = 'MUT');
c.addData(Format = 'VKJ', RootDir = root_treat, Folder = 'Naty388ExtractedJoined', Treatment = 'MUT');

root_ctrl = 'D:\tempHFO_Naty_GFPcontrols'; % cesta
c.addData(Format = 'VKJ', RootDir = root_ctrl, Folder = 'Naty554ExtractedJoined', Treatment = 'GFP');
c.addData(Format = 'VKJ', RootDir = root_ctrl, Folder = 'Naty600ExtractedJoined', Treatment = 'GFP');
c.addData(Format = 'VKJ', RootDir = root_ctrl, Folder = 'Naty601ExtractedJoined', Treatment = 'GFP');
c.addData(Format = 'VKJ', RootDir = root_ctrl, Folder = 'Naty602ExtractedJoined', Treatment = 'GFP');

% We added all the data

c.assignRoleBy(Treatment = {'MUT'}, Role = 'TREAT');
c.assignRoleBy(Treatment = {'GFP'}, Role = 'CTRL');

c.consolidate()

c.printvar(c.Tsub)

%%
%save7fp = 'D:\temp_FCD_analyza_1\c.mat'; save7
save7fp = a.pwd('c.mat'); save7
