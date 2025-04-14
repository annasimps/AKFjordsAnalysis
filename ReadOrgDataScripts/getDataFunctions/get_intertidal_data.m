% The point of this script will be to load in the intertidal temperature
% data and put it into a matlab matrix.
% Right now, I copied and pasted the format from how I did it in the
% read_data.m script, but I think in reality I will want to change this...
% this is currently VERY INCOMPLETE


 %% 'NearshoreBenthicSystemsInGOA_SOP10_WaterQuality_2006-2014IntertidalHOBOTemperature'
    locations = readtable('/Volumes/GoogleDrive/Shared drives/Alaska Fjord Data Gathering Project/Data/data_info/NearshoreSystemsInGOA_Intertidal_and_EelgrassBed_SiteLocations_metadata/NearshoreSystemsInGOA_IntertidalSiteLocations_MasterList21Dec2016.csv');
    if data_dir(csv_files(ind)).name == 'NearshoreBenthicSystemsInGOA_SOP10_WaterQuality_2006-2014IntertidalHOBOTemperature';
            lat_file = [];
            lon_file = [];
            time_file = [];
            isctd = [];
            istmp = [];
            for n = 1%:length(csv_dir)
                clear dat_table
                csvfile = [data_files{csv_files(ind)}.iscsv(n).folder filesep data_files{csv_files(ind)}.iscsv(n).name];
                dat_table = readtable(csvfile);
               time = datenum(table2array(dat_table(:,1)));
               
               lat = table2array(dat_table(:,9));
               lon = table2array(dat_table(:,10));

               [lat_uni,ila] = unique(lat,'stable');
               [lon_uni,ilo] = unique(lon,'stable');
               time = time(ila);
               
                if isempty(lat_file)
                   lat_file = lat_uni;
                   lon_file = lon_uni;
                   time_file = time;
                   
                else
                   lat_file = [lat_file;lat_uni];
                   lon_file = [lon_file; lon_uni];
                   time_file = [time_file;time];
                end
            end
            isctd = ones(size(time_file));
            istmp = zeros(size(time_file));
            
            if isempty(csv.lat)
               csv.lat = lat_file;
               csv.lon = lon_file;
               csv.time = time_file;
               csv.isctd = isctd;
               csv.istmp = istmp;
           else
               csv.lat = [csv.lat;lat_file];
               csv.lon = [csv.lon;lon_file];
               csv.time = [csv.time;time_file];
               csv.isctd = [csv.ctd;isctd];
                csv.istmp = [csv.istmp;istmp];
               
           end
    end
    
     %% %%% 'kbay_intertidal_temp'
        if data_dir(csv_files(ind)).name == 'kbay_intertidal_temp';
            lat_file = [];
            lon_file = [];
            time_file = [];
            isctd = [];
            istmp = [];
            for n = 1:length(csv_dir)
                clear dat_table
                csvfile = [data_files{csv_files(ind)}.iscsv(n).folder filesep data_files{csv_files(ind)}.iscsv(n).name];
                dat_table = readtable(csvfile);
                lat_uni = table2array(dat_table(:,4));
                lon_uni = table2array(dat_table(:,5));
                time = datenum(table2array(dat_table(:,7)));
                if isempty(lat_file)
                   lat_file = lat_uni;
                   lon_file = lon_uni;
                   time_file = time;
                else
                   lat_file = [lat_file;lat_uni];
                   lon_file = [lon_file; lon_uni];
                   time_file = [time_file;time];
                end
            end
            isctd = zeros(size(time_file));
            istmp = ones(size(time_file));
            if isempty(csv.lat)
               csv.lat = lat_file;
               csv.lon = lon_file;
               csv.time = time_file;
               csv.isctd = isctd;
               csv.istmp = istmp;
           else
               csv.lat = [csv.lat;lat_file];
               csv.lon = [csv.lon;lon_file];
               csv.time = [csv.time;time_file];
                csv.isctd = [csv.ctd;isctd];
                csv.istmp = [csv.istmp;istmp];
           end
        end