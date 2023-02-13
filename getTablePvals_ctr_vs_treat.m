function [ Tplt_CtrlVsTreat ] =  getTablePvals_ctr_vs_treat(TsubRes, featuresC)
% this computes p values to the plosts
% it expects a single value per animal and compares the datapoints (animals) betweeen
% control and  treatment animals

Nf = numel(featuresC);
Tplt_CtrlVsTreat = table;

for i = 1:Nf
    feature = featuresC{i};

    if contains(feature, TsubRes.Properties.VariableNames)
        Tplt_CtrlVsTreat = updateT(Tplt_CtrlVsTreat,TsubRes,feature, 'CTRL');
        Tplt_CtrlVsTreat = updateT(Tplt_CtrlVsTreat,TsubRes,feature, 'TREAT');
    
        %[x,y] = tablegroups2num(Tplot(:,{feature,'Role'}),'Role');
        p = NaN;
        Tin = Tplt_CtrlVsTreat;
        if (   any(~isnan( Tin{feature,'CTRL_data'}{:} )) && any(~isnan( Tin{feature,'TREAT_data'}{:}  ))    )
                p = ranksum( Tin{feature,'CTRL_data'}{:} , Tin{feature,'TREAT_data'}{:} ) ;  %sp = 0.01;  % plt.Tst_CtrVsTreat{ feature , 'p' }
        end
        Tplt_CtrlVsTreat{ feature , 'p' } = p;
    else
        disp(['skipping ' feature ' because the table does contain the column']);
    end

end


function Tplt_CtrlVsTreat = updateT(Tplt_CtrlVsTreat,TsubRes,feature, role)

        data = TsubRes.(feature)( TsubRes.Role == role);
        mmed = nanmedian(data);
        m = nanmean( data );
        s = nansem( data );
        txt_ms = printmeansem(  m  , s );
        %txt_mmeds = printmeansem(  mmed  , s );
    
        Tplt_CtrlVsTreat{ feature , [ role '_median' ]} = mmed;
        Tplt_CtrlVsTreat{ feature , [ role '_mean' ]} = m;
        Tplt_CtrlVsTreat{ feature , [ role '_sem' ]} = s;
        Tplt_CtrlVsTreat( feature , [ role '_asText' ] ) = { txt_ms };
        Tplt_CtrlVsTreat( feature , [ role '_data' ] ) = {data};
        Tplt_CtrlVsTreat( feature , [ role '_asTextPaper' ] ) = { printmeansemmedian_HFOpaper(data) }; % mean +- sem (median) zaokrouhleno
end



end
