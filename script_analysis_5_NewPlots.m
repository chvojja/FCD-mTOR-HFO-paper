

%%

% Tiedf.Subject=Tiedf.Subject;
% 
% Tiedf = leftjoinsorted(Tiedf,Tsub,'LeftKeys',{'Subject'},'RightKeys',{'Subject'},'RightVariables',{'Role'});
% 
% TieddSubset = Tiedf;
% save7fp = 'D:\temp_FCD_analyza_1\TieddSubset.mat'; save7

%% plot settings

color.CTRL=[0 0 1];
color.TREAT = [1 0 0];



% %% Histogram of oscillations
% % 
% controlsL = Tiedf.Role == 'CTRL' ;
% 
% selectL = controlsL;
% x = double( cell2mat( Tiedf.Signal( selectL  )  ) );
% ied_avg_CTRL =  mean( x - mean(x,2) , 1 ) ;
% 
% x = double( cell2mat( Tiedf.RpeaksInd( selectL & Tiedf.HasR )  ) );
% RpeaksCount_CTRL = sum(x);
% x = double( cell2mat( Tiedf.FRpeaksInd( selectL & Tiedf.HasFR )  ) );
% FRpeaksCount_CTRL = sum(x);
% 
% 
% 
% fcdsL = Tiedf.Role == 'TREAT'  ;
% 
% selectL = fcdsL;
% x = double( cell2mat( Tiedf.Signal( selectL  )  ) );
% ied_avg_TREAT =  mean( x - mean(x,2) , 1 ) ;
% 
% x = double( cell2mat( Tiedf.Signal( selectL & Tiedf.HasR  )  ) );
% ied_avgR_TREAT =  mean( x - mean(x,2) , 1 ) ;
% x = double( cell2mat( Tiedf.Signal( selectL & Tiedf.HasFR  )  ) );
% ied_avgFR_TREAT =  mean( x - mean(x,2) , 1 ) ;
% 
% x = double( cell2mat( Tiedf.RpeaksInd( selectL & Tiedf.HasR )  ) );
% RpeaksCount_TREAT = sum(x);
% x = double( cell2mat( Tiedf.FRpeaksInd( selectL & Tiedf.HasFR )  ) );
% FRpeaksCount_TREAT = sum(x);
% 
% %% R plot histogram of oscillations
% 
% ied_avg = ied_avg_CTRL -0.2;
% peakcounts = RpeaksCount_CTRL;
% 
% ied_avg = ied_avgR_TREAT -0.2; % Comment if you need CTRL
% peakcounts = RpeaksCount_TREAT;
% 
% NbinsOnseSide = 20;
% NsOneBin = 25;
% Nframe = 5000;
% 
% NOneSide = NsOneBin * NbinsOnseSide;
% 
% sI = Nframe/2 -NOneSide; eI = Nframe/2 + NOneSide  -1;
% peakCountsCropped = peakcounts( sI : eI );
% groups_bins = repelem(1:2*NbinsOnseSide,NsOneBin);
% counts = splitapply(@sum,peakCountsCropped,groups_bins);
% 
% figure;
% h1 = plot(ied_avg(sI:eI), 'LineWidth',1.5,'Color','k'); hold on;
% Nb=eI-sI+1;
% bar(linspace(1,Nb,NbinsOnseSide*2)  ,    counts/sum(counts)  ,'k')  %max(ied_avg)
% 
% ied_avg = ied_avg_CTRL -0.2;
% h2 = plot(ied_avg(sI:eI), 'LineWidth',1.5,'Color',[0.8 0.8 0.8]); hold on;
% 
% legend([h1 h2], {'FCD','CTRL'})
% hold off;
% 
% title('Distribution of R oscillation peaks (FCD) with respect to average IED (FCD, CTRL)');
% 
% 
% %% FR  plot histogram of oscillations
% 
% ied_avg = ied_avg_CTRL -0.2;
% peakcounts = FRpeaksCount_CTRL;
% 
% ied_avg = ied_avgFR_TREAT -0.2;      % Comment if you need CTRL
% peakcounts = FRpeaksCount_TREAT;
% % 
% % ied_avg = ied_avgFR_TREAT -0.2;
% 
% NbinsOnseSide = 20;
% NsOneBin = 25;
% Nframe = 5000;
% 
% NOneSide = NsOneBin * NbinsOnseSide;
% 
% sI = Nframe/2 -NOneSide; eI = Nframe/2 + NOneSide  -1;
% peakCountsCropped = peakcounts( sI : eI );
% groups_bins = repelem(1:2*NbinsOnseSide,NsOneBin);
% counts = splitapply(@sum,peakCountsCropped,groups_bins);
% 
% figure;
% h1 = plot(ied_avg(sI:eI), 'LineWidth',1.5,'Color','k'); hold on;
% Nb=eI-sI+1;
% bar(linspace(1,Nb,NbinsOnseSide*2)  ,    counts/sum(counts)  ,'k')  %max(ied_avg)
% 
% ied_avg = ied_avg_CTRL -0.2;
% h2 = plot(ied_avg(sI:eI), 'LineWidth',1.5,'Color',[0.8 0.8 0.8]); hold on;
% 
% legend([h1 h2], {'FCD','CTRL'})
% hold off;
% 
% title('Distribution of FR oscillation peaks (FCD) with respect to average IED (FCD, CTRL)');
% 
% %%
% % 
% % plot(ied_avg_CTRL);
% % hold on;
% % plot(ied_avg_TREAT);



