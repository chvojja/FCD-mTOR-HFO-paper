

% %%
% figurefull;
% sp(1) = subplot(3,3,1);  % This has to be drawn first to be able to draw significant line exactly :((
% sp(2) = subplot(3,3,2);
% sp(3) = subplot(3,3,3);
% sp(4) = subplot(3,3,4);
% sp(5) = subplot(3,3,5); %
% sp(6) = subplot(3,3,6);
% sp(7) = subplot(3,3,7); % ratio of psd     'position',[left bottom width height])
% % custom plots
% dist_lbl = 0.03;
% 
% % dists = [ dist_lbl dist_lbl dist_lbl];
% % widths_perc = [ 0.4 0.2 0.4];
% %  
% % redge_third_column = sp(6).Position(1)+sp(6).Position(3);
% % redge_first_column = sp(1).Position(1)+sp(1).Position(3);
% % space = redge_third_column-redge_first_column;
% % 
% % sum(pos_IEDsBox([1 3]));
% % pos_pie =
% % sp(8) = subplot('Position',pos_pie); % pie
% % sp(9) = subplot('Position',pos_IEDsBox); % Box
% % sp(10) = subplot('Position',pos_HFOsBox);
% 
% left_middle_column = sp(5).Position(1);
% bottom_thirdrow= sp(7).Position(2);
% width = sp(7).Position(3);
% height = sp(7).Position(4);
% 
% pos_pie = [left_middle_column*0.9 bottom_thirdrow width*0.8 height];
% sp(8) = subplot('Position',pos_pie); % pie
% 
% pos_IEDsBox = pos_pie;
% pos_IEDsBox(1)=pos_IEDsBox(1) + pos_pie(3)+dist_lbl ; %+ width*0.6;
% pos_IEDsBox(3)=width/2;
% sp(9) = subplot('Position',pos_IEDsBox); % Box
% 
% 
% pos_HFOsBox = pos_IEDsBox;
% pos_HFOsBox(1) = pos_HFOsBox (1) + pos_IEDsBox(3)+dist_lbl;
% redge_right_column = sp(6).Position(1)+sp(6).Position(3);
% left_HFOsBox = dist_lbl +  sum(pos_IEDsBox([1 3]));
% pos_HFOsBox(3) = redge_right_column-left_HFOsBox;
% sp(10) = subplot('Position',pos_HFOsBox);
% % pause(0.5);
% drawnow;
% resize2cm(9.5,10.5);
% %


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Fig 4. IEDs and PSD plots
%----------------------------Prepare window----------------------------
figurefull;
% tiledlayout definition

row_widths_3columns=[4 4 4];
third_row_tile_widths = [4 3 5];
row_heights = [4 4 4];

% [hax(1),hax(2),hax(3),hax(4),hax(5),hax(6),hax(7),hax(6),hax(7)] = layoutaxesrows(row_heights,row_widths_3x3,row_widths_3x3,third_row_tile_widths);

h_subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.1 0.05], [0.1 0.05]);
h_subplot = @(m,n,p) subtightplot (m, n, p, [0.0 0.0], [0.0 0.0], [0.0 0.00]);
h_subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.05 0.05], [0.05 0.05]);
h_subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.05 0.05], [0.062 0.062]);

% na prvni dobrou
h_subplot = @(m,n,p) subtightplot (m, n, p, [0.05658 0.0565], [0.081 0.051], [0.0998 0.0293]);

%ax_layout
[hax] = layoutaxesrows(h_subplot,row_heights,row_widths_3columns,row_widths_3columns,third_row_tile_widths);
%axis(hax(1:7),'square');
%
drawnow;
%--------------------------Position to centimeters--------------------------
resize2cm(9.5,11.2); % paper size on figure but axes are still on auto mode
previous_units_C = axesunits(hax,'centimeters');
resizeaxes_center(hax(1:7),[plt.w_square_boxplot plt.w_square_boxplot]);
width_oversizeIEDtrace = 1.05*plt.w_square_boxplot;
resizeaxes_topright(hax(1),[width_oversizeIEDtrace width_oversizeIEDtrace]);

