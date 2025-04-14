% Filter Salinity again

for n = 1:length(seas)
    for m = 1:length(fjord.lat)
        for dd = 15:length(fjord.casts(1).z)
%             if dd==1
%                 compS = abs(fjord.lowCI_S(dd,m,n) -fjord.lowCI_S(dd+1,m,n));
%                 if compS>1
%                     fjord.lowCI_S(dd,m,n) = NaN;
%                 end
%             elseif dd == length(fjord.casts(1).z)
%                 compS = abs(fjord.lowCI_S(dd,m,n) -fjord.lowCI_S(dd-1,m,n));
%                 if compS>1
%                     fjord.lowCI_S(dd,m,n) = NaN;
%                 end
%             else
                compS1 = abs(fjord.lowCI_S(dd,m,n) -fjord.lowCI_S(dd-1,m,n));
                compS2 = abs(fjord.lowCI_S(dd,m,n) -fjord.lowCI_S(dd-1,m,n));
                if compS1 >1 || compS2 >1
                    fjord.lowCI_S(dd,m,n) = NaN;
                end
%             end
        end
    end
end
