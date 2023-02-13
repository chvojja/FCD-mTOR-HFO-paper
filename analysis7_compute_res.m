
%%
warning off;

%% Per subject results

% inputs
% TiedfRes - filtered by labelName
% Tsub


% TsubRes = Tsub;
% TiedfRes = Tiedf;

% compute new with filtered and unfiltered table
TsubRes = perSubjectRes(Tsub,Tiedf, VKJeeg, 'TsubRes');

% TsubRes_temp = table2missing(TsubRes_inlesion);
TsubRes_temp = table2missing(TsubRes);
TsubRes_temp = updatecols(Tsub,TsubRes_temp );

TsubRes_inlesion = perSubjectRes(TsubRes_temp, Tiedf( Tiedf.InLesion == true , :) , VKJeeg,'inout');

TsubRes_outlesion = perSubjectRes(TsubRes_temp, Tiedf( Tiedf.InLesion == false , :) , VKJeeg,'inout');

% correct for mistakes
% TsubRes = perSubjectRes(TsubRes,Tiedf, Tdati);
% TsubRes_inlesion = perSubjectRes(TsubRes_inlesion, Tiedf( Tiedf.InLesion == true , :) , Tdati);
% TsubRes_outlesion = perSubjectRes(TsubRes_outlesion, Tiedf( Tiedf.InLesion == false , :) , Tdati);

% TsubRes.InLesion
TsubRes_inlesion.InLesion=true(size(TsubRes_inlesion,1),1);
TsubRes_outlesion.InLesion=false(size(TsubRes_outlesion,1),1);

%save7fp = a.pwd('TsubRes_inlesion.mat'); save7
%save7fp = a.pwd('TsubRes_outlesion.mat'); save7

TsubRes_inout = [TsubRes_inlesion ; TsubRes_outlesion];
TsubRes_inout.ID = [1:size(TsubRes_inout,1)]';

% % delete the bilateral animals
% iBilateral =  ismember( TsubRes_inout.Subject, { 'Naty338' , 'TryskoMys' } );
% TsubRes_inout( iBilateral, : ) = [];
%%
TsubRes = perSubject_compute_independantVsSource(TsubRes,Tiedf);
%%
save7fp = a.pwd('TsubRes.mat'); save7

save7fp = a.pwd('TsubRes_inout.mat'); save7

% Compute features
featuresC = {'IEDskew','IEDampl_mV','IEDwidth_msec','IEDmed','Rfreq','FRfreq','Rlength_ms','FRlength_ms',...
             'Rpwr','FRpwr','RinIEDs','FRinRFRs','RtoIEDrateShare', 'FRtoIEDrateShare', 'rateIED_min','rateR_min','rateFR_min','HFOsInIEDs_percent','NRs','NFRs'};
[ Tplt_CtrlVsTreat] =  getTablePvals_ctr_vs_treat(TsubRes , featuresC );



featuresC = {'IEDskew','IEDampl_mV','IEDwidth_msec','IEDmed','Rfreq','FRfreq','Rlength_ms','FRlength_ms',...
             'Rpwr','FRpwr','RinIEDs','FRinRFRs','RtoIEDrateShare', 'FRtoIEDrateShare', 'rateIED_min','rateR_min','rateFR_min',...
             'FRpeaksPositions_detectionLevel_ms','FRpeaksPositions_mean_ms', 'RpeaksPositions_detectionLevel_ms','RpeaksPositions_mean_ms' };
%             'Rpwr','RinIEDs','FRinRFRs','RtoIEDrateShare', 'FRtoIEDrateShare', 'rateIED_min','rateR_min','rateFR_min','meanPeakPos_bunched_together'}; ''
%featuresC = {'FRpeaksPositions_detectionLevel_ms','FRpeaksPositions_mean_ms'};
[ Tplt_OutVsIn ] =  getTablePvals_in_vs_out(TsubRes_inout( TsubRes_inout.Role == 'TREAT' , : ) , featuresC );


Tplt_CtrlVsTreat = rownames2var( Tplt_CtrlVsTreat , 'Features' );
Tplt_OutVsIn = rownames2var( Tplt_OutVsIn , 'Features' );

save7fp = a.pwd('Tplt_CtrlVsTreat.mat'); save7
save7fp = a.pwd('Tplt_OutVsIn.mat'); save7
%%
writetable( Tplt_CtrlVsTreat(:,setdiff(Tplt_CtrlVsTreat.Properties.VariableNames,{'CTRL_data','TREAT_data'}))    , a.pwd('Tplt_CtrlVsTreat.xlsx') );
writetable( Tplt_OutVsIn(:,setdiff(Tplt_OutVsIn.Properties.VariableNames,{'In_data','Out_data'}))    , a.pwd('Tplt_OutVsIn.xlsx') );


%% Compute all dataset features

timePerMouse = splitapply(@sum,VKJeeg.DurationMin,findgroups(VKJeeg.Subject));
TsubRes.TimeRawMinsExact=timePerMouse;

TsubRes.SkullFluoro_mm2 = Tlesions.SkullFluoro_mm2;

stats.fluoro_medianstd_mm2 =  printmeansem(  nanmedian( TsubRes.SkullFluoro_mm2 )  , nansem( TsubRes.SkullFluoro_mm2 ) );
stats.fluoro_in_contra = 2;
stats.Nanimals_TREAT = numel(find(TsubRes.Role == 'TREAT'));
stats.Nanimals_CTRL = numel(find(TsubRes.Role == 'CTRL'));
stats.Nanimals_TREAT_withIEDs = numel(find(TsubRes.Nieds>0 & TsubRes.Role == 'TREAT'));
stats.Nanimals_TREAT_withHFOs = numel(find( (TsubRes.NRs>0 | TsubRes.NFRs>0 ) & TsubRes.Role == 'TREAT'));
stats.Nanimals_TREAT_withRipples = numel(find( (TsubRes.NRs>0 ) & TsubRes.Role == 'TREAT'));
stats.Nanimals_TREAT_withFastRipples = numel(find( (TsubRes.NFRs>0 ) & TsubRes.Role == 'TREAT'));

