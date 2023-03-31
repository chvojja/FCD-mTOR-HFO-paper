p1 = [a.pwd '\Tied\Signal\789.dat'];
s =  loadfun(plt.loadSignalIED, {p1} );
fs = 5000;
% %%
% % multiple
% s =  loadfun(plt.loadSignalIED, {[a.pwd '\Tied\Signal\637.dat']; ...
%                                 [a.pwd '\Tied\Signal\1351.dat']; ...
%                                 [a.pwd '\Tied\Signal\2910.dat']; ...
%                                 [a.pwd '\Tied\Signal\15190.dat']; ...
%                                 [a.pwd '\Tied\Signal\65901.dat']} );
% %%
% % multiple
% s =  loadfun(plt.loadSignalIED, {[a.pwd '\Tied\Signal\408.dat']; ...
%                                 [a.pwd '\Tied\Signal\538.dat']; ...
%                                 [a.pwd '\Tied\Signal\539.dat']; ...
%                                 [a.pwd '\Tied\Signal\766.dat']; ...
%                                 [a.pwd '\Tied\Signal\789.dat']} );
%%
for i = 1:size(s,1)
    plot(s(i,:));
    pause

end

  %%

plot(s(1,:))

fvtool(b,1,Analysis="freq")
bp1 = designfilt('bandpassfir','FilterOrder',4, ...
         'CutoffFrequency1',100,'CutoffFrequency2',300, ...
         'SampleRate',fs);


[~,bp1] = bandpass(zeros(fs,1),[ 100 300],fs,'ImpulseResponse','iir','Steepness',[0.5 0.5],'StopbandAttenuation', 30);

bp1 = designfilt('bandpassfir')

%%

bp1 = designfilt('bandpassfir','StopbandFrequency1',60,'PassbandFrequency1',100,'PassbandFrequency2',300,'StopbandFrequency2',350,'StopbandAttenuation1',40,'PassbandRipple',0.0001,'StopbandAttenuation2',40,'SampleRate',5000);
bp2 = designfilt('bandpassfir','StopbandFrequency1',250,'PassbandFrequency1',300,'PassbandFrequency2',1000,'StopbandFrequency2',1050,'StopbandAttenuation1',40,'PassbandRipple',0.0001,'StopbandAttenuation2',40,'SampleRate',5000);
%%
Nparts = 5;
subplot(Nparts,1,[1 2 3]);

hold on;

% source signal crop
sI = 1650+100; 
eI = 3160+100;
sone = s(1,sI:eI);

s3 = [];
s3(1,:) = sone ;
s3(2,:)= filtfilt(bp1,sone);
s3(3,:) = filtfilt(bp2,sone);

s2t(s3(1,:),fs)

Ns =4;
%s3 = filtfilt(ones(1,Ns)/Ns,1,s3')';


% plotting signal crop
sI=375; eI=1125;
s3 = s3(:,sI:eI);

h(1) =plot(s2t(s3(1,:),fs), 0.1+s3(1,:));
h(2) =plot(s2t(s3(1,:),fs), -1.15+ s3(2,:) +0.3-0.08);
h(3) =plot(s2t(s3(1,:),fs), -2.0+ s3(3,:)  +0.4);

set(gca,'YLim',[0.5-2.3-0.15 0.5+0.2])
[h.Color]=deal('k');

% format
hideaxis()
xaxisfitdata();
setall('LineWidth',0.5)


% spectrogram
subplot(Nparts,1,[4 5]);

res = 1.1;
frange = [0.01 1000];
frange = [0 1000];
Nfreqpoints = 3;

h1 = plotstockwell(sone(sI:eI),fs,res,frange,Nfreqpoints,'linear');
ylabel('Frequency, Hz');

map = jet;
map = [map(10:end,:); repmat( map(end,:)  ,175,1 )      ];


colormap(bound(map*1,0,1))

% add labels
ha = gca;
ha.XTickLabels = num2cellstr(1000*linspace(0.02,7*0.02,7));



%
 set(gcf,'Units','centimeters');
% resizeaxes_center([3.85,2.53]);
k=1.1;
%resize2cm(k*7.2,k*2.7)
resize2cm(k*8.5,k*8)
%resize2cm(7.0,4)
trueblackaxis();


axesfun(ha,@format_axesB);

%%
exportgraphics(gcf, 'kokoti.pdf','BackgroundColor', 'none','ContentType','vector')

%%
cwt(sone,fs)
%%
[cfs,f] = cwt(sone,fs);
image("XData",sone,"YData",f,"CData",abs(cfs),"CDataMapping","scaled")




function format_axesB(hax)
arguments 
    hax = gca;
end
hax.FontSize = plt.FontSize; % premeks favourite
hax.LabelFontSizeMultiplier = 1; % prevent font size from changing

% Line width
setall(hax,'LineWidth',0.4);

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
%scientificfontcompact;

end