%%% Script to run through fjord .mat files and count the total number of
%%% casts, count the number of casts in each year, and separate out the
%%% casts by season. We then want to resave teh profiles into the new
%%% directory labeled fjord_profiles_num


colors = load([rootdir '2 Alaska Fjord Data Gathering Project/code/functions/color.mat']);
colors = colors.color;

% get Fjord names & static characteristics
get_static_characteristics

fdir = dir([rootdir '2 Alaska Fjord Data Gathering Project/Data/data_output/fjord_profiles/*.mat']);


%% Loop through each file to load in and do the counting

profile_num.lat = fjord.lat;
profile_num.lon = fjord.lon;
profile_num.name = fjord.name;
profile_num.year = [1945:2022];

for ff = 1:length(fdir)
    clear fjord_casts
    load([rootdir '2 Alaska Fjord Data Gathering Project/Data/data_output/fjord_profiles/' fdir(ff).name])
%     fjord_casts = rmfield(fjord_casts,'profnum_seas');
     mn = strfind(fdir(ff).name,'.mat');
    strname = fdir(ff).name(1:mn-1);
    
    % split time into dates
    dates = datetime(fjord_casts.time,'ConvertFrom','datenum','Format','yyyy-MM');
    yr = year(dates);
    mth = month(dates);
    yr_uniq = unique(yr); 
    seas(1,:) = [1,2,3];
    seas(2,:)= [4,5,6];
    seas(3,:)= [7,8,9];
    seas(4,:)= [10,11,12];
    
   
    
    % Initializing the matrix for the number of profiles in each season
    pnum.win = NaN*ones(1,length(profile_num.year));
    pnum.spr = NaN*ones(1,length(profile_num.year));
    pnum.sum = NaN*ones(1,length(profile_num.year));
    pnum.fal = NaN*ones(1,length(profile_num.year));
    
     % get the number of profiles per season for each year in the area
    clear prof_num
    for n = 1:length(yr_uniq)
        
        indyr = find(yr ==yr_uniq(n));
        month_yr = mth(indyr);
        
        for ss =1:4
                prof_num(n,ss) = length(find(month_yr>=seas(ss,1) & month_yr<=seas(ss,3))); 
        end
        
        inda = find(profile_num.year == yr_uniq(n));
        pnum.win(1,inda) = prof_num(n,1);
        pnum.spr(1,inda) = prof_num(n,2);
        pnum.sum(1,inda) = prof_num(n,3);
        pnum.fal(1,inda) = prof_num(n,4);
    end
    
    fjord_casts.profnum_seas = pnum;
    fjord_casts.profnum_seas.yr = profile_num.year;
    fjord_casts.totprof = length(fjord_casts.time);
    
    save([rootdir '2 Alaska Fjord Data Gathering Project/Data/data_output/fjord_profiles_num/' fjord_casts.name '.mat'] ,'fjord_casts')

end