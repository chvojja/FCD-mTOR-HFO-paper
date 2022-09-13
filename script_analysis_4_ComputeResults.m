

%% Per subject results

% inputs
% Tiedf - filtered by labelName
% Tsub

subjects = Tsub.Subject; %(Tsub.Role =='CTRL');
for i = 1:numel(subjects)
    subject = subjects(i);

    % Pwelch
    x = double([Tiedf.Signal{  Tiedf.Subject == subject    }]);
    nff = 5000; fs = 5000;
    [pxxwelch,fwelch] = pwelch(x,ones(nff,1), [], nff, fs) ; % , 'ConfidenceLevel',0.95);
    Tsub.IEDpwelch( Tsub.Subject == subject)  = {pxxwelch'};
    Tsub.IEDfwelch( Tsub.Subject == subject)  = {fwelch'};
    
    % Features 
    Tsub.IEDskew_mean( Tsub.Subject == subject) = mean(  Tiedf.IEDskew(Tiedf.Subject == subject )   );  % & Tiedf.Role == 'CTRL' )
    Tsub.IEDampl_mV( Tsub.Subject == subject) = mean(  Tiedf.IEDampl_mV(Tiedf.Subject == subject )  ); 
    Tsub.IEDwidth_sec( Tsub.Subject == subject) = mean(  Tiedf.IEDwidth_sec(Tiedf.Subject == subject )  ); 
    Tsub.Rfreq( Tsub.Subject == subject) = mean(  Tiedf.Rfreq(Tiedf.Subject == subject & Tiedf.HasR==true )  ); 
    Tsub.FRfreq( Tsub.Subject == subject) = mean(  Tiedf.FRfreq(Tiedf.Subject == subject  & Tiedf.HasFR==true  )  ); 

    % rates
    dataLength = 1*Tdati.Files( Tdati.Subject == subject );
    k = 1;
    % IED
    Nieds = numel( find(Tiedf.Subject == subject  )  );
    Tsub.rateIED_min( Tsub.Subject == subject ) = k*Nieds/dataLength;
    
    % HFO R
    NR = numel( find(Tiedf.Subject == subject & Tiedf.HasR==true )  );
    Tsub.rateR_min( Tsub.Subject == subject ) = k*NR/dataLength;
    
    % HFO FR
    NFR = numel( find(Tiedf.Subject == subject & Tiedf.HasFR==true  )  );
    Tsub.rateFR_min( Tsub.Subject == subject ) = k*NFR/dataLength;

    % average IED and oscilaltion peaks for each subject
    x = double( cell2mat( Tiedf.Signal( Tiedf.Subject == subject  )  ) );
    x =  mean( x - mean(x,2) , 1 ) ;
    Tsub.meanIED{ Tsub.Subject == subject } = x;


    % average  R oscilaltion peaks for each subject
    x = double( cell2mat( Tiedf.RpeaksInd( Tiedf.Subject == subject & Tiedf.HasR  )  ) );
    x = sum(x,1);
    if ~isempty(x)
        Tsub.RpeaksCount{ Tsub.Subject == subject } = x;
    end

    % average  FR oscilaltion peaks for each subject
    x = double( cell2mat( Tiedf.FRpeaksInd( Tiedf.Subject == subject & Tiedf.HasFR  )  ) );
    x = sum(x,1);
    if ~isempty(x)
        Tsub.FRpeaksCount{ Tsub.Subject == subject } = x;
    end




end