%%% This script makes the overview figures that summarize the spatial and 
%%% temporal distribution for the data we have gathered across the Gulf of
%%% Alaska 
%%% 
%%% 4 figures MADE IN THIS SCRIPT:
%%% => 1) map of the total number of profiles in each fjord
%%% => 2) map of total number of profiles in each fjord divided by season
%%% => 3) time series for the number of profiles in fjord/region divided by
%%% season and year
%%% => 4) STILL TO BE ADDED: distribution of the physical characteristics
%%% that were collected as part of this project 
%%% 
%%% Anna Simpson
%%% Updated September 13, 2022
%%%

%%
% set the root directory to match the directory path on local computer -
% the path is set in the RUNFIRST_initialize_scripts.m file

% rootdir = '/Volumes/GoogleDrive/Shared drives/'; 

% decide if you want to save plots or not
save_plot = 0;  % 0 = NO saving, 1 = save plots



%% LOAD DATA
rootdir = '/Volumes/GoogleDrive/Shared drives/';
figpath = ['/Users/simpson/Dropbox/Apps/Overleaf/akfjords_nps_paper/']; %[rootdir '2 Alaska Fjord Data Gathering Project/figures/paper_figs/'];
fdir = dir([rootdir '2 Alaska Fjord Data Gathering Project/Data/data_output/fjord_profiles_num/*.mat']);

load([rootdir '2 Alaska Fjord Data Gathering Project/Data/data_output/fjord_data_combined.mat'])



%% analysis GETS THE SUM TOTAL NUMBER OF FJORDS PER SEASON FOR EACH FJORD
   numprof.lat = fjord.lat;
   numprof.lon = fjord.lon;
   numprof.win = nansum(fjord.prof_num.win,2);  
   numprof.win(find(numprof.win==0))= NaN;
   numprof.spr = nansum(fjord.prof_num.spr,2);
   numprof.spr(find(numprof.spr==0))= NaN;
   numprof.sum = nansum(fjord.prof_num.sum,2);
   numprof.sum(find(numprof.sum==0))= NaN;
   numprof.fal = nansum(fjord.prof_num.fal,2);
   numprof.fal(find(numprof.fal==0))= NaN;
   numprof.tot = nansum(fjord.prof_num.tot,2);
   numprof.tot(find(numprof.tot==0)) = NaN;

%% figure: MAP: NUMBER OF PROFILES IN FJORD PER SEASON
set(0,'DefaultFigureWindowStyle','normal')
figure
% set(gcf,'Position',[376 60 1476 925])
set(gcf,'Units','centimeters','Position', [0 0 16.8 10])
set(gcf,'Color','w')
txtsize = 9;

nn = 1;
for n = 1:2
    for j = 1:2
        
        gx(nn) = geoaxes('Position', [0.05+(j-1)*0.45 0.05+(n-1)*0.5 0.4 0.4]);
        geobasemap 'colorterrain'% topographic
        hold on, box on
        nn = nn+1;
%         lat = [54.5 62];
%         lon = [-154.5 -131];
%         geoplot(gx(n), lat, lon);
    end
end

dsize = 50;

for nm = 1:length(numprof.win)
    if isnan(numprof.win(nm))
        geoscatter(gx(3),numprof.lat(nm),numprof.lon(nm),dsize,numprof.win(nm),'filled','MarkerEdgeColor',colors.bk1,'MarkerEdgeAlpha',.7);
    end
end
geoscatter(gx(3),numprof.lat,numprof.lon,dsize,numprof.win,'filled','MarkerFaceAlpha',.7);
% colormap(gx(3),cmocean('tempo',200))
colormap(gx(3),brewermap(200,'YlOrRd'))
% c1 = colorbar(gx(3),'Position',[0.455 0.5500 0.01 0.4000]);;
%  c1.Limits = [0 50];
caxis(gx(3),[0 50])
% caxis([0 50])

for nm = 1:length(numprof.spr)
    if isnan(numprof.spr(nm))
        geoscatter(gx(4),numprof.lat(nm),numprof.lon(nm),dsize,numprof.spr(nm),'filled','MarkerEdgeColor',colors.bk1,'MarkerEdgeAlpha',.7);
    end