width_3boxplots = 1.243*plt.w_square_boxplot;
resizeaxes_bottomright(hax(8),[width_3boxplots/2.8 plt.w_square_boxplot]);
resizeaxes_bottomright(hax(9),[width_3boxplots plt.w_square_boxplot]);

hax(7).InnerPosition(2)=hax(8).InnerPosition(2); % snap Pie to bottom
hax(8).InnerPosition(1)=hax(8).InnerPosition(1)-0.2; % move middle bottom to the left
hax(1).InnerPosition(1)=hax(1).InnerPosition(1)-0.12; % move first axes  to the left
axesunits(hax,previous_units_C);
%pieAxisPosition = get(pieAxis, 'Position');

%----------------------------Plotting of individual axes----------------------------
% IED traces
axes(hax(1)); hold on;
plot_averaged_IEDs(TsubRes,Tiedf);

% Boxplots
axes(hax(2)); hold on;
plot_IEDrate_Cx_Treat( TsubRes, Tplt_CtrlVsTreat);

axes(hax(3)); hold on;
plot_IEDrate_In_vs_Out(TsubRes_inout, Tplt_OutVsIn);


% Pwelchs
%plt.formatSpecial1;

axes(hax(4)); hold on;
plot_pwelch_individual_Cx_vs_Treat(TsubRes)


axes(hax(5)); hold on;
% [pwelch_f, pwelch_mean_TREAT,pwelch_sems_TREAT,pwelch_mean_CTRL,pwelch_sems_CTRL] =  plot_pwelch_means_Cx_vs_Treat(TsubRes);
plot_pwelch_means_Cx_vs_Treat(TsubRes);


axes(hax(6)); hold on;
% plot_pwelch_diff(pwelch_f, pwelch_mean_TREAT,pwelch_sems_TREAT,pwelch_mean_CTRL,pwelch_sems_CTRL);
%plot_pwelch_means_Cx_vs_Treat_ZOOM(TsubRes);
plot_pwelch_ratio(TsubRes);

% Pie and small boxes
axes(hax(7)); hold on;

plot_pieIEDs(stats.pieData);

axes(hax(8)); hold on; 
% hb=boxchart([1 1 1 1 1 1 1 1 ], stats.percents_IEDsNoHFO );
hb=boxchart(stats.percents_IEDsNoHFO );
hb.BoxWidth=1;
format_boxchart(hb);
xticklabels('IED');
ylabel('IEDs w/o HFO (%)');
% hax(8).YLim = [80 100];
% hax(8).YTick = [80 85 90 95 100];
% hax(8).YTick = [90 92 94 96 98 100];
% 
% hax(8).YLim = [88 98];
% hax(8).YTick = [88 90 92 94 96 98];

hax(8).YLim = [84 99];
hax(8).YTick = [84 87 90 93 96 99];
ylimoptimal(PercentMargin = plt.OptimAxLimOffsetPercentage);


axes(hax(9)); hold on; 
hb=boxchart( stats.percents_IEDsWithHFO);
hb.BoxWidth=0.8;
format_boxchart(hb);
xticklabels({'GR','FR','FR+GR'});
ylabel('IEDs with HFO (%)');
% hax(9).YLim = [0 15];
% hax(9).YTick = [0 5 10 15];
a.set_yprops(hax(9),'IEDsWithHFOs'); 
ylimoptimal(PercentMargin = plt.OptimAxLimOffsetPercentage);

%format_axes(hax(9));
%
%
axesfun(hax,@format_axes);


%%
%setall('LineWidth',0.5,'FontSize',plt.FontSize);
if plt.savefigs_b
savefig( a.pwd([mfilename '.fig']) );
exportgraphics(gcf, a.pwd([mfilename '.pdf'])  ,'ContentType','vector');
printpaper(  a.pwd([mfilename '.' plt.formatExt])   , dpi = plt.dpi, close = plt.closeFigs);
end


