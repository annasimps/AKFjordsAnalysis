 %%% This script reads in data from the data_download folder and pulls out
%%% latitude, longitude, and time from the files. Currently this script
%%% deals with similar data structures the same way and others individually
%%% It would be great to write this to be a bit more universal and deal
%%% with the data a bit better, but this is how it is right now. This
%%% script will be the base for pulling out the other relevant parameters
%%% to create the dataset with all the parameters, etc. 
%%% Outputs: .csv and .mat file with latitude, longitude, time for each
%%% profile in coastal lcations

%%% Anna Simpson
%%% June 2021
%%%
%%% Updated Jan 2022 to save out ctd profiles too

% First select if you want to save out .csv and .mat file 1= yes, 0 = no
save_csv = 1;
save_mat = 1;
save_casts = 1;
rootdir = '/Volumes/GoogleDrive/Shared drives/';
% Set relevant paths for data location and save paths
datapath = [rootdir '2 Alaska Fjord Data Gathering Project/Data/data_download/'];
savepath = [rootdir '2 Alaska Fjord Data Gathering Project/Data/data_output/'];

% datapath = 'G:/Shared drives/Shared drives/Alaska Fjord Data Gathering Project/Data/data_download/';
% savepath = 'G:/Shared drives/Shared drives/Alaska Fjord Data Gathering Project/Data/data_output/';

data_dir = dir(datapath);

lk_tab = readtable([rootdir '2 Alaska Fjord Data Gathering Project/Data/data_sheets/all_data_sheets.csv'],'Headerlines',1);
link_struct = table2struct(lk_tab);

%% Run through folders to determine data file tpe: .txt, .nc,.csv,.dat files
for n = 3:length(data_dir)
    data_folder = dir([datapath data_dir(n).name filesep '*/data/']);
    
    clear potPaths
    if ~isempty(data_folder)
    for foldInd = 1:length(data_folder)
        if contains(data_folder(foldInd).name,'data')
            potPaths(foldInd) = foldInd;
        end
    end
       
        data_loc = data_folder(potPaths(end));

    
        data_files{n}.istxt = dir([data_loc.folder filesep data_loc.name filesep '**/*.txt']);
        data_files{n}.isnc = dir([data_loc.folder filesep data_loc.name filesep '**/*.nc']);
        data_files{n}.iscsv = dir([data_loc.folder filesep data_loc.name filesep '**/*.csv']);
        data_files{n}.isdat = dir([data_loc.folder filesep data_loc.name filesep '**/*.dat']);
        data_files{n}.iscnv = dir([data_loc.folder filesep data_loc.name filesep '**/*.cnv']);
    
        
    else
        data_files{n}.istxt = dir([datapath data_dir(n).name filesep '**/*.txt']);
        data_files{n}.isnc = dir([datapath data_dir(n).name filesep '**/*.nc']);
        data_files{n}.iscsv = dir([datapath data_dir(n).name filesep '**/*.csv']);
        data_files{n}.isdat = dir([datapath data_dir(n).name filesep '**/*.dat']); 
        data_files{n}.iscnv = dir([datapath data_dir(n).name filesep '**/*.cnv']); 
    end
    
    ff = fieldnames(data_files{n});
    data_file_stats{n}.name = data_dir(n).name;
%     data_file_struct(n,1) = data_dir(n).name;
    for mm = 1:length(ff)
        if ~isempty(data_files{n}.(ff{mm}))
            data_file_stats{n}.(ff{mm}) = length(data_files{n}.(ff{mm}));
            data_file_struct(n,mm) = length(data_files{n}.(ff{mm}));
        else
            data_files_stats{n}.(ff{mm}) = 0;
            data_file_struct(n,mm) = 0;
        end
    end
end

sum_filetype = sum(data_file_struct,1);
sum_instr = sum(data_file_struct,2);

%% Load data files, extract lat, lon, time, if they contain CTD or temp data => save positions and times out

load_from_scratch = 1;
if load_from_scratch == 1
    data.time = [];
    data.lat = [];
    data.lon = [];
    data.isctd = [];
    data.istmp = [];
end
profile_nc = [];
for n = 1:length(data_files)
    if ~isempty(data_files{n})
    if ~isempty(data_files{n}.isnc)
        
        for ind = 1:length(data_files{n}.isnc)
            clear fieldname
            clear NcInf
            clear NcData

            ncfile = [data_files{n}.isnc(ind).folder filesep data_files{n}.isnc(ind).name];
            [ncprofile] = get_nc_data(ncfile);
            
            if ~isempty(ncprofile.time)
                profile_nc_int{ind} = ncprofile;
                for mmm = 1:length(link_struct)
                    if contains(link_struct(mmm).online_link,data_dir(n).name)
                        profile_nc_int{ind}.link = link_struct(mmm).online_link;
                        if ~isempty(link_struct(mmm).doi)
                            profile_nc_int{ind}.doi = link_struct(mmm).doi;
                        else
                            profile_nc_int{ind}.doi = [];
                        end
                    end
                end
            else
                profile_nc_int{ind} = [];
            end
        
        end
        
         if isempty(profile_nc)
            profile_nc = profile_nc_int;
         else
            profile_nc = [profile_nc, profile_nc_int];
         end
    end
    end  
   
   
    
   