overallAvg_numberOfIedsPerElectrode = (numel(find((Tiedf.Role == 'TREAT' & Tiedf.LabelName == a.IEDlabelName)))/5 );
stats.overallEEGRawTimeMins = sum(  TsubRes.TimeRawMinsExact(TsubRes.Role == 'TREAT')  );
%overall_IEDrate_perMin = overallAvg_numberOfIedsPerElectrode / overallEEGRawTimeMins;  
treat_logi = TsubRes.Role == 'TREAT';
stats.overall_IEDs_Nevents  = numel(find((Tiedf.Role == 'TREAT' & Tiedf.LabelName == a.IEDlabelName) ));

stats.totalHFOevents_seizing_and_nonseizing =  sum(TsubRes.NHFOs(TsubRes.Role == "TREAT"));

% alternative way of computing but too compicated
%stats.overall_percentIEDdetectionsAssociatedHFOInControls  = 100*  numel(find(   (Tiedf.Role == 'CTRL' & Tiedf.LabelName == a.IEDlabelName) & (Tiedf.HasR | Tiedf.HasFR)    ))    /     numel(find(   (Tiedf.Role == 'CTRL' & Tiedf.LabelName == a.IEDlabelName)     ));

stats.overall_percentIEDdetectionsAssociatedHFOInControls = 100* sum( TsubRes.NHFOs(TsubRes.Role =='CTRL') ) / sum( TsubRes.Nieds(TsubRes.Role =='CTRL') );
stats.overall_percentIEDdetectionsAssociatedHFOInFCD = 100* sum( TsubRes.NHFOs(TsubRes.Role =='TREAT') ) / sum( TsubRes.Nieds(TsubRes.Role =='TREAT') );

%% Test histograms
% KS tests
% In Tplt_OutVsIn FRpeaksPosition row we have the raw HFO peaks positions
% KS1 differnt from normal
positions_C = Tplt_OutVsIn{ 'FRpeaksPositions_detectionLevel_ms', 'In_data'}; 
stats = test_kstest(positions_C{:},'FRpeaksPositions_In_distribution_diffferent_from_norm',stats); % struct.h struct.p
positions_C = Tplt_OutVsIn{ 'FRpeaksPositions_detectionLevel_ms', 'Out_data'}; 
stats = test_kstest(positions_C{:},'FRpeaksPositions_Out_distribution_diffferent_from_norm',stats); % struct.h struct.p
positions_C = Tplt_OutVsIn{ 'RpeaksPositions_detectionLevel_ms', 'In_data'}; 
stats = test_kstest(positions_C{:},'RpeaksPositions_In_distribution_diffferent_from_norm',stats); % struct.h struct.p
positions_C = Tplt_OutVsIn{ 'RpeaksPositions_detectionLevel_ms', 'Out_data'}; 
stats = test_kstest(positions_C{:},'RpeaksPositions_Out_distribution_diffferent_from_norm',stats); % struct.h struct.p

% KS2 distribution differnt in vs out
positions_inC = Tplt_OutVsIn{ 'FRpeaksPositions_detectionLevel_ms', 'In_data'};  % all times of HFO oscillation peaks pooled together inside lesion
positions_outC = Tplt_OutVsIn{ 'FRpeaksPositions_detectionLevel_ms', 'Out_data'}; 
stats = test_kstest(positions_inC{:},positions_outC{:},'FRpeaksPositions_distribution_In_vs_Out_diffferent',stats);

positions_inC = Tplt_OutVsIn{ 'RpeaksPositions_detectionLevel_ms', 'In_data'};  % all times of HFO oscillation peaks pooled together inside lesion
positions_outC = Tplt_OutVsIn{ 'RpeaksPositions_detectionLevel_ms', 'Out_data'}; 
stats = test_kstest(positions_inC{:},positions_outC{:},'RpeaksPositions_distribution_In_vs_Out_diffferent',stats);

% KS2 different FR vs R
FRpositions_inC = Tplt_OutVsIn{ 'FRpeaksPositions_detectionLevel_ms', 'In_data'};  % all times of HFO oscillation peaks pooled together inside lesion
FRpositions_outC = Tplt_OutVsIn{ 'FRpeaksPositions_detectionLevel_ms', 'Out_data'};  

Rpositions_inC = Tplt_OutVsIn{ 'RpeaksPositions_detectionLevel_ms', 'In_data'};  % all times of HFO oscillation peaks pooled together inside lesion
Rpositions_outC = Tplt_OutVsIn{ 'RpeaksPositions_detectionLevel_ms', 'Out_data'}; 

stats = test_kstest( [FRpositions_inC{:}; FRpositions_outC{:}] , [Rpositions_inC{:}; Rpositions_outC{:}] , 'PeaksPositions_distribution_FR_vs_R_diffferent',stats);
% %%
% stats = test_kstest( means_OUT , means_IN , 'TimeRelationshipBars_INvsOUT_distribution_diffferent',stats);
% 
% %%





