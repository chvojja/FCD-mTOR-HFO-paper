% testing datastore





% 
% folder = fullfile('D:\temp_FCD_analyza_1Full','toolbox','matlab','demos');
% fs = matlab.io.datastore.DsFileSet(folder,...
%                  'IncludeSubfolders',true,...
%                  'FileExtensions','.mat');
N = 59297;
N = 30000;
tic
for i = 1:N % round(size(Tiedd,1)/2)
    nameStr = num2str(Tiedd.ID(i));
    x = Tiedd.Signal{i};
    %save7fp = ['D:\temp_FCD_analyza_1Full\Tied\Signal\'  '.mat']; save7;  
    save(  ['D:\temp_FCD_analyza_1Full\Tied\Signal\' , nameStr , '.mat']    , 'x'  , '-v7');
end
toc

% 59297


tic
for i = 1:N % round(size(Tiedd,1)/2)
    nameStr = num2str(Tiedd.ID(i));
    x = Tiedd.Signal{i};
    %save7fp = ['D:\temp_FCD_analyza_1Full\Tied\Signal\'  '.mat']; save7;  
    %save(  ['D:\temp_FCD_analyza_1Full\Tied\Signal\' , nameStr , '.mat']    , 'x'  , '-v7');
    save(  ['D:\temp_FCD_analyza_1Full\Tied\Signal\' , nameStr , '.mat']    , 'x'  , '-v7','-nocompression');
end
toc

tic
for i = 1:N % round(size(Tiedd,1)/2)
    nameStr = num2str(Tiedd.ID(i));
    x = Tiedd.Signal{i};
    savebin( ['D:\temp_FCD_analyza_1Full\Tied\SignalDat\' , nameStr , '.dat'] , x );
end
toc

%  x = cell2mat(  Tiedd.Signal(1:N) );
%  nameStr = ['Signal_1_' num2str(N) ];
%  save(  ['D:\temp_FCD_analyza_1Full\Tied\' , nameStr , '.mat']    , 'x'  , '-v7');
%  save(  ['D:\temp_FCD_analyza_1Full\Tied\' , nameStr , '2.mat']    , 'x'  , '-v7','-nocompression');

%%
folder = 'D:\temp_FCD_analyza_1Full\Tied\Signal';
%fs = matlab.io.datastore.DsFileSet(folder,'IncludeSubfolders',false,'FileExtensions','.mat');



%%
fds = fileDatastore( folder ,"ReadFcn",@loaddata,"FileExtensions",".mat",'UniformRead',true);
%fds = fileDatastore( folder ,"ReadFcn",@load,"FileExtensions",".mat",'UniformRead',true);
N = numel(fds.Files);
x = zeros(N,5000); % using cell for efficiency

reset(fds); % reset to the beginning of the fileset


tic
ss2 = readall(fds);
toc

tic
i = 1;
while hasdata(fds)       
    x(i,:) = read(fds);
    i = i+1;
end
toc

% tic
% for i = 1:N
%     x(i,:) = read(fds);
% end
% toc

%%


y = loadbin(filepath, dim, precision)


%%

allFiles = vertcat(ft{:});


%%





