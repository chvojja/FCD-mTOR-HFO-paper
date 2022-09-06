

%%

% Tiedf.Subject=Tiedf.Subject;
% 
% Tiedf = leftjoinsorted(Tiedf,Tsub,'LeftKeys',{'Subject'},'RightKeys',{'Subject'},'RightVariables',{'Role'});
% 
% TieddSubset = Tiedf;
% save7fp = 'D:\temp_FCD_analyza_1\TieddSubset.mat'; save7

%% Construct tables for plotting


%Tiedf = glueByID(Tied,Tiedd); % full Tiedf = Tiedf
Tiedf = leftjoinsorted(Tied,Tiedd,'LeftKeys',{'ID'},'RightKeys',{'ID'},'RightVariables',{'Signal'});
clear Tiedd;
Tiedf = leftjoinsorted(Tiedf,Tsub,'LeftKeys',{'Subject'},'RightKeys',{'Subject'},'RightVariables',{'Role'});


% Filter by labelname
labelname = 'IED_dontmiss5000Hz' ; 
Tiedf = Tiedf( Tiedf.LabelName == labelname , : ); % get rid of different type of label


% plot settings

color_CTRL=[0 0 1];
color_TREAT = [1 0 0];



%% Histogram of oscillations


controlsL = Tiedf.Role == 'CTRL' ;

selectL = controlsL;
x = double( cell2mat( Tiedf.Signal( selectL  )  ) );
ied_avg_CTRL =  mean( x - mean(x,2) , 1 ) ;

x = double( cell2mat( Tiedf.RpeaksInd( selectL & Tiedf.HasR )  ) );
RpeaksCount_CTRL = sum(x);
x = double( cell2mat( Tiedf.FRpeaksInd( selectL & Tiedf.HasFR )  ) );
FRpeaksCount_CTRL = sum(x);



fcdsL = Tiedf.Role == 'TREAT'  ;

selectL = fcdsL;
x = double( cell2mat( Tiedf.Signal( selectL  )  ) );
ied_avg_TREAT =  mean( x - mean(x,2) , 1 ) ;

x = double( cell2mat( Tiedf.RpeaksInd( selectL & Tiedf.HasR )  ) );
RpeaksCount_TREAT = sum(x);
x = double( cell2mat( Tiedf.FRpeaksInd( selectL & Tiedf.HasFR )  ) );
FRpeaksCount_TREAT = sum(x);

%% R

ied_avg = ied_avg_CTRL -0.2;
peakcounts = RpeaksCount_CTRL;

ied_avg = ied_avg_TREAT -0.2;
peakcounts = RpeaksCount_TREAT;

NbinsOnseSide = 20;
NsOneBin = 25;
Nframe = 5000;

NOneSide = NsOneBin * NbinsOnseSide;

sI = Nframe/2 -NOneSide; eI = Nframe/2 + NOneSide  -1;
peakCountsCropped = peakcounts( sI : eI );
groups_bins = repelem(1:2*NbinsOnseSide,NsOneBin);
counts = splitapply(@sum,peakCountsCropped,groups_bins);

figure;
plot(ied_avg(sI:eI), 'LineWidth',1.5,'Color','k'); hold on;
Nb=eI-sI+1;
bar(linspace(1,Nb,NbinsOnseSide*2)  ,    counts/sum(counts)  ,'k')  %max(ied_avg)
hold off;


%% FR

ied_avg = ied_avg_CTRL -0.2;
peakcounts = FRpeaksCount_CTRL;

ied_avg = ied_avg_TREAT -0.2;
peakcounts = FRpeaksCount_TREAT;

NbinsOnseSide = 20;
NsOneBin = 25;
Nframe = 5000;

NOneSide = NsOneBin * NbinsOnseSide;

sI = Nframe/2 -NOneSide; eI = Nframe/2 + NOneSide  -1;
peakCountsCropped = peakcounts( sI : eI );
groups_bins = repelem(1:2*NbinsOnseSide,NsOneBin);
counts = splitapply(@sum,peakCountsCropped,groups_bins);

figure;
plot(ied_avg(sI:eI), 'LineWidth',1.5,'Color','k'); hold on;
Nb=eI-sI+1;
bar(linspace(1,Nb,NbinsOnseSide*2)  ,    counts/sum(counts)  ,'k')  %max(ied_avg)
hold off;


%%
% 
% plot(ied_avg_CTRL);
% hold on;
% plot(ied_avg_TREAT);



