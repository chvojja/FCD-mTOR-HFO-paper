%%%%%%%%%%%%%%%%%%%%%%%
clear all
fs = 5000;

%% Create cohort and gather info about subjects
% full
%rmpath('testing'); addpath('full');
% testing
%rmpath('full'); addpath('testing');

rmpath('testing','full','full_strict','full_dontmiss','full_hfoloose');
addpath('full_dontmiss');
%addpath('full_hfoloose');
%addpath('full');