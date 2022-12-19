function [haxes] = layoutaxesrows(h_subplot,row_heights,row_widths)
arguments
    h_subplot
    row_heights;
end
arguments (Repeating)
    row_widths;
end
Nc = numel(row_widths);
Nr = length(row_heights);
if Nc==Nr
   total_height = sum( row_heights );
   for i =1:Nr, widths(i) = sum(row_widths{i}); end
   total_width = max(widths);

   ind_map = reshape(1:(total_height*total_width),total_width,total_height);

   Ntiles = numel(cell2mat(row_widths));
  % starts_col = [1 1+cumsum(row_widths(1:end-1))];
   starts_row = [1 1+cumsum(row_heights(1:end-1))];
   i =1;
   for r =1:Nr
        rws = row_widths{r};
        starts_col = [1 1+cumsum(rws(1:end-1))];

        Nc_current = length(rws);
        for c = 1:Nc_current
            tile_dims(1)=row_heights(r);
            tile_dims(2)=rws(c);

            %hax = nexttile(tile_dims);
           % hax = subaxis(total_height,total_width,starts_row(r),starts_col(c),row_heights(r),rws(c)); 
         % hax = subaxis(total_height,total_width,starts_col(c),starts_row(r),rws(c),row_heights(r));
         inds = ind_map( starts_col(c):(starts_col(c)+rws(c)-1) , starts_row(r):(starts_row(r)+row_heights(r)-1)  );
         %hax = subplot(total_height,total_width,inds(:));
         hax = h_subplot(total_height,total_width,inds(:));

         %  hax = subplot_er(total_height,total_width,starts_col(c),starts_row(r),rws(c),row_heights(r));  
            %varargout{i}=hax;
            haxes(i)=hax;
            i = i+1;
            
%             [X,Y,Z] = peaks(20);
%             surf(X,Y,Z);     
        end
   end 
else
    disp('Arguments not in pairs');
   haxes = [];
end
end