%%
% 
% % counts as boxplots per count type;
% 
% 
% % only treatment animals
% % Tplot = TsubRes_inout( TsubRes_inout.Role == 'TREAT' , {'Subject','Number','InLesion',feature}); 
% Tplot = TsubRes_inout( TsubRes_inout.Role == 'TREAT' , {'Subject','Number','InLesion'}); 
% Tplot.InLesion = categorical(Tplot.InLesion);
% Tplot.InLesion = cat2num(Tplot.InLesion,'false',2,'true',1);
% 
% percentsEachAnimal = 100*[countsOnlyIEDsNoRsNoFRs countsOnlyRs countsOnlyFRs  countsOnlyRFRs ]./T.Nieds;
%  
% yyaxis left
% barsData = [percentsEachAnimal(:,1:end) 100*countsOnlyRFRs./(countsOnlyRFRs+countsOnlyFRs) ];
% barsData(:,2:end) = NaN;
% 
% hb=boxchart( stats.percents_IEDsNoHFO );
% format_boxchart(hb);
% 
% ax= gca; ax.YAxis(1).Color= favouritecolors('epipink');
% hbcounts1(1).BoxFaceColor = favouritecolors('epipink');
% ylabel('IED, %');
% 
% yyaxis right
% barsData = [percentsEachAnimal(:,1:end) 100*countsOnlyRFRs./(countsOnlyRFRs+countsOnlyFRs) ];
% barsData(:,1) = NaN;
% hbcounts2=boxchart( barsData ,'BoxFaceColor','k','LineWidth',plt.LineWidthBox);
% hbcounts2(1).MarkerColor = [0 0 0];
% ax= gca; ax.YAxis(2).Color= favouritecolors('halflife');
% hbcounts2(1).BoxFaceColor = favouritecolors('halflife');
% ylabel('HFO, %');
% 
% NdetTypes = numel( labelsDetTypes );
% set(gca,'xticklabel', [labelsDetTypes([1 2 4 ])  { 'FR+R' 'R/FR' } ] );
% 
% %%
% 
% 
% 
% 
% 
% %setall('LineWidth',0.5,'FontSize',plt.FontSize);
% if plt.savefigs_b
% savefig( a.pwd([ ' Fig4.fig']) );
% printpaper(  a.pwd([ ' Fig4.' plt.formatExt])   , dpi = plt.dpi, close = plt.closeFigs);
% end



% the good one
% function [haxes] = layoutaxesrows(h_subplot,row_heights,row_widths)
% arguments
%     h_subplot
%     row_heights;
% end
% arguments (Repeating)
%     row_widths;
% end
% Nc = numel(row_widths);
% Nr = length(row_heights);
% if Nc==Nr
%    total_height = sum( row_heights );
%    for i =1:Nr, widths(i) = sum(row_widths{i}); end
%    total_width = max(widths);
% 
%    ind_map = reshape(1:(total_height*total_width),total_height,total_width);
% 
%    Ntiles = numel(cell2mat(row_widths));
%   % starts_col = [1 1+cumsum(row_widths(1:end-1))];
%    starts_row = [1 1+cumsum(row_heights(1:end-1))];
%    i =1;
%    for r =1:Nr
%         rws = row_widths{r};
%         starts_col = [1 1+cumsum(rws(1:end-1))];
% 
%         Nc_current = length(rws);
%         for c = 1:Nc_current
%             tile_dims(1)=row_heights(r);
%             tile_dims(2)=rws(c);
% 
%             %hax = nexttile(tile_dims);
%            % hax = subaxis(total_height,total_width,starts_row(r),starts_col(c),row_heights(r),rws(c)); 
%          % hax = subaxis(total_height,total_width,starts_col(c),starts_row(r),rws(c),row_heights(r));
%          inds = ind_map( starts_col(c):(starts_col(c)+rws(c)-1) , starts_row(r):(starts_row(r)+row_heights(r)-1)  );
%          %hax = subplot(total_height,total_width,inds(:));
%          hax = h_subplot(total_height,total_width,inds(:));
% 
%          %  hax = subplot_er(total_height,total_width,starts_col(c),starts_row(r),rws(c),row_heights(r));  
%             %varargout{i}=hax;
%             haxes(i)=hax;
%             i = i+1;
%             
% %             [X,Y,Z] = peaks(20);
% %             surf(X,Y,Z);     
%         end
%    end 
% else
%     disp('Arguments not in pairs');
%    haxes = [];
% end
% end