%% PSD Ctrl vs treatment
x1 = double([Tiedf.Signal{ Tiedf.Role == 'CTRL'    }]) ;
x2 = double([Tiedf.Signal{ Tiedf.Role == 'TREAT'    }]);

nff = 5000; fs = 5000;
plotPSDWelch(x1,fs,nff,color_CTRL);
plotPSDWelch(x2,fs,nff,color_TREAT);
title('Welch Power Spectral Density estimate, control vs FCD animals')
legend({'Control', 'FCD'});
hold off;


paperW = 8;
paperH = 5;
print2pngPaper(a.pwd('HFOpow.png'),paperW,paperH);


% %% PSD FCD lesion vs outer
% x1 = double([Tiedf.Signal{  Tiedf.Role == 'TREAT'  && Tiedf.Position == 'OUT'    }]) ;
% x2 = double([Tiedf.Signal{ Tiedf.Role == 'TREAT'  && Tiedf.Position == 'IN'     }]);
% 
% nff = 5000; fs = 5000;
% plotPSDWelch(x1,fs,nff,[0 0 1]);
% plotPSDWelch(x2,fs,nff,[1 0 0]);
% title('Welch Power Spectral Density estimate, electrodes in the lesion vs outside the lesion, FCD animals')
% legend({'Outside, FCD', 'Inside, FCD'});
% hold off;

%% IED plots
Nb = 50;

controlsL = Tiedf.Role == 'CTRL' ;
fcdsL = Tiedf.Role == 'TREAT' ;

selectL = fcdsL;
x = double( cell2mat( Tiedf.Signal( selectL  )  ) );
x=  mean( x - mean(x,2) , 1 ) ;
x = x(:,2300:2700);
x=x(:);

ht = histogram(x,Nb,"FaceColor",color_TREAT,'Normalization','probability');


hold on;

selectL = controlsL;
x = double( cell2mat( Tiedf.Signal( selectL  )  ) );
x=  mean( x - mean(x,2) , 1 ) ;
x = x(:,2300:2700);
x=x(:);

hc = histogram(x,Nb,"FaceColor",color_CTRL,'Normalization','probability'); 

bw = 0.02;
ht.Normalization = 'probability';
ht.BinWidth = bw;
hc.Normalization = 'probability';
hc.BinWidth = bw;

title('Distribution of IED samples')
legend({'FCD', 'Control'});


xlim([-1.5 1.5])
xlabel('Positivity/negativity, mV')
ylabel('Probability [-]')

hold off;

paperW = 4;
paperH = 4;
print2pngPaper(a.pwd('IEDpob.png'),paperW,paperH);

%% Tsubj stats

velikostKolecka=45;
alpha=1;
w = 7.87*0.85;
h = 2.36*0.85;

%%%%%%%%%%%%%%%%%%%%%%%


% 
% plotBeforeAfterLinked(data,0,velikostKolecka,alpha,COLOR_CTRL,ydataLabels);
% set(gca,'xticklabel',{'lesion','non-lesion'});
% 
k=4;

% Tiedf = leftjoinsorted(Tiedf,Tsub,'LeftKeys',{'Subject'},'RightKeys',{'Subject'},'RightVariables',{'Role'});
subjects = Tsub.Subject; %(Tsub.Role =='CTRL');
for i = 1:numel(subjects)
    subject = subjects(i);
    Tsub.IEDskew_mean( Tsub.Subject == subject) = mean(  Tiedf.IEDskew(Tiedf.Subject == subject )   );  % & Tiedf.Role == 'CTRL' )
    Tsub.IEDampl_mV( Tsub.Subject == subject) = mean(  Tiedf.IEDampl_mV(Tiedf.Subject == subject )  ); 
    Tsub.IEDwidth_sec( Tsub.Subject == subject) = mean(  Tiedf.IEDwidth_sec(Tiedf.Subject == subject )  ); 
    Tsub.Rfreq( Tsub.Subject == subject) = mean(  Tiedf.Rfreq(Tiedf.Subject == subject & Tiedf.HasR==true )  ); 
    Tsub.FRfreq( Tsub.Subject == subject) = mean(  Tiedf.FRfreq(Tiedf.Subject == subject  & Tiedf.HasFR==true  )  ); 

    % rates
    dataLength = 1*Tdati.Files( Tdati.Subject == subject );

    Nieds = numel( find(Tiedf.Subject == subject  )  );
    Tsub.rateIED_min( Tsub.Subject == subject ) = k*Nieds/dataLength;

    NR = numel( find(Tiedf.Subject == subject & Tiedf.HasR==true )  );
    Tsub.rateR_min( Tsub.Subject == subject ) = k*NR/dataLength;

    NFR = numel( find(Tiedf.Subject == subject & Tiedf.HasFR==true  )  );
    Tsub.rateFR_min( Tsub.Subject == subject ) = k*NFR/dataLength;

    % average IED and oscilaltion peaks for each subject
    x = double( cell2mat( Tiedf.Signal( Tiedf.Subject == subject  )  ) );
    x =  mean( x - mean(x,2) , 1 ) ;
    Tsub.meanIED{ Tsub.Subject == subject } = x;


    % average  R oscilaltion peaks for each subject
    x = double( cell2mat( Tiedf.PeaksInd( Tiedf.Subject == subject & Tiedf.HasR & ~Tiedf.HasFR  )  ) );
    x = sum(x);
    if ~isempty(x)
        Tsub.RpeaksCount{ Tsub.Subject == subject } = x;
    end

