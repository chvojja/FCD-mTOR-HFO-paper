function y = printmeansemmedian_HFOpaper(data)

m = nanmean(data);
s = nansem(data);
mmed = nanmedian(data);


    [meansem_char,var_decimal] = printmeanvar_singlesig(  m  , s );
%     txt_mmeds = printmeanvar_singlesig(  mmed  , s );
% 


    meandata = round(mmed, var_decimal ) ;
    if var_decimal<0 
     var_decimal = 0;
    end
    medStr = sprintf(['%.' num2str( var_decimal ) 'f'], mmed );  % '%.4f'

    y = [ meansem_char ' (' medStr ')' ];
%     y = [ meansem_char(1:end-6) ' (' txt_mmeds(1:regexp(txt_mmeds,'±')-2)  ')' ];


end