% 
% function [haxes,ht] = layoutaxesrows(row_heights,row_widths)
% arguments
%     row_heights;
% end
% arguments (Repeating)
%     row_widths;
% end
% Nc = numel(row_widths);
% Nr = length(row_heights);
% if Nc==Nr
%    total_height = sum( row_heights );
%    for i =1:Nr, widths(i) = sum(row_widths{i}); end
%    total_width = max(widths);
%     tiledlayout(total_height,total_width,'TileSpacing','compact','Padding','compact');
% %ht = tiledlayout(total_height,total_width,'TileSpacing','tight','Padding','tight');
%    Ntiles = numel(cell2mat(row_widths));
%    i =1;
%    for r =1:Nr
%         rws = row_widths{r};
%         Nc_current = length(rws);
%         for c = 1:Nc_current
%             tile_dims(1)=row_heights(r);
%             tile_dims(2)=rws(c);
% 
%             hax = nexttile(tile_dims);
%             %hax = subaxis(total_height,total_width,tile_dims); 
%             %varargout{i}=hax;
%             haxes(i)=hax;
%             i = i+1;
%             
% %             [X,Y,Z] = peaks(20);
% %             surf(X,Y,Z);     
%         end
%    end 
% else
%     disp('Arguments not in pairs');
%    haxes = [];
% end
% end


function plot_averaged_IEDs(TsubRes,Tiedf)
fs = plt.fs;
hax = gca;

[ied, iedsems] =  getIEDmeansems(    TsubRes( TsubRes.Role == 'CTRL' , :)    ,   Tiedf( Tiedf.InLesion == true , : )    ) ;
ied = cropfill( Signal = ied, CropPercent = plt.IedCropPercent ); iedsems = cropfill( Signal = iedsems, CropPercent =  plt.IedCropPercent );
hp1 = plot( 1000*s2t(ied,fs),ied,'k' ); 

[ied, iedsems] =  getIEDmeansems(    TsubRes( TsubRes.Role == 'CTRL', :)    ,   Tiedf( Tiedf.InLesion == false , : )    ) ;
ied = cropfill( Signal = ied, CropPercent =  plt.IedCropPercent ); iedsems = cropfill( Signal = iedsems, CropPercent =  plt.IedCropPercent );
hp2 = plot( 1000*s2t(ied,fs),ied,'k:' ); 

[ied, iedsems] =  getIEDmeansems(    TsubRes( TsubRes.Role == 'TREAT' , :)    ,   Tiedf( Tiedf.InLesion == true , : )    ) ;
ied = cropfill( Signal = ied, CropPercent =  plt.IedCropPercent ); iedsems = cropfill( Signal = iedsems, CropPercent =  plt.IedCropPercent );
hp3 = plot( 1000*s2t(ied,fs) , ied,'r' ); 

[ied, iedsems] =  getIEDmeansems(    TsubRes( TsubRes.Role == 'TREAT', :)    ,   Tiedf( Tiedf.InLesion == false , : )    ) ;
ied = cropfill( Signal = ied, CropPercent =  plt.IedCropPercent ); iedsems = cropfill( Signal = iedsems, CropPercent =  plt.IedCropPercent );
hp4 = plot( 1000*s2t(ied,fs), ied,'r:'  ); 

title('Averaged detection');

hax.XAxis.Visible = false;
hax.YAxis.Visible = false;

%format_axes(hax);
squareaxis(hax);
end

function plot_IEDrate_Cx_Treat(TsubRes, Tplt_CtrlVsTreat)
hax = gca;
feature = 'rateIED_min';
[hs,hb] = plotDotBoxplot_CXvsTREAT(TsubRes,feature,Tplt_CtrlVsTreat);
ylabel(plt.labelrateMin);

title('Detection rate');
format_axes(hax);
squareaxis(hax);
end

function plot_IEDrate_In_vs_Out(TsubRes_inout, Tplt_OutVsIn)
hax = gca;
feature = 'rateIED_min';
[h] = plotBox_OutvsIn(TsubRes_inout,feature,Tplt_OutVsIn);
title('Detection rate');
%format_axes(hax);
squareaxis(hax);
end


function plot_pwelch_individual_Cx_vs_Treat(TsubRes)
hax=gca;