end
    %% load  csv files
    csv_files = find(data_file_struct(:,3)~=0);
    
    for ind =1:length(csv_files)
        csv_dir = data_files{csv_files(ind)}.iscsv;
        

        
    %    %%% 'pws_pelagic_fish_ctd'
    if contains(data_dir(csv_files(ind)).name,'pws_pelagic_fish_ctd');
            lat_file = [];
            lon_file = [];
            time_file = [];
            isctd = [];
            istmp = [];
            
            for n = 1:length(csv_dir)
                clear dat_table
                
                csvfile = [data_files{csv_files(ind)}.iscsv(n).folder filesep data_files{csv_files(ind)}.iscsv(n).name];
                
                fid = fopen(csvfile);
                cfile = fscanf(fid,'%c');

                latind = strfind(cfile,'Start latitude');
                lonind = strfind(cfile,'Start longitude');
                timeind = strfind(cfile,'Cast time (local)');
                
                
                pf_profiles{n}.lat = str2num(cfile(latind+15:latind+22));
                pf_profiles{n}.lon = str2num(cfile(lonind+16:lonind+25));
                pf_profiles{n}.time = datenum(cfile(timeind+19:timeind+ 32));
                
                dat_table = readtable(csvfile,"HeaderLines",28);
                pf_profiles{n}.z = table2array(dat_table(:,1));
                pf_profiles{n}.T = table2array(dat_table(:,3));
                pf_profiles{n}.S = table2array(dat_table(:,6));
                pf_profiles{n}.link = [];
                pf_profiles{n}.doi = [];

                fclose(fid)
            end
     
    %%    %%% 'pws_forage_fish_ctd'
       elseif contains(data_dir(csv_files(ind)).name, 'pws_forage_fish_ctd');
            m = 1;
            for n = 1:length(csv_dir)
                clear dat_table
                clear lat
                clear lon
                clear temp
                clear sal
                clear depth
                clear time
                
                csvfile = [data_files{csv_files(ind)}.iscsv(n).folder filesep data_files{csv_files(ind)}.iscsv(n).name];
               
               dat_table = readtable(csvfile);
                
               date = datestr(table2array(dat_table(:,2)));
               date(:,8) = '2';
               space = repmat(' ',length(date),1);
               for tt = 1:length(date)
                    time(tt) = datenum([date(tt,:) space(tt) cell2mat(table2array(dat_table(tt,3)))]);
               end
               
               [tl_uni,ilt] = unique(time,'stable');
               
               indlat = find(contains(dat_table.Properties.VariableNames,'latitude','IgnoreCase',true));
               lat = table2array(dat_table(:,indlat));
               indlon = find(contains(dat_table.Properties.VariableNames,'longitude','IgnoreCase',true)); 
               lon = table2array(dat_table(:,indlon));
               indtemp = find(contains(dat_table.Properties.VariableNames,'Tv290C','IgnoreCase',true)); 
               temp = table2array(dat_table(:,indtemp));
               indsal = find(contains(dat_table.Properties.VariableNames,'Sal00','IgnoreCase',true)); 
               sal = table2array(dat_table(:,indsal));
               inddepth = find(contains(dat_table.Properties.VariableNames,'PrdM','IgnoreCase',true)); 
               depth = table2array(dat_table(:,inddepth));
               
%                lat = table2array(dat_table(:,4));
%                lon = table2array(dat_table(:,5));
%                temp = table2array(dat_table(:,10));
%                
%                sal = table2array(dat_table(:,22));
%                depth = table2array(dat_table(:,8));
               
               for a = 1:length(tl_uni)
                   ff_profiles{m}.lat = lat(ilt(a));
                   ff_profiles{m}.lon = lon(ilt(a));
                   ff_profiles{m}.time = tl_uni(a);

                   
                   if a~=length(tl_uni)
                       ff_profiles{m}.z = depth(ilt(a):ilt(a+1)-1);
                       ff_profiles{m}.T = temp(ilt(a):ilt(a+1)-1);
                       ff_profiles{m}.S = sal(ilt(a):ilt(a+1)-1);
                   else
                       ff_profiles{m}.z = depth(ilt(a):end);
                       ff_profiles{m}.T = temp(ilt(a):end);
                       ff_profiles{m}.S = sal(ilt(a):end);
                   end
               ff_profiles{m}.link = 'https://alaska.usgs.gov/products/data.php?dataid=117';
               ff_profiles{m}.doi = ['https://doi.org/10.5066/F74J0C9Z'];
               m = m+1;
               end
              
            end
  
%%   %%% 'gwa_lowercookinletCTD'
    elseif contains(data_dir(csv_files(ind)).name,'gwa_lowercookinletCTD');
            lat_file = [];
            lon_file = [];
            time_file = [];
            isctd = [];
            istmp = [];
            m = 1;
            for n = 1:length(csv_dir)
                clear dat_table
                clear lat
                clear lon
                clear temp
                clear sal
                clear depth
                clear time
                csvfile = [data_files{csv_files(ind)}.iscsv(n).folder filesep data_files{csv_files(ind)}.iscsv(n).name];
                dat_table = readtable(csvfile);
                inddate = find(contains(dat_table.Properties.VariableNames,'Date'));
                date = datestr(table2array(dat_table(:,inddate)));
                date(:,8) = '2';
                space = repmat(' ',length(date),1);
                indtime = find(contains(dat_table.Properties.VariableNames,'Time'));
                if length(indtime) ==2
                    indtime = indtime(2);
                end
                for tt = 1:length(date)
                    time(tt) = datenum([date(tt,:) space(tt) cell2mat(table2array(dat_table(tt,indtime)))]);
                end
                
                    
               
               
               
               [tl_uni,ilt] = unique(time,'stable');
               
               indlat = find(contains(dat_table.Properties.VariableNames,'latitude','IgnoreCase',true));
               lat = table2array(dat_table(:,indlat));
               indlon = find(contains(dat_table.Properties.VariableNames,'longitude','IgnoreCase',true)); 
               lon = table2array(dat_table(:,indlon));
               indtemp = find(contains(dat_table.Properties.VariableNames,'Temperature','IgnoreCase',true)); 
               temp = table2array(dat_table(:,indtemp));
               indsal = find(contains(dat_table.Properties.VariableNames,'Salinity','IgnoreCase',true)); 
               sal = table2array(dat_table(:,indsal));
               inddepth = find(contains(dat_table.Properties.VariableNames,'Pressure','IgnoreCase',true)); 
               depth = table2array(dat_table(:,inddepth));
               
               for a = 1:length(tl_uni)
                   lc_profiles{m}.lat = lat(ilt(a));
                   lc_profiles{m}.lon = lon(ilt(a));
                   lc_profiles{m}.time = tl_uni(a);
                   
                   
                   if a~=length(tl_uni)
                       lc_profiles{m}.z = depth(ilt(a):ilt(a+1)-1);
                       lc_profiles{m}.T = temp(ilt(a):ilt(a+1)-1);
                       lc_profiles{m}.S = sal(ilt(a):ilt(a+1)-1);
                   else
                       lc_profiles{m}.z = depth(ilt(a):end);
                       lc_profiles{m}.T = temp(ilt(a):end);
                       lc_profiles{m}.S = sal(ilt(a):end);
                   end
                   lc_profiles{m}.link = 'https://portal.aoos.org/#metadata/4e28304c-22a1-4976-8881-7289776e4173/project/files';
                   lc_profiles{m}.doi = [];  
                   m = m+1;
               end

               

            end

