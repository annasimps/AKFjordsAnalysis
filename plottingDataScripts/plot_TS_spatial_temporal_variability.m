%%% Investigate the temporal and spatial variability in fjords
txtsize = 8;
save_plot = 0;  % 0 = NO saving, 1 = save plots
figpath = ['/Users/annasimpson/Dropbox/Apps/Overleaf/akfjords_nps_paper/'];
%% Load data to make figures/etc
load([rootdir '2 Alaska Fjord Data Gathering Project/Data/data_output/fjord_data_combined.mat'])

avgTandS

%%
% Select which fjord to plot 
% kachemak bay = 48;  glacier bay= 32;
fjInd = 32;

% figure
% set(gcf,'Units','centimeters','Position', [0 0 16.8 16])
% % set(gcf,'Position',[376 60 1476 925])
% set(gcf,'Color','w')
% ax(1) = subplot(2,4,1); % Winter
% hold on, grid on, box on
% 
% ax(2) = subplot(2,4,2); % Spring
% hold on, grid on, box on
% 
% ax(3) = subplot(2,4,3); % summer
% hold on, grid on, box on
% 
% ax(4) = subplot(2,4,4); % fall
% hold on, grid on, box on
% 
% ax(5) = subplot(2,4,5); % Winter
% hold on, grid on, box on
% 
% ax(6) = subplot(2,4,6); % Spring
% hold on, grid on, box on
% 
% ax(7) = subplot(2,4,7); % summer
% hold on, grid on, box on
% 
% ax(8) = subplot(2,4,8); % fall
% hold on, grid on, box on

% Average Casts by year and season
mth = month(fjord.casts(fjInd).time);
mthnum = [ 1 2 3; 4 5 6; 7 8 9; 10 11 12];
seas = {'win';'spr';'sum';'fal'};

for m = 1:length(seas)
    seasind = find(mth>=mthnum(m,1) & mth<=mthnum(m,3));
    Tseas = fjord.casts(fjInd).T(:,seasind);
    Sseas = fjord.casts(fjInd).S(:,seasind);

    yr = year(fjord.casts(fjInd).time(seasind));

    yrs2Avg = unique(yr);
    zyrs = fjord.casts(fjInd).z;

    TyrAvg = NaN*ones(length(zyrs),length(yrs2Avg));
    TyrMin = NaN*ones(length(zyrs),length(yrs2Avg));
    TyrMax = NaN*ones(length(zyrs),length(yrs2Avg));
    SyrAvg = NaN*ones(length(zyrs),length(yrs2Avg));
    SyrMin(:,n) = NaN*ones(length(zyrs),length(yrs2Avg));
    SyrMax(:,n) = NaN*ones(length(zyrs),length(yrs2Avg));
    
    for n = 1:length(yrs2Avg)
        indyrs = find(yr == yrs2Avg(n));
        TyrAvg(:,n) = nanmean(Tseas(:,indyrs),2);
        TyrMin(:,n) = nanmin(Tseas(:,indyrs),[],2);
        TyrMax(:,n) = nanmax(Tseas(:,indyrs),[],2);
        SyrAvg(:,n) = nanmean(Sseas(:,indyrs),2);
        SyrMin(:,n) = nanmin(Tseas(:,indyrs),[],2);
        SyrMax(:,n) = nanmax(Tseas(:,indyrs),[],2);
    end

    yrCol = distinguishable_colors(length(yrs2Avg));
%% Plot things
% 
%     for n = 1:length(yrs2Avg)
%         avgz = moving_average(zyrs,2,2);
%         avgT = moving_average(TyrAvg(:,n),2,2);
%         minT = moving_average(TyrMin(:,n),2,2);
%         maxT = moving_average(TyrMax(:,n),2,2);
% 
%         indminmax = find(~isnan(minT) & ~isnan(maxT));
%         patch([minT(indminmax) fliplr(maxT(indminmax))], [avgz(indminmax) fliplr(avgz(indminmax))], yrCol(n,:),'FaceAlpha',0.2,'EdgeColor',yrCol(n,:),'EdgeAlpha',0,'Parent',ax(m))
%         plot(TyrAvg(:,n),zyrs,'linewidth',2,'Color',yrCol(n,:),'Parent',ax(m));
%         
%       
%     end
end