group = 'TREAT';
rows_for_group = find( TsubRes.Role ==  group );
for i = rows_for_group'
    pwelch_y = TsubRes.IEDpwelch{i};
    pwelch_f = TsubRes.IEDfwelch{i};

    plot(pwelch_f+1,pwelch_y,'Color',plt.colors.( group  )  ); hold on;
end
formatAsPSDplot();

group = 'CTRL';
rows_for_group = find( TsubRes.Role ==  group );
for i = rows_for_group'
    pwelch_y = TsubRes.IEDpwelch{i};
    pwelch_f = TsubRes.IEDfwelch{i};

    plot(pwelch_f+1,pwelch_y,'Color',plt.colors.( group  )   ); hold on;  
end
formatAsPSDplot();

% ticks
hax.XTick =[1 10 100 1000];
hax.YTick = [10^-8 10^-6 10^-4 10^-2];

ylabel(plt.labelpsd);
%legend([hp1 hp2],{'Control', 'FCD'},'Location','southwest');
title('PSD in FCD/controls');
%format_axes(hax);
squareaxis(hax);
end


function  plot_pwelch_means_Cx_vs_Treat(TsubRes)
hax = gca;

group = 'TREAT';
[pwelch_mean ,  pwelch_ci_lo, pwelch_ci_hi, pwelch_f] = getPWELCH_ci(TsubRes, group);
hp2 = plot(pwelch_f+1,pwelch_mean,'Color',plt.colors.( group  )  ); hold on;
hs2 = confidenceshade( pwelch_f+1 , pwelch_ci_lo , pwelch_ci_hi , Color='r' ); 

group = 'CTRL';
[pwelch_mean , pwelch_ci_lo, pwelch_ci_hi , pwelch_f] = getPWELCH_ci(TsubRes, group);
hp1 = plot(pwelch_f+1,pwelch_mean,'Color',plt.colors.( group  )   );  hold on;
hs1 = confidenceshade( pwelch_f+1 , pwelch_ci_lo , pwelch_ci_hi , Color='k' );% for normal distribution CI


formatAsPSDplot();

% ticks
hax.XTick =[1 10 100 1000];
hax.YTick = [10^-8 10^-6 10^-4 10^-2];

%ylabel(plt.labelpsd);
%legend([hp1 hp2],{'Control', 'FCD'},'Location','southwest');
title('Averaged PSD');
%format_axes(hax);
squareaxis(hax);
    function [pwelch_mean ,  pwelch_ci_lo, pwelch_ci_hi, pwelch_f ] =  getPWELCH_ci(TsubRes, group)
        
        x = double( cell2mat( TsubRes.IEDpwelch(  TsubRes.Role ==  group  )  ) );
        if ~isempty(x)
            idxTrue = find(TsubRes.Role ==  group);
            pwelch_f  = TsubRes.IEDfwelch{  idxTrue(1)   }; % get freq vector from somewhere
            
            % mean
            pwelch_mean = nanmean(x,1); 
                       
            % ci normal - parametric   for <30 samples
%             p_alpha = 0.05;
%             nsamples = x;
%             nsamples(~isnan(nsamples))=1; nsamples(isnan(nsamples))=0  ;
%             nsamples = sum(nsamples,1);
%             df = nsamples     -1;  % number of samples minus one
%             pwelch_ci_lo = pwelch_mean - nansem(x).*tinv(1-p_alpha/2,df); 
%             pwelch_ci_hi = pwelch_mean + nansem(x).*tinv(1-p_alpha/2,df);

            % ci non parametric for median - exact method - very small sample size
            Nf = size(pwelch_f,2);
            probs = zeros(1,Nf); pwelch_ci_hi = zeros(1,Nf); pwelch_ci_lo = zeros(1,Nf);
            for i =1:Nf
                xcol = x(:,i);
                x_notnans = xcol(~isnan( xcol )); 
               
                res = quantci(x = x_notnans, pquant = 0.5, prob = 90);
                probs(i) = res.probability;
                pwelch_ci_lo(i) =  res.ci(1);
                pwelch_ci_hi(i) =  res.ci(2);
                pwelch_mean(i) = res.quantile;
            end
            disp(['Minimum CI probability for group: ' group ' was: '  num2str(  min(probs) ) '.']);
            %hold on; scatter( pwelch_f+1 , x );

            pwelch_ci_lo(pwelch_ci_lo<0)=0+eps;  % plotting reasons
            pwelch_ci_hi(pwelch_ci_hi<0)=0+eps;

        end
    
    end

