%%% Plot overview of physical characteristics in fjords across the Gulf of
%%% Alaska : 4 panel figure with
%%% 1.) outer sill height
%%% 2.) difference between width outer sill and width at head of fjord
%%% 3.) centerline length
%%% 4.) Indication if fjord has a tidewater glacier , receded in the last
%%% several decades, or no glacier

save_plot = 0;
%% load data
figpath = ['/Users/simpson/Dropbox/Apps/Overleaf/akfjords_nps_paper/']; %[rootdir '2 Alaska Fjord Data Gathering Project/figures/paper_figs/'];
load([rootdir '2 Alaska Fjord Data Gathering Project/Data/data_output/fjord_data_combined.mat'])

%% Figure with 4 map panels 
txtsize = 9;
figure
set(gcf,'Units','centimeters','Position', [0 0 16.8 10])
% set(gcf,'Position',[376 60 1476 925])
set(gcf,'Color','w')

nn = 1;
for n = 1:2
    for j = 1:2      
        gx(nn) = geoaxes('Position', [0.05+(j-1)*0.45 0.05+(n-1)*0.5 0.4 0.4]);
        geobasemap colorterrain
        hold on, box on
        nn = nn+1;
    end
end

dsize = 50;

% Plot 

geoscatter(gx(3),fjord.lat,fjord.lon,dsize,fjord.outer_sill_depth,'filled','MarkerFaceAlpha',0.7,'MarkerEdgeColor','k','MarkerEdgeAlpha',0.2);
colormap(gx(3),brewermap(200,'YlGnBu'))
c3 = colorbar(gx(3),'Location','south','Position',[0.12 0.61 0.3 0.015]);%'Position',[0.48 0.55 0.015 0.45]);
ylabel(c3,'Outer Sill Depth (m)','fontsize',txtsize,'Fontweight','bold','FontName','Arial')


geoscatter(gx(4),fjord.lat, fjord.lon,dsize,fjord.centerline_length,'filled','MarkerEdgeColor','k','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.2);
colormap(gx(4),brewermap(100,'YlOrRd'))
c2 = colorbar(gx(4),'Location','south','Position',[0.57 0.61 0.3 0.015]);%'Position',[0.94 0.55 0.015 0.45]);
ylabel(c2,'Centerline length (km)','fontsize',txtsize,'Fontweight','bold','FontName','Arial')
 caxis(gx(4),[0 80])

bayparam = (fjord.width_outer_sill-fjord.width_glac_term)/1000;
geoscatter(gx(1),fjord.lat,fjord.lon,dsize,bayparam ,'filled','MarkerFaceAlpha',0.7,'MarkerEdgeColor','k','MarkerEdgeAlpha',0.2);
colormap(gx(1),brewermap(100,'RdBu'))
c1 = colorbar(gx(1),'Location','south','Position',[0.12 0.14 0.3 0.015]);%'Position',[0.48 0.05 0.015 0.45]);
ylabel(c1,'Outer sill width  - fjord head width (km)','fontsize',txtsize,'Fontweight','bold','FontName','Arial')
caxis(gx(1),[-10 10])



glacpar = NaN*ones(size(fjord.lat));
for n = 1:length(fjord.lat)
    
    if ~isempty(fjord.glac_category{n})
        if contains(fjord.glac_category{n},'tidewater')
            glacpar(n) = 1;
%             gl(n) = geoscatter(gx(2),fjord.lat(n),fjord.lon(n),dsize,glacpar(n),'filled','MarkerFaceAlpha',.7);
            gl(n) = geoscatter(gx(2),fjord.lat(n),fjord.lon(n),dsize,colors.bk1,'filled','MarkerFaceAlpha',.7,'MarkerEdgeColor','k','MarkerEdgeAlpha',0.2);
            ldgnames{n} = 'Tidewater Glacier';
        end
        if contains(fjord.glac_category{n},'no_glacier')
            glacpar(n) = 2;
%              gl(n) = geoscatter(gx(2),fjord.lat(n),fjord.lon(n),dsize,glacpar(n),'filled','MarkerFaceAlpha',.7);
            gl(n) = geoscatter(gx(2),fjord.lat(n),fjord.lon(n),dsize,colors.b,'filled','MarkerFaceAlpha',.7,'MarkerEdgeColor','k','MarkerEdgeAlpha',0.2);
            ldgnames{n} = 'No Glacier';
        end
    else
        gl(n) = geoscatter(gx(2),fjord.lat(n),fjord.lon(n),dsize,'MarkerFaceAlpha',.7,'MarkerEdgeColor','k');
        ldgnames{n} = 'Unidentified';
    end
end

% gl = geoscatter(gx(2),fjord.lat,fjord.lon,dsize,glacpar,'filled','MarkerFaceAlpha',.7,'MarkerEdgeColor','k');
colormap(gx(2),brewermap(2,'Dark2'))
[a,b] = unique(ldgnames);
lg = legend([gl(b)],a);
lg.FontSize = 7;
% caxis(gx(2),[0 2])
lg.Position = [0.775 0.38 0.08 0.113];


gx(1).Position = [0.05 0.05 0.43 0.45];
gx(2).Position = [0.5 0.050 0.43 0.45];
gx(3).Position = [0.05 0.52 0.43 0.45];
gx(4).Position = [0.5 0.52 0.43 0.45];

seaslabel = [{'Width @ outer sill - Width @ fjord head'};{'Glacier Presence'};{'Outer Sill Depth'};{'Centerline Length'};];
abcd = 'cdab';
for n = 1:length(gx)
    gx(n).LatitudeLabel.String = [];
    gx(n).LongitudeLabel.String = [];
    gx(n).FontSize = txtsize;
    gx(n).FontWeight = 'bold';
    gx(n).FontName = 'Arial';
    geolimits(gx(n),[54.5 62],[-156 -130])
    text(gx(n),0.02,0.95,[abcd(n) '.) ' seaslabel{n}],'units','normalized','Fontsize',txtsize,'Fontweight','bold','FontName','Arial')
end

gx(4).LatitudeAxis.TickLabel = [];
gx(2).LatitudeAxis.TickLabel = [];

gx(3).LongitudeAxis.TickLabel = [];
gx(4).LongitudeAxis.TickLabel = [];    

if save_plot ==1; export_fig([figpath 'Fig02_physChar.pdf'],'-nofontswap'); 
    print -dpng -r600 Fig02_physChar.png
end
