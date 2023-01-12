
% tady se nebude nic menit
% amplitudy u kontrol jsou 4x zvetsene, ok
%%%

% plotting algo
% data selection

rmpath('testing','full','full_strict');
addpath('full_strict');

fs = 5000;
load(a.pwd('Tied.mat')); 
analysis_HFOsDetection; % set some breakpoints here and launch the plotting function from inside


%%

rmpath('testing','full','full_strict');
addpath('full_strict');
addpath('full');

load(a.pwd('Tiedf.mat')); 

%%

inds = Tiedf.Role =='CTRL' & Tiedf.ChName == 'L';     % IEDampl_mV
%inds = Tiedf.Role =='CTRL' & Tiedf.HasFR;     % IEDampl_mV
mice=unique(Tiedf.Subject(inds));
inds3=[];

% with sorting
which_inds = [1 2];
%which_inds = [4 5];
which_inds = [2 3];
which_inds = [2 4];


inds2 = find( inds & Tiedf.Subject==mice(1) ); [samp,si] = sort(Tiedf.IEDampl_mV(inds2),'descend'); inds2 = inds2(si);
inds3 = [inds3 ; inds2(which_inds) ];
inds2 = find( inds & Tiedf.Subject==mice(2) ); [samp,si] = sort(Tiedf.IEDampl_mV(inds2),'descend'); inds2 = inds2(si);
inds3 = [inds3 ; inds2(which_inds) ];
inds2 = find( inds & Tiedf.Subject==mice(3) ); [samp,si] = sort(Tiedf.IEDampl_mV(inds2),'descend'); inds2 = inds2(si);
inds3 = [inds3 ; inds2(which_inds) ];
inds2 = find( inds & Tiedf.Subject==mice(4) ); [samp,si] = sort(Tiedf.IEDampl_mV(inds2),'descend'); inds2 = inds2(si);
inds3 = [inds3 ; inds2(which_inds) ];

s =  loadfun(plt.loadSignalIED, Tiedf.Signal(inds3) );
% Now the signal files are loaded and we can pick from them

%%

figurefull;

% h_subplot = @(m,n,p) subtightplot (m, n, p, [0.05658 0.0565], [0.081 0.051], [0.0998 0.0293]);
h_subplot = @(m,n,p) subtightplot (m, n, p, [0.05658 0.0565], [0.081 0.051], [0.0998 0.0293]);
h_subplot = @(m,n,p) subtightplot (m, n, p, [0.06658 0.0925], [0.081 0.051], [0.0998 0.0293]);
h_subplot = @(m,n,p) subtightplot (m, n, p, [0.06658 0.0925], [0.025 0.025], [0.025 0.025]);
%ax_layout
[hax] = layoutaxesrows(h_subplot,[1 1 1],[1 1],[1 1],[1 1]);



for i = 1:6
    ha = hax(i); 
    axes(ha);

    plot_single3line_trace(s,i);

    %set(gca,'Units','centimeters');
    %resizeaxes_center([3.85,2.53]);
  
end


resize2cm(9.2,9.5);

% set(gca,'Units','centimeters');
% resizeaxes_center([3.85,2.53]);
% set(gca,'Units','normalized');

%exportgraphics(gcf, 'kokoti.pdf','BackgroundColor', 'none','ContentType','vector')


function plot_single3line_trace(s,selInd)
%
fs = 5000;
%plot(s(1,:))
%fvtool(b,1,Analysis="freq")

hold on;
s3 = [];
s3(1,:) = s(selInd,:) ;
s3(2,:)= filtfilt(plt.bpR,s(selInd,:));
s3(3,:) = filtfilt(plt.bpFR,s(selInd,:));

Ns = 4;
s3 = filtfilt(ones(1,Ns)/Ns,1,s3')';

sI = 1700; 
eI = 3400;
%sI=1; eI=5000;
s3 = s3(:,sI:eI);
scl=4;

h(1) =plot( 0.1+s3(1,:));
h(2) =plot( -1.15+ scl*s3(2,:));
h(3) =plot( -2.0+ scl*s3(3,:));

% if selInd ==5
%     figurefull;
%     plotstockwell(s3(1,:)',fs,1.8,[1 1000],50,'linear');
% end

set(gca,'YLim',[0.5-3.5 0.5+0.2]);
[h.Color]=deal('k');

% no axis and fit
hideaxis()
xaxisfitdata();
%setall('LineWidth',0.5)
%
% set(gca,'Units','centimeters');
% resizeaxes_center([3.85,2.53]);
% set(gca,'Units','normalized');

%resize2cm(4.0,2.5)
trueblackaxis();
end