end

function  plot_pwelch_means_Cx_vs_Treat_ZOOM(TsubRes)
hax = gca;

group = 'TREAT';
[pwelch_mean ,  pwelch_ci_lo, pwelch_ci_hi, pwelch_f] = getPWELCH_ci(TsubRes, group);
hp2 = plot(pwelch_f+1,pwelch_mean,'Color',plt.colors.( group  )  ); hold on;
hs2 = confidenceshade( pwelch_f+1 , pwelch_ci_lo , pwelch_ci_hi , Color='r' ); 

group = 'CTRL';
[pwelch_mean , pwelch_ci_lo, pwelch_ci_hi , pwelch_f] = getPWELCH_ci(TsubRes, group);
hp1 = plot(pwelch_f+1,pwelch_mean,'Color',plt.colors.( group  )   );  hold on;
hs1 = confidenceshade( pwelch_f+1 , pwelch_ci_lo , pwelch_ci_hi , Color='k' );% for normal distribution CI

hax = gca;
%hax.XScale ="log";
hax.YScale = "log";
hax.Box ="on";

hax.XLim = [50 700];
hax.YLim = [10^-8 10^-5];

xlabel(plt.labelfreqHz);


% % ticks
% hax.XTick =[80 100 300 500 700];
 hax.YTick = [10^-8 10^-7 10^-6 10^-5];

%ylabel(plt.labelpsd);
%legend([hp1 hp2],{'Control', 'FCD'},'Location','southwest');
title('Avg.PSD, GR+FRs');
%format_axes(hax);
squareaxis(hax);
    function [pwelch_mean ,  pwelch_ci_lo, pwelch_ci_hi, pwelch_f ] =  getPWELCH_ci(TsubRes, group)
        
        x = double( cell2mat( TsubRes.IEDpwelch(  TsubRes.Role ==  group  )  ) );
        if ~isempty(x)
            idxTrue = find(TsubRes.Role ==  group);
            pwelch_f  = TsubRes.IEDfwelch{  idxTrue(1)   }; % get freq vector from somewhere
            
            % mean
            pwelch_mean = nanmean(x,1); 
                       
            % ci normal - parametric   for <30 samples
%             p_alpha = 0.05;
%             nsamples = x;
%             nsamples(~isnan(nsamples))=1; nsamples(isnan(nsamples))=0  ;
%             nsamples = sum(nsamples,1);
%             df = nsamples     -1;  % number of samples minus one
%             pwelch_ci_lo = pwelch_mean - nansem(x).*tinv(1-p_alpha/2,df); 
%             pwelch_ci_hi = pwelch_mean + nansem(x).*tinv(1-p_alpha/2,df);

            % ci non parametric for median - exact method - very small sample size
            Nf = size(pwelch_f,2);
            probs = zeros(1,Nf); pwelch_ci_hi = zeros(1,Nf); pwelch_ci_lo = zeros(1,Nf);
            for i =1:Nf
                xcol = x(:,i);
                x_notnans = xcol(~isnan( xcol )); 
               
                res = quantci(x = x_notnans, pquant = 0.5, prob = 90);
                probs(i) = res.probability;
                pwelch_ci_lo(i) =  res.ci(1);
                pwelch_ci_hi(i) =  res.ci(2);
                pwelch_mean(i) = res.quantile;
            end
            disp(['Minimum CI probability for group: ' group ' was: '  num2str(  min(probs) ) '.']);
            %hold on; scatter( pwelch_f+1 , x );

            pwelch_ci_lo(pwelch_ci_lo<0)=0+eps;  % plotting reasons
            pwelch_ci_hi(pwelch_ci_hi<0)=0+eps;

        end
    
    end

end


