function format_axes(hax)
arguments 
    hax = gca;
end
hax.FontSize = plt.FontSize; % premeks favourite
hax.LabelFontSizeMultiplier = 1; % prevent font size from changing

% Line width
setall('LineWidth',0.4);

% Title format
hax.Title.FontSize=plt.FontSize;
hax.Title.FontWeight='normal';

hax.TitleFontWeight ="normal";
hax.TitleFontSizeMultiplier=1;

Nstr = numel(hax.Title.String);
for i =1:Nstr
    switch class(hax.Title.String)
        case 'char'
            hax.Title.String=[ '\fontsize{' num2str(plt.FontSize) '}' hax.Title.String ];
        case 'cell'
            hax.Title.String{i}=[ '\fontsize{' num2str(plt.FontSize) '}' hax.Title.String{i} ];
    end
end
%

% set length of ticks
set(hax, 'Units', 'centimeters');
pos = hax.Position;
height_cm = pos(4);
desired_length = 0.05; %cm
normalized_length = desired_length./height_cm;
hax.TickLength = [normalized_length, 0.01];


% disable labels rotation
hax.XTickLabelRotationMode="manual";
hax.XTickLabelRotation=0;

trueblackaxis(hax);
scientificfontcompact;

end