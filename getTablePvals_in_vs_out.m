function [ Tplt_OutVsIn ] =  getTablePvals_in_vs_out(TsubRes_inout , featuresC )
% this computes p values to the plosts
% it expects a single value per animal and compares the datapoints (animals) betweeen
% inside and outside the lesion

% also accepts comparision on the level of detections and not only on the subject level!!!!
% see updateT2()


Nf = numel(featuresC);
Tplt_OutVsIn = table;

for i = 1:Nf
    feature = featuresC{i};

    if contains(feature, TsubRes_inout.Properties.VariableNames)
        Tplt_OutVsIn = updateT2(Tplt_OutVsIn,TsubRes_inout,feature,'In');
        Tplt_OutVsIn = updateT2(Tplt_OutVsIn,TsubRes_inout,feature,'Out');
    
        p = NaN;
        Tin = Tplt_OutVsIn;
        data1 = Tin{feature, [ 'In' '_data' ] }{:};
        data2 = Tin{feature, [ 'Out' '_data' ] }{:};
        if (   any(~isnan( data1 )) && any(~isnan( data2  ))    )
            if numel(data1) == numel(data2)
                p = signrank( data1 , data2 ) ;  %sp = 0.01;  % plt.Tst_CtrVsTreat{ feature , 'p' }
            else
                p = ranksum( data1 , data2 ) ;
                %p = NaN;
            end
                
        end
        Tplt_OutVsIn{ feature , 'p' } = p;
    else
        disp(['skipping ' feature ' because the table does contain the column']);
    end

end

% additional features computed differently
% we have treat filtered 



function Tplt_OutVsIn = updateT2(Tplt_OutVsIn,TsubRes_inout,feature, lesionPos)

        lesionPosSet = {'Out','In'}; % the order is important - do not change
        lesionLogi = logical( find(ismember(lesionPosSet, lesionPos  )) -1  );
        data = TsubRes_inout.(feature)( TsubRes_inout.InLesion ==  lesionLogi     );
        if iscell(data) % this accepts also bunched numbers (all numbers from one animal concatenated to all numbers from other animals so number of datapoints is higher than number of animals
            data = cell2mat(data); 
            data = data(:); % we bunch together all numbers
        end
    

        mmed = nanmedian(data);
        m = nanmean( data );
        s = nansem( data );
        txt_ms = printmeansem(  m  , s );
        %txt_mmeds = printmeansem(  mmed  , s );
    
        Tplt_OutVsIn{ feature , [ lesionPos '_median' ]} = mmed;
        Tplt_OutVsIn{ feature , [ lesionPos '_mean' ]} = m;
        Tplt_OutVsIn{ feature , [ lesionPos '_sem' ]} = s;
        Tplt_OutVsIn( feature , [ lesionPos '_asText' ] ) = { txt_ms };
        Tplt_OutVsIn( feature , [ lesionPos '_data' ] ) = {data};
        Tplt_OutVsIn( feature , [ lesionPos '_asTextPaper' ] ) = { printmeansemmedian_HFOpaper(data) }; % mean +- sem (median) zaokrouhleno

end

end
