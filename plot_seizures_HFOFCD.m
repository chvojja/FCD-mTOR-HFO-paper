
%% Get info about mice

path_mouse_root = '\\neurodata\Lab Neurophysiology root\EEG Naty\mTOR MUT';
T = readtable([ path_mouse_root '\zachvatujici_mysi_Naty.xlsx' ]);
empty_inds = cellfun(@isempty,T.Plasmid);
T( empty_inds , : ) = [];

%% Get lbl files for particular EarTags

% dc_extra = getLbl3DirContentsBy_path_ET('\\neurodata\Lab Neurophysiology root\EEG conversion',[339; 283]); %10.1.2021  11.11.2020
% dc_mTOR = getLbl3DirContentsBy_path_ET('\\neurodata\Lab Neurophysiology root\EEG Naty\mTOR MUT',[343; 413]);
% 
% dc = [dc_extra; dc_mTOR];


etags = [339 283 343 413];
EEGtimes_days = [171 291 51 221]*2/24; % in days

%dirContents_lbl3_1 = getLbl3DirContentsBy_path('\\neurodata\Lab Neurophysiology root\EEG conversion');
% dirContents_lbl3_2 = getLbl3DirContentsBy_path('\\neurodata\Lab Neurophysiology root\EEG Naty\mTOR MUT');
% dirContents_lbl3_2 = getLbl3DirContentsBy_path('\\neurodata\Lab Neurophysiology root\EEG Naty');
dirContents_lbl3 = [getLbl3DirContentsBy_path('\\neurodata\Lab Neurophysiology root\EEG Naty');,...
                    ];

dirContents_lbl3 = dirContents_lbl3( ismember([dirContents_lbl3.etag],etags) ); %  filter by eartags



%% Plotting
stats_seizure=struct('Nseizures',[],'mean_freq',[],'mean_dur',[],'earliest_seizure_days',[],'etag',[]);  
for etag = etags

    row = T.ET == etag;
    startTime = datetime(   T.DOB(row)   , 'InputFormat', 'dd.MM.yyyy');

    files_singe_etag_logi = strcmp({dirContents_lbl3.etag}, num2str(etag) );
    dirContents_one_mouse =  dirContents_lbl3( ismember([dirContents_lbl3.etag],etag) );
    
    [ lblPosDT, lblDurS ] = get_seizurecounts( {dirContents_one_mouse.fpath} , etag,startTime);
    %plot_seizures_etag_startTime(lblPosDT, lblDurS , startTime,etag);

    lblPosDT = lblPosDT - startTime;
    lblPosDT.Format= 'd';

    statOne.Nseizures = numel(lblDurS);
    statOne.mean_freq = statOne.Nseizures/EEGtimes_days(etags==etag);
    statOne.mean_dur = mean(lblDurS);
    statOne.etag = etag;

    statOne.earliest_seizure_days = days(lblPosDT(1));

    

    stats_seizure = [stats_seizure; statOne];


    

    %pause
%     fpath_fig = fullfile(path_mouse_root , [num2str(etag) '.fig' ]);
%     %mkdir(fpath_fig); 
%     savefig(gcf,fpath_fig);
%     close(gcf);
end

stats_seizure(1) = [];
stats_seizure_cohort.freq_days = printmeansemmedian_HFOpaper( [ stats_seizure.mean_freq ] );
stats_seizure_cohort.dur_sec = printmeansemmedian_HFOpaper( [ stats_seizure.mean_dur ] );
stats_seizure_cohort.earliest_seizure_days = printmeansemmedian_HFOpaper( [ stats_seizure.earliest_seizure_days ] );

save7fp = a.pwd('stats_seizure.mat'); save7
save7fp = a.pwd('stats_seizure_cohort.mat'); save7

%%

function  [ lblPosDT, lblDurS ] = get_seizurecounts(filepn,etag,startTime)

%className = "Seizure"; % ClassName to plot
minValue = 5; % Labels with value < minValue will be not plotted



%% Get the data
%filepn = getFilepn('Browse lbl3 files', 'on'); % Get files path and names

l = load(filepn{1});
subject = l.sigInfo.Subject(1);
if ~all(subject == l.sigInfo.Subject) % Check if Subject is the same in all channels
    error('Multiple subjects in the first file')
