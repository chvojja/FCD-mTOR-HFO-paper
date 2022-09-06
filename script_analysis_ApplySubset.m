%% 


load(a.pwd('VKJeegSubsetIDs.mat')); % get subset

VKJeeg = VKJeeg( ismember(VKJeeg.ID,VKJeegSubsetIDs.ID) , :  ) ; % filter only selected IDs
VKJlbl = VKJlbl( ismember(VKJlbl.VKJeeg_ID,VKJeegSubsetIDs.ID) , :  ) ;


save7fp = a.pwd('VKJeeg.mat'); save7
save7fp = a.pwd('VKJlbl.mat'); save7