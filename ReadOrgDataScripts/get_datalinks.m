%%% Get and pull out the data links and dois from files and export to a csv
%%% 
%%% Anna Simpson
%%% Sept 23,2022

load([rootdir '2 Alaska Fjord Data Gathering Project/Data/data_output/'])

%% Select the datalinks for the data

m = 1;
for n = 1:length(fjord.casts)
    if ~isempty(fjord.casts(n).link)
        
        for fc = 1:length(fjord.casts(n).link)
            if iscell(fjord.casts(n).link)
                if ~isempty(fjord.casts(n).link{fc})
                    datalinks{m} = fjord.casts(n).link(fc);
                    if ~isempty(fjord.casts(n).doi)
                        datadois{m} = fjord.casts(n).doi(fc);
                    else
                        datadois{m} = [];
                    end
                    m = m+1;
                end
            else
                datalinks{m} = fjord.casts(n).link;
%                 datadois{m} = fjord.casts(n).doi;
                m = m+1;
            end
        end
    end
end

%% Select out the DOIs for the data
for n =1:length(datadois)
    if iscell(datadois{n})
       datadois(n) = datadois{n};
       
       if isempty(datadois{n})
           datadois{n} = '';
       end   
    end
end

for n = 1:length(datalinks)
     if iscell(datalinks{n})
       datalinks(n) = datalinks{n};
       
       if isempty(datalinks{n})
           datalinks{n} = '';
       end   
    end
end
%% merge the data links and dois and export as a csv

DataLinks = [datalinks' datadois'];

writecell(DataLinks,[rootdir '/2 Alaska Fjord Data Gathering Project/Data/data_output/datalinks.csv'])