%% %%% 'kachemak bay'
    elseif contains(data_dir(csv_files(ind)).name,'gwa_KachemakBay');
            
            m = 1;
            
            for n = 1:length(csv_dir)
                clear dat_table
                 clear lat
                clear lon
                clear temp
                clear sal
                clear depth
                clear time
                csvfile = [data_files{csv_files(ind)}.iscsv(n).folder filesep data_files{csv_files(ind)}.iscsv(n).name];
                dat_table = readtable(csvfile);
                date = datestr(table2array(dat_table(:,2)));
                dati = cell2mat(table2array(dat_table(:,3)));
                space = repmat(' ',length(date),1);
                time = datenum([date space dati]);
               
               
               [tl_uni,ilt] = unique(time,'stable');
               
               lat = table2array(dat_table(:,4));
               lon = table2array(dat_table(:,5));
               temp = table2array(dat_table(:,13));
               sal = table2array(dat_table(:,14));
               depth = table2array(dat_table(:,12));
               
               for a = 1:length(tl_uni)
                   kb_profiles{m}.lat = lat(ilt(a));
                   kb_profiles{m}.lon = lon(ilt(a));
                   kb_profiles{m}.time = tl_uni(a);
                   
                   
                   if a~=length(tl_uni)
                       kb_profiles{m}.z = depth(ilt(a):ilt(a+1)-1);
                       kb_profiles{m}.T = temp(ilt(a):ilt(a+1)-1);
                       kb_profiles{m}.S = sal(ilt(a):ilt(a+1)-1);
                   else
                       kb_profiles{m}.z = depth(ilt(a):end);
                       kb_profiles{m}.T = temp(ilt(a):end);
                       kb_profiles{m}.S = sal(ilt(a):end);
                   end
                   kb_profiles{m}.link = 'https://portal.aoos.org/#metadata/4e28304c-22a1-4976-8881-7289776e4173/project/files';
                   kb_profiles{m}.doi = [];
                   m = m+1;
               end  
               
            end
   %% 'glacier_bay_ltm' - T/S output
        elseif contains(data_dir(csv_files(ind)).name,'glacier_bay_ltm');

            for n = 1:length(csv_dir)
                clear dat_table
                csvfile = [data_files{csv_files(ind)}.iscsv(n).folder filesep data_files{csv_files(ind)}.iscsv(n).name];
                dat_table = readtable(csvfile);
                date = datestr(table2array(dat_table(:,11)));
                dati = cell2mat(table2array(dat_table(:,12)));
                space = repmat(' ',length(date),1);
                time = datenum([date space dati]);
               
               
               [tl_uni,ilt] = unique(time,'stable');
               
               lat = table2array(dat_table(:,9));
               lon = table2array(dat_table(:,10));
               temp = table2array(dat_table(:,16));
               sal = table2array(dat_table(:,18));
               depth = table2array(dat_table(:,15));
               
               for a = 1:length(tl_uni)
                   gb_profiles{a}.lat = lat(ilt(a));
                   gb_profiles{a}.lon = lon(ilt(a));
                   gb_profiles{a}.time = tl_uni(a);
                   
                  
                   
                   if a~=length(tl_uni)
                       gb_profiles{a}.z = depth(ilt(a):ilt(a+1)-1);
                       gb_profiles{a}.T = temp(ilt(a):ilt(a+1)-1);
                       gb_profiles{a}.S = sal(ilt(a):ilt(a+1)-1);
                   else
                       gb_profiles{a}.z = depth(ilt(a):end);
                       gb_profiles{a}.T = temp(ilt(a):end);
                       gb_profiles{a}.S = sal(ilt(a):end);
                   end
                       gb_profiles{a}.link = 'https://irma.nps.gov/DataStore/Reference/Profile/2293317';
                       gb_profiles{a}.doi = [];
               end

            end
           

     
  %% 'GlacierRunoff_GulfofAlaskaFjords_2004_2011'- T/S output

  elseif contains(data_dir(csv_files(ind)).name,'GlacierRunoff_GulfofAlaskaFjords_2004_2011');

            for n = 1%:length(csv_dir)
                clear dat_table
                csvfile = [data_files{csv_files(ind)}.iscsv(n).folder filesep data_files{csv_files(ind)}.iscsv(n).name];
                dat_table = readtable(csvfile);

                date = datestr(table2array(dat_table(:,2)));
                dati = datestr(table2array(dat_table(:,3)));
                space = repmat(' ',length(date),1);
                time = datenum([date space dati]);
               
               
               [tl_uni,ilt] = unique(time,'stable');
               
               lat = table2array(dat_table(:,4));
               lon = table2array(dat_table(:,5));
               temp = table2array(dat_table(:,8));
               sal = table2array(dat_table(:,9));
               depth = table2array(dat_table(:,6));
               
               for mmm = 1:length(link_struct)
                    if contains(link_struct(mmm).online_link,'glacierRunoff')
                        data_link = link_struct(mmm).online_link;
                        if ~isempty(link_struct(mmm).doi)
                            data_doi = link_struct(mmm).doi;
                        else
                            data_doi = [];
                        end
                    end
               end
               
               for a = 1:length(tl_uni)
                   gr_profiles{a}.lat = lat(ilt(a));
                   gr_profiles{a}.lon = lon(ilt(a));
                   gr_profiles{a}.time = tl_uni(a);
                   
                   lat_comb(a) = lat(ilt(a));
                   lon_comb(a) = lon(ilt(a));
                   time_indlat(a) = time(ilt(a));
                   
                   if a~=length(tl_uni)
                       gr_profiles{a}.z = depth(ilt(a):ilt(a+1)-1);
                       gr_profiles{a}.T = temp(ilt(a):ilt(a+1)-1);
                       gr_profiles{a}.S = sal(ilt(a):ilt(a+1)-1);
                   else
                       gr_profiles{a}.z = depth(ilt(a):end);
                       gr_profiles{a}.T = temp(ilt(a):end);
                       gr_profiles{a}.S = sal(ilt(a):end);
                   end
                       gr_profiles{a}.link = data_link;
                       gr_profiles{a}.doi = data_doi;
               end
            end
           
 %% gak1 long term monitoring CTD station --T/S output
 
  elseif contains(data_dir(csv_files(ind)).name,'gak1_ltm');
            lat_file = [];
            lon_file = [];
            time_file = [];

            for n = 1
                clear dat_table
                csvfile = [data_files{csv_files(ind)}.iscsv(n).folder filesep data_files{csv_files(ind)}.iscsv(n).name];
                dat_table = readtable(csvfile,'HeaderLines',3);
            end
            
             lat = table2array(dat_table(:,9));
             lon = table2array(dat_table(:,10));
             zcsv = table2array(dat_table(:,4));
             tempcsv = table2array(dat_table(:,5));
             salcsv = table2array(dat_table(:,6));
             
             time_dec = table2array(dat_table(:,3));
             [time_dec_un,indtime,ind_tab] = unique(time_dec,'stable');
             
            
             
             
             for mm = 1:length(time_dec_un)
                [time_num(mm)] = ConvertSerialYearToDate(time_dec_un(mm));
             end
             
             lat_file = lat(indtime);
             lon_file = lon(indtime);
             time_file = time_num';
             
            
             for mm = 1:length(time_dec_un)
                 inddepth = find(ind_tab == indtime(mm));
                 gak_profiles{mm}.lat = lat_file(mm);
                 gak_profiles{mm}.lon = lon_file(mm);
                 gak_profiles{mm}.time = time_file(mm);
                 gak_profiles{mm}.z = zcsv(inddepth);
                 gak_profiles{mm}.T = tempcsv(inddepth);
                 gak_profiles{mm}.S = salcsv(inddepth);
                 gak_profiles{mm}.link = 'https://search.dataone.org/view/10.24431_rw1k595_20210618T011621Z';
                 gak_profiles{mm}.doi = 'https://doi.org/10.24431/rw1k32u';
                 
             end
             
    end
    end 
    
