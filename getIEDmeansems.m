function [ied, iedsems ] =  getIEDmeansems(TsubRes,Tiedf)
%

subjects = TsubRes.Subject; % treatments
Nsubj = numel(subjects);

Ns = numel( fevalc(  Tiedf.Signal( 1 )  ) ); 

ied=NaN(Nsubj,5000); iedsems=NaN(Nsubj,Ns);
%ied2=NaN(Nsubj,5000);
for ir = 1:Nsubj
    subject = subjects(ir);
    x = fevalc(  Tiedf.Signal( Tiedf.Subject == subject )   ); % signals from one subject
    if ~isempty(x)
        ied(ir,:) = nanmean(x,1); 
        iedsems(ir,:) = nansem(x);
    end
end
ied = nanmean(ied,1);
iedsems = nanmean(iedsems,1);
end