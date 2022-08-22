%%%%%%%%%%%%%%%%%%%%%%%
%clear all


%% create cohort and gather info about subjects

c = MEcohort(Name = 'FCD_MTORvsGFP_Naty_5el_2020_2022',Verbose=true);

root_treat = 'D:\tempPremek'; %% Beware! I have to put here only mice with no bilateral lesion!!!!!!
c.addData(Format = 'VKJ', RootDir = root_treat, Folder = 'PremekMysExtractedJoinedChanCorrect', Treatment = 'MUT'); % , Number = 339
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

%% We added all the data

c.assignRoleBy(Treatment = {'MUT'}, Role = 'TREAT');
c.assignRoleBy(Treatment = {'GFP'}, Role = 'CTRL');

c.printvar(c.Tsub)

%c.summary(); % prints informations about cohort, its a table or plot..


% %%
% clear o
% o.subjRootPathsCell{1} = 'D:\tempPremek';
% % bez bilateralu
% o.subjNamesCell{1} = {'PremekMysExtractedJoinedChanCorrect';'Naty419ExtractedJoined';'TykravoMysExtractedJoined';'Naty413ExtractedJoined';'Naty341ExtractedJoined';'Naty388ExtractedJoined'};
% o.subjNamesCell{1} = {'PremekMysExtractedJoinedChanCorrect'};
%     % which channels to use
% o.kchs=[1 2 3 4 5];
% o.verboseOn=false;
% o.fs = 5000;
% 
% % struct for saving data
% st_fpath = [o.subjRootPathsCell{1} '\st20220113.mat']; % where is the stats file loca
% o.st_fpath=st_fpath; % pass the path
% 
% % o = WKJcomputeAverageIED_miceLevelLesionvsOut(o);
% % averages.IED.TREAT = o.st.averageIED.TREAT;
% % o = WKJcomputeAverageIEDHFO_miceLevelLesionvsOut(o);
% % averages.IEDHFO.TREAT = o.st.averageIED.TREAT;
% o = WKJselectExampleHFOs(o);
% picks.IEDHFO.TREAT = o.st.averages;
% % plot
% % xlabel('Time, ms');
% % ylabel('Amplitude, mV');

 