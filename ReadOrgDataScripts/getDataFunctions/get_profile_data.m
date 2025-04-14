 % get profile data
% prof_type = 'CTD';
function[profilecast] = get_profile_data(prof_type,wod_path)
% first read in the depth (z) data 
wod_profile.lat = ncread([wod_path 'ocldb1623005924.12638_' prof_type '.nc'],'lat');
wod_profile.lon = ncread([wod_path 'ocldb1623005924.12638_' prof_type '.nc'],'lon');
wod_profile.date = ncread([wod_path 'ocldb1623005924.12638_' prof_type '.nc'],'date');
wod_profile.time = datenum(num2str(wod_profile.date),'yyyymmdd');

z_rowsize = ncread([wod_path 'ocldb1623005924.12638_' prof_type '.nc'],'z_row_size'); 
temp_rowsize = ncread([wod_path 'ocldb1623005924.12638_' prof_type '.nc'],'Temperature_row_size');

if ~endsWith(prof_type,'T')
    sal_rowsize = ncread([wod_path 'ocldb1623005924.12638_' prof_type '.nc'],'Salinity_row_size');
    Sal = ncread([wod_path 'ocldb1623005924.12638_' prof_type '.nc'],'Salinity');
else
    sal_rowsize = [];
end


Z = ncread([wod_path 'ocldb1623005924.12638_' prof_type '.nc'],'z');
Temp = ncread([wod_path 'ocldb1623005924.12638_' prof_type '.nc'],'Temperature');


zstart = 1;
tstart = 1;
sstart = 1;
% ctdcast_info.date = wod_ctd.date;
% ctdcast_info.time = wod_ctd.time;
% ctdcast_info.lat = wod_ctd.lat;
% ctdcast_info.lon = wod_ctd.lon;
    
for n = 1:length(z_rowsize)
%     profilecast{n}.date = wod_profile.date(n);
    profilecast{n}.lat = wod_profile.lat(n);
    profilecast{n}.lon = wod_profile.lon(n);
    profilecast{n}.time = wod_profile.time(n);
    
    
    zind = zstart:zstart+z_rowsize(n)-1;
    if isnan(zind)
        profilecast{n}.z = NaN;
    else
        profilecast{n}.z = Z(zind);
    end
    
    tind = tstart:tstart+temp_rowsize(n)-1;
    if isnan(tind)
        profilecast{n}.T = NaN;
    else
        profilecast{n}.T = Temp(tind);
    end
 
    if ~isempty(sal_rowsize) 
        sind = sstart:sstart+sal_rowsize(n)-1;
        if isnan(sind)
            profilecast{n}.S = NaN;
        else
            profilecast{n}.S = Sal(sind);
        end
        sstart = sstart+sal_rowsize(n);
    else
        profilecast{n}.S = NaN;
    end
    
    profilecast{n}.link = 'https://www.ncei.noaa.gov/access/world-ocean-database-select/dbsearch.html';
    profilecast{n}.doi = [];
    zstart = zstart+z_rowsize(n);
    tstart = tstart+temp_rowsize(n);
    
end

%%
