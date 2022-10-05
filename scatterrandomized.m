function hb1 = scatterrandomized(nv)
%SCATTERRANDOM Summary of this function goes here
%   Detailed explanation goes here
% varargin{1} = Cloud Width
arguments 
    nv.CloudWidth=0.1;
    nv.ScatterParams;
end

y=nv.ScatterParams{2};
N=numel(y);

offsets = nv.CloudWidth*rand(size(y)) - 0.5*nv.CloudWidth;

hb1 = scatter(nv.ScatterParams{1} + offsets,nv.ScatterParams{2:end}); 

end