% seaslabel = [{'Winter'};{'Spring'};{'Summer'};{'Fall'};{'Winter'};{'Spring'};{'Summer'};{'Fall'}];
% abcd = 'abcdefgh';
% for n =1:8
% 
%     text(ax(n),0.02,0.95,[abcd(n) '.) ' seaslabel{n}],'units','normalized','Fontsize',txtsize)
%     
%     set(ax(n),'YDir','reverse')
%     set(ax(n),'XLim',[0 15])
%     set(ax(n),'YLim',[0 450])
%     ax(n).FontSize = txtsize;
%     
% end
% 
% text(ax(1),1.05,1.06,['Yearly Temperature Averages'],'units','normalized','Fontsize',txtsize,'HorizontalAlignment','center')
% 
% ylabel(ax(1),'Depth')
% ylabel(ax(3),'Depth')
% xlabel(ax(3),'Temperature')
% xlabel(ax(4),'Temperature')
% ax(1).Position = [0.1 0.55 0.4 0.2];
% ax(2).Position = [0.32 0.55 0.4 0.2];
% ax(3).Position = [0.54 0.55 0.4 0.2]; 
% ax(4).Position = [0.76 0.55 0.4 0.2];

% ax(5).Position = [0.1 0.08 0.4 0.2];
% ax(2).Position = [0.32 0.08 0.4 0.2];
% ax(3).Position = [0.54 0.08 0.4 0.2]; 
% ax(4).Position = [0.76 0.08 0.4 0.2];
%% Plot things from 1 station 
for m = 1:length(seas)
    seasind = find(mth>=mthnum(m,1) & mth<=mthnum(m,3));
    Tseas = fjord.casts(fjInd).T(:,seasind);
    Sseas = fjord.casts(fjInd).S(:,seasind);

%     yr = year(fjord.casts(fjInd).time(seasind));
% 
%     yrs2Avg = unique(yr);
%     zyrs = fjord.casts(fjInd).z;

    TyrAvg = NaN*ones(length(zyrs),length(yrs2Avg));
    TyrMin = NaN*ones(length(zyrs),length(yrs2Avg));
    TyrMax = NaN*ones(length(zyrs),length(yrs2Avg));
    SyrAvg = NaN*ones(length(zyrs),length(yrs2Avg));

    for n = 1:length(yrs2Avg)
        indyrs = find(yr == yrs2Avg(n));
        TyrAvg(:,n) = nanmean(Tseas(:,indyrs),2);
        TyrMin(:,n) = nanmin(Tseas(:,indyrs),[],2);
        TyrMax(:,n) = nanmax(Tseas(:,indyrs),[],2);
        SyrAvg(:,n) = nanmean(Sseas(:,indyrs),2);
    end

    yrCol = distinguishable_colors(length(yrs2Avg));
%% Plot things





    for n = 1:length(yrs2Avg)
        avgz = moving_average(zyrs,2,2);
        avgT = moving_average(TyrAvg(:,n),2,2);
        minT = moving_average(TyrMin(:,n),2,2);
        maxT = moving_average(TyrMax(:,n),2,2);

        indminmax = find(~isnan(minT) & ~isnan(maxT));
        patch([minT(indminmax) fliplr(maxT(indminmax))], [avgz(indminmax) fliplr(avgz(indminmax))], yrCol(n,:),'FaceAlpha',0.2,'EdgeColor',yrCol(n,:),'EdgeAlpha',0,'Parent',ax(m))
        plot(TyrAvg(:,n),zyrs,'linewidth',2,'Color',yrCol(n,:),'Parent',ax(m));
    end
end

seaslabel = [{'Winter'};{'Spring'};{'Summer'};{'Fall'}];
abcd = 'abcd';
for n =1:4

    text(ax(n),0.02,0.95,[abcd(n) '.) ' seaslabel{n}],'units','normalized','Fontsize',txtsize)
    
    set(ax(n),'YDir','reverse')
    set(ax(n),'XLim',[0 15])
    set(ax(n),'YLim',[0 450])
    ax(n).FontSize = txtsize;
    