% 
% stats.FRpeaksPositions_distribution_In_vs_Out_diffferent = test_kstest(positions_inC{:},positions_outC{:});
% %
% positions_inC = Tplt_OutVsIn{ 'FRpeaksPositions_detectionLevel_ms', 'In_data'};  % all times of HFO oscillation peaks pooled together inside lesion
% positions_outC = Tplt_OutVsIn{ 'FRpeaksPositions_detectionLevel_ms', 'Out_data'}; 
% % test HFO histograms 
% if ~isempty(positions_inC{:}) && ~isempty(positions_outC{:})
%     [h,p] = kstest2( positions_inC{:} , positions_outC{:} ,'Alpha',0.05);
% else
%     h = NaN; p = NaN;
% end
% stats.FRpeaksPositions_distribution_diffferent = h;
% stats.FRpeaksPositions_distribution_diffferent_p = p;
% 
% 
% positions_inC = Tplt_OutVsIn{ 'RpeaksPositions_detectionLevel_ms', 'In_data'}; 
% positions_outC = Tplt_OutVsIn{ 'RpeaksPositions_detectionLevel_ms', 'Out_data'}; 
% % test HFO histograms 
% if ~isempty(positions_inC{:}) && ~isempty(positions_outC{:})
%     [h,p] = kstest2( positions_inC{:} , positions_outC{:} ,'Alpha',0.05);
% else
%     h = NaN; p = NaN;
% end
% stats.RpeaksPositions_distribution_diffferent = h;
% stats.RpeaksPositions_distribution_diffferent_p = p;

% This is a slow function
stats = addMeanshapes(stats, TsubRes, Tiedf);



% Compute Pie data
T = TsubRes(TsubRes.Role=='TREAT',:);  % Only Treatments

NiedsTotal = sum(T.Nieds);
%
countsOnlyIEDsNoRsNoFRs =  T.Nieds - (T.NRs+T.NFRs-T.NFRswithRs)  ;
countsOnlyRs = T.NRs-T.NFRswithRs;
countsOnlyRFRs = T.NFRswithRs;
countsOnlyFRs = T.NFRs-T.NFRswithRs;

pieData(1) = sum(countsOnlyIEDsNoRsNoFRs) / NiedsTotal ;
pieData(2) = sum(countsOnlyRs) / NiedsTotal;
pieData(3) = sum(countsOnlyRFRs) / NiedsTotal;
pieData(4) = sum(countsOnlyFRs) / NiedsTotal;

% small box plots
percentsEachAnimal = 100*[countsOnlyIEDsNoRsNoFRs countsOnlyRs countsOnlyFRs  countsOnlyRFRs ]./T.Nieds;

% barsData = [percentsEachAnimal(:,1:end) 100*countsOnlyRFRs./(countsOnlyRFRs+countsOnlyFRs) ];
% barsData(:,2:end) = NaN;
% hbcounts1=boxchart( barsData ,'BoxFaceColor','k','LineWidth',plt.LineWidthBox);
% 

stats.pieData = pieData;
stats.percents_IEDsNoHFO = percentsEachAnimal(:,1);
stats.percents_IEDsWithHFO = percentsEachAnimal(:,2:end);
stats.percents_IEDsWithHFO_asText.GR = printmeansemmedian_HFOpaper(stats.percents_IEDsWithHFO(:,1));
stats.percents_IEDsWithHFO_asText.FR = printmeansemmedian_HFOpaper(stats.percents_IEDsWithHFO(:,2));
stats.percents_IEDsWithHFO_asText.GRFR = printmeansemmedian_HFOpaper(stats.percents_IEDsWithHFO(:,3));

%
% Multimadals

feature = 'Rfreq';
frqs = Tiedf{Tiedf.Role=='TREAT' & ~isnan(Tiedf.(feature)),feature};
[mus,sems] = multimodalstats(frqs,2,'sem');
stats.([feature '_multimodals_mu']) = mus;
stats.([feature '_multimodals_sems']) = sems;
stats.([feature '_multimodals_AsText_1']) = printmeansem(mus(1),sems(1));
stats.([feature '_multimodals_AsText_2']) = printmeansem(mus(2),sems(2));

feature = 'FRfreq';
frqs = Tiedf{Tiedf.Role=='TREAT' & ~isnan(Tiedf.(feature)),feature};
[mus,sems] = multimodalstats(frqs,2,'sem');
stats.([feature '_multimodals_mu']) = mus;
stats.([feature '_multimodals_sems']) = sems;    
stats.([feature '_multimodals_AsText_1']) = printmeansem(mus(2),sems(2));


%% Peak positions and distrubutions


numbers = unique(TsubRes_inout.Number(TsubRes_inout.Role=='TREAT'));


% compute pvalues for R before after inlesion
data1 = TsubRes_inout{ ismember(TsubRes_inout.Number, numbers ) & (TsubRes_inout.InLesion == true) , 'RpeaksPercentBeforeIed' };
data2 = TsubRes_inout{ ismember(TsubRes_inout.Number, numbers ) & (TsubRes_inout.InLesion == true) , 'RpeaksPercentAfterIed' };
validPairsInds = ~cellfun(@isempty,data1) & ~cellfun(@isempty,data2);
p = signrank( [data1{validPairsInds}] , [data2{validPairsInds}] ) ;  %sp = 0.01;  % plt.Tst_CtrVsTreat{ feature , 'p' }
stats.RprobBeforeDifferentFromAfterIED_in_p = p;
% compute pvalues for R before after outlesion
data1 = TsubRes_inout{ ismember(TsubRes_inout.Number, numbers ) & (TsubRes_inout.InLesion == false) , 'RpeaksPercentBeforeIed' };
data2 = TsubRes_inout{ ismember(TsubRes_inout.Number, numbers ) & (TsubRes_inout.InLesion == false) , 'RpeaksPercentAfterIed' };
validPairsInds = ~cellfun(@isempty,data1) & ~cellfun(@isempty,data2);
p = signrank( [data1{validPairsInds}] , [data2{validPairsInds}] ) ;  %sp = 0.01;  % plt.Tst_CtrVsTreat{ feature , 'p' }
stats.RprobBeforeDifferentFromAfterIED_out_p = p;

