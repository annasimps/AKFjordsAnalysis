%%% Use this script after plotting all profiles onto a map to select
%%% profiles in a certain area to make a bar graph of numbers of profiles
%%% split by year and season. 

%%% 1. latitude/longitude of the ctd profiles will be plotted on a map
%%% created by plot_profile_data.m
%%% 2. Zoom in on region on the map that you'll want to select
%%% 3. Prompted to select region: y/n
%%% 4. Then put points on map to outline region you want the points inside
%%% of 
%%% 5. Points will turn red
%%% 6. Prompt if pts are ok: y/n
%%% 7. Prompt to select fjord name from list: Enter number from the list
%%% 8. Prompt to input fjord name: Type name of Fjord 
%%% 9. The bar figure will be made with number of data points per season,
%%% per year
%%% 10. Prompt if you want to select another region: y/n

%%% Anna Simpson
%%% June 1, 2022

%% load color vectors
colors = load([rootdir '2 Alaska Fjord Data Gathering Project/code/functions/color.mat']);
colors = colors.color;

%% Get Fjord names & characteristics
get_static_characteristics
%% load the profile data
load([rootdir '2 Alaska Fjord Data Gathering Project/Data/data_output/profile_data_matrix.mat'])

%% Plot a map of the profile data
plot_profile_data_location

%% Set up structure to put the number of profiles for each season for each fjord
profile_num.lat = fjord.lat;
profile_num.lon = fjord.lon;
profile_num.name = fjord.name;
profile_num.year = [1945:2022];


geoscatter(profile_num.lat,profile_num.lon,'r*')
aa = 1;
%% Section where the selection actually takes place
% for aa = 1:length(profile_num.lat)

rid = input('select region to get profiles from [y/n] ', 's');
while(rid == 'y')
    
    pnum.win = NaN*ones(length(profile_num.year));
    pnum.spr = NaN*ones(length(profile_num.year));
    pnum.sum = NaN*ones(length(profile_num.year));
    pnum.fal = NaN*ones(length(profile_num.year));
    
     disp('Zoom in on area to get profiles from')
     pause

    disp('Select points to plot')
    [xb,yb] = ginput;
    
    indfjordint = inpolygon(profile_num.lat,profile_num.lon,xb,yb);
    
    indfjord = find(indfjordint ==1);
    if length(indfjord)>1
        disp(profile_num.name(indfjord))
        kk = input('Which fjord name to use?','s');
        indfj = indfjord(str2num(kk));
        fjord2use = profile_num.name(indfj);
        
    else
        indfj = indfjord;
        fjord2use = profile_num.name(indfj);
    end
    
    geoscatter(profile_num.lat(indfj),profile_num.lon(indfj),'g*')
    disp(['Fjord Selected:' fjord.name{indfj}])
    
    fjord_casts.name = fjord.name{indfj};
    fjord_casts.fj_lat = profile_num.lat(indfj);
    fjord_casts.fj_lon = profile_num.lon(indfj);
    

    % determines indices inside polygon created
    indpts = inpolygon(profiles.lat,profiles.lon,xb,yb);
    
    
    % plots points on map in magenta
    if numel(indpts)
        ply = geoscatter(profiles.lat(indpts),profiles.lon(indpts),'m.');
    end
    
    % prompt if pts are ok
    aok = [];
    while numel(aok) == 0
        aok = input('ok? [y/n] ', 's')
    end
    
    if aok == 'n'
        ply = geoscatter(profiles.lat(indpts),profiles.lon(indpts),'k.');
         geoscatter(profile_num.lat(indfj),profile_num.lon(indfj),'c*')
    end
    
    if aok == 'y'
        
        % lat,lon,time selected for points in region selected
        fjord_casts.lat = profiles.lat(indpts);
        fjord_casts.lon = profiles.lon(indpts);
        fjord_casts.time = profiles.time(indpts);
        fjord_casts.z = profiles.z;
        fjord_casts.T = profiles.T(:,indpts);
        fjord_casts.S = profiles.S(:,indpts);
        indlink = find(indpts==1);
        fjord_casts.link = profiles.link(indlink);
        fjord_casts.doi = profiles.doi(indlink);


       geoscatter(profile_num.lat(indfj),profile_num.lon(indfj),'b*') 
    end
    
    % Save out individual file
    save([rootdir '2 Alaska Fjord Data Gathering Project/Data/data_output/fjord_profiles/' fjord_casts.name '.mat'] ,'fjord_casts')
    
    % Prompt user to select another region
    rid = input('select another fjord? [y/n] ', 's');
end


