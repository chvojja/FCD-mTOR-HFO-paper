

%% Per subject results

% inputs
% Tiedf - filtered by labelName
% Tsub

subjects = Tsub.Subject; %(Tsub.Role =='CTRL');
for i = 1:numel(subjects)
    subject = subjects(i);
    
    Tsub.IEDskew_mean( Tsub.Subject == subject) = mean(  Tiedf.IEDskew(Tiedf.Subject == subject )   );  % & Tiedf.Role == 'CTRL' )
    Tsub.IEDampl_mV( Tsub.Subject == subject) = mean(  Tiedf.IEDampl_mV(Tiedf.Subject == subject )  ); 
    Tsub.IEDwidth_sec( Tsub.Subject == subject) = mean(  Tiedf.IEDwidth_sec(Tiedf.Subject == subject )  ); 
    Tsub.Rfreq( Tsub.Subject == subject) = mean(  Tiedf.Rfreq(Tiedf.Subject == subject & Tiedf.HasR==true )  ); 
    Tsub.FRfreq( Tsub.Subject == subject) = mean(  Tiedf.FRfreq(Tiedf.Subject == subject  & Tiedf.HasFR==true  )  ); 

    % rates
    dataLength = 1*Tdati.Files( Tdati.Subject == subject );

    Nieds = numel( find(Tiedf.Subject == subject  )  );
    Tsub.rateIED_min( Tsub.Subject == subject ) = k*Nieds/dataLength;

    NR = numel( find(Tiedf.Subject == subject & Tiedf.HasR==true )  );
    Tsub.rateR_min( Tsub.Subject == subject ) = k*NR/dataLength;

    NFR = numel( find(Tiedf.Subject == subject & Tiedf.HasFR==true  )  );
    Tsub.rateFR_min( Tsub.Subject == subject ) = k*NFR/dataLength;

    % average IED and oscilaltion peaks for each subject
    x = double( cell2mat( Tiedf.Signal( Tiedf.Subject == subject  )  ) );
    x =  mean( x - mean(x,2) , 1 ) ;
    Tsub.meanIED{ Tsub.Subject == subject } = x;


    % average  R oscilaltion peaks for each subject
    x = double( cell2mat( Tiedf.PeaksInd( Tiedf.Subject == subject & Tiedf.HasR & ~Tiedf.HasFR  )  ) );
    x = sum(x);
    if ~isempty(x)
        Tsub.RpeaksCount{ Tsub.Subject == subject } = x;
    end

end