% compute pvalues for FR before after inlesion
data1 = TsubRes_inout{ ismember(TsubRes_inout.Number, numbers ) & (TsubRes_inout.InLesion == true) , 'FRpeaksPercentBeforeIed' };
data2 = TsubRes_inout{ ismember(TsubRes_inout.Number, numbers ) & (TsubRes_inout.InLesion == true) , 'FRpeaksPercentAfterIed' };
validPairsInds = ~cellfun(@isempty,data1) & ~cellfun(@isempty,data2);
p = signrank( [data1{validPairsInds}] , [data2{validPairsInds}] ) ;  %sp = 0.01;  % plt.Tst_CtrVsTreat{ feature , 'p' }
stats.FRprobBeforeDifferentFromAfterIED_in_p = p;
% compute pvalues for FR before after outlesion
data1 = TsubRes_inout{ ismember(TsubRes_inout.Number, numbers ) & (TsubRes_inout.InLesion == false) , 'FRpeaksPercentBeforeIed' };
data2 = TsubRes_inout{ ismember(TsubRes_inout.Number, numbers ) & (TsubRes_inout.InLesion == false) , 'FRpeaksPercentAfterIed' };
validPairsInds = ~cellfun(@isempty,data1) & ~cellfun(@isempty,data2);
p = signrank( [data1{validPairsInds}] , [data2{validPairsInds}] ) ;  %sp = 0.01;  % plt.Tst_CtrVsTreat{ feature , 'p' }
stats.FRprobBeforeDifferentFromAfterIED_out_p = p;

% R compare inlesion vs outlesion
data1 = TsubRes_inout{ ismember(TsubRes_inout.Number, numbers ) & (TsubRes_inout.InLesion == true) , 'RpeaksPercentBeforeIed' };
data2 = TsubRes_inout{ ismember(TsubRes_inout.Number, numbers ) & (TsubRes_inout.InLesion == false) , 'RpeaksPercentBeforeIed' };
validPairsInds = ~cellfun(@isempty,data1) & ~cellfun(@isempty,data2);
p = signrank( [data1{validPairsInds}] , [data2{validPairsInds}] ) ;  %sp = 0.01;  % plt.Tst_CtrVsTreat{ feature , 'p' }
stats.RprobInVsOut_before_p = p;
% FR compare inlesion vs outlesion
data1 = TsubRes_inout{ ismember(TsubRes_inout.Number, numbers ) & (TsubRes_inout.InLesion == true) , 'FRpeaksPercentBeforeIed' };
data2 = TsubRes_inout{ ismember(TsubRes_inout.Number, numbers ) & (TsubRes_inout.InLesion == false) , 'FRpeaksPercentBeforeIed' };
validPairsInds = ~cellfun(@isempty,data1) & ~cellfun(@isempty,data2);
p = signrank( [data1{validPairsInds}] , [data2{validPairsInds}] ) ;  %sp = 0.01;  % plt.Tst_CtrVsTreat{ feature , 'p' }
stats.FRprobInVsOut_before_p = p;

% compare R prob vs FR prob inlesion 
data1 = TsubRes_inout{ ismember(TsubRes_inout.Number, numbers ) & (TsubRes_inout.InLesion == true) , 'RpeaksPercentBeforeIed' };
data2 = TsubRes_inout{ ismember(TsubRes_inout.Number, numbers ) & (TsubRes_inout.InLesion == true) , 'FRpeaksPercentBeforeIed' };
validPairsInds = ~cellfun(@isempty,data1) & ~cellfun(@isempty,data2);
p = signrank( [data1{validPairsInds}] , [data2{validPairsInds}] ) ;  %sp = 0.01;  % plt.Tst_CtrVsTreat{ feature , 'p' }
stats.RprobVsFRprob_before_p = p;


% save as text mean stats for peaks
data1 = TsubRes_inout{ ismember(TsubRes_inout.Number, numbers ) & (TsubRes_inout.InLesion == true) , 'FRpeaksPercentBeforeIed' };
stats.FRpeaksPercentBeforeIed_in_asText = printmeansemmedian_HFOpaper([data1{:}]);

data1 = TsubRes_inout{ ismember(TsubRes_inout.Number, numbers ) & (TsubRes_inout.InLesion == false) , 'FRpeaksPercentBeforeIed' };
stats.FRpeaksPercentBeforeIed_out_asText = printmeansemmedian_HFOpaper([data1{:}]);


% add KS tests for each mouse
% this goes through all mice and computes 
% 1. KS test for in lesion and out of lesion distribution
% 2. ttest for difference in means