%% Load Endicott Arm/Dawes glacier Data that Erin shared with me

mat_path = '/Volumes/GoogleDrive/Shared drives/2 Alaska Fjord Data Gathering Project/Data/data_download/dawes/ctd/';

mat_files = dir([mat_path '*.mat']);
    clear lat
    clear lon
    clear time
    
for n = 1:length(mat_files)
    clear cast

   cast = load([mat_files(n).folder '/' mat_files(n).name]);
   lat(n) = cast.LatitudeStart;
   lon(n) = cast.LongitudeStart;
   yr = num2str(cast.CastTimeLocal(1));
   mth = cast.CastTimeLocal(2);
   if (mth-10)<0
       mth = ['0' num2str(cast.CastTimeLocal(2))];
   else
       mth = num2str(cast.CastTimeLocal(2));
   end
   
   dy = cast.CastTimeLocal(3);
   if (dy-10)<0
       dy = ['0' num2str(cast.CastTimeLocal(3))];
   else
       dy = num2str(cast.CastTimeLocal(3));
   end
  
   time_cast = [yr mth dy];
   
   time(n) = datenum(time_cast,'yyyymmdd');
   
   mat_cast{n}.lat = lat(n);
   mat_cast{n}.lon = lon(n);
   mat_cast{n}.time = time(n);
   mat_cast{n}.z = cast.Depth;
   mat_cast{n}.T = cast.Temperature;
   mat_cast{n}.S = cast.Salinity;
   mat_cast{n}.link = [];
   mat_cast{n}.doi = [];
end

%% Load Anne Hoover-Miller's Data
kffiles = dir(fullfile([datapath 'CTD_Hoover-Miller_KenaiFjords_Data/*/ctd_data/'],'**','*.cnv'));
kftable = readtable([datapath 'CTD_Hoover-Miller_KenaiFjords_Data/KEFJ_oceanography_datasheets_2006-2011.csv']);
kfdate = table2array(kftable(:,3));
kfd = datenum(kfdate);
kfdropnum = table2array(kftable(:,1));
kflat = table2array(kftable(:,4));
kflon = table2array(kftable(:,5));


m = 1;

for f = 1:length(kffiles)
    kffile = [kffiles(f).folder filesep kffiles(f).name];
fid = fopen(kffile);

clear datakf
fseek(fid,0,-1);                % set read position to beginning of file
while strcmp(fgetl(fid),'*END*') == 0; end        % go through lines until '*END*'
  

n=1;                            
while 1
    tline = fgetl(fid) ;                % read in line
    if ~ischar(tline), break, end       % if eof, break and finish
    datakf(n,:) = sscanf(tline,'%f');     % put numbers in a matrix (in columns)
    n=n+1;
end
inddrop = str2num(kffiles(f).name(end-6:end-4));
mmddyr = datenum(kffiles(f).name(1:6),'mmddyy');

indc = find(kfd == mmddyr & kfdropnum ==inddrop);