%     % average  R oscilaltion peaks for each subject
%     x = double( cell2mat( Tiedf.FReaksInd( Tiedf.Subject == subject & Tiedf.HasR & ~Tiedf.HasFR  )  ) );
%     x = sum(x);
%     if ~isempty(x)
%         Tsub.RpeaksCount{ Tsub.Subject == subject } = x;
%     end
%     % average  FR oscilaltion peaks for each subject
%     x = double( cell2mat( Tiedf.RpeaksInd( Tiedf.Subject == subject & Tiedf.HasFR  )  ) );
%     x = sum(x);
%     if ~isempty(x)
%         Tsub.FRpeaksCount{ Tsub.Subject == subject } = x;
%     end

end



% 
% data = [1 10; 1 10];
% offset = 0;
% color = [0 1 1]*0.8;
% ydataLabels = [];
% plotBeforeAfterLinked(data,offset,velikostKolecka,alpha,'k',color_pink,ydataLabels)

%%
color.TREAT = favouritecolors('EpiPink');
cellparams.scatter.TREAT = {velikostKolecka,'LineWidth',1.5,'MarkerFaceColor',color_pink,'MarkerEdgeColor',color };



%% Skewness
y = Tsub.IEDskew_mean(Tsub.Role == 'CTRL');
h = scatterrandomized(1, y ,velikostKolecka,'LineWidth',1.5,'MarkerFaceColor','k','MarkerEdgeColor','k');  hold on;

y = Tsub.IEDskew_mean(Tsub.Role == 'TREAT');
%color = ;
h = scatterrandomized(2, y ,cellparams.scatter.TREAT{:}); 

set(gca,'YLim',[-3.5 0]);

set(gca,'XLim',[0.5 2.5]);
set(gca,'XTick',[1 2]);
set(gca,'xticklabel',{'Control','FCD'});
% xlabel('Skewness');
ylabel('Skewness, [-]');

paperW = 4;
paperH = 4;
print2pngPaper(a.pwd('IEDskew.png'),paperW,paperH);

%% IED rate
y = Tsub.rateIED_min(Tsub.Role == 'CTRL');
h = scatterrandomized(1, y ,velikostKolecka,'LineWidth',1.5,'MarkerFaceColor','k','MarkerEdgeColor','k');  hold on;

y = Tsub.rateIED_min(Tsub.Role == 'TREAT');
color = color_pink;
h = scatterrandomized(2, y ,velikostKolecka,'LineWidth',1.5,'MarkerFaceColor',color,'MarkerEdgeColor',color); 

set(gca,'YLim',[0 6]);

set(gca,'XLim',[0.5 2.5]);
set(gca,'XTick',[1 2]);
set(gca,'xticklabel',{'Control','FCD'});
% xlabel('Skewness');
ylabel('IED rate, event/min.');

paperW = 4;
paperH = 4;
print2pngPaper(a.pwd('IEDrate.png'),paperW,paperH);

%% IED amplitude
y = Tsub.IEDampl_mV(Tsub.Role == 'CTRL');
h = scatterrandomized(1, y ,velikostKolecka,'LineWidth',1.5,'MarkerFaceColor','k','MarkerEdgeColor','k');  hold on;

y = Tsub.IEDampl_mV(Tsub.Role == 'TREAT');
color = color_pink;
h = scatterrandomized(2, y ,velikostKolecka,'LineWidth',1.5,'MarkerFaceColor',color,'MarkerEdgeColor',color); 

