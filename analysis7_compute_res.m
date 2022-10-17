

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

% delete the bilateral animals
iBilateral =  ismember( TsubRes_inout.Subject, { 'Naty338' , 'TryskoMys' } );
TsubRes_inout( iBilateral, : ) = [];

save7fp = a.pwd('TsubRes_inout.mat'); save7

% Compute features
[ Tplt_CtrlVsTreat , Tplt_OutVsIn ] =  getTablePvals(TsubRes,TsubRes_inout( TsubRes_inout.Role == 'TREAT' , : ) );

Tplt_CtrlVsTreat = rownames2var( Tplt_CtrlVsTreat , 'Features' );
Tplt_OutVsIn = rownames2var( Tplt_OutVsIn , 'Features' );

save7fp = a.pwd('Tplt_CtrlVsTreat.mat'); save7
save7fp = a.pwd('Tplt_OutVsIn.mat'); save7

writetable( Tplt_CtrlVsTreat , a.pwd('Tplt_CtrlVsTreat.xlsx') );
writetable( Tplt_OutVsIn , a.pwd('Tplt_OutVsIn.xlsx') );


%%
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

    TsubRes.RinIEDs( TsubRes.Subject == subject) = round(   100*NRs/Nieds   );
    TsubRes.FRinRFRs( TsubRes.Subject == subject) = round(   100*NFRswithRs/NRs   );

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
for ir = 1:Nsubj
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
        TsubRes.IEDpwelch( TsubRes.Subject == subject)  = {pxxwelch'};
        TsubRes.IEDfwelch( TsubRes.Subject == subject)  = {fwelch'};
    end
    
%     % average IED
%     %x = double( cell2mat( Tiedf.Signal( Tiedf.Subject == subject  )  ) );
%     x = readvar( Files = Tiedf.Signal( Tiedf.Subject == subject ) , ReadFun = @(x)loadbin(x, [1,5000] , 'double' ), CatDim = 1 )  ;
%     x =  meanfun( x - meanfun(x,2) , 1 ) ;
     TsubRes.meanIED{ TsubRes.Subject == subject } = mean(x,1);

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

     a.verboser.sprintf2('ProgressPerc',round(100*ir/Nsubj),'Computing per subject');
end

end