kf_cast{m}.lat = kflat(indc);
kf_cast{m}.lon = kflon(indc);
kf_cast{m}.time = mmddyr;
if year(datetime(datestr(kf_cast{1}.time)))<2009
    kf_cast{m}.z = datakf(:,3);
    kf_cast{m}.T = datakf(:,6);
    kf_cast{m}.S = datakf(:,1);

else
    kf_cast{m}.z = datakf(:,4);
    kf_cast{m}.T = datakf(:,9);
    kf_cast{m}.S = datakf(:,12);
end
    kf_cast{m}.link = [];
    kf_cast{m}.doi = [];

fclose(fid)    % close file
m = m+1;
end

%% Load PWS Data 
m = 1;
for mmm = 1:length(data_dir)
    if ~isempty(strfind(data_dir(mmm).name,'PWS'))
        pwsfileind(m) = mmm;
        m = m+1;
    end
end

m = 1;
for ff = 1:length(pwsfileind)
pwsfiles=dir([datapath data_dir(pwsfileind(ff)).name filesep '*/ctd/*_bin/*.cnv']);

for f = 1:length(pwsfiles)
datapws =[];
pwsfile = [pwsfiles(f).folder filesep pwsfiles(f).name];
fid = fopen(pwsfile);     % open file to read

ffile = fscanf(fid,'%c');
fLat = strfind(ffile,'Latitude');
latint = str2num(ffile(fLat+10:fLat+19));
if ~isempty(latint)
    pws_cast{m}.lat = latint(1)+latint(2)/60;
else
    pws_cast{m}.lat = NaN;
end

fLon = strfind(ffile,'Longitude');
lonint =  str2num(ffile(fLon+11:fLon+20));
if ~isempty(lonint)
    pws_cast{m}.lon = -(lonint(1)+lonint(2)/60);
else
    pws_cast{m}.lon = NaN;
end

tind = [];
tind = strfind(ffile,'AKDT (time)');
if ~isempty(tind)
    timeint = ffile(tind+13:tind+29);
    pws_cast{m}.time = datenum(timeint);
else
    tind = strfind(ffile,'UTC (time)')
    timeint = ffile(tind+12:tind+28);
    pws_cast{m}.time = datenum(timeint);
end

salind = [];
salind = strfind(ffile,'sal00');
if ~isempty(salind)
    salcol = str2num(ffile(salind-4))+1;
else
    salind = strfind(ffile,'gsw_saA0');
    salcol = str2num(ffile(salind-4))+1;
end


fseek(fid,0,-1);                % set read position to beginning of file
while strcmp(fgetl(fid),'*END*') == 0; end        % go through lines until '*END*'
  

n=1;                            
while 1
    tline = fgetl(fid) ;                % read in line
    if ~ischar(tline), break, end       % if eof, break and finish
    datapws(n,:) = sscanf(tline,'%f');     % put numbers in a matrix (in columns)
    n=n+1;
end

if ~isempty(datapws)
pws_cast{m}.z = datapws(:,1);
pws_cast{m}.T = datapws(:,2);
pws_cast{m}.S = datapws(:,salcol);

if contains(data_dir(pwsfileind(ff)).name,'_HS_')
    pws_cast{m}.link = 'https://portal.aoos.org/#metadata/1d252c01-4948-4c20-93b2-69f3069c8a4b/project/files';
    pws_cast{m}.doi = 'https://doi.org/10.24431/rw1k14';
else
    pws_cast{m}.link = 'https://search.dataone.org/view/10.24431/rw1k19';
    pws_cast{m}.doi = 'https://doi.org/10.24431/rw1k19';
end

else
pws_cast{m}.z = [];
pws_cast{m}.T = [];
pws_cast{m}.S = [];
pws_cast{m}.link = [];
pws_cast{m}.doi = [];
end

fclose(fid)    % close file
m = m+1;

end
end


%% Load text files Data 

m = 1;
for mmm = 1:length(data_dir)
    if strncmp(data_dir(mmm).name,'00',2);
        txtfileind(m) = mmm;
        m = m+1;
    end
end

m = 1;
for ff = 1:3
    d = dir([datapath data_dir(txtfileind(ff)).name filesep '*/data/']);
    
    folders = dir([d(end).folder filesep d(end).name]);
    
    for n = 3:length(folders)
        if folders(n).isdir
            txtfiles= dir([folders(n).folder filesep folders(n).name]);
        else
            txtfiles = dir([d(end).folder filesep d(end).name]);
        end
    end 
    % In here now try to find and identify if there are subfolders. we
    % really want to get to a list of files
        for f = 3:length(txtfiles);
            txtfile = [txtfiles(f).folder filesep txtfiles(f).name];
        
            read_txt_files
        
            tcast{m} = txt_cast;
            %tcast{m}.filename = txtfile;
        
            for mmm = 1:length(link_struct)
                if contains(link_struct(mmm).online_link,data_dir(txtfileind(ff)).name)
                    tcast{m}.link = link_struct(mmm).online_link;
                    if ~isempty(link_struct(mmm).doi)
                    tcast{m}.doi = link_struct(mmm).doi;
                    else
                    tcast{m}.doi = [];
                    end
                end
            end        
 
            m = m+1;
        end
    
end
%
for ff = 4:5    
     d = dir([datapath data_dir(txtfileind(ff)).name filesep '*/data/']);
    
     folders = dir([d(end).folder filesep d(end).name]);
    
    for n = 3:length(folders)
    if folders(n).isdir
        txtfiles= dir([folders(n).folder filesep folders(n).name]);
    else
        txtfiles = dir([d(end).folder filesep d(end).name]);
    end
    end
    % In here now try to find and identify if there are subfolders. we
    % really want to get to a list of files
    for f = 3:length(txtfiles);
        txtfile = [txtfiles(f).folder filesep txtfiles(f).name];
    
        read_txt_files2
        
        tcast{m} = txt_cast;
         for mmm = 1:length(link_struct)
             if contains(link_struct(mmm).online_link,data_dir(txtfileind(ff)).name)
                tcast{m}.link = link_struct(mmm).online_link;
                if ~isempty(link_struct(mmm).doi)
                   tcast{m}.doi = link_struct(mmm).doi;
                else
                   tcast{m}.doi = [];
                end
             end
          end   
        m = m+1;
    end
    
