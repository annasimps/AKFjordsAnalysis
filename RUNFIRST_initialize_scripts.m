%%% This script should be run first before starting to run any of the other
%%% scripts. It will set things up, so that while running the rest of the
%%% scripts for this project, the pathnames to the specific functions are
%%% already lined up and will run automatically
%%% 
%%% 1.) Set the rootdir, which is the root directory for wherever the google
%%% drive folder lives on your computer. 
%%% 2.) Run this script

% root directory
rootdir = '/Users/annasimpson/Library/CloudStorage/GoogleDrive-simpanna@oregonstate.edu/Shared drives/';% ['/Volumes/GoogleDrive/Shared drives/']; %laptop
% rootdir =
% '/Users/annasimpson/Library/CloudStorage/GoogleDrive-simpanna@oregonstate.edu/Shared drives/'; % work computer
% adds the root directory with the Alaska project folder into your matlab
% path, so everything will be found
addpath = addpath(genpath([rootdir '/2 Alaska Fjord Data Gathering Project']));

% Undocked figure window is necesary for the mapping functions that are
% used
set(0,'DefaultFigureWindowStyle','normal')