%% PSD each 
r = size(Tsub,1);

for i = 1:r
    pw = Tsub.IEDpwelch{i};
    fw = Tsub.IEDfwelch{i};
    subplot(5,2,i);
    semilogy(fw,pw,'Color',0.5*color.( char(Tsub.Role(i))   )  ,'LineWidth',1 );
    grid
    title([ char(Tsub.Subject(i)) '  '  num2str(Tsub.Number(i))  ]);
    %legend({'Control', 'FCD'});
    xlabel('Hz');
    ylabel('PSD')
end
paperW = 8;
paperH = 12;
print2pngPaper(a.pwd([ picIdentifier 'PSDeach.png']),paperW,paperH);

%% PSD means

for i = 1:r
    pw = Tsub.IEDpwelch{i};
    fw = Tsub.IEDfwelch{i};

    semilogy(fw,pw,'Color',0.5*color.( char(Tsub.Role(i))   )  ,'LineWidth',0.5 ); hold on;
end
% means
group = 'CTRL';
x = double( cell2mat( Tsub.IEDpwelch(  Tsub.Role ==  group  )  ) );
%x =  mean( x - mean(x,2) , 1 ) ;
x =  mean( x , 1 ) ;
semilogy(fw,x,'Color',color.( group  )  ,'LineWidth',1.5 ); hold on;

group = 'TREAT';
x = double( cell2mat( Tsub.IEDpwelch(  Tsub.Role ==  group  )  ) );
%x =  mean( x - mean(x,2) , 1 ) ;
x =  mean( x , 1 ) ;
semilogy(fw,x,'Color',color.( group  )  ,'LineWidth',1.5 ); hold on;
grid

title('Welch Power Spectral Density estimate, all subjects with means')
%legend({'Control', 'FCD'});
xlabel('Hz');
ylabel('PSD')
hold off;


paperW = 8;
paperH = 5;
print2pngPaper(a.pwd([ picIdentifier 'PSD.png']),paperW,paperH);


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

% %% IED plots
% Nb = 50;
% 
% controlsL = Tiedf.Role == 'CTRL' ;
% fcdsL = Tiedf.Role == 'TREAT' ;
% 
% selectL = fcdsL;
% x = double( cell2mat( Tiedf.Signal( selectL  )  ) );
% x=  mean( x - mean(x,2) , 1 ) ;
% x = x(:,2300:2700);
% x=x(:);
% 
% ht = histogram(x,Nb,"FaceColor",color.TREAT,'Normalization','probability');
% 
% 
% hold on;
% 
% selectL = controlsL;
% x = double( cell2mat( Tiedf.Signal( selectL  )  ) );
% x=  mean( x - mean(x,2) , 1 ) ;
% x = x(:,2300:2700);
% x=x(:);
% 
% hc = histogram(x,Nb,"FaceColor",color.CTRL,'Normalization','probability'); 
% 
% bw = 0.02;
% ht.Normalization = 'probability';
% ht.BinWidth = bw;
% hc.Normalization = 'probability';
% hc.BinWidth = bw;
% 
% title('Distribution of IED samples')
% legend({'FCD', 'Control'});
% 
% 
% xlim([-1.5 1.5])
% xlabel('Positivity/negativity, mV')
% ylabel('Probability [-]')
% 
% hold off;
% 
% paperW = 4;
% paperH = 4;
% print2pngPaper(a.pwd('IEDpob.png'),paperW,paperH);