end

%% Getting data from number folders that have .nc files
m = 1;
for mmm = 1:length(data_dir)
    if strncmp(data_dir(mmm).name,'01',2) | strncmp(data_dir(mmm).name,'02',2);
        txtfileind(m) = mmm;
        m = m+1;
    end
    
end  

m = 1;
for ff = 1:length(txtfileind)
    d = dir(fullfile([datapath data_dir(txtfileind(ff)).name filesep],'**','*.nc'));% *.nc']);
    
    for nf = 1:length(d)
        clear ncprof
        ncprof = get_nc_data([d(nf).folder filesep d(nf).name]);
        if ~isempty(ncprof.time)
            nc_prof{m} = ncprof;
            if nc_prof{m}.lon>0
                nc_prof{m}.lon = -nc_prof{m}.lon;
            end
            
         for mmm = 1:length(link_struct)
             if contains(link_struct(mmm).online_link,data_dir(txtfileind(ff)).name)
                nc_prof{m}.link = link_struct(mmm).online_link;
                if ~isempty(link_struct(mmm).doi)
                   nc_prof{m}.doi = link_struct(mmm).doi;
                else
                   nc_prof{m}.doi = [];
                end
             end
          end        

            
            m = m+1;
        end
    end
    
end



m = 1;
for nf = 1:length(nc_prof)
    if length(nc_prof{nf}.lat) ==1
        nc_prof_new(m) = nc_prof(nf);
        m = m+1;
    else
        for nn = 1:length(nc_prof{nf}.lat)
            nc_prof_new{m}.lat = nc_prof{nf}.lat(nn);
            nc_prof_new{m}.lon = nc_prof{nf}.lon(nn);
            nc_prof_new{m}.time = nc_prof{nf}.time(nn);
            nc_prof_new{m}.z = nc_prof{nf}.z;
            nc_prof_new{m}.T = nc_prof{nf}.T(:,nn);
            nc_prof_new{m}.S = nc_prof{nf}.S(:,nn);
            nc_prof_new{m}.link = nc_prof{nf}.link;
            nc_prof_new{m}.doi = nc_prof{nf}.doi;
            m = m+1;
        end
    end
end
   
clear nc_prof
nc_prof = nc_prof_new;

%% load Roman's data
LePath = '/Volumes/GoogleDrive/Shared drives/2 Alaska Fjord Data Gathering Project/Data/data_download/Historic LeConte Data 2012/';

LeCTDS = load([LePath 'Sept 2012 CTD data/ctddata.mat']);
LeCTDinfS = load([LePath 'Sept 2012 CTD data/ctdinfo.mat']);

m = 1;
for n = 1:length(LeCTDinfS.lat)
    LeCTD{m}.lat = LeCTDinfS.lat(n);
    LeCTD{m}.lon = LeCTDinfS.lon(n);
    LeCTD{m}.time = datenum(2012,0,LeCTDS.ctd(n).timej(1));
    LeCTD{m}.z = LeCTDS.ctd(n).pres;
    LeCTD{m}.T = LeCTDS.ctd(n).ptemp;
    LeCTD{m}.S = LeCTDS.ctd(n).sal;
    LeCTD{m}.link = [];
    LeCTD{m}.doi = [];
    m = m+1;
end

d = dir([LePath 'June 2012 CTD data/*.asc' ]);

ctdSinf = importdata([LePath 'June 2012 CTD data/CTD_ADCP locations.xlsx']);
ctdSlat = ctdSinf.data.LocationsCasts(:,3);
ctdSlon = ctdSinf.data.LocationsCasts(:,4);

for n = 1:length(d)
    ctdJ = importdata([d(n).folder filesep d(n).name]);
    
    LeCTD{m}.lat = ctdSlat(n);
    LeCTD{m}.lon = ctdSlon(n);
    LeCTD{m}.time = datenum(2012,0,ctdJ.data(1,1));
    LeCTD{m}.z = ctdJ.data(:,2);
    LeCTD{m}.T = ctdJ.data(:,10);
    LeCTD{m}.S = ctdJ.data(:,9);
    LeCTD{m}.link = [];
    LeCTD{m}.doi = [];
    m = m+1;
end


%% load .nc files from wod
wod_path = '/Volumes/GoogleDrive/Shared drives/2 Alaska Fjord Data Gathering Project/Data/data_download/wod/';
% CTD: high resolution
wod_ctd.lat = ncread([wod_path 'ocldb1623005924.12638_CTD.nc'],'lat');
wod_ctd.lon = ncread([wod_path 'ocldb1623005924.12638_CTD.nc'],'lon');
wod_ctd.date = ncread([wod_path 'ocldb1623005924.12638_CTD.nc'],'date');
wod_ctd.time = datenum(num2str(wod_ctd.date),'yyyymmdd');
wod_ctd.access_no = ncread([wod_path 'ocldb1623005924.12638_CTD.nc'],'Access_no');

% XBT: expendable bathythermogrpah
wod_xbt.lat = ncread([wod_path 'ocldb1623005924.12638_XBT.nc'],'lat');
wod_xbt.lon = ncread([wod_path 'ocldb1623005924.12638_XBT.nc'],'lon');
wod_xbt.date = ncread([wod_path 'ocldb1623005924.12638_XBT.nc'],'date');
wod_xbt.time = datenum(num2str(wod_xbt.date),'yyyymmdd');
 wod_xbt.access_no = ncread([wod_path 'ocldb1623005924.12638_XBT.nc'],'Access_no');
 
