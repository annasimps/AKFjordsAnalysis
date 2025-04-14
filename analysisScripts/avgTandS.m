%%% This script averages temperature and salinity together

%% load color vectors
colors = load([rootdir '2 Alaska Fjord Data Gathering Project/code/functions/color.mat']);
colors = colors.color;

%% Average temperature and salinity and put into matrix
fjord.avgT = NaN*ones(200,length(fjord.lat),4);
fjord.minT = NaN*ones(200,length(fjord.lat),4);
fjord.maxT = NaN*ones(200,length(fjord.lat),4);
fjord.lowCI_T = NaN*ones(200,length(fjord.lat),4);
fjord.higCI_T = NaN*ones(200,length(fjord.lat),4);

fjord.avgS = NaN*ones(200,length(fjord.lat),4);
fjord.minS = NaN*ones(200,length(fjord.lat),4);
fjord.maxS = NaN*ones(200,length(fjord.lat),4);
fjord.lowCI_S = NaN*ones(200,length(fjord.lat),4);
fjord.higCI_S = NaN*ones(200,length(fjord.lat),4);

fjord.numT = NaN*ones(1,length(fjord.lat),4);
fjord.numS = NaN*ones(1,length(fjord.lat),4);

fjord.avgN2 =  NaN*ones(200,length(fjord.lat),4);
fjord.minN2 = NaN*ones(200,length(fjord.lat),4);
fjord.maxN2 = NaN*ones(200,length(fjord.lat),4);

for n = 1:length(fjord.lat)
    
    if ~isempty(fjord.casts(n).lat)
        dates = datetime(fjord.casts(n).time,'ConvertFrom','datenum','Format','yyyy-MM');
        yr = year(dates);
        mth = month(dates);
        yr_uniq = unique(yr); 
        seasN(1,:) = [1,2,3];
        seasN(2,:)= [4,5,6];
        seasN(3,:)= [7,8,9];
        seasN(4,:)= [10,11,12];
        
        for ss = 1:size(seasN,1)
            indseas = find(mth >=seasN(ss,1) & mth <=seasN(ss,3));
            
            fjord.avgT(:,n,ss) = nanmean(fjord.casts(n).T(:,indseas),2);
            fjord.avgS(:,n,ss) = nanmean(fjord.casts(n).S(:,indseas),2);
            
            SA = gsw_SA_from_SP(fjord.avgS(:,n,ss)',fjord.casts(n).z,fjord.lon(n),fjord.lat(n));
            CT = gsw_CT_from_t(SA,fjord.avgT(:,n,ss)',fjord.casts(n).z);
            [fjord.avgN2(2:end,n,ss),pmid] = gsw_Nsquared(SA,CT,fjord.casts(n).z);
            
            fjord.numT(1,n,ss) = length(indseas);
%             fjord.numS(1,n,ss) = 
            if ~isempty(indseas)
                [qT] = quantile(fjord.casts(n).T(:,indseas),[.05 .95],2);
                fjord.lowCI_T(:,n,ss) = qT(:,1);
                fjord.higCI_T(:,n,ss) = qT(:,2);
                fjord.minT(:,n,ss) = nanmin(fjord.casts(n).T(:,indseas),[],2);
                fjord.maxT(:,n,ss) = nanmax(fjord.casts(n).T(:,indseas),[],2);
                
                [qS] = quantile(fjord.casts(n).S(:,indseas),[.05 .95],2);
                fjord.lowCI_S(:,n,ss) = qS(:,1);
                fjord.higCI_S(:,n,ss) = qS(:,2);
                fjord.minS(:,n,ss) = nanmin(fjord.casts(n).S(:,indseas),[],2);
                fjord.maxS(:,n,ss) = nanmax(fjord.casts(n).S(:,indseas),[],2);
                
                SA = gsw_SA_from_SP(fjord.lowCI_S(:,n,ss)',fjord.casts(n).z,fjord.lon(n),fjord.lat(n));
                CT = gsw_CT_from_t(SA,fjord.lowCI_T(:,n,ss)',fjord.casts(n).z);
                [fjord.minN2(2:end,n,ss),pmid] = gsw_Nsquared(SA,CT,fjord.casts(n).z);
                
                SA = gsw_SA_from_SP(fjord.higCI_S(:,n,ss)',fjord.casts(n).z,fjord.lon(n),fjord.lat(n));
                CT = gsw_CT_from_t(SA,fjord.higCI_T(:,n,ss)',fjord.casts(n).z);
                [fjord.maxN2(2:end,n,ss),pmid] = gsw_Nsquared(SA,CT,fjord.casts(n).z);
%                 fjord.numT(:
            end
        end
    end
end

totmean = nanmean(fjord.avgT,3);
fjwdat = (find(sum(isnan(totmean))<200));
fjcmap = distinguishable_colors(length(fjwdat));
fjord.cmap = NaN*ones(length(fjord.lat),3);
for n = 1:length(fjwdat)
    fjord.cmap(fjwdat(n),:) = fjcmap(n,:);
end
