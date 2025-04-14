%%% A script that outputs some key statistics regarding the amount of data
%%% in each fjord

%%% Anna Simpson


%% Load data
load([rootdir '2 Alaska Fjord Data Gathering Project/Data/data_output/fjord_data_combined.mat'])

avgTandS
%% Get % of fjords with data

% Across the whole region
 fjordwdat = nansum(fjord.prof_num.tot,2);
 indfjdat = find(fjordwdat>0);
 percfjdat = length(indfjdat)/length(fjordwdat);
 
 disp(['Number of fjords w/ Temp data: ' num2str(length(indfjdat)) ' or ' num2str(round(percfjdat*100)) '% of fjords'])
 
 % Number of fjords with temperature data

 avgallT = nanmean(fjord.avgT,3);
 indTemp = find(sum(isnan(avgallT),1)<200);
 
 % Number of fjords with Salinity data
 avgallS = nanmean(fjord.avgS,3);
 indSal = find(sum(isnan(avgallS),1)<200);
 
 disp(['Number of fjords w/ Temp & Sal data: ' num2str(length(indSal)) ' or ' num2str(round(length(indSal)/length(fjordwdat)*100)) '% of fjords'])
 
 
%% fjord locations with T/S data
geogTS = fjord.geog_region(indSal);
silldepthTS = fjord.outer_sill_depth(indSal);

regionnames = {'cook';'kenai';'prince';'yakutat';'southeast'};

for m = 1:length(regionnames)
    clear numreg
    clear indreg
    indreg = find(contains(geogTS,regionnames{m}));
    numreg = find(contains(fjord.geog_region,regionnames{m}));
    disp(['Num of fjords w/ T/S data in ' regionnames{m} ':' num2str(length(indreg)) ' or ' num2str(round(length(indreg)/length(numreg)*100)) '%'])
end

%% fjord locations with T data
geogT = fjord.geog_region(indTemp);
silldepthT = fjord.outer_sill_depth(indTemp);

regionnames = {'cook';'kenai';'prince';'yakutat';'southeast'};

for m = 1:length(regionnames)
    clear numreg
    clear indreg
    indreg = find(contains(geogT,regionnames{m}));
    numreg = find(contains(fjord.geog_region,regionnames{m}));
    disp(['Num of fjords w/ Temp data in ' regionnames{m} ':' num2str(length(indreg)) ' or ' num2str(round(length(indreg)/length(numreg)*100)) '%'])
end
%% Number of fjords in geographic region
georeg = unique(fjord.geog_region);

for m = 1:length(georeg)
    numgeog = length(find(contains(fjord.geog_region,georeg(m))));
    
    disp(['Number of fjords in ' georeg{m} ': ' num2str(numgeog)])
end

%% Number of fjords in climate divisions
climdiv = unique(fjord.climate_div);

for m = 1:length(climdiv)
    numclim = length(find(contains(fjord.climate_div,climdiv(m))));
    
    disp(['Number of fjords in ' climdiv{m} ': ' num2str(numclim)])
end
%% Sill depths of fjords with 

%% List the total number of profiles in each fjord
totalprof = nansum(fjord.prof_num.tot,2);
for n = 1:length(fjord.lat)
    if totalprof(n)>0
    disp([fjord.name{n} ':' num2str(totalprof(n))])
    end
end
%% fjords with data in each season

indAllSeas = find(~isnan(numprof.win) & ~isnan(numprof.spr) & ~isnan(numprof.sum) & ~isnan(numprof.fal));

% fjord.prof_num.win(find(fjord.prof_num.win ==0)) = NaN;
% fjord.prof_num.spr(find(fjord.prof_num.spr ==0)) = NaN;
% fjord.prof_num.sum(find(fjord.prof_num.sum ==0)) = NaN;
% fjord.prof_num.fal(find(fjord.prof_num.fal ==0)) = NaN;

for n = 1:length(indAllSeas)
    
    disp([fjord.name{indAllSeas(n)} ' Num Yrs w/ Data in Winter: ' num2str(sum(~isnan(fjord.prof_num.sum(indAllSeas(n)))))]) 
end

%%
for m = 1:length(regionnames)
    numgeog = length(find(contains(fjord.geog_region(indAllSeas),regionnames(m))));
    numreg = find(contains(fjord.geog_region,regionnames{m}));
    disp(['Number of fjords with data in every season ' regionnames{m} ': ' num2str(numgeog) ' or ' num2str(round(numgeog/length(numreg)*100)) '%'])
end


%% Compute number of years

for n = 1:length(fjord.lat)
    numyrsdat(n) = length(find(~isnan(fjord.prof_num.tot(n,:))));
    numyrswin(n) = length(find(~isnan(fjord.prof_num.win(n,:))));
    numyrsspr(n) = length(find(~isnan(fjord.prof_num.spr(n,:))));
    numyrssum(n) = length(find(~isnan(fjord.prof_num.sum(n,:))));
    numyrsfal(n) = length(find(~isnan(fjord.prof_num.fal(n,:))));
end

%% fjord locations with T/S data
geogTS = fjord.geog_region(indSal);
silldepthTS = fjord.outer_sill_depth(indSal);
ind20 = find(silldepthTS<20);
disp(['Num of fjords w/ T/S data and sill depths <20m :' num2str(length(ind20)) ' or ' num2str(round(length(ind20)/length(silldepthTS)*100)) '%'])

ind20_200 = find(silldepthTS>20 & silldepthTS<200);
disp(['Num of fjords w/ T/S data and 20 <sill depths <200m :' num2str(length(ind20_200)) ' or ' num2str(round(length(ind20_200)/length(silldepthTS)*100)) '%'])

ind200 = find(silldepthTS>200);
disp(['Num of fjords w/ T/S data and sill depths>200m :' num2str(length(ind200)) ' or ' num2str(round(length(ind200)/length(silldepthTS)*100)) '%'])

%% Number of fjords in different sill categories

inddepth = find(fjord.outer_sill_depth<20);
disp(['Num of fjords with shallow sills :' num2str(length(inddepth)) ' or ' num2str(round(length(inddepth)/length(fjord.outer_sill_depth)*100)) '%'])

inddepth = find(fjord.outer_sill_depth>20 & fjord.outer_sill_depth<200);
disp(['Num of fjords with intermediate sills :' num2str(length(inddepth)) ' or ' num2str(round(length(inddepth)/length(fjord.outer_sill_depth)*100)) '%'])

inddepth = find(fjord.outer_sill_depth>200);
disp(['Num of fjords with deep or no sills :' num2str(length(inddepth)) ' or ' num2str(round(length(inddepth)/length(fjord.outer_sill_depth)*100)) '%'])