% OSD: ocean station data: bottle,low res ctd
wod_osd.lat = ncread([wod_path 'ocldb1623005924.12638_OSD.nc'],'lat');
wod_osd.lon = ncread([wod_path 'ocldb1623005924.12638_OSD.nc'],'lon');
wod_osd.date = ncread([wod_path 'ocldb1623005924.12638_OSD.nc'],'date');
wod_osd.time = datenum(num2str(wod_osd.date),'yyyymmdd');
 wod_osd.access_no = ncread([wod_path 'ocldb1623005924.12638_OSD.nc'],'Access_no');
 
% MBT: mechanical bathythermographs
wod_mbt.lat = ncread([wod_path 'ocldb1623005924.12638_MBT.nc'],'lat');
wod_mbt.lon = ncread([wod_path 'ocldb1623005924.12638_MBT.nc'],'lon');
wod_mbt.date = ncread([wod_path 'ocldb1623005924.12638_MBT.nc'],'date');
wod_mbt.time = datenum(num2str(wod_mbt.date),'yyyymmdd');
 wod_mbt.access_no = ncread([wod_path 'ocldb1623005924.12638_MBT.nc'],'Access_no');

% APB: Autonomous Pinniped Bathythermographs
wod_apb.lat = ncread([wod_path 'ocldb1623005924.12638_APB.nc'],'lat');
wod_apb.lon = ncread([wod_path 'ocldb1623005924.12638_APB.nc'],'lon');
wod_apb.date = ncread([wod_path 'ocldb1623005924.12638_APB.nc'],'date');
wod_apb.time = datenum(num2str(wod_apb.date),'yyyymmdd');
 wod_apb.access_no = ncread([wod_path 'ocldb1623005924.12638_APB.nc'],'Access_no');

% GLD: glider data
wod_gld.lat = ncread([wod_path 'ocldb1623005924.12638_GLD.nc'],'lat');
wod_gld.lon = ncread([wod_path 'ocldb1623005924.12638_GLD.nc'],'lon');
wod_gld.date = ncread([wod_path 'ocldb1623005924.12638_GLD.nc'],'date');
wod_gld.time = datenum(num2str(wod_gld.date),'yyyymmdd');
 wod_gld.access_no = ncread([wod_path 'ocldb1623005924.12638_GLD.nc'],'Access_no');

% SUR: surface only: bucket, thermosalinograph
wod_sur.lat = ncread([wod_path 'ocldb1623005924.12638_SUR.nc'],'lat');
wod_sur.lon = ncread([wod_path 'ocldb1623005924.12638_SUR.nc'],'lon');
wod_sur.date = ncread([wod_path 'ocldb1623005924.12638_SUR.nc'],'date');
wod_sur.time = datenum(num2str(wod_sur.date),'yyyymmdd');
 wod_sur.access_no = ncread([wod_path 'ocldb1623005924.12638_SUR.nc'],'Access_no');
% PFL: profiling floats
wod_pfl.lat = ncread([wod_path 'ocldb1623005924.12638_PFL.nc'],'lat');
wod_pfl.lon = ncread([wod_path 'ocldb1623005924.12638_PFL.nc'],'lon');
wod_pfl.date = ncread([wod_path 'ocldb1623005924.12638_PFL.nc'],'date');
wod_pfl.time = datenum(num2str(wod_pfl.date),'yyyymmdd');
%% get profile data from the wod files
prof_type = 'CTD';
ctdcasts = get_profile_data(prof_type,wod_path);
 
prof_type = 'XBT';
xbtcasts = get_profile_data(prof_type,wod_path);

prof_type = 'OSD';
osdcasts = get_profile_data(prof_type,wod_path);

prof_type = 'MBT';
mbtcasts = get_profile_data(prof_type,wod_path);

prof_type = 'SUR';
surcasts = get_profile_data(prof_type,wod_path);



%% Combine wod profile data

wod.lat = [wod_ctd.lat;wod_xbt.lat;wod_osd.lat;wod_mbt.lat;wod_sur.lat];
wod.lon = [wod_ctd.lon;wod_xbt.lon;wod_osd.lon;wod_mbt.lon;wod_sur.lat];
wod.time = [wod_ctd.time;wod_xbt.time;wod_osd.time;wod_mbt.time;wod_sur.time];
wod.access = [wod_ctd.access_no;wod_xbt.access_no;wod_osd.access_no;wod_mbt.access_no;wod_sur.access_no];
%% Combine all profile data
% all_profiles.lat = [wod.lat;ctd_profiles.lat];
% all_profiles.lon = [wod.lon;ctd_profiles.lon];
% all_profiles.time = [wod.time;ctd_profiles.time];

 %% Combine Casts from the different sets
 csvcast = [gb_profiles, gr_profiles,gak_profiles,pf_profiles,ff_profiles, kb_profiles,lc_profiles];
 all_casts_cell = [ctdcasts, xbtcasts, osdcasts, mbtcasts, surcasts, csvcast, mat_cast, tcast,nc_prof, kf_cast, LeCTD,pws_cast];
 all_casts_preQC = cell2mat(all_casts_cell);

%% Quality Control the data 
%%% 1.) get rid of repeated profiles
%%% 2.) get rid of physically unlikely values (− 2 °C < T > 25 °C, 0 < S > 35)
%%% 3.) if a whole profile is determined to be ‘bad’ - we want to get rid of it from the dataset

%%% Get rid of repeated profiles: Want to search for indices where the lat,
%%% lon, and time all equal each other 

% first fix the dates problem and replace any empty lat/lon/time with NaN
for n = 1:length(all_casts_preQC)
    
    if ~isempty(all_casts_preQC(n).time)
    tstri = datestr(all_casts_preQC(n).time);
    if str2num(tstri(8)) == 0
        tstri(8) = '2';
        if datenum(tstri)>datenum('Jan-01-2023')
            tstri(8:9) = '19';
        end
        all_casts_preQC(n).time = datenum(tstri);
    end
    
    else
         all_casts_preQC(n).time = NaN;
    end
    
    if isempty(all_casts_preQC(n).lat)
        all_casts_preQC(n).lat = NaN;
    end
    if isempty(all_casts_preQC(n).lon)
        all_casts_preQC(n).lon = NaN;
    end
