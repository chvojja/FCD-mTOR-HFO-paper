function [ Tplt_CtrlVsTreat , Tplt_OutVsIn ] =  getTablePvals(TsubRes,TsubRes_inout)
%
featuresC = {'IEDskew','IEDampl_mV','IEDwidth_msec','IEDmed','Rfreq','FRfreq','Rlength_ms','FRlength_ms','Rpwr','RinIEDs','FRinRFRs','rateIED_min','rateR_min','rateFR_min'};
Nf = numel(featuresC);

Tplt_CtrlVsTreat = table;
Tplt_OutVsIn = table;


for i = 1:Nf
    feature = featuresC{i};

    %%
    Tplt_CtrlVsTreat = updateT(Tplt_CtrlVsTreat,TsubRes,feature, 'CTRL');
    Tplt_CtrlVsTreat = updateT(Tplt_CtrlVsTreat,TsubRes,feature, 'TREAT');

    %[x,y] = tablegroups2num(Tplot(:,{feature,'Role'}),'Role');
    p = NaN;
    Tin = Tplt_CtrlVsTreat;
    if (   any(~isnan( Tin{feature,'CTRL_data'}{:} )) && any(~isnan( Tin{feature,'TREAT_data'}{:}  ))    )
            p = ranksum( Tin{feature,'CTRL_data'}{:} , Tin{feature,'TREAT_data'}{:} ) ;  %sp = 0.01;  % plt.Tst_CtrVsTreat{ feature , 'p' }
    end
    Tplt_CtrlVsTreat{ feature , 'p' } = p;
 



    %%
    Tplt_OutVsIn = updateT2(Tplt_OutVsIn,TsubRes_inout,feature,'In');
    Tplt_OutVsIn = updateT2(Tplt_OutVsIn,TsubRes_inout,feature,'Out');

    p = NaN;
    Tin = Tplt_OutVsIn;
    data1 = Tin{feature, [ 'In' '_data' ] }{:};
    data2 = Tin{feature, [ 'Out' '_data' ] }{:};
    if (   any(~isnan( data1 )) && any(~isnan( data2  ))    )
            p = signrank( data1 , data2 ) ;  %sp = 0.01;  % plt.Tst_CtrVsTreat{ feature , 'p' }
    end
    Tplt_OutVsIn{ feature , 'p' } = p;


end


function Tplt_CtrlVsTreat = updateT(Tplt_CtrlVsTreat,TsubRes,feature, role)
    data = TsubRes.(feature)( TsubRes.Role == role);
    m = plt.barsMeanFun( data );
    s = nansem( data );

    Tplt_CtrlVsTreat{ feature , [ role '_mean' ]} = m;
    Tplt_CtrlVsTreat{ feature , [ role '_sem' ]} = s;
    Tplt_CtrlVsTreat( feature , [ role '_asText' ] ) = { printmeansem(  m  , s ) };
    Tplt_CtrlVsTreat( feature , [ role '_data' ] ) = {data};
end



function Tplt_OutVsIn = updateT2(Tplt_OutVsIn,TsubRes_inout,feature, lesionPos)
    lesionPosSet = {'Out','In'}; % the order is important - do not change
    lesionLogi = logical( find(ismember(lesionPosSet, lesionPos  )) -1  );
    data = TsubRes_inout.(feature)( TsubRes_inout.InLesion ==  lesionLogi     );
    m = plt.barsMeanFun( data );
    s = nansem( data );

    Tplt_OutVsIn{ feature , [ lesionPos '_mean' ]} = m;
    Tplt_OutVsIn{ feature , [ lesionPos '_sem' ]} = s;
    Tplt_OutVsIn( feature , [ lesionPos '_asText' ] ) = { printmeansem(  m  , s ) };
    Tplt_OutVsIn( feature , [ lesionPos '_data' ] ) = {data};
end  





end