%% Tsubj stats

velikostKolecka=45;
alpha=1;
w = 7.87*0.85;
h = 2.36*0.85;

%%%%%%%%%%%%%%%%%%%%%%%

% 
% data = [1 10; 1 10];
% offset = 0;
% color = [0 1 1]*0.8;
% ydataLabels = [];
% plotBeforeAfterLinked(data,offset,velikostKolecka,alpha,'k',color_pink,ydataLabels)

%%
% color.TREAT = favouritecolors('EpiPink');
% cellparams.scatter.TREAT = {velikostKolecka,'LineWidth',1.5,'MarkerFaceColor',color_pink,'MarkerEdgeColor',color };


paperW = 6;
paperH = 6;

%% Skewness
group = 'CTRL';
y = Tsub.IEDskew_mean(Tsub.Role == group);
h = scatterrandomized(1, y ,velikostKolecka,'LineWidth',1.5,'MarkerFaceColor',color.(group),'MarkerEdgeColor',color.(group));  hold on;
text(1*ones(size(y))+0.2,y,   num2str( Tsub.Number(Tsub.Role == group) )   );

group = 'TREAT';
y = Tsub.IEDskew_mean(Tsub.Role == group);
%color = ;
h = scatterrandomized(2, y ,velikostKolecka,'LineWidth',1.5,'MarkerFaceColor',color.(group),'MarkerEdgeColor',color.(group));  hold on;
text(2*ones(size(y))+0.2,y,   num2str( Tsub.Number(Tsub.Role == group) )   );



set(gca,'YLim',[-3.5 0]);

set(gca,'XLim',[0.5 2.5]);
set(gca,'XTick',[1 2]);
set(gca,'xticklabel',{'Control','FCD'});
% xlabel('Skewness');
ylabel('Skewness, [-]');


print2pngPaper(a.pwd([ picIdentifier 'IEDskew.png']),paperW,paperH);


%% IED rate

group = 'CTRL';
y = Tsub.rateIED_min(Tsub.Role == group);
h = scatterrandomized(1, y ,velikostKolecka,'LineWidth',1.5,'MarkerFaceColor',color.(group),'MarkerEdgeColor',color.(group));  hold on;
text(1*ones(size(y))+0.2,y,   num2str( Tsub.Number(Tsub.Role == group) )   );

group = 'TREAT';
y = Tsub.rateIED_min(Tsub.Role == group);
%color = ;
h = scatterrandomized(2, y ,velikostKolecka,'LineWidth',1.5,'MarkerFaceColor',color.(group),'MarkerEdgeColor',color.(group));  hold on;
text(2*ones(size(y))+0.2,y,   num2str( Tsub.Number(Tsub.Role == group) )   );

%set(gca,'YLim',[0 6]);

set(gca,'XLim',[0.5 2.5]);
set(gca,'XTick',[1 2]);
set(gca,'xticklabel',{'Control','FCD'});
% xlabel('Skewness');
ylabel('IED rate, event/min.');


print2pngPaper(a.pwd([ picIdentifier 'IEDrate.png']),paperW,paperH);

%% IED amplitude

group = 'CTRL';
y = Tsub.IEDampl_mV(Tsub.Role == group);
h = scatterrandomized(1, y ,velikostKolecka,'LineWidth',1.5,'MarkerFaceColor',color.(group),'MarkerEdgeColor',color.(group));  hold on;
text(1*ones(size(y))+0.2,y,   num2str( Tsub.Number(Tsub.Role == group) )   );

group = 'TREAT';
y = Tsub.IEDampl_mV(Tsub.Role == group);
%color = ;
h = scatterrandomized(2, y ,velikostKolecka,'LineWidth',1.5,'MarkerFaceColor',color.(group),'MarkerEdgeColor',color.(group));  hold on;
text(2*ones(size(y))+0.2,y,   num2str( Tsub.Number(Tsub.Role == group) )   );