end

text(ax(1),1.05,1.06,['Yearly Temperature Averages'],'units','normalized','Fontsize',txtsize,'HorizontalAlignment','center')

ylabel(ax(1),'Depth')
ylabel(ax(3),'Depth')
xlabel(ax(3),'Temperature')
xlabel(ax(4),'Temperature')
ax(1).Position = [0.1 0.55 0.4 0.38];
ax(2).Position = [0.55 0.55 0.4 0.38];
ax(3).Position = [0.1 0.08 0.4 0.38]; 
ax(4).Position = [0.55 0.08 0.4 0.38];

%% Select points in a specific areas for spatial comparison
%% Plot a map of the profile data to get locations
% figure
% gx = geoaxes;
% geobasemap(gx,'grayterrain')
% geoscatter(fjord.casts(fjInd).lat,fjord.casts(fjInd).lon,'k.')
% hold on
% 
% yy = 1;
% 
% rid = input('select area to get profiles from [y/n] ', 's');
% while(rid == 'y')
%     disp('Zoom in on area to get profiles from')
%     pause
% 
%     disp('Select points to plot')
%     [xb,yb] = ginput;
% 
%     indfjordint = inpolygon(fjord.casts(fjInd).lat,fjord.casts(fjInd).lon,xb,yb);
% 
%      % plots points on map in magenta
%     if numel(indfjordint)
%         ply = geoscatter(fjord.casts(fjInd).lat(indfjordint),fjord.casts(fjInd).lon(indfjordint),'m.')
%     end
%     
%     % prompt if pts are ok
%     aok = [];
%     while numel(aok) == 0
%         aok = input('ok? [y/n] ', 's')
%     end
%     
%     if aok == 'n'
%         ply = geoscatter(fjord.casts(fjInd).lat,fjord.casts(fjInd).lon,'k.')
% %         geoscatter(profile_num.lat(indfj),profile_num.lon(indfj),'c*')
%     end
%     
%      if aok == 'y'
% 
%          loc_casts(yy).lat = fjord.casts(fjInd).lat(indfjordint);
%          loc_casts(yy).lon = fjord.casts(fjInd).lon(indfjordint);
%          loc_casts(yy).time = fjord.casts(fjInd).time(indfjordint);
%          loc_casts(yy).z = fjord.casts(fjInd).z;
%          loc_casts(yy).T = fjord.casts(fjInd).T(:,indfjordint);
%          loc_casts(yy).S = fjord.casts(fjInd).S(:,indfjordint);
%      end
% 
%      % Prompt user to select another region
%     rid = input('select another station? [y/n] ', 's');
%     yy = yy+1;
% end
%

%% Load glacier bay file to look at variability at different locations

load('/Users/annasimpson/Library/CloudStorage/GoogleDrive-simpanna@oregonstate.edu/Shared drives/2 Alaska Fjord Data Gathering Project/Data/data_output/kachemak_bay_station_data.mat');
loc_casts = loc_casts(1:4);

figure
set(gcf,'Units','centimeters','Position', [0 0 16 12])
% set(gcf,'Position',[376 60 1476 925])
set(gcf,'Color','w')
%
ax(1) = subplot(2,5,1); % Winter
hold on, grid on, box on

ax(2) = subplot(2,5,2); % Spring
hold on, grid on, box on

ax(3) = subplot(2,5,3); % summer
hold on, grid on, box on

ax(4) = subplot(2,5,4); % fall
hold on, grid on, box on
% 
ax(5) = subplot(2,5,5); % 10m
hold on, grid on, box on

ax(6) = subplot(2,5,6); % 50m
hold on, grid on, box on

ax(7) = subplot(2,5,7); % 100m
hold on, grid on, box on

ax(8) = subplot(2,5,8); % 200m
hold on, grid on, box on

% ax(9) = subplot(2,5,9); % 400m
% hold on, grid on, box on

% Average Casts by year and season

mthnum = [ 1 2 3; 4 5 6; 7 8 9; 10 11 12];
seas = {'win';'spr';'sum';'fal'};
col = brewermap(4,'Dark2');
col(1,:) = colors.bk1;