end
signalGood = [];
lblPosDT = [];
lblDurS = [];
lblVal = [];
for k =1 : length(filepn)
    l = load(filepn{k});
    if ~all(subject == l.sigInfo.Subject) % Check the subject
        %error(['Multiple subjects in the data set. Last loaded file:', 10, filepn{k}])
        disp('error subject')
        continue
    end
    signalGood = [signalGood; max(l.sigInfo.SigStart), min(l.sigInfo.SigEnd)];
    % lbl = l.lblSet(l.lblSet.ClassName == className, :); % Seizure positions in datetime
    lbl = l.lblSet;
    lblPosDT = [lblPosDT; lbl.Start]; % Position in datetime format
%     if datenum(lbl.End - lbl.Start)<0
%         lbl
%         disp('shit')
%     end
    lblDurS = [lblDurS; abs(datenum(lbl.End - lbl.Start)*24*3600) ]; % Duration in days
    lblVal = [lblVal; lbl.Value]; %#ok<*AGROW>
end

[lblPosDT,lblDurS,lblVal] = sort2(lblPosDT,lblDurS,lblVal); % sort labels
lblDurS = abs(lblDurS);

% Remove labels with too low value (probably unsure labels)
lblPosDT = lblPosDT(lblVal >= minValue);
lblDurS = lblDurS(lblVal >= minValue);
lblVal = lblVal(lblVal >= minValue); %#ok<NASGU>

sec_betweenLabels = datenum(diff(lblPosDT))*24*3600;
b_between_labels_mismatch = any(sec_betweenLabels-lblDurS(1:end-1) <0);
if b_between_labels_mismatch
    disp(['labels shitty time mismatch between labels, etag: ' num2str(etag) ]);
end  

%startTime = datetime(   , 'InputFormat', 'dd.MM.yyyy');


end


% Functions


function plot_seizures_etag_startTime(lblPosDT, lblDurS , startTime,etag)
figure
    lblWidth = 1;
    lblColor = [0.8 0.1 0];
    
    figurePosition = [200 500 1500 400];
    
    % Convert to days from the day of birth (DOB)
    lblPosDT = lblPosDT - startTime;
    lblPosDT.Format = 'd';
    
    % % Recording 2p
    % scatter(recording2p, zeros(size(recording2p)), '^k', 'MarkerFaceColor', 'k')
    hold on
    
    % Labels
    stem(lblPosDT, lblDurS, 'Color', lblColor, 'LineWidth', lblWidth, 'Marker', 'none')
    
    % Graph labels
    xlabel('Age (days)')
    ylabel('Duration (s)')
    %title(['Subject "', char(subject), '"']);
    title(['Subject "', num2str(etag) , '"']);
    % title(['Subject "', char(subject), '", label class "', char(className), '"'])
    % Formatting
    hf = gcf;
    hf.Position = figurePosition;
    hax = gca;
    hax.XLim(1) = hax.XLim(1)*0;
    hax.XLim(2) = duration('160:00:00:00', 'InputFormat', 'dd:hh:mm:ss');

end

function dirContents_lbl3 = getLbl3DirContentsBy_path_ET(root_path, etags)

    dirContents_lbl3 = getLbl3DirContentsBy_path(root_path);
    selInd = ismember([dirContents_lbl3.etag],etags);
    dirContents_lbl3 = dirContents_lbl3(selInd);

end

function dirContents_lbl3 = getLbl3DirContentsBy_path(root_path)

    path_lbl3 = [root_path '\**\*lbl3.mat'];
    dirContents_lbl3=dir(path_lbl3); 
    for i = 1:size(dirContents_lbl3,1)
    
        [ ~ , path_rest ] = splitpath(  dirContents_lbl3(i).folder   , ByFolder= previousFolder(root_path,0) );
        
        subjectNumber = regexp( path_rest , '\d\d\d','match','once') ;
        dirContents_lbl3(i).etag = str2double(subjectNumber);
        dirContents_lbl3(i).fpath =  [ dirContents_lbl3(i).folder '\' dirContents_lbl3(i).name ];
    end

end

% function filepn = getFilepn(prompt, multisel)
%     if exist('loadpath.mat', 'file')
%         load('loadpath.mat', 'loadpath'); % Second argument: which variable from the file should be loaded
%     else
%         loadpath = '';
%     end
%     [fn, fp] = uigetfile([loadpath, '\*.*'], prompt, 'MultiSelect', multisel); % File names, file path
%     if isa(fn, 'double')
%         filepn = [];
%         return
%     end
%     % If the user selected only one file, it is returned as a char array. Let's put it in a cell for consistency.
%     if ~iscell(fn)
%         filen{1} = fn;
%     else
%         filen = fn;
%     end
%     filep = fp;
%     filepn = fullfile(filep, filen);
%     loadpath = filep;
%     save('loadpath.mat', 'loadpath')
% end