end
geoscatter(gx(4),numprof.lat,numprof.lon,dsize,numprof.spr,'filled','MarkerFaceAlpha',.7);
% colormap(gx(4),cmocean('tempo',500))
colormap(gx(4),brewermap(100,'YlOrRd'))
c2 = colorbar(gx(4),'Position',[0.925 0.05 0.015 0.92]);
ylabel(c2,'Number of Profiles','fontsize',txtsize,'Fontweight','bold','FontName','Arial')
caxis(gx(4),[0 50])

% caxis([0 50])

for nm = 1:length(numprof.sum)
    if isnan(numprof.sum(nm))
        geoscatter(gx(1),numprof.lat(nm),numprof.lon(nm),dsize,numprof.sum(nm),'filled','MarkerEdgeColor',colors.bk1,'MarkerEdgeAlpha',.7);
    end
end
geoscatter(gx(1),numprof.lat,numprof.lon,dsize,numprof.sum,'filled','MarkerFaceAlpha',.7);
colormap(gx(1),brewermap(100,'YlOrRd'))
% c3 = colorbar(gx(1),'Location','North');%'Position',[0.455 0.0500 0.01 0.4000]);
caxis(gx(1),[0 100])
% c3.Position = [0.47 0.0500 0.01 0.4000];
% caxis([0 50])

for nm = 1:length(numprof.fal)
    if isnan(numprof.fal(nm))
        geoscatter(gx(2),numprof.lat(nm),numprof.lon(nm),dsize,numprof.fal(nm),'filled','MarkerEdgeColor',colors.bk1,'MarkerEdgeAlpha',.7);
    end
end
geoscatter(gx(2),numprof.lat,numprof.lon,dsize,numprof.fal,'filled','MarkerFaceAlpha',.7);
% ylabel(c,'Number of Profiles','fontsize',30)
colormap(gx(2),brewermap(100,'YlOrRd'))
% c4 = colorbar(gx(2),'Position',[0.905 0.0500 0.01 0.4000]);
caxis(gx(2),[0 50])
% caxis([0 50])

gx(1).Position = [0.05 0.05 0.43 0.45];
gx(2).Position = [0.49 0.050 0.43 0.45];
gx(3).Position = [0.05 0.52 0.43 0.45];
gx(4).Position = [0.49 0.52 0.43 0.45];

seaslabel = [{'Summer'};{'Fall'};{'Winter'};{'Spring'}];
abcd = 'cdab';
for n = 1:length(gx)
    gx(n).LatitudeLabel.String = [];
    gx(n).LongitudeLabel.String = [];
    gx(n).FontSize = txtsize;
    gx(n).FontWeight = 'bold';
    gx(n).FontName = 'Arial';
%     geolimits(gx(n),[60 61.5],[-149 -146.5]) %pws
%     geolimits(gx(n),[59 60.25],[-152.5 -148.5]) %kenai
%     geolimits(gx(n),[58 61],[-145 -137.5]) %yakutat
%     geolimits(gx(n),[57.75 60.75],[-158 -150]) %cook
%     geolimits(gx(n),[55.5 59.5],[-140.5 -129]) %southeast
%     geolimits(gx(n),[56 62],[-156 -130])
    text(gx(n),0.02,0.95,[abcd(n) '.) ' seaslabel{n}],'units','normalized','Fontsize',txtsize,'Fontweight','bold','FontName','Arial')
end
% linkaxes(gx)
gx(4).LatitudeAxis.TickLabel = [];
gx(2).LatitudeAxis.TickLabel = [];

gx(3).LongitudeAxis.TickLabel = [];
gx(4).LongitudeAxis.TickLabel = [];    

if save_plot ==1; export_fig([figpath 'Fig04_seasProfSpat.png']); 
 print -dpng -r600 Fig04_seasProfSpat.png
%  print -dpng -r600 seasprofiles_southeast.png
end%'profile_num_map_by_season.png']); end


%% figure : MAP: TOTAL NUMBER OF PROFILES IN EACH FJORD
set(0,'DefaultFigureWindowStyle','normal')
figure
set(gcf,'Units','centimeters','Position', [0 0 16.8 10])%[376 60 1476 925])
% figure;%('Color',[1 1 1],'Paperunits','centimeters',...
%          'Papersize',[2 1],'PaperPosition',[0 0 2 1])
     
