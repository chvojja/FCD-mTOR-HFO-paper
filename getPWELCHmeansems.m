function [pwelch_mean , pwelch_sems , pwelch_f ] =  getPWELCHmeansems(TsubRes, group)
%

x = double( cell2mat( TsubRes.IEDpwelch(  TsubRes.Role ==  group  )  ) );
if ~isempty(x)

    pwelch_mean = nanmean(x,1); 
    pwelch_sems = nansem(x);
    idxTrue = find(TsubRes.Role ==  group);
    pwelch_f  = TsubRes.IEDfwelch{  idxTrue(1)   };
end

end