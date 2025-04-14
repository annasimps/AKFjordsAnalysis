%%% This script plots the profile locations

%%% Anna Simpson
%%% Updated: Oct 2,2022



%% Plot the profile locations
figure
gx = geoaxes;
geobasemap(gx,'grayterrain')
geoscatter(profiles.lat,profiles.lon,'k.')
hold on
