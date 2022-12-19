
p1 = 'C:\temp_FCD_analyza_1Full\Tied\Signal\214051.dat';
p2 = 'C:\temp_FCD_analyza_1Full\Tied\Signal\221369.dat';

  s =  loadfun(plt.loadSignalIED, {p1; p2} );

  %%
fs = 5000;



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
hold on;
s3 = [];
s3(1,:) = s(1,:) ;
s3(2,:)= filtfilt(bp1,s(1,:));
s3(3,:) = filtfilt(bp2,s(1,:));

Ns =4;
s3 = filtfilt(ones(1,Ns)/Ns,1,s3')';


sI = 1700; 
eI = 3400;
%sI=1; eI=5000;
s3 = s3(:,sI:eI);

h(1) =plot( 0.1+s3(1,:));
h(2) =plot( -1.15+ s3(2,:));
h(3) =plot( -2.0+ s3(3,:));

set(gca,'YLim',[0.5-3.5 0.5+0.2])

[h.Color]=deal('k');

% no axis and fit
hideaxis()
xaxisfitdata();
setall('LineWidth',0.5)
%
set(gca,'Units','centimeters');
resizeaxes_center([3.85,2.53]);
%resize2cm(4.0,2.5)
trueblackaxis();
exportgraphics(gcf, 'kokoti.pdf','BackgroundColor', 'none','ContentType','vector')

