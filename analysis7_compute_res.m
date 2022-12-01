
warning off;

%% Per subject results

% inputs
% TiedfRes - filtered by labelName
% Tsub

% TsubRes = Tsub;
% TiedfRes = Tiedf;

% compute new with filtered and unfiltered table
TsubRes = perSubjectRes(Tsub,Tiedf, VKJeeg);
% TsubRes_temp = table2missing(TsubRes_inlesion);
TsubRes_temp = table2missing(TsubRes);
TsubRes_temp = updatecols(Tsub,TsubRes_temp );

TsubRes_inlesion = perSubjectRes(TsubRes_temp, Tiedf( Tiedf.InLesion == true , :) , VKJeeg);
TsubRes_outlesion = perSubjectRes(TsubRes_temp, Tiedf( Tiedf.InLesion == false , :) , VKJeeg);

% correct for mistakes
% TsubRes = perSubjectRes(TsubRes,Tiedf, Tdati);
% TsubRes_inlesion = perSubjectRes(TsubRes_inlesion, Tiedf( Tiedf.InLesion == true , :) , Tdati);
% TsubRes_outlesion = perSubjectRes(TsubRes_outlesion, Tiedf( Tiedf.InLesion == false , :) , Tdati);

% TsubRes.InLesion
TsubRes_inlesion.InLesion=true(size(TsubRes_inlesion,1),1);
TsubRes_outlesion.InLesion=false(size(TsubRes_outlesion,1),1);
save7fp = a.pwd('TsubRes.mat'); save7
%save7fp = a.pwd('TsubRes_inlesion.mat'); save7
%save7fp = a.pwd('TsubRes_outlesion.mat'); save7

TsubRes_inout = [TsubRes_inlesion ; TsubRes_outlesion];
TsubRes_inout.ID = [1:size(TsubRes_inout,1)]';

% % delete the bilateral animals
% iBilateral =  ismember( TsubRes_inout.Subject, { 'Naty338' , 'TryskoMys' } );
% TsubRes_inout( iBilateral, : ) = [];

save7fp = a.pwd('TsubRes_inout.mat'); save7

% Compute features
featuresC = {'IEDskew','IEDampl_mV','IEDwidth_msec','IEDmed','Rfreq','FRfreq','Rlength_ms','FRlength_ms',...
             'Rpwr','RinIEDs','FRinRFRs','RtoIEDrateShare', 'FRtoIEDrateShare', 'rateIED_min','rateR_min','rateFR_min'};
[ Tplt_CtrlVsTreat] =  getTablePvals_ctr_vs_treat(TsubRes , featuresC );



featuresC = {'IEDskew','IEDampl_mV','IEDwidth_msec','IEDmed','Rfreq','FRfreq','Rlength_ms','FRlength_ms',...
             'Rpwr','RinIEDs','FRinRFRs','RtoIEDrateShare', 'FRtoIEDrateShare', 'rateIED_min','rateR_min','rateFR_min',...
             'FRpeaksPositions_detectionLevel_ms','FRpeaksPositions_mean_ms', 'RpeaksPositions_detectionLevel_ms','RpeaksPositions_mean_ms' };
%             'Rpwr','RinIEDs','FRinRFRs','RtoIEDrateShare', 'FRtoIEDrateShare', 'rateIED_min','rateR_min','rateFR_min','meanPeakPos_bunched_together'}; ''
%featuresC = {'FRpeaksPositions_detectionLevel_ms','FRpeaksPositions_mean_ms'};
[ Tplt_OutVsIn ] =  getTablePvals_in_vs_out(TsubRes_inout( TsubRes_inout.Role == 'TREAT' , : ) , featuresC );


Tplt_CtrlVsTreat = rownames2var( Tplt_CtrlVsTreat , 'Features' );
Tplt_OutVsIn = rownames2var( Tplt_OutVsIn , 'Features' );

save7fp = a.pwd('Tplt_CtrlVsTreat.mat'); save7
save7fp = a.pwd('Tplt_OutVsIn.mat'); save7

writetable( Tplt_CtrlVsTreat , a.pwd('Tplt_CtrlVsTreat.xlsx') );
writetable( Tplt_OutVsIn , a.pwd('Tplt_OutVsIn.xlsx') );


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

overallAvg_numberOfIedsPerElectrode = (numel(find((Tiedf.Role == 'TREAT' & Tiedf.LabelName == IEDlabelName)))/5 );
stats.overallEEGRawTimeMins = sum(  TsubRes.TimeRawMinsExact(TsubRes.Role == 'TREAT')  );
%overall_IEDrate_perMin = overallAvg_numberOfIedsPerElectrode / overallEEGRawTimeMins;  
treat_logi = TsubRes.Role == 'TREAT';
stats.overall_IEDs_Nevents  = numel(find((Tiedf.Role == 'TREAT' & Tiedf.LabelName == IEDlabelName) ));

stats.totalHFOevents_seizing_and_nonseizing =  sum(TsubRes.NHFOs(TsubRes.Role == "TREAT"));

% Test histograms

% KS test
% In Tplt_OutVsIn FRpeaksPosition row we have the raw HFO peaks positions
positions_inC = Tplt_OutVsIn{ 'FRpeaksPositions_detectionLevel_ms', 'In_data'}; 
positions_outC = Tplt_OutVsIn{ 'FRpeaksPositions_detectionLevel_ms', 'Out_data'}; 
% test HFO histograms 
if ~isempty(positions_inC{:}) && ~isempty(positions_outC{:})
    [h,p] = kstest2( positions_inC{:} , positions_outC{:} ,'Alpha',0.05);
else
    h = NaN; p = NaN;
end
stats.FRpeaksPositions_distribution_diffferent = h;
stats.FRpeaksPositions_distribution_diffferent_p = p;


positions_inC = Tplt_OutVsIn{ 'RpeaksPositions_detectionLevel_ms', 'In_data'}; 
positions_outC = Tplt_OutVsIn{ 'RpeaksPositions_detectionLevel_ms', 'Out_data'}; 
% test HFO histograms 
if ~isempty(positions_inC{:}) && ~isempty(positions_outC{:})
    [h,p] = kstest2( positions_inC{:} , positions_outC{:} ,'Alpha',0.05);
else
    h = NaN; p = NaN;
end
stats.RpeaksPositions_distribution_diffferent = h;
stats.RpeaksPositions_distribution_diffferent_p = p;

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



save7fp = a.pwd('stats.mat'); save7


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
%     % average  FR oscilaltion peaks for each subject
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
    

end
end


function TsubRes = perSubjectRes(Tsub, Tiedf, VKJeeg)

TsubRes = Tsub;

TsubRes = perSubjectResFast(TsubRes, Tiedf, VKJeeg);
TsubRes = perSubjectResSlow(TsubRes, Tiedf);

end


function TsubRes = perSubjectResSlow(TsubRes,Tiedf)

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