set(gca,'YLim',[0 1]);

set(gca,'XLim',[0.5 2.5]);
set(gca,'XTick',[1 2]);
set(gca,'xticklabel',{'Control','FCD'});
% xlabel('Skewness');
ylabel('IED amplitude, mV');

paperW = 4;
paperH = 4;
print2pngPaper(a.pwd('IEDamp.png'),paperW,paperH);

%% IED width
y = Tsub.IEDwidth_sec(Tsub.Role == 'CTRL');
h = scatterrandomized(1, 1000*y ,velikostKolecka,'LineWidth',1.5,'MarkerFaceColor','k','MarkerEdgeColor','k');  hold on;

y = Tsub.IEDwidth_sec(Tsub.Role == 'TREAT');
color = color_pink;
h = scatterrandomized(2, 1000*y ,velikostKolecka,'LineWidth',1.5,'MarkerFaceColor',color,'MarkerEdgeColor',color); 

set(gca,'YLim',1000*[0.01 0.07]);

set(gca,'XLim',[0.5 2.5]);
set(gca,'XTick',[1 2]);
set(gca,'xticklabel',{'Control','FCD'});
% xlabel('Skewness');
ylabel('IED width, ms');


paperW = 4;
paperH = 4;
print2pngPaper(a.pwd('IEDwidth.png'),paperW,paperH);


%% R rate
y = Tsub.rateR_min(Tsub.Role == 'CTRL');
h = scatterrandomized(1, y ,velikostKolecka,'LineWidth',1.5,'MarkerFaceColor','k','MarkerEdgeColor','k');  hold on;

y = Tsub.rateR_min(Tsub.Role == 'TREAT');
color = color_pink;
h = scatterrandomized(2, y ,velikostKolecka,'LineWidth',1.5,'MarkerFaceColor',color,'MarkerEdgeColor',color); 

%set(gca,'YLim',[0 6]);

set(gca,'XLim',[0.5 2.5]);
set(gca,'XTick',[1 2]);
set(gca,'xticklabel',{'Control','FCD'});
% xlabel('Skewness');
ylabel('Ripple rate, event/min.');

paperW = 4;
paperH = 4;
print2pngPaper(a.pwd('Rrate.png'),paperW,paperH);

%% FR rate
y = Tsub.rateIED_min(Tsub.Role == 'CTRL');
h = scatterrandomized(1, y ,velikostKolecka,'LineWidth',1.5,'MarkerFaceColor','k','MarkerEdgeColor','k');  hold on;

y = Tsub.rateIED_min(Tsub.Role == 'TREAT');
color = color_pink;
h = scatterrandomized(2, y ,velikostKolecka,'LineWidth',1.5,'MarkerFaceColor',color,'MarkerEdgeColor',color); 

set(gca,'YLim',[0 5]);

set(gca,'XLim',[0.5 2.5]);
set(gca,'XTick',[1 2]);
set(gca,'xticklabel',{'Control','FCD'});
% xlabel('Skewness');
ylabel('Fast ripple rate, event/min.');

paperW = 4;
paperH = 4;
print2pngPaper(a.pwd('FRrate.png'),paperW,paperH);



function plotBeforeAfterLinked(data,offset,velikostKolecka,alpha,color1,color2,ydataLabels)
% data is two columns before, after
fontSize = 10;

miny=min( min(data));
maxy=max( max(data));
dy=(maxy-miny)/10;

hold on;

for i = 1:size(data,1)
    y1=data(i,1);
    y2 =data(i,2);
    
    if ~isnan(y1) && ~isnan(y2)
        plot([1 2]-offset,[y1 y2],'Color','k');
        
    end
    lw = 1.5;
   
        hb1 = scatter([1]-offset,y1 ,velikostKolecka,'LineWidth',lw); 
  
        hb2 = scatter([2]-offset,[ y2],velikostKolecka,'filled','LineWidth',lw); 

    set(hb1,'MarkerFaceColor',color1,'MarkerEdgeColor',color1,'MarkerEdgeAlpha',alpha,'MarkerFaceAlpha',alpha);
    set(hb2,'MarkerFaceColor',[1 1 1],'MarkerEdgeColor',color2,'MarkerEdgeAlpha',alpha,'MarkerFaceAlpha',alpha);
    %text(2+0.38-offset,y2+dy/10,ydataLabels(i),'HorizontalAlignment','right','FontSize',fontSize,'Color',color); 
end

set(gca,'YLim',[miny-dy maxy+dy]);
box off;
end





