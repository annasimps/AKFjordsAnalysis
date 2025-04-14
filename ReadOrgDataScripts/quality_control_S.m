%%% Quality Control Data - incase the other quality controling didn't
%%% work...
%%% What I realized happened is that the quality controling was messed up
%%% in the read_data.m script - I fixed it there, but didn't want to go
%%% back and re-run everything, so I just did that here...
load([rootdir '2 Alaska Fjord Data Gathering Project/Data/data_output/fjord_data_combined.mat'])

for n = 1:length(fjord.casts)
    if ~isempty(fjord.casts(n).S)
        fjord.casts(n).S(find(fjord.casts(n).S>35)) = NaN;
        fjord.casts(n).S(find(fjord.casts(n).S<0)) = NaN;
    end
end

save([rootdir '2 Alaska Fjord Data Gathering Project/Data/data_output/fjord_data_combined.mat'],'fjord')
        