set(gca,'YLim',[0 1]);

set(gca,'XLim',[0.5 2.5]);
set(gca,'XTick',[1 2]);
set(gca,'xticklabel',{'Control','FCD'});
% xlabel('Skewness');
ylabel('IED amplitude, mV');


print2pngPaper(a.pwd([ picIdentifier 'IEDamp.png']),paperW,paperH);

%% IED width

group = 'CTRL';
y = 1000*Tsub.IEDwidth_sec(Tsub.Role == group);
h = scatterrandomized(1, y ,velikostKolecka,'LineWidth',1.5,'MarkerFaceColor',color.(group),'MarkerEdgeColor',color.(group));  hold on;
text(1*ones(size(y))+0.2,y,   num2str( Tsub.Number(Tsub.Role == group) )   );

group = 'TREAT';
y = 1000*Tsub.IEDwidth_sec(Tsub.Role == group);
%color = ;
h = scatterrandomized(2, y ,velikostKolecka,'LineWidth',1.5,'MarkerFaceColor',color.(group),'MarkerEdgeColor',color.(group));  hold on;
text(2*ones(size(y))+0.2,y,   num2str( Tsub.Number(Tsub.Role == group) )   );

%set(gca,'YLim',1000*[0.01 0.07]);

%set(gca,'XLim',[0.5 2.5]);
set(gca,'XTick',[1 2]);
set(gca,'xticklabel',{'Control','FCD'});
% xlabel('Skewness');
ylabel('IED width, ms');


print2pngPaper(a.pwd([ picIdentifier 'IEDwidth.png']),paperW,paperH);


%% R rate

group = 'CTRL';
y = Tsub.rateR_min(Tsub.Role == group);
h = scatterrandomized(1, y ,velikostKolecka,'LineWidth',1.5,'MarkerFaceColor',color.(group),'MarkerEdgeColor',color.(group));  hold on;
text(1*ones(size(y))+0.2,y,   num2str( Tsub.Number(Tsub.Role == group) )   );

group = 'TREAT';
y = Tsub.rateR_min(Tsub.Role == group);
%color = ;
h = scatterrandomized(2, y ,velikostKolecka,'LineWidth',1.5,'MarkerFaceColor',color.(group),'MarkerEdgeColor',color.(group));  hold on;
text(2*ones(size(y))+0.2,y,   num2str( Tsub.Number(Tsub.Role == group) )   );


%set(gca,'YLim',[0 6]);

set(gca,'XLim',[0.5 2.5]);
set(gca,'XTick',[1 2]);
set(gca,'xticklabel',{'Control','FCD'});
% xlabel('Skewness');
ylabel('Ripple rate, event/min.');


%print2pngPaper(a.pwd('Rrate.png'),paperW,paperH);
print2pngPaper(a.pwd([ picIdentifier 'Rrate.png']),paperW,paperH);

%% FR rate

group = 'CTRL';
y = Tsub.rateFR_min(Tsub.Role == group);
h = scatterrandomized(1, y ,velikostKolecka,'LineWidth',1.5,'MarkerFaceColor',color.(group),'MarkerEdgeColor',color.(group));  hold on;
text(1*ones(size(y))+0.2,y,   num2str( Tsub.Number(Tsub.Role == group) )   );

group = 'TREAT';
y = Tsub.rateFR_min(Tsub.Role == group);
%color = ;
h = scatterrandomized(2, y ,velikostKolecka,'LineWidth',1.5,'MarkerFaceColor',color.(group),'MarkerEdgeColor',color.(group));  hold on;
text(2*ones(size(y))+0.2,y,   num2str( Tsub.Number(Tsub.Role == group) )   );


set(gca,'YLim',[0 5]);

set(gca,'XLim',[0.5 2.5]);
set(gca,'XTick',[1 2]);
set(gca,'xticklabel',{'Control','FCD'});
% xlabel('Skewness');
ylabel('Fast ripple rate, event/min.');


print2pngPaper(a.pwd([ picIdentifier 'FRrate.png']),paperW,paperH);

%%

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





