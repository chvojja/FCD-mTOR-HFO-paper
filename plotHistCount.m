function plotHistCount(TwithPeakCounts,feature)

hold on
peakcounts =  cell2mat(  TwithPeakCounts.(feature)  );
meanIED = sum(cell2mat(TwithPeakCounts.meanIED),1);

if ~isempty(peakcounts)
    NbinsOnseSide = 6;
    NsOneBin = 20;

    NbinsOnseSide = 8;
    NsOneBin = 8;

%     NbinsOnseSide = 12;
%     NsOneBin = 5;

    fs = 5000;
    
    peakcountsBinedProbabilityPerSubjC = cell(size(peakcounts,1),1);
    for i = 1: size(peakcounts,1)
        %[c,b,Nb,sI,eI] = binPeakCounts(peakcounts_subjects(i,:),NbinsOnseSide); [counts,groups_bins,Nb] = binPeakCounts(peakcounts,NbinsOnseSide)
        Nframe = 5000;
        NOneSide = NsOneBin * NbinsOnseSide;
        sI = Nframe/2 -NOneSide; eI = Nframe/2 + NOneSide  -1;
        peakCountsCropped = peakcounts(i, sI : eI );
        groups_bins = repelem(1:2*NbinsOnseSide,NsOneBin);
        counts = splitapply(@sum,peakCountsCropped,groups_bins);
        Nb=eI-sI+1;
    
        peakcountsBinedProbabilityPerSubjC{i} = 100*counts/sum(counts);
    end
    
    peakcountsBinedProbabilityPerSubj=cell2mat(peakcountsBinedProbabilityPerSubjC);
    means = nanmean(peakcountsBinedProbabilityPerSubj);
    sems = nansem( peakcountsBinedProbabilityPerSubj );
    
    max_percentage_y = max(means+sems);
    % rescale meanIED between 0 and max_percentage_y
    [ meanIED_scaled, scale_factor ] = fitrange(meanIED(sI:eI),[1 max_percentage_y]);

%     meanIED = meanIED - max(meanIED);
%     meanIED = meanIED * max(means);
    % plot

    time_centered = 1000*s2t(meanIED_scaled,fs); % in miliseconds
    time_centered = time_centered-max(time_centered)/2;
    h1 = plot(time_centered,meanIED_scaled,'Color','k','LineWidth',plt.LineWidthThicker); hold on;
    xlabel(plt.labeltimems);
   % Nb=eI-sI+1;
    
    time_range = [time_centered(1) time_centered(end)];
    set(gca,'XLim',time_range);
   % maxTime = max(get(gca,'XLim'));
  %  bar(  linspace(0,maxTime,NbinsOnseSide*2)    ,    means ,'k')  %max(ied_avg)
    
%    time_range_onebin = abs(diff(time_range))/(NbinsOnseSide*2);
%     Ns_bin numel(meanIED_scaled)/(NbinsOnseSide*2);
    %time_centered([round(NsOneBin/2):NsOneBin:(numel(meanIED_scaled)-round(NsOneBin/2))]);
    t_bins = time_centered( [1:NsOneBin:(numel(meanIED_scaled))]+round(NsOneBin/2) );
    er = errorbar( t_bins ,  means  ,sems,sems,'o','LineWidth',plt.LineWidthThin);    
    er.CapSize = 3;
    er.MarkerSize = 3;
%     er.Color = [0 0 0];    
%     er.LineStyle = 'none'; 
    [er(:).Color] = deal([0 0 0 ]);
    [er(:).LineStyle] = deal('none');
    
    
    box on
   % set(gca,'YLim', [0 max(means+sems)]);
    ylimoptimal(PercentMargin = 0.05);
    
    % delete ticklabels to negative values
%     yt = get(gca,'yticklabels');
%     ytNum = cellstr2num(yt);
%     yt(ytNum<0)={' '};
%     set(gca,'yticklabels',yt);
end

end
