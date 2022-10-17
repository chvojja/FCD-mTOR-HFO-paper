




% tic
% s = readvar( Files = flist , ReadFun = @(x)loadbin(x, [1,5000] , 'double' ), CatDim = 1 );
% toc
% 
% 


%fhandle =  @(x)loadbin(x, [1,5000] , 'double' );

tic

s = loadfun(plt.loadSignalIED,flist);

toc