set(gcf,'Color','w')
geobasemap colorterrain
hold on, box on

latx = 56: 0.25:62;
lony = 131:0.25:155; 
% 
% for nm = 1:length(numprof.tot)
%     if isnan(numprof.tot(nm))
%         geoscatter(numprof.lat(nm),numprof.lon(nm),dsize,numprof.tot(nm),'filled','MarkerEdgeColor',colors.bk1,'MarkerEdgeAlpha',.7);
%     end
% end
geoscatter(numprof.lat,numprof.lon,10,colors.bk1,'filled','MarkerFaceAlpha',.7);
geoscatter(numprof.lat,numprof.lon,dsize,numprof.tot,'filled','MarkerFaceAlpha',.7);

for n = 1:size(fjord.prof_num.tot,1)
    if sum(~isnan(fjord.prof_num.tot(n,:)))>10
        geoscatter(numprof.lat(n),numprof.lon(n),dsize,colors.bk1,'MarkerEdgeAlpha',1);
    end
end
colormap(brewermap(100,'YlOrRd'))
caxis([0 100])
c = colorbar;
c.Position = [0.91 0.1095 0.015 0.8163];
ylabel(c,'Number of Profiles','fontsize',txtsize,'Fontweight','bold','FontName','Arial')
set(gca,'Fontsize',txtsize,'Fontweight','bold','FontName','Arial')
geolimits([55 61.5],[-156 -130])

% if save_plot ==1;  print(gcf,[figpath 'Fig03_totalNumProfSpat.pdf'],'-dpdf','-painters');end%
if save_plot ==1; export_fig([figpath 'Fig03_totalNumProfSpat.pdf']);
print -dpng -r600 Fig03_totalNumProfSpat.png
end%'profile_tot_map.png']); end

