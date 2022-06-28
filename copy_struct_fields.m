function y = copy_struct_fields(nv)
% % Example use
% struct1.a=1;
% struct1.b=2;
% struct2.blabla='asdadfxf';
% struct2 = copy_struct_fields(src = struct1,dest = struct2,fields={'a','b'})
% struct2 = copy_struct_fields(nv) % second possible call
% nv is name value pairs
arguments
   nv.src (1,1) struct = []; 
   nv.dest (1,1) struct = [];
   nv.fields (1,:) cell = [];
   nv.verbose (1,1) logical = false;
end
    
% Code
Nf=numel(nv.fields);
if nv.verbose, disp(['Im going to copy ' num2str(Nf) ' fields.' ]); end;

for i = 1:Nf
    field_name = nv.fields{i};
    nv.dest.(field_name) = nv.src.(field_name);
end
y = nv.dest;
end