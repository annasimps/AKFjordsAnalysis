function ncprofile = get_nc_data(ncfile)
            NcInf = ncinfo(ncfile);
%             NcInf.Variables.Name
            
            for nn = 1:length(NcInf.Variables)
                fieldname{nn} = NcInf.Variables(nn).Name;
            end  
            
            time_check = contains(fieldname,'time');
            if sum(time_check)>1
%                time_check = matches(fieldname,'time');
               time_check = strcmp(fieldname,'time');
            end
            lat_check = contains(fieldname,'lat');
            if sum(lat_check)>1
%                lat_check = matches(fieldname,'lat');
               lat_check = strcmp(fieldname,'lat');
            end
            lon_check = contains(fieldname,'lon');
            if sum(lon_check)>1
%                lon_check = matches(fieldname,'lon');
                lon_check = strcmp(fieldname,'lon');
            end
            
            is_temp_dat = contains(fieldname,'temp');
            is_sal_dat = contains(fieldname,'sal');
            if sum(is_sal_dat)>1
%                 is_sal_dat = matches(fieldname,'salinity');
                is_sal_dat = strcmp(fieldname,'salinity');
            end
            is_dep_dat = contains(fieldname,'z');
            is_dep_dat2 = contains(fieldname,'dep');
            if sum(is_dep_dat2)>1;
%                 is_dep_dat2 = matches(fieldname,'depth');
                is_dep_dat2 = strcmp(fieldname,'depth');
            end
            is_vel_dat = contains(fieldname,'vel');
            is_ctd = [is_temp_dat;is_sal_dat;is_dep_dat;is_dep_dat2];
          
            
           
           
           if any(lat_check)
              NcData.lat = ncread(ncfile,fieldname{lat_check});
           end
           
           if any(lon_check)
              NcData.lon = ncread(ncfile,fieldname{lon_check}); 
           end
           
           if any(time_check)
              NcData.time = ncread(ncfile,fieldname{time_check}); 
              NcData.time_mat = double(NcData.time)./(24*3600)+datenum('1970-01-01 00:00:00');
           else
               NcData.time = NaN*ones(size(NcData.lat));
           end
           
           if any(is_vel_dat)
              NcData.isvel = ones(size(NcData.time));
           else
               NcData.isvel = zeros(size(NcData.time));
           end
           
           if sum(sum(is_ctd)) ==3
              NcData.isctd = ones(size(NcData.time));
              NcData.S = ncread(ncfile,fieldname{is_sal_dat}); 
              if any(is_dep_dat)
                  NcData.z = ncread(ncfile,fieldname{is_dep_dat});
              else
                  NcData.z = ncread(ncfile,fieldname{is_dep_dat2});
              end
           else
               NcData.isctd = zeros(size(NcData.time));
           end
           
           if any(is_temp_dat) 
              NcData.istmp = ones(size(NcData.time));
              NcData.T = ncread(ncfile,fieldname{is_temp_dat}); 
              if any(is_dep_dat)
                  NcData.z = ncread(ncfile,fieldname{is_dep_dat});
              else
                  NcData.z = ncread(ncfile,fieldname{is_dep_dat2});
              end
           else
               NcData.istmp = zeros(size(NcData.time));
           end
           
           if sum(NcData.isctd)~=0 | sum(NcData.istmp)~=0
                
                ncprofile.lat = NcData.lat;
                ncprofile.lon = NcData.lon;
                ncprofile.time = NcData.time_mat;
                ncprofile.z = NcData.z;
                ncprofile.T = NcData.T;
                if any(is_sal_dat)
                    ncprofile.S = NcData.S;
                else
                    ncprofile.S = [];
                end
           else
               
                ncprofile.lat = [];
                ncprofile.lon = [];
                ncprofile.time = [];
                ncprofile.z = [];
                ncprofile.T = [];
                ncprofile.S = [];
           end
%                 ncprofile.istmp = NcData.istmp;
%                 ncprofile.isctd = NcData.isctd;
%            if sum(NcData.isctd)~=0 | sum(NcData.istmp)~=0
%                if isempty(data.time)
%                    data.time = NcData.time_mat;
%                    data.lat = NcData.lat;
%                    data.lon = NcData.lon;
%                    data.istmp = NcData.istmp;
%                    data.isctd = NcData.isctd;
%                else
%                    data.time = [data.time; NcData.time_mat];
%                    data.lat = [data.lat; NcData.lat];
%                    data.lon = [data.lon; NcData.lon];
%                    data.istmp = [data.istmp; NcData.istmp];
%                    data.isctd = [data.isctd; NcData.isctd];
%                end
%            end
 
end
  
    