for n = 1:length(loc_casts)
%     mth = month((loc_casts(n).time));
    mth = month(datetime(loc_casts(n).time,'ConvertFrom','datenum'));
    for m = 1:length(seas)
        seasind = find(mth>=mthnum(m,1) & mth<=mthnum(m,3));
        Tseas = loc_casts(n).T(:,seasind);
        Sseas = loc_casts(n).S(:,seasind);
        
        TAvg = nanmean(Tseas,2);
        tquant = quantile(Tseas,[0.05 0.95],2);
        TMin = tquant(:,1);
        TMax = tquant(:,2);
%         TMin = nanmin(Tseas,[],2);
%         TMax=  nanmax(Tseas,[],2);
        SAvg= nanmean(Sseas,2);
        Squant = quantile(Sseas,[0.05 0.95],2);
        SMin = Squant(:,1);
        SMax = Squant(:,2);

        %% Plot things

    
        avgz = moving_average(loc_casts(n).z,2,2);
        avgT = moving_average(TAvg,2,2);
        minT = moving_average(TMin,2,2);
        maxT = moving_average(TMax,2,2);

        indminmax = find(~isnan(minT) & ~isnan(maxT));
        patch([minT(indminmax) fliplr(maxT(indminmax))], [avgz(indminmax) fliplr(avgz(indminmax))], col(n,:),'FaceAlpha',0.2,'EdgeColor',col(n,:),'EdgeAlpha',0,'Parent',ax(m))
        plot(avgT,avgz,'linewidth',1,'Color',col(n,:),'Parent',ax(m));
  
        avgS = moving_average(SAvg,2,2);
        minS = moving_average(SMin,2,2);
        maxS = moving_average(SMax,2,2);

        indminmax = find(~isnan(minS) & ~isnan(maxS));
        patch([minS(indminmax) fliplr(maxS(indminmax))], [avgz(indminmax) fliplr(avgz(indminmax))], col(n,:),'FaceAlpha',0.2,'EdgeColor',col(n,:),'EdgeAlpha',0,'Parent',ax(m+4))
        plot(avgS,avgz,'linewidth',1,'Color',col(n,:),'Parent',ax(m+4));
    end
    if ~isempty(loc_casts(n).time)
        stationlat(n) = nanmean(loc_casts(n).lat);
        stationlon(n) = nanmean(loc_casts(n).lon);
    end
end

seaslabel = [{'Winter'};{'Spring'};{'Summer'};{'Fall'};{'Winter'};{'Spring'};{'Summer'};{'Fall'}];
abcd = 'abcdefghijklmn';
for n =1:8

    text(ax(n),0.02,0.05,[abcd(n) '.) ' seaslabel{n}],'units','normalized','Fontsize',txtsize)
    
    set(ax(n),'YDir','reverse')