% %% figure: TIME SERIES: NUMBER OF PROFILES IN EACH FJORD PER SEASON
% clear ax
% figure
% set(gcf,'Units','centimeters','Position', [0 0 16.8 10])
% % figure('Color',[1 1 1],'Paperunits','centimeters',...
% %         'Papersize',[16 12],'PaperPosition',[0 0 16 12])
% % set(gcf,'Position',[376 60 1476 925])
% set(gcf,'Color','w')
% 
% ax(1) = subplot(411); % Winter
% hold on, grid on, box on
% 
% ax(2) = subplot(412); % Spring
% hold on, grid on, box on
% 
% ax(3) = subplot(413); % summer
% hold on, grid on, box on
% 
% ax(4) = subplot(414); % fall
% hold on, grid on, box on
% 
% seas = {'win';'spr';'sum';'fal'};
% colors2plot = {'Blues';'Reds';'Greens';'Purples';'Greys'};
% regionnames = {'cook';'kenai';'prince';'yakutat';'southeast'};
% 
% for n = 1:length(seas)
%     seasdata = fjord.prof_num.(seas{n});
%     seasdata(find(seasdata == 0)) = NaN;
%     
%     ycord = linspace(0,280,6);
%     ycord = fliplr(ycord);
%     
%     
%     for m = 1:length(regionnames)
%        indreg = find(contains(fjord.geog_region,regionnames{m}));
%        regiondata = [];
%         
%         a = 1;
%         for mm = 1:length(indreg)
%             
%             sumNan = sum(isnan(seasdata(indreg(mm),:)));
%             
%             if sumNan <78
%                 regiondata(a,:) = seasdata(indreg(mm),:);
%                 a = a+1;
%             end
%         end
%         
%        numFjords = size(regiondata,1);
%        
%        if ~isempty(regiondata)
%             cmap = flipud(brewermap(size(regiondata,1)*2,colors2plot{m}));
%             cmap = flipud(cmap(1:size(regiondata,1),:));
%        else
%             cmap = flipud(brewermap(10*2,colors2plot{m}));
%             cmap = flipud(cmap(1:10,:));
%        end
%        
%        for rd = 1:size(regiondata,1)
%            plot(fjord.prof_num.yr,regiondata(rd,:),'.','Markersize',15,'Color',cmap(rd,:),'Parent',ax(n))
%        end
%        %52,53,54
%       rectangle(ax(n),'Position',[ 1946 ycord(m) 1 ycord(m)-ycord(m+1)],'FaceColor',cmap(1,:),'EdgeColor',cmap(1,:)) 
%       rectangle(ax(n),'Position',[ 1947 ycord(m) 1 ycord(m)-ycord(m+1)],'FaceColor',cmap(end,:),'EdgeColor',cmap(end,:))
%       text(ax(n),1948,ycord(m)+(ycord(m)-ycord(m+1))/2,[regionnames{m} ' : ' num2str(numFjords)],'Fontsize',txtsize,'FontName','Arial')
% 
%         
%         
%     end
% end
% 
% seaslabel = {'Winter';'Spring';'Summer';'Fall'};
% seasmark = 'abcdefg';
% 
% for n = 1:length(ax)
%     text(ax(n),0.001,0.93,[seasmark(n) ') ' seaslabel{n}],'units','normalized','Fontsize',txtsize,'Fontweight','bold','FontName','Arial')
%     ax(n).FontSize = txtsize;
%     ax(n).XLim = [1945 2022];
% %     ax(n).YLim = [1e0 500];
% %     ax(n).YLim = [0 400];
%     ax(n).XTickLabel = [];
%     set(ax(n),'YScale','log')
%     ax(n).FontName = 'Arial';
% %     ax(n).YTickLabel = {'1';'10';'100';'500'};
% %     ax(n).YTick = [0 100 200 300];
% %     ax(n).YTickLabel = {'0';'100';'200';'300'};
%     ax(n).FontWeight = 'bold';
% end
% xtickmarks = ['1950';'1960';'1970';'1980';'1990';'2000';'2010';'2020'];
% 
% ax(4).XTickLabel = xtickmarks;
% h = text(ax(3),-0.075,1,'Number of profiles','fontsize',txtsize,'Rotation',90,'units','normalized','HorizontalAlignment','center','Fontweight','bold','FontName','Arial');
% ax(4).XLabel.String = 'Year';
% ax(4).XLabel.FontWeight = 'bold';
% ax(4).XLabel.FontSize = txtsize;
% ax(4).XLabel.FontName = 'Arial';
% ax(1).Position = [0.1300 0.7673 0.7750 0.2];
% ax(2).Position = [0.1300 0.5482 0.7750 0.2];
% ax(3).Position = [0.1300 0.3291 0.7750 0.2];
% ax(4).Position = [0.1300 0.1100 0.7750 0.2];
% 
% %  if save_plot ==1;  print(gcf,[figpath 'Fig05_seasProfTime.pdf'],'-dpdf','-painters');end%
% if save_plot ==1; export_fig([figpath 'Fig05_seasProfTime.pdf']);end%'profile_num_timeseries_by_season.png']); end
% 
%% figure: TIME SERIES: NUMBER OF PROFILES IN EACH FJORD PER SEASON REDO to simplify colors
clear ax
figure
set(gcf,'Units','centimeters','Position', [0 0 16.8 10])
% figure('Color',[1 1 1],'Paperunits','centimeters',...
%         'Papersize',[16 12],'PaperPosition',[0 0 16 12])
% set(gcf,'Position',[376 60 1476 925])
set(gcf,'Color','w')

ax(1) = subplot(411); % Winter
hold on, grid on, box on

ax(2) = subplot(412); % Spring
hold on, grid on, box on

ax(3) = subplot(413); % summer
hold on, grid on, box on

ax(4) = subplot(414); % fall
hold on, grid on, box on

seas = {'win';'spr';'sum';'fal'};
colors2plot = {'Blues';'Reds';'Greens';'Purples';'Greys'};
colors2plot = [colors.b;colors.r;colors.dg;colors.p;colors.bk1];
regionnames = {'cook';'kenai';'prince';'yakutat';'southeast'};