end


% remove any profiles that do not have a lat, lon or time
m = 1;
for n = 1:length(all_casts_preQC)
    if ~isnan(all_casts_preQC(n).time) && ~isnan(all_casts_preQC(n).lat) && ~isnan(all_casts_preQC(n).lon)
        all_casts_int(n) = all_casts_preQC(n);
        m = m+1;
    end
end

% NaN out unlikely values for T and S
for n = 1:length(all_casts_int)
    indT = find(all_casts_int(n).T<-2 | all_casts_int(n).T>25);
    if length(indT) == length(all_casts_int(n).T)
        all_casts_int(n).T = NaN;
    else
        all_casts_int(n).T(indT) = NaN;
    end
    
    if ~isnan(all_casts_int(n).S)
        indS = find(all_casts_int(n).S<0 | all_casts_int(n).S>35);
        if length(indS) == length(all_casts_int(n).S)
            all_casts_int(n).S = NaN;
        else
            all_casts_int(n).S(indS) = NaN;
        end
    end
end

% Select profiles and points with data - so we are getting rid of points
% that don't have any Temperature data or points where all the data was
% bad/outside of the expected values range
m = 1;
for n = 1:length(all_casts_int)
    if sum(isnan(all_casts_int(n).T)) ~=length(all_casts_int(n).T)
        all_casts_QC(m) = all_casts_int(n);
        
        if length(all_casts_QC(m).T) ==1 && isnan(all_casts_QC(m).T)
            all_casts_QC(m) = [];
        end
        m = m+1;
    end
end


    
%% get rid of repeated profiles
ala = [all_casts_QC.lat];
alo = [all_casts_QC.lon];
alt = [all_casts_QC.time];
profID = [ala' alo' alt'];

[pID,~,idx] = unique(profID,'rows');
numoccurences = accumarray(idx,1);
indices = accumarray(idx, find(idx),[],@(rows){rows});

m = 1;
for n = 1:length(numoccurences)
    if numoccurences(n) == 1
        all_casts(n) = all_casts_QC(indices{n});
    else
        all_casts(n) = all_casts_QC(indices{n}(1));
    end
end

 %% filter out data that is out in the gulf of ak


rx = [54.4078;
   54.4547;
   56.1518;
   57.8201;
   58.8565;
   59.3737;
   59.7209;
   59.7412;
   59.9638;
   59.4966;
   59.5579;
   58.8357;
   58.3527;
   57.6696;
   57.6480;
   58.0341;
   58.7731;
   59.4966;
   60.6623;
   61.5386;
   61.4500;
   60.8395;
   60.2250;
   60.4046;
   60.9571;
   61.3653;
   61.3073;
   60.6228;
   60.6228;
   59.8628;
   58.3527;
   56.6203;
   55.2894;
   54.5015];
% 
ry =[-129.4987;
 -133.8509;
 -135.3017;
 -137.3166;
 -139.2106;
 -140.8628;
 -142.3941;
 -144.9329;
 -145.7389;
 -148.0358;
 -149.0030;
 -151.1791;
 -152.5895;
 -154.2820;
 -155.1283;
 -155.4507;
 -153.7985;
 -154.3626;
 -152.7910;
 -150.6149;
 -149.4060;
 -149.6478;
 -150.0507;
 -149.0836;
 -148.8418;
 -148.6806;
 -145.5777;
 -144.6105;
 -139.3718;
 -134.3748;
 -132.6017;
 -130.5062;
 -128.6525;
 -129.3376];


ptskeep = inpolygon([all_casts(1:end).lat],[all_casts(1:end).lon],rx,ry);


%% --------- save csv file of profile lat, lon, date
if save_csv ==1
    cst_prof = table(coast_prof.lat,coast_prof.lon,datestr(coast_prof.time,'mm/dd/yyyy'));
    writetable(cst_prof,[savepath 'profile_locations/coast_profiles_date.csv'])
end

%% --------- save mat file of profile lat, lon, time
% if save_mat ==1
%     save([savepath 'profile_locations/coast_profile_locations.mat'],'coast_prof')
% end

%% ---------- save all profile casts 
save_casts =1;
if save_casts ==1
    save([savepath 'all_profile_data.mat'],'all_casts')
end
%% select coast casts
coast_casts = all_casts(ptskeep);


if save_casts == 1
    save([savepath 'coast_profile_data.mat'],'coast_casts')
end

%% --------- Average profile data from each individual cast into a matrix 
% Will average by 5 meters
profiles.lat = NaN*ones(size(coast_casts));
profiles.lon = NaN*ones(size(coast_casts));
profiles.time = NaN*ones(size(coast_casts));
profiles.z = 2.5:5:1000;
profiles.T = NaN*ones(length(profiles.z),length(profiles.lat));
profiles.S = NaN*ones(length(profiles.z),length(profiles.lat));

    

for n =1:length(coast_casts)
    
    if ~isempty(coast_casts(n).lat) && ~isempty(coast_casts(n).time)
    profiles.lat(n) = coast_casts(n).lat;
    profiles.lon(n) = coast_casts(n).lon;
    profiles.time(n) = coast_casts(n).time;
    profiles.link{n} = coast_casts(n).link;
    profiles.doi{n} = coast_casts(n).doi;
    for dd = 1:length(profiles.z)
        dind = find(coast_casts(n).z>=profiles.z(dd)-2.5 & coast_casts(n).z<profiles.z(dd)+2.5);
        
        if ~isnan(coast_casts(n).T)
            profiles.T(dd,n) = nanmean(coast_casts(n).T(dind));
        end
        
        if ~isnan(coast_casts(n).S)
            profiles.S(dd,n) = nanmean(coast_casts(n).S(dind));
        end
        
    end
    end
end


if save_casts ==1 
    save([savepath 'profile_data_matrix.mat'],'profiles')
end