for num = numbers'

   % FRs
   feature = 'FRpeaksPositions_detectionLevel_ms';
   peakPositions_inC = TsubRes_inout.(feature)( TsubRes_inout.Number == num & TsubRes_inout.InLesion == 1);
   peakPositions_outC = TsubRes_inout.(feature)( TsubRes_inout.Number == num & TsubRes_inout.InLesion == 0);
   x = peakPositions_inC{:};
   y = peakPositions_outC{:};

   % In vs Out tests
   if ~isempty(x) & ~isempty(y)
       % test distributions In from  OUT in each mouse
       [h,p] = kstest2( x , y ,'Alpha',0.05); 
       TsubRes.FR_pval_PeakPositionsDistDifferent_InOut_KS(TsubRes.Number == num) = p;
       % test also means
       [h,p] = ttest2( x , y ,'Alpha',0.05);
       TsubRes.FR_pval_PeakPositionsMeanDifferent_InOut_Ttest(TsubRes.Number == num) = p;
       %TsubRes.FR_pval_PeakPositionsMeanDifference_InMinusOut_msByTtest(TsubRes.Number == num)  = mean(x)-mean(y);
   else
       TsubRes.FR_pval_PeakPositionsDistDifferent_InOut_KS(TsubRes.Number == num) = NaN;
       %TsubRes.FR_pval_PeakPositionsMeanDifferent_InOut_Ttest(TsubRes.Number == num) = NaN;
   end
   % Each vs uniform
   if ~isempty(x)
       % test distributions In from uniform  in each mouse
       uni = unifrnd(min(x),max(x),size(x));
       [h,p] = kstest2( x , uni ,'Alpha',0.05); 
       TsubRes.FR_pval_PeakPositionsDistDifferent_InVsUNIFORM_KS(TsubRes.Number == num) = p;
       %TsubRes.FRpeaksPositions_mean_in_ms(TsubRes.Number == num) = mean(x);

   else
       TsubRes.FR_pval_PeakPositionsDistDifferent_InVsUNIFORM_KS(TsubRes.Number == num) = NaN;
       %TsubRes.FRpeaksPositions_mean_in_ms(TsubRes.Number == num) = NaN;
   end
   if ~isempty(y)
       % test distributions Out from uniform in each mouse
       uni = unifrnd(min(y),max(y),size(y));
       [h,p] = kstest2( uni , y ,'Alpha',0.05); 
       TsubRes.FR_pval_PeakPositionsDistDifferent_OutVsUNIFORM_KS(TsubRes.Number == num) = p;
       %TsubRes.FRpeaksPositions_mean_out_ms(TsubRes.Number == num) = mean(y);
   else
       TsubRes.FR_pval_PeakPositionsDistDifferent_OutVsUNIFORM_KS(TsubRes.Number == num) = NaN;
       %TsubRes.FRpeaksPositions_mean_out_ms(TsubRes.Number == num) = NaN;
   end


   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % Rs
   feature = 'RpeaksPositions_detectionLevel_ms';
   peakPositions_inC = TsubRes_inout.(feature)( TsubRes_inout.Number == num & TsubRes_inout.InLesion == 1);
   peakPositions_outC = TsubRes_inout.(feature)( TsubRes_inout.Number == num & TsubRes_inout.InLesion == 0);
   x = peakPositions_inC{:};
   y = peakPositions_outC{:};

   % In vs Out tests
   if ~isempty(x) & ~isempty(y)
       % test distributions In from  OUT in each mouse
       [h,p] = kstest2( x , y ,'Alpha',0.05); 
       TsubRes.R_pval_PeakPositionsDistDifferent_InOut_KS(TsubRes.Number == num) = p;
       % test also means
       [h,p] = ttest2( x , y ,'Alpha',0.05);
       TsubRes.R_pval_PeakPositionsMeanDifferent_InOut_Ttest(TsubRes.Number == num) = p;
       %TsubRes.R_pval_PeakPositionsMeanDifference_InMinusOut_msByTtest(TsubRes.Number == num)  = mean(x)-mean(y);
   else
       TsubRes.R_pval_PeakPositionsDistDifferent_InOut_KS(TsubRes.Number == num) = NaN;
       %TsubRes.R_pval_PeakPositionsMeanDifferent_InOut_Ttest(TsubRes.Number == num) = NaN;
   end
   % Each vs uniform
   if ~isempty(x)
       % test distributions In from uniform  in each mouse
       uni = unifrnd(min(x),max(x),size(x));
       [h,p] = kstest2( x , uni ,'Alpha',0.05); 
       TsubRes.R_pval_PeakPositionsDistDifferent_InVsUNIFORM_KS(TsubRes.Number == num) = p;
       %TsubRes.RpeaksPositions_mean_in_ms(TsubRes.Number == num) = mean(x);
   else
       TsubRes.R_pval_PeakPositionsDistDifferent_InVsUNIFORM_KS(TsubRes.Number == num) = NaN;
       %TsubRes.RpeaksPositions_mean_in_ms(TsubRes.Number == num) = NaN;
   end
   if ~isempty(y)
       % test distributions Out from uniform in each mouse
       uni = unifrnd(min(y),max(y),size(y));
       [h,p] = kstest2( uni , y ,'Alpha',0.05); 
       TsubRes.R_pval_PeakPositionsDistDifferent_OutVsUNIFORM_KS(TsubRes.Number == num) = p;
       %TsubRes.RpeaksPositions_mean_out_ms(TsubRes.Number == num) = mean(y);
   else
       TsubRes.R_pval_PeakPositionsDistDifferent_OutVsUNIFORM_KS(TsubRes.Number == num) = NaN;
       %TsubRes.RpeaksPositions_mean_out_ms(TsubRes.Number == num) = NaN;
   end
      
end

%%




save7fp = a.pwd('stats.mat'); save7



function stats = test_kstest(varargin)
% tests by kstest or kstest2
h = NaN; p = NaN;
switch nargin
    case 3
        x=varargin{1};
        name=varargin{2};
        stats=varargin{3};

        %x = normalize(x);
            if ~isempty(x)
                [h,p] = kstest( x ,'Alpha',0.05); 
            end
         
    case 4
        x=varargin{1};
        y=varargin{2};
        name=varargin{3};
        stats=varargin{4};

        %x = normalize(x);
        %y = normalize(y);
            if ~isempty(x) && ~isempty(y)
                [h,p] = kstest2( x , y ,'Alpha',0.05); 
            end
end
stats.([name '_p'])=p;
stats.([name '_h'])=h;

end


%%
function stats = addMeanshapes(stats, TsubRes, Tiedf)

% SLOW mean IED shapes with and without HFOs
[ied, iedsems] =  getIEDmeansems(    TsubRes( TsubRes.Role == 'TREAT' , :)    ,   Tiedf( Tiedf.HasR == true , : )    ) ;
stats = addOneMeanShape(stats,'withRipple',ied, iedsems);

[ied, iedsems] =  getIEDmeansems(    TsubRes( TsubRes.Role == 'TREAT' , :)    ,   Tiedf( Tiedf.HasR == false , : )    ) ;
stats = addOneMeanShape(stats,'noRipple',ied, iedsems);