for n = 1:length(seas)
    seasdata = fjord.prof_num.(seas{n});
    seasdata(find(seasdata == 0)) = NaN;
    
    ycord = linspace(0,280,6);
    ycord = fliplr(ycord);
    
     lgnames = [];
    for m = 1:length(regionnames)
       indreg = find(contains(fjord.geog_region,regionnames{m}));
       regiondata = [];
        
        a = 1;
        for mm = 1:length(indreg)
            
            sumNan = sum(isnan(seasdata(indreg(mm),:)));
            
            if sumNan <78
                regiondata(a,:) = seasdata(indreg(mm),:);
                a = a+1;
            end
        end
        
       numFjords = size(regiondata,1);
       
%        if ~isempty(regiondata)
%             cmap = flipud(brewermap(size(regiondata,1)*2,colors2plot{m}));
%             cmap = flipud(cmap(1:size(regiondata,1),:));
%        else
%             cmap = flipud(brewermap(10*2,colors2plot{m}));
%             cmap = flipud(cmap(1:10,:));
%        end
       
       if ~isempty(regiondata)
           pl(m) = plot(fjord.prof_num.yr(1),regiondata(1,1),'.','Markersize',15,'Color',colors2plot(m,:),'Parent',ax(n));
           if isempty(lgnames)
               lgnames = {regionnames{m}};
           else
               lgnames = [lgnames;{regionnames{m}}];
           end
       end
       for rd = 1:size(regiondata,1)
           plot(fjord.prof_num.yr,regiondata(rd,:),'.','Markersize',15,'Color',colors2plot(m,:),'Parent',ax(n))
       end
       %52,53,54
%       rectangle(ax(n),'Position',[ 1946 ycord(m) 1 ycord(m)-ycord(m+1)],'FaceColor',cmap(1,:),'EdgeColor',cmap(1,:)) 
%       rectangle(ax(n),'Position',[ 1947 ycord(m) 1 ycord(m)-ycord(m+1)],'FaceColor',cmap(end,:),'EdgeColor',cmap(end,:))
%       text(ax(n),1948,ycord(m)+(ycord(m)-ycord(m+1))/2,[regionnames{m} ' : ' num2str(numFjords)],'Fontsize',txtsize,'FontName','Arial')
   
        
        
    end
     
end
lg = legend(pl,lgnames,'location','north','Orientation','horizontal','fontsize',txtsize,'Color','none');
lg.Position = [0.1991    0.94    0.6376    0.0389];
seaslabel = {'Winter';'Spring';'Summer';'Fall'};
seasmark = 'abcdefg';

for n = 1:length(ax)
    text(ax(n),0.001,0.93,[seasmark(n) ') ' seaslabel{n}],'units','normalized','Fontsize',txtsize,'Fontweight','bold','FontName','Arial')
    ax(n).FontSize = txtsize;
    ax(n).XLim = [1945 2022];
%     ax(n).YLim = [1e0 500];
%     ax(n).YLim = [0 400];
    ax(n).XTickLabel = [];
    set(ax(n),'YScale','log')
    ax(n).FontName = 'Arial';
%     ax(n).YTickLabel = {'1';'10';'100';'500'};
    ax(n).YTick = [0 10 100];
%     ax(n).YTickLabel = {'0';'100';'200';'300'};
    ax(n).FontWeight = 'bold';
end
xtickmarks = ['1950';'1960';'1970';'1980';'1990';'2000';'2010';'2020'];

ax(4).XTickLabel = xtickmarks;
h = text(ax(3),-0.075,1,'Number of profiles','fontsize',txtsize,'Rotation',90,'units','normalized','HorizontalAlignment','center','Fontweight','bold','FontName','Arial');
ax(4).XLabel.String = 'Year';
ax(4).XLabel.FontWeight = 'bold';
ax(4).XLabel.FontSize = txtsize;
ax(4).XLabel.FontName = 'Arial';
ax(1).Position = [0.1300 0.73 0.7750 0.19];
ax(2).Position = [0.1300 0.52 0.7750 0.19];
ax(3).Position = [0.1300 0.31 0.7750 0.19];
ax(4).Position = [0.1300 0.1 0.7750 0.19];

%  if save_plot ==1;  print(gcf,[figpath 'Fig05_seasProfTime.pdf'],'-dpdf','-painters');end%
if save_plot ==1; export_fig([figpath 'Fig05_seasProfTime.pdf']);end%'profile_num_timeseries_by_season.png']); end



