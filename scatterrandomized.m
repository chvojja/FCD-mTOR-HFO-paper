function hb1 = scatterrandomized(varargin)
%SCATTERRANDOM Summary of this function goes here
%   Detailed explanation goes here
y=varargin{2};
N=numel(y);

offsets = 0.1*rand(size(y));

hb1 = scatter(varargin{1}+offsets,varargin{2:end}); 

end

