%%% Combine the static characteristics with the fjord_profiles_num dataset


rootdir = '/Volumes/GoogleDrive/Shared drives/';

% get static characteristics for each fjord
load([rootdir '2 Alaska Fjord Data Gathering Project/Data/data_output/fjord_static_characteristics.mat']);


% directory where the files are located
fdir = dir([rootdir '2 Alaska Fjord Data Gathering Project/Data/data_output/fjord_profiles_num/*.mat']);

%directory to save files to
fdir2save = [rootdir '/2 Alaska Fjord Data Gathering Project/Data/data_output/fjord_data_final/'];


%% Combine static characteristics + profile data
% loop through each file in the directory and add the static
% characteristics to the appropriate file and save it out into a new
% directory
castnumyr = [1945:2022];
clear prof_num
prof_num.yr = castnumyr;
prof_num.win = NaN*ones(length(fjord.lat),length(castnumyr));
prof_num.sum = NaN*ones(length(fjord.lat),length(castnumyr));
prof_num.spr = NaN*ones(length(fjord.lat),length(castnumyr));
prof_num.fal = NaN*ones(length(fjord.lat),length(castnumyr));
prof_num.tot = NaN*ones(length(fjord.lat),length(castnumyr));

for ff = 1:length(fdir)
    clear fjord_casts
    load([fdir(ff).folder '/' fdir(ff).name])
    
    indchar = find(contains(fjord.name,fjord_casts.name));
    
    fjord_casts.geog_region = fjord.geog_region{indchar};
    fjord_casts.climate_div = fjord.climate_div{indchar};
    fjord_casts.glacier_name = fjord.glacier_name{indchar};
    fjord_casts.glac_category = fjord.glac_category{indchar};
    fjord_casts.outer_sill_depth = fjord.outer_sill_depth(indchar);
    fjord_casts.deepest_depth = fjord.deepest_depth(indchar);
    fjord_casts.width_outer_sill = fjord.width_outer_sill(indchar);
    fjord_casts.width_glac_term = fjord.width_glac_term(indchar);
    fjord_casts.num_inner_sills = fjord.num_inner_sills(indchar);
    fjord_casts.centerline_length = fjord.centerline_length(indchar);
  
    
    save([fdir2save fjord_casts.name '.mat'] ,'fjord_casts')
   
   prof_num.win(indchar,:) = fjord_casts.profnum_seas.win;
   prof_num.spr(indchar,:) = fjord_casts.profnum_seas.spr;
   prof_num.sum(indchar,:) = fjord_casts.profnum_seas.sum;
   prof_num.fal(indchar,:) = fjord_casts.profnum_seas.fal;
   prof_num.tot(indchar,:) = fjord_casts.profnum_seas.win+fjord_casts.profnum_seas.spr+fjord_casts.profnum_seas.sum+fjord_casts.profnum_seas.fal;
end

fjord.prof_num = prof_num;

 %% Add the temprature, salinity, depth data in profile form back into the dataset
 
 % First initialize the matrices
 
 for n = 1:length(fjord.lat)
     fjord.casts(n).lat = [];
     fjord.casts(n).lon = [];
     fjord.casts(n).time = [];
     fjord.casts(n).z = [];
     fjord.casts(n).T = [];
     fjord.casts(n).S = [];
     fjord.casts(n).link = {};
     fjord.casts(n).doi = {};
 end
 
 for ff = 1:length(fdir)
    clear fjord_casts
    load([fdir(ff).folder '/' fdir(ff).name])
    
    indchar = find(contains(fjord.name,fjord_casts.name));
    
    fjord.casts(indchar).lat = fjord_casts.lat;
    fjord.casts(indchar).lon = fjord_casts.lon;
    fjord.casts(indchar).time = fjord_casts.time;
    fjord.casts(indchar).z = fjord_casts.z;
    fjord.casts(indchar).T = fjord_casts.T;
    fjord.casts(indchar).S = fjord_casts.S;
    fjord.casts(indchar).link = fjord_casts.link;
    fjord.casts(indchar).doi = fjord_casts.doi;
 end
 
 % Quality cotrol the data
 save([rootdir '2 Alaska Fjord Data Gathering Project/Data/data_output/fjord_data_combined.mat'],'fjord')
 
 
 
 
 

