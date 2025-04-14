%%% This script loads in fjord static characteristics from the csv file and
%%% puts them into matrix structure. 
%%% Save out a few different things if you would like
%%% 1. csv file of the sill depths
%%% 2. mat file of the fjord location with sill depths. 
%%% 3. kml file for where data exists in a fjord

%%% Anna Simpson
%%% May 20, 2021

save_files = 1;
write_kml = 0;

%%% ------- load static fjord characteristics from csv file 

filepath = [rootdir '2 Alaska Fjord Data Gathering Project/Data/data_output/fjord_static_char/'];
savepath = [rootdir '/2 Alaska Fjord Data Gathering Project/Data/data_output/fjord_static_char/'];


fj_data = readtable([filepath 'fjord_static_characteristics.csv'],'Headerlines',2);
fj_struc = table2struct(fj_data(2:end,:));

%%% pull variables from fj_struc and assign to different things
fjord_name = fj_data{:,1};
lat = fj_data{:,2};
lon = fj_data{:,3};
data_exist = fj_data{:,4};
data_exist2(isnan(data_exist)) = 0;
outer_sill_depth = fj_data{:,13};
  
 descrip.geog_region = fj_data{:,5};
 descrip.climate_div = fj_data{:,6};
 descrip.glacier_name = fj_data{:,8};
 descrip.outer_sill_depth = fj_data{:,13};
 descrip.deepest_depth = fj_data{:,19};
 descrip.fjord_centerline_length = fj_data{:,9};
 descrip.width_glac_term = fj_data{:,10};
 descrip.width_outer_sill = fj_data{:,11};
 descrip.num_inner_sills = fj_data{:,15};
 descrip.glac_category = fj_data{:,18};
 
 sill_depths(:,1) = fjord_name;
 sill_depths(:,2) = num2cell(lat);
 sill_depths(:,3) = num2cell(lon);
 sill_depths(:,4) = num2cell(outer_sill_depth);

%% ---------- save csv file of sill depths
 writecell(sill_depths,[savepath 'sill_depths.csv'])


%% ----------- save mat file of fjord location with fjord name, lat, lon
fjord.lat = lat;
fjord.lon = lon;
fjord.name = fj_data{:,1};%fjord_name;
% fjord.geog = descrip.geog_region;
fjord.geog_region = descrip.geog_region;
fjord.climate_div = descrip.climate_div;
fjord.glacier_name = descrip.glacier_name;

fjord.centerline_length = descrip.fjord_centerline_length;
fjord.width_glac_term = descrip.width_glac_term;
fjord.width_outer_sill = descrip.width_outer_sill;
fjord.num_inner_sills = descrip.num_inner_sills;
fjord.outer_sill_depth = descrip.outer_sill_depth;
fjord.deepest_depth = descrip.deepest_depth;
fjord.glac_category = descrip.glac_category;

if save_files==1
save([rootdir '/2 Alaska Fjord Data Gathering Project/Data/data_output/fjord_static_characteristics.mat'],'fjord')
save([rootdir '/2 Alaska Fjord Data Gathering Project/Data/data_output/fjord_loc.mat'],'fjord_name','fjord')
end
%% ----------- save kml file with the fjord locations where data exists
% fjord_name = fjord_name(~isnan(data_exist));
% lat_e = lat(~isnan(data_exist));
% lon_e = lon(~isnan(data_exist));
% 
% if write_kml ==1
% kmlwritepoint([savepath 'fj_data_exist.kml'],lat_e,lon_e,'Name',fjord_name)
% end