[ied, iedsems] =  getIEDmeansems(    TsubRes( TsubRes.Role == 'TREAT' , :)    ,   Tiedf( Tiedf.HasFR == true , : )    ) ;
stats = addOneMeanShape(stats,'withFRipple',ied, iedsems);

[ied, iedsems] =  getIEDmeansems(    TsubRes( TsubRes.Role == 'TREAT' , :)    ,   Tiedf( Tiedf.HasFR == false , : )    ) ;
stats = addOneMeanShape(stats,'noFRipple',ied, iedsems);


% SLOW mean IED shapes with HFOs but In or Out of the lesion
[ied, iedsems] =  getIEDmeansems(    TsubRes( TsubRes.Role == 'TREAT' , :)    ,   Tiedf( Tiedf.HasR == true & Tiedf.InLesion == true , : )    ) ;
stats = addOneMeanShape(stats,'withRipple_inLesion',ied, iedsems);

[ied, iedsems] =  getIEDmeansems(    TsubRes( TsubRes.Role == 'TREAT' , :)    ,   Tiedf( Tiedf.HasFR == true & Tiedf.InLesion == true , : )    ) ;
stats = addOneMeanShape(stats,'withFRipple_inLesion',ied, iedsems);

[ied, iedsems] =  getIEDmeansems(    TsubRes( TsubRes.Role == 'TREAT' , :)    ,   Tiedf( Tiedf.HasR == true & Tiedf.InLesion == false , : )    ) ;
stats = addOneMeanShape(stats,'withRipple_outLesion',ied, iedsems);

[ied, iedsems] =  getIEDmeansems(    TsubRes( TsubRes.Role == 'TREAT' , :)    ,   Tiedf( Tiedf.HasFR == true & Tiedf.InLesion == false , : )    ) ;
stats = addOneMeanShape(stats,'withFRipple_outLesion',ied, iedsems);

    function stats = addOneMeanShape(stats,name,ied, iedsems)
        disp('adding mean IED with SEM')
        stats.meanIEDshapes.(name).ied = ied;
        stats.meanIEDshapes.(name).iedsems = iedsems;
    end

end



function TsubRes = perSubjectResFast(TsubRes,Tiedf,VKJeeg)

meanfun = @mean;

subjects = TsubRes.Subject; 
Nsubj = numel(subjects);
for ir = 1:Nsubj
    subject = subjects(ir);
   
    %     % Features 
    TsubRes.IEDskew( TsubRes.Subject == subject) = meanfun(  Tiedf.IEDskew(Tiedf.Subject == subject )   );  % & Tiedf.Role == 'CTRL' )
    TsubRes.IEDampl_mV( TsubRes.Subject == subject) = meanfun(  Tiedf.IEDampl_mV(Tiedf.Subject == subject )  ); 
    TsubRes.IEDwidth_msec( TsubRes.Subject == subject) = meanfun(  Tiedf.IEDwidth_msec(Tiedf.Subject == subject )  ); 
    TsubRes.Rfreq( TsubRes.Subject == subject) = meanfun(  Tiedf.Rfreq(Tiedf.Subject == subject & Tiedf.HasR==true )  ); 
    TsubRes.FRfreq( TsubRes.Subject == subject) = meanfun(  Tiedf.FRfreq(Tiedf.Subject == subject  & Tiedf.HasFR==true  )  ); 
    TsubRes.Rlength_ms( TsubRes.Subject == subject) = meanfun(  Tiedf.Rlength_ms(Tiedf.Subject == subject & Tiedf.HasR==true )  ); 
    TsubRes.FRlength_ms( TsubRes.Subject == subject) = meanfun(  Tiedf.FRlength_ms(Tiedf.Subject == subject  & Tiedf.HasFR==true  )  ); 
    
    TsubRes.Rpwr( TsubRes.Subject == subject) = meanfun(  Tiedf.Rpwr(Tiedf.Subject == subject & Tiedf.HasR==true )  ); 
    TsubRes.FRpwr( TsubRes.Subject == subject) = meanfun(  Tiedf.FRpwr(Tiedf.Subject == subject & Tiedf.HasFR==true )  ); 

    Nieds =  numel(find(Tiedf.Subject == subject)); 
    NRs =  numel(find(Tiedf.Subject == subject  & Tiedf.HasR==true));  
    NFRswithRs =  numel(find(Tiedf.Subject == subject  & Tiedf.HasFR==true & Tiedf.HasR==true)); 
    TsubRes.Nieds( TsubRes.Subject == subject) = Nieds;
    TsubRes.NRs( TsubRes.Subject == subject) = NRs;
    TsubRes.NFRs( TsubRes.Subject == subject) = numel(find(Tiedf.Subject == subject  & Tiedf.HasFR==true));  
    TsubRes.NFRswithRs( TsubRes.Subject == subject) = NFRswithRs;
    TsubRes.NHFOs( TsubRes.Subject == subject ) = numel(find(Tiedf.Subject == subject & (Tiedf.HasR == true | Tiedf.HasFR == true) ) );

    TsubRes.RinIEDs_percent( TsubRes.Subject == subject) = (   100*NRs/Nieds   );
    TsubRes.FRinRFRs_percent( TsubRes.Subject == subject) = (   100*NFRswithRs/NRs   );

    NHFOs =  numel(find(Tiedf.Subject == subject  & (Tiedf.HasR==true | Tiedf.HasFR==true)    ));  
    TsubRes.NHFOs( TsubRes.Subject == subject) = NHFOs;
    TsubRes.HFOsInIEDs_percent( TsubRes.Subject == subject) = (   100*NHFOs/Nieds   );
 

    % rates
    dataLength_Min = sum( VKJeeg.DurationMin( VKJeeg.Subject == subject )  ); 
    
    Nelectrodes = numel(unique( Tiedf(Tiedf.Subject == subject ,: ).ChName ) );
    % IED
    N = numel( find(Tiedf.Subject == subject  )  ) / Nelectrodes;
    TsubRes.rateIED_min( TsubRes.Subject == subject ) = N/dataLength_Min;
    
    % HFO R
    N = numel( find(Tiedf.Subject == subject & Tiedf.HasR==true )  ) / Nelectrodes;
    TsubRes.rateR_min( TsubRes.Subject == subject ) = N/dataLength_Min;
    
    % HFO FR
    N = numel( find(Tiedf.Subject == subject & Tiedf.HasFR==true  )  ) / Nelectrodes;
    TsubRes.rateFR_min( TsubRes.Subject == subject ) = N/dataLength_Min;

    % HFO R or FR / general HFO
    N = numel( find(Tiedf.Subject == subject & (Tiedf.HasR==true | Tiedf.HasFR==true)  )  ) / Nelectrodes;
    TsubRes.rateHFO_min( TsubRes.Subject == subject ) = N/dataLength_Min;

    TsubRes.RtoIEDrateShare( TsubRes.Subject == subject) = 100 * TsubRes.rateR_min( TsubRes.Subject == subject ) / TsubRes.rateIED_min( TsubRes.Subject == subject );
    TsubRes.FRtoIEDrateShare( TsubRes.Subject == subject) = 100 * TsubRes.rateFR_min( TsubRes.Subject == subject ) / TsubRes.rateIED_min( TsubRes.Subject == subject );
    TsubRes.HFOtoIEDrateShare( TsubRes.Subject == subject) = 100 * TsubRes.rateHFO_min( TsubRes.Subject == subject ) / TsubRes.rateIED_min( TsubRes.Subject == subject );


    % Oscillation peaks
    % average  R oscilaltion peaks for each subject
    p = double( cell2mat( Tiedf.RpeaksInd( Tiedf.Subject == subject & Tiedf.HasR  )  ) );
    p = sum(p,1);
    if ~isempty(p)
        TsubRes.RpeaksCount{ TsubRes.Subject == subject } = p;
    end
