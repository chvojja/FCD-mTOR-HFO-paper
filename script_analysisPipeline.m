%%%%%%%%%%%%%%%%%%%%%%%
% 
% %% Root analysis dir
% %clear all
% roota='D:\temp_FCD_analyza_1';
% 
% %% Load parts of analysis
% c = load2(a.pwd('c.mat'));

%% Create cohort and gather info about subjects
script_analysis_0_cohort;
script_analysis_1_IEDdetectionAndCheck;
script_analysis_0_cohort;
script_analysis_2_IEDreadOut_plots;


%%
% save(a.pwd('cohort.mat'),'c')
save(a.ptmp,'c','-append');

% %% Load parts of analysis
% c = load2(pwd2('cohort.mat'));
% 
% B = rowfun(@testrow,c.Tsub);
% 
% function testRow(varargin)
% disp('sdsd')
% 
% 
% end

%%
% eeg_subset_5perc_L = o.VKJeeg.

%%


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

 