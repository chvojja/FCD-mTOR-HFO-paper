function y = printmeansemmedian_HFOpaper(data)

m = nanmean(data);
s = nansem(data);
mmed = nanmedian(data);

    txt_ms = printmeansem(  m  , s );
    txt_mmeds = printmeansem(  mmed  , s );
    y = [ txt_ms(1:end-6) ' (' txt_mmeds(1:regexp(txt_mmeds,'±')-2)  ')' ];


end