% function [pwelch_f, pwelch_mean_TREAT,pwelch_sems_TREAT,pwelch_mean_CTRL,pwelch_sems_CTRL] =  plot_pwelch_means_Cx_vs_Treat(TsubRes)
% hax = gca;
% 
% group = 'TREAT';
% [pwelch_mean , pwelch_sems, pwelch_f] = getPWELCHmeansems(TsubRes, group);
% [pwelch_conf_n,pwelch_conf_p] = pwelchmeansem2confs(pwelch_mean , pwelch_sems);
% min_pw = min(pwelch_conf_n);
% if min_pw<0, lift_pw = -min_pw; end;
% 
% hp2 = plot(pwelch_f+1,pwelch_mean,'Color',plt.colors.( group  )  ); hold on;
% hs2 = confidenceshade( pwelch_f+1 , pwelch_conf_n , pwelch_conf_p , Color='r' ); % for normal distribution CI
% hs2 = confidenceshade( pwelch_f+1 , pwelch_mean - pwelch_sems , pwelch_mean + pwelch_sems, Color='r' );
% %for diff graph
% pwelch_mean_TREAT = pwelch_mean;
% pwelch_sems_TREAT = pwelch_sems;
% 
% group = 'CTRL';
% [pwelch_mean , pwelch_sems, pwelch_f] = getPWELCHmeansems(TsubRes, group);
% [pwelch_conf_n,pwelch_conf_p] = pwelchmeansem2confs(pwelch_mean , pwelch_sems);
% hp1 = plot(pwelch_f+1,pwelch_mean,'Color',plt.colors.( group  )   );  hold on;
% hs1 = confidenceshade( pwelch_f+1 , pwelch_conf_n , pwelch_conf_p, Color='k' );% for normal distribution CI
% set(gca, 'XScale', 'log', 'YScale','log');
% %for diff graph
% pwelch_mean_CTRL = pwelch_mean;
% pwelch_sems_CTRL = pwelch_sems;
% 
% formatAsPSDplot();
% 
% ticks
% hax.XTick =[1 10 100 1000];
% hax.YTick = [10^-8 10^-6 10^-4 10^-2];
% 
% ylabel(plt.labelpsd);
% legend([hp1 hp2],{'Control', 'FCD'},'Location','southwest');
% title('Averaged PSD');
% format_axes(hax);
% squareaxis(hax);
% 
%     function [pwelch_conf_n,pwelch_conf_p] = pwelchmeansem2confs(pwelch_mean , pwelch_sems)
%         pwelch_conf_n = pwelch_mean - pwelch_sems*1.96;
%         pwelch_conf_p = pwelch_mean + pwelch_sems*1.96;
%         pwelch_conf_n(pwelch_conf_n<0)=0+eps;
%         pwelch_conf_p(pwelch_conf_p<0)=0+eps;
%     end
% 
% end



%function plot_pwelch_diff(pwelch_f, pwelch_mean_TREAT,pwelch_sems_TREAT,pwelch_mean_CTRL,pwelch_sems_CTRL)
function plot_pwelch_ratio(TsubRes)

group = 'TREAT';
[pwelch_mean_TREAT,pwelch_f] = getPWELCH_data(TsubRes, group);

group = 'CTRL';
[pwelch_mean_CTRL, pwelch_f ] = getPWELCH_data(TsubRes, group);

pwelch_ratio_mean=(pwelch_mean_TREAT./pwelch_mean_CTRL);
%pwelch_ratio_sem = pwelch_ratio_mean.*sqrt(  (pwelch_sems_TREAT./pwelch_mean_TREAT).^2 + (pwelch_sems_CTRL./pwelch_mean_CTRL).^2 );

% https://en.wikipedia.org/wiki/Propagation_of_uncertainty
% |A/B| * sqrt( (sA/A) ² + (sB/B)² )

hp_d = plot(pwelch_f+1,pwelch_ratio_mean,'Color',plt.colors.( 'TREAT' )  );  hold on; % mean ratio line
%hs_d= confidenceshade( pwelch_f+1 ,  pwelch_ratio_mean - pwelch_ratio_sem*1.96  ,  pwelch_ratio_mean + pwelch_ratio_sem*1.96 , Color='k' ); % for normal distribution CI