% 
%   % average  FR oscilaltion peaks for each subject
    p = double( cell2mat( Tiedf.FRpeaksInd( Tiedf.Subject == subject & Tiedf.HasFR  )  ) );
    p = sum(p,1);
    if ~isempty(p)
        TsubRes.FRpeaksCount{ TsubRes.Subject == subject } = p;
    end

    % peaksPositions
    fs = 5000;  

    TsubRes.RpeaksPositions_detectionLevel_ms{ TsubRes.Subject == subject } = hist2bins( TsubRes.RpeaksCount{ TsubRes.Subject == subject } ) / fs;
    TsubRes.FRpeaksPositions_detectionLevel_ms{ TsubRes.Subject == subject } = hist2bins( TsubRes.FRpeaksCount{ TsubRes.Subject == subject } ) / fs;

    TsubRes.RpeaksPositions_mean_ms(TsubRes.Subject == subject) =  mean( TsubRes.RpeaksPositions_detectionLevel_ms{ TsubRes.Subject == subject } );
    TsubRes.FRpeaksPositions_mean_ms(TsubRes.Subject == subject) =  mean( TsubRes.FRpeaksPositions_detectionLevel_ms{ TsubRes.Subject == subject } );

    p = TsubRes.RpeaksPositions_detectionLevel_ms{ TsubRes.Subject == subject };
        percBefore = 100*numel(find(p<0.5))/numel(p);
        TsubRes.RpeaksPercentBeforeIed{ TsubRes.Subject == subject } = percBefore;
        TsubRes.RpeaksPercentAfterIed{ TsubRes.Subject == subject } = 100-percBefore;

    p = TsubRes.FRpeaksPositions_detectionLevel_ms{ TsubRes.Subject == subject };
        percBefore = 100*numel(find(p<0.5))/numel(p);
        TsubRes.FRpeaksPercentBeforeIed{ TsubRes.Subject == subject } = percBefore;
        TsubRes.FRpeaksPercentAfterIed{ TsubRes.Subject == subject } = 100-percBefore;


end
end


function TsubRes = perSubjectRes(Tsub, Tiedf, VKJeeg, modifier)

TsubRes = Tsub;

TsubRes = perSubjectResFast(TsubRes, Tiedf, VKJeeg);
TsubRes = perSubjectResSlow(TsubRes, Tiedf,modifier);

end



function TsubRes = perSubjectResSlow(TsubRes,Tiedf,modifier)