%     set(ax(n),'YTickDir
%     set(ax(n),'YLim',[0 450])
    ax(n).FontSize = txtsize;
    
end
set(ax(1:4),'XLim',[2 12])
set(ax(5:8),'XLim',[28 33])
set(ax(2:4),'YTickLabel',[])
set(ax(1:4),'XTick',[3 6 9])
set(ax(5:8),'XTick',[27 30])
% ax(1).YTickLabel = Ylab;
% ax(5).YTickLabel = Ylab;
set(ax(6:8),'YTickLabel',[])
% set(ax(1:4),'XTickLabel',[])
% set(ax(2),'XTickLabel',[])
% set(ax(3),'XTickLabel',[{''};{'100'};{'200'};{'300'};{'400'}]
text(ax(1),2.1,1.1,['Glacier Bay Station Average Profiles'],'units','normalized','Fontsize',txtsize,'HorizontalAlignment','center')
text(ax(2),1,-0.15,['Temperature (\circC)'],'units','normalized','Fontsize',txtsize,'HorizontalAlignment','center')
text(ax(6),1,-0.15,['Salinity (psu)'],'units','normalized','Fontsize',txtsize,'HorizontalAlignment','center')

ylabel(ax(1),'Depth','Fontsize',txtsize)
ylabel(ax(5),'Depth','Fontsize',txtsize)
% xlabel(ax(3),'Temperature')
% xlabel(ax(4),'Temperature')

ax(1).Position = [0.1 0.53 0.12 0.31];
ax(2).Position = [0.225 0.53 0.12 0.31];
ax(3).Position = [0.35 0.53 0.12 0.31]; 
ax(4).Position = [0.475 0.53 0.12 0.31];

ax(5).Position = [0.1 0.15 0.12 0.31];
ax(6).Position = [0.225 0.15 0.12 0.31];
ax(7).Position = [0.35 0.15 0.12 0.31]; 
ax(8).Position = [0.475 0.15 0.12 0.31];

%create smaller axes in top right to plot a map of locations
%
% basemapName = "opentopomap"; 
% url = "a.tile.opentopomap.org/${z}/${x}/${y}.png"; 
% % copyright = char(uint8(169));
% att = 'OpenStreetMap';
% attribution = [ ...
%       "map data:  " + copyright + "OpenStreetMap contributors,SRTM", ...
%       "map style: " + copyright + "OpenTopoMap (CC-BY-SA)"]; 

basemapName = "usgstopo";
url = "https://basemap.nationalmap.gov/ArcGIS/rest/services/USGSTopo/MapServer/tile/${z}/${y}/${x}/png";
att = "Credit: USGS";

addCustomBasemap(basemapName,url,"Attribution",att)

% geoplot(lat,lon,"r","LineWidth",2)
% figure
% geobasemap(basemapName)
%
gx = geoaxes('Position',[.68 .25 .28 .5]);
box on, hold on
geobasemap(gx, basemapName)%'colorterrain' 
geoscatter(stationlat,stationlon,50,col,'filled')
geoscatter(stationlat,stationlon,50,'k')
gx.LatitudeLabel.String = [];
gx.LongitudeLabel.String = [];
gx.TickLabelFormat = 'dd';
gx.FontSize = txtsize;
%% Illustrate the temporal variability at different depths
% 10m,50m,100m,200m,400m

% Want a time series figure for each station at these different depths
depthplot = [10;50;100;200;300];
% figure
% 
% set(gcf,'Units','centimeters','Position', [0 0 12 12])
% set(gcf,'Color','w')


% abcd = 'abcdefg';

for n = 1:length(loc_casts)
    
    for m = 1:length(depthplot)
        inddepth = find_approx(loc_casts(n).z,depthplot(m));
        
        T2plot = nanmean(loc_casts(n).T(inddepth:inddepth+1,:),1);

        if sum(isnan(T2plot))~=length(T2plot)
            [sorttime,I] = sort(loc_casts(n).time);
            plot(sorttime,T2plot(I),'Color',col(n,:),'Parent',ax(m+4))
        end
    end
end

depthlabel = [{'10m'};{'50m'};{'100m'};{'200m'};{'300m'}];
for n =5:9

    text(ax(n),0.02,0.85,[abcd(n) '.) ' depthlabel{n-4}],'units','normalized','Fontsize',txtsize)
    
    set(ax(n),'YLim',[3 10])
    ax(n).FontSize = txtsize;
    ax(n).XLim = [datenum('01-Jan-1990') datenum('01-Jan-2023')];
    ax(n).XTick = [ 712224  715876  719529 723181 726834 730486 734139 737791 741444];
    ax(n).XTickLabel = [];
    
end
xlab = datestr(ax(5).XTick);
ax(9).XTickLabel = xlab(:,8:end);

ax(5).Position = [0.66 0.71 0.32 0.12];
ax(6).Position = [0.66 0.585 0.32 0.12];
ax(7).Position = [0.66 0.46 0.32 0.12];
ax(8).Position = [0.66 0.335 0.32 0.12];
ax(9).Position = [0.66 0.21 0.32 0.12];

gx = geoaxes('Position',[.07 .3 .2 .4]);
box on, hold on
geobasemap(gx, 'colorterrain')
geoscatter(stationlat,stationlon,50,col,'filled')
gx.LatitudeLabel.String = [];
gx.LongitudeLabel.String = [];
gx.TickLabelFormat = 'dd';
gx.FontSize = txtsize;