hax = gca;
%set(hax, 'XScale', 'log', 'YScale','log');
set(gca,'XScale','log');
%grid on
% ylim([10^-9 10^-2]);
ylim([0 7]);
xlim([1 2*10^3]);
xlabel(plt.labelfreqHz);
ylabel('FCD/Cx PSD ratio')

% ticks
hax.XTick =[1 10 100 1000];

box on;
%ylabel(plt.labelpsdratio);
title('PSDs comparison');
%format_axes(hax);
squareaxis(hax);
ylimoptimal(PercentMargin = plt.OptimAxLimOffsetPercentage);
  function [pwelch_mean , pwelch_f ] =  getPWELCH_data(TsubRes, group)
        
        x = double( cell2mat( TsubRes.IEDpwelch(  TsubRes.Role ==  group  )  ) );
        if ~isempty(x)
            idxTrue = find(TsubRes.Role ==  group);
            pwelch_f  = TsubRes.IEDfwelch{  idxTrue(1)   }; % get freq vector from somewhere
            
            % mean
            pwelch_mean = nanmean(x,1); 
        end
  end

end



function plot_pieIEDs(pieData)
hax = gca;

labelsDetTypes = {'IED without HFOs','GR',['FR+GR'],'FR'};
for i=1:numel(labelsDetTypes )
    switch i
        case 1
            labelsPerc{i} = ['\fontsize{' num2str(plt.FontSizeAnnotate) '}' sprintf('%s \n(%.1f%%)', labelsDetTypes {i}, 100*pieData(i))   ];  % newline   
        otherwise
            labelsPerc{i} = ['\fontsize{' num2str(plt.FontSizeAnnotate) '}' sprintf('%s (%.1f%%)', labelsDetTypes {i}, 100*pieData(i))   ];
    end
end
pieHandle = pie(pieData,labelsPerc);

%pieHandle = pie(pieData,labelsPerc);
colors = favouritecolors({'w','k','red','premeksskin'});
posLabel = 0.13+[0.55 1.1 1.45 1.2];
for iHandle = 2:2:2*numel(labelsPerc)
    pieHandle(iHandle-1).FaceColor=colors(iHandle/2,:);
    pieHandle(iHandle).Position = posLabel(iHandle/2)*pieHandle(iHandle).Position;  
end
[pieHandle([1 3 5 7]).EdgeColor] = deal('none');  % remove black line around the shit piece
hc = viscircles([0 0],1);
hc.Children(1).LineWidth =0.5;
hc.Children(2).LineWidth =0.5;
hc.Children(1).Color = 'k';
hc.Children(2).Color = 'k';
% rotate
hax.View = [180 90];
% squareaxis
title('IEDs and HFOs');

hax.XAxis.Visible = false;
hax.YAxis.Visible = false;

%format_axes(hax);
squareaxis(hax);
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% function format_axes(hax)
% arguments 
%     hax = gca;
% end
% hax.FontSize = plt.FontSize; % premeks favourite
% hax.LabelFontSizeMultiplier = 1; % prevent font size from changing
% 
% % Line width
% setall('LineWidth',0.4);
% 
% % Title format
% hax.Title.FontSize=plt.FontSize;
% hax.Title.FontWeight='normal';
% 
% hax.TitleFontWeight ="normal";
% hax.TitleFontSizeMultiplier=1;
% 
% Nstr = numel(hax.Title.String);
% for i =1:Nstr
%     switch class(hax.Title.String)
%         case 'char'
%             hax.Title.String=[ '\fontsize{' num2str(plt.FontSize) '}' hax.Title.String ];
%         case 'cell'
%             hax.Title.String{i}=[ '\fontsize{' num2str(plt.FontSize) '}' hax.Title.String{i} ];
%     end
% end
% %
% 
% % set length of ticks
% set(hax, 'Units', 'centimeters');
% pos = hax.Position;
% height_cm = pos(4);
% desired_length = 0.05; %cm
% normalized_length = desired_length./height_cm;
% hax.TickLength = [normalized_length, 0.01];
% 
% 
% % disable labels rotation
% hax.XTickLabelRotationMode="manual";
% hax.XTickLabelRotation=0;
% 
% trueblackaxis(hax);
% scientificfontcompact;
% 
% end