subjects = TsubRes.Subject; %(TsubRes.Role =='CTRL');
Nsubj = numel(subjects);
for ir = 1:Nsubj %[Nsubj:-1:1]
    subject = subjects(ir);

     % signals from one subject
    x =  loadfun( plt.loadSignalIED, Tiedf.Signal( Tiedf.Subject == subject )  );

    % means
    xmed = median(x,2); % mean IED

    TsubRes.IEDmed( TsubRes.Subject == subject) = mean(xmed);
    xc = x - xmed; % centered x

    % Pwelch  
    nff = 5000; fs = 5000;
    if ~isempty(xc)
        [pxxwelch,fwelch] = pwelch( reshape(xc',[],1) , ones(nff,1), [], nff, fs) ; % , 'ConfidenceLevel',0.95);
        % 50 Hz correction for certain mice
        if strcmp(char(subject),'Naty602') % only for this animal
            char(subject)
%             pxxwelch = pxxwelch';
%             fwelch = fwelch';
            pxxwelch = 10*log10(pxxwelch);

            psdDB_L = thresholdbyslopestd(pxxwelch,50,8,1.8);
            pxxwelch(psdDB_L) = NaN;
            
            pxxwelch(1:6) = pxxwelch(7);
            pxxwelch = fillgapsbylpc(pxxwelch,5);

            pxxwelch=10.^(pxxwelch/10);
            TsubRes.IEDpwelch( TsubRes.Subject == subject)  = {pxxwelch'};
            TsubRes.IEDfwelch( TsubRes.Subject == subject)  = {fwelch'};    

        else
        TsubRes.IEDpwelch( TsubRes.Subject == subject)  = {pxxwelch'};
        TsubRes.IEDfwelch( TsubRes.Subject == subject)  = {fwelch'};
        end
        
    end
    
%     % average IED
%     %x = double( cell2mat( Tiedf.Signal( Tiedf.Subject == subject  )  ) );
%     x = readvar( Files = Tiedf.Signal( Tiedf.Subject == subject ) , ReadFun = @(x)loadbin(x, [1,5000] , 'double' ), CatDim = 1 )  ;
%     x =  meanfun( x - meanfun(x,2) , 1 ) ;
    TsubRes.meanIED{ TsubRes.Subject == subject } = mean(x,1);

    a.verboser.sprintf2('ProgressPerc',round(100*ir/Nsubj),'Computing per subject');
end



     
end








function TsubRes = perSubject_compute_independantVsSource(TsubRes,Tiedf)

subjects = TsubRes.Subject; %(TsubRes.Role =='CTRL');
Nsubj = numel(subjects);
for ir = 1:Nsubj %[Nsubj:-1:1]
    subject = subjects(ir);
    % compute independant oscillations vs source ones if only TsubRes is submitted ( no lesion inlesions )
    TiedfOne = Tiedf(Tiedf.Subject == subject & Tiedf.HasFR,:); 
    [percIn, Ntotal] =compute_independantVsSource_OneMouse(  TiedfOne, subject ); 
    frperc_indep = 100-percIn;
    rperc_indep = NaN;

    %save results to TsubRes
           TsubRes.FRpercentOfIndep( TsubRes.Subject == subject ) = frperc_indep;
           TsubRes.FRpercentOfIndep_Ntotal( TsubRes.Subject == subject ) = Ntotal;

%      Nmin = 10;
%         if Ntotal<Nmin  % if less than min. number for meaningfull statistic
%            TsubRes.FRpercentOfIndep( TsubRes.Subject == subject ) = NaN;
%            TsubRes.RpercentOfIndep( TsubRes.Subject == subject ) = NaN;
%         else
%            TsubRes.FRpercentOfIndep( TsubRes.Subject == subject ) = frperc_indep;
%            TsubRes.FRpercentOfIndep_Ntotal( TsubRes.Subject == subject ) = Ntotal;
% 
%            TsubRes.RpercentOfIndep( TsubRes.Subject == subject ) = rperc_indep;
%         end

end
end


function [percIn,Nt] = compute_independantVsSource_OneMouse(  TiedfOne, subject ) % TsubRes = 
percIn = NaN;
Nt = NaN;
Nmin = 20; % minimum detections to consider

% subject
Ndets = size(TiedfOne,1);

if Ndets>Nmin    
   TiedfOne = sortrows(TiedfOne,'StartDn');
    
    if Ndets>Nmin
        clusterSizeMinDn = sec2dn(1/1000);
        clusterSizeMaxDn = sec2dn(20/1000);
        %clusterSpacingDn = sec2dn(40/1000);
        
        % clusterEndInd=1; 
        % clusterStartInd=1;
        % clusterStartsWith_InLesionState = [];
        % 
        % time_offsetDn = TiedfOne.StartDn(1);
        
        %figurefull; 
        % sDn = 0; eDn = 0;
        last_startDn = 0;
        clusterID = 0;
        for i = 1:Ndets
          %  x =  loadfun( plt.loadSignalIED, TiedfOne.Signal( TiedfOne.ID == TiedfOne.ID(i) )  );
            signalEnlargeEachSide_sec = 0.5;
            rangeDn = [TiedfOne.StartDn(i)-sec2dn(signalEnlargeEachSide_sec)         TiedfOne.StartDn(i)+sec2dn(signalEnlargeEachSide_sec)   ];
        
        
            if ( rangeDn(1) >= last_startDn+clusterSizeMinDn ) & ( rangeDn(1) <= last_startDn+clusterSizeMaxDn )
        
                if inlesion_state ~= TiedfOne.InLesion(i) % non empty cluster then save it
        
                   if inlesion_state
                       %cluster_dir = 'Lesion2Out';
                       TiedfOne.FRcluster_Lesion2Out( TiedfOne.ID==clusterID ) = 1;
                   else
                       %cluster_dir = 'Out2Lesion';
                       TiedfOne.FRcluster_Out2Lesion( TiedfOne.ID==clusterID ) = 1;
                   end
                   % write to Tiedf
                   %Tiedf.FRclusterLength_ms( Tiedf.ID==clusterID ) = 0;
                   %Tiedf.FRclusterDir( Tiedf.ID==clusterID ) = cluster_dir; 
                end
        
        %         % plotting
        %         hold on;
        %         plot(    linspace( rangeDn(1) , rangeDn(2),  5000)   , x   );
        
            else % a new cluster
                 inlesion_state = TiedfOne.InLesion(i);
                 clusterID = TiedfOne.ID(i);
        
        %          % plot
        %          hold off;
        %          plot(    linspace( rangeDn(1) , rangeDn(2),  5000)   , x   );
        
            end  
            last_startDn = rangeDn(1);   
        %pause
        end
        
        % finished on mouse
        Nl=0;
        No=0;
        if ismember('FRcluster_Lesion2Out', TiedfOne.Properties.VariableNames)
            Nl = numel(find(TiedfOne.FRcluster_Lesion2Out));
        end
         if ismember('FRcluster_Out2Lesion', TiedfOne.Properties.VariableNames)
            No = numel(find(TiedfOne.FRcluster_Out2Lesion));
         end
        
        Nt=Nl+No;
        if Nt >0
            percIn = 100*Nl/Nt;
        end
        
        
            
        
        
   end 
end

end