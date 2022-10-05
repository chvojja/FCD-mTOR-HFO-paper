

%% Per subject results

% inputs
% TiedfRes - filtered by labelName
% Tsub

% TsubRes = Tsub;
% TiedfRes = Tiedf;

% compute new
% TsubRes = perSubjectRes(Tsub,Tiedf, Tdati);
% TsubRes_inlesion = perSubjectRes(Tsub, Tiedf( Tiedf.InLesion == true , :) , Tdati);
% TsubRes_outlesion = perSubjectRes(Tsub, Tiedf( Tiedf.InLesion == false , :) , Tdati);
% 
% correct for mistakes
TsubRes = perSubjectRes(TsubRes,Tiedf, Tdati);
TsubRes_inlesion = perSubjectRes(TsubRes_inlesion, Tiedf( Tiedf.InLesion == true , :) , Tdati);
TsubRes_outlesion = perSubjectRes(TsubRes_outlesion, Tiedf( Tiedf.InLesion == false , :) , Tdati);


% TsubRes.InLesion
TsubRes_inlesion.InLesion=true(size(TsubRes_inlesion,1),1);
TsubRes_outlesion.InLesion=false(size(TsubRes_outlesion,1),1);
 save7fp = a.pwd('TsubRes.mat'); save7
% save7fp = a.pwd('TsubRes_inlesion.mat'); save7
% save7fp = a.pwd('TsubRes_outlesion.mat'); save7

TsubRes_inout = [TsubRes_inlesion ; TsubRes_outlesion];
TsubRes_inout.ID = [1:size(TsubRes_inout,1)]';

 %save7fp = a.pwd('TsubRes_inout.mat'); save7
%%
TsubRes = perSubjectResFast(TsubRes,Tiedf);

function TsubRes = perSubjectResFast(TsubRes,Tiedf)

Nripples_total = numel(find(Tiedf.HasR==true));

subjects = TsubRes.Subject; %(TsubRes.Role =='CTRL');
Nsubj = numel(subjects);
for ir = 1:Nsubj
    subject = subjects(ir);
    TiedfSub =  Tiedf( Tiedf.Subject == subject , :) ;
    %
    TsubRes.TotalRipples(ir) = numel(find(TiedfSub.HasR==true));
    TsubRes.TotalFastRipples(ir) = numel(find(TiedfSub.HasFR==true));
    TsubRes.TotalIeds(ir) = size(TiedfSub,1);

end
end




function TsubRes = perSubjectRes(Tsub,Tiedf, Tdati)
TsubRes = Tsub;
subjects = Tsub.Subject; %(TsubRes.Role =='CTRL');
Nsubj = numel(subjects);
for ir = 1:Nsubj
    subject = subjects(ir);

%     % Pwelch
%     x = readvar( Files = Tiedf.Signal( Tiedf.Subject == subject ) , ReadFun = @(x)loadbin(x, [1,5000] , 'double' ), CatDim = 1 )  ;
%     nff = 5000; fs = 5000;
%     [pxxwelch,fwelch] = pwelch(x,ones(nff,1), [], nff, fs) ; % , 'ConfidenceLevel',0.95);
%     TsubRes.IEDpwelch( Tsub.Subject == subject)  = {pxxwelch'};
%     TsubRes.IEDfwelch( Tsub.Subject == subject)  = {fwelch'};
    
%     % Features 
    TsubRes.IEDskew_mean( Tsub.Subject == subject) = mean(  Tiedf.IEDskew(Tiedf.Subject == subject )   );  % & Tiedf.Role == 'CTRL' )
    TsubRes.IEDampl_mV( Tsub.Subject == subject) = mean(  Tiedf.IEDampl_mV(Tiedf.Subject == subject )  ); 
    TsubRes.IEDwidth_sec( Tsub.Subject == subject) = mean(  Tiedf.IEDwidth_sec(Tiedf.Subject == subject )  ); 
    TsubRes.Rfreq( Tsub.Subject == subject) = mean(  Tiedf.Rfreq(Tiedf.Subject == subject & Tiedf.HasR==true )  ); 
    TsubRes.FRfreq( Tsub.Subject == subject) = mean(  Tiedf.FRfreq(Tiedf.Subject == subject  & Tiedf.HasFR==true  )  ); 
    TsubRes.Rlength_ms( Tsub.Subject == subject) = mean(  Tiedf.Rlength_ms(Tiedf.Subject == subject & Tiedf.HasR==true )  ); 
    TsubRes.FRlength_ms( Tsub.Subject == subject) = mean(  Tiedf.FRlength_ms(Tiedf.Subject == subject  & Tiedf.HasFR==true  )  ); 
    
    TsubRes.Rpwr( Tsub.Subject == subject) = mean(  Tiedf.Rpwr(Tiedf.Subject == subject & Tiedf.HasR==true )  ); 

    Nieds =  numel(find(Tiedf.Subject == subject)); 
    NRs =  numel(find(Tiedf.Subject == subject  & Tiedf.HasR==true));  
    NFRswithRs =  numel(find(Tiedf.Subject == subject  & Tiedf.HasFR==true & Tiedf.HasR==true)); 

    TsubRes.RinIEDs( Tsub.Subject == subject) = round(   100*NRs/Nieds   );
    TsubRes.FRinRFRs( Tsub.Subject == subject) = round(   100*NFRswithRs/NRs   );

    % rates
    dataLength = 1*Tdati.Files( Tdati.Subject == subject );
    k = 4;
    
    Nelectrodes = numel(unique( Tiedf(Tiedf.Subject == subject ,: ).ChName ) );
    % IED
    Nieds = numel( find(Tiedf.Subject == subject  )  ) / Nelectrodes;
    TsubRes.rateIED_min( Tsub.Subject == subject ) = k*Nieds/dataLength;
    
    % HFO R
    NR = numel( find(Tiedf.Subject == subject & Tiedf.HasR==true )  ) / Nelectrodes;
    TsubRes.rateR_min( Tsub.Subject == subject ) = k*NR/dataLength;
    
    % HFO FR
    NFR = numel( find(Tiedf.Subject == subject & Tiedf.HasFR==true  )  ) / Nelectrodes;
    TsubRes.rateFR_min( Tsub.Subject == subject ) = k*NFR/dataLength;

%     % average IED and oscilaltion peaks for each subject
%     %x = double( cell2mat( Tiedf.Signal( Tiedf.Subject == subject  )  ) );
%     x = readvar( Files = Tiedf.Signal( Tiedf.Subject == subject ) , ReadFun = @(x)loadbin(x, [1,5000] , 'double' ), CatDim = 1 )  ;
%     x =  mean( x - mean(x,2) , 1 ) ;
%     TsubRes.meanIED{ Tsub.Subject == subject } = x;
% 
% 
%     % average  R oscilaltion peaks for each subject
%     x = double( cell2mat( Tiedf.RpeaksInd( Tiedf.Subject == subject & Tiedf.HasR  )  ) );
%     x = sum(x,1);
%     if ~isempty(x)
%         TsubRes.RpeaksCount{ Tsub.Subject == subject } = x;
%     end
% 
%     % average  FR oscilaltion peaks for each subject
%     x = double( cell2mat( Tiedf.FRpeaksInd( Tiedf.Subject == subject & Tiedf.HasFR  )  ) );
%     x = sum(x,1);
%     if ~isempty(x)
%         TsubRes.FRpeaksCount{ Tsub.Subject == subject } = x;
%     end

     a.verboser.sprintf2('ProgressPerc',round(100*ir/Nsubj),'Computing per subject');
end

end