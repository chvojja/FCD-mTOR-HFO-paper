function y = printmeansem_HFOpaper(m,s)


    [meansem_char,var_decimal] = printmeanvar_singlesig(  m  , s );
%     txt_mmeds = printmeanvar_singlesig(  mmed  , s );
% 


    y = [ meansem_char  ];
%     y = [ meansem_char(1:end-6) ' (' txt_mmeds(1:regexp(txt_mmeds,'±')-2)  ')' ];


end