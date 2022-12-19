function [ied, iedsems ] =  getIEDmeansems(TsubRes,Tiedf)
% This function is usefull as well because the meanIEDs in TsubRes are computed from all IEDs. 
% This function allows more refined grouping according to modified Tiedf
% it computes also sems

subjects = TsubRes.Subject; % treatments
Nsubj = numel(subjects);

if ~isempty(Tiedf.Signal)
    Ns = numel( loadfun( plt.loadSignalIED, Tiedf.Signal( 1 )  ) ); 
    
    ied=NaN(Nsubj,5000); iedsems=NaN(Nsubj,Ns);
    %ied2=NaN(Nsubj,5000);
    for ir = 1:Nsubj
        subject = subjects(ir);
    
        x =  loadfun( plt.loadSignalIED, Tiedf.Signal( Tiedf.Subject == subject )  );% signals from one subject
        if ~isempty(x)
            ied(ir,:) = nanmean(x,1); 
            iedsems(ir,:) = nansem(x);
        end
    end
    ied = nanmean(ied,1);
    iedsems = nanmean(iedsems,1);
else
    ied = NaN;
    iedsems = NaN;
end

end