% read text data
clear txt_cast
clear textfile
% txtfile = [datapath  '/0000900/1.1/data/0-data/02080185.R6A'];% 02079165.R1A'];
fid = fopen(txtfile); 
tfile = fscanf(fid,'%c');

fLat = strfind(tfile,'LAT');
latint = str2num(tfile(fLat+4:fLat+12));
if ~isempty(latint)
    txt_cast.lat = latint(1)+latint(2)/60;
else
   txt_cast.lat = NaN;
end

fLon = strfind(tfile,'LG');
lonint =  str2num(tfile(fLon+3:fLon+12));
if ~isempty(lonint)
    txt_cast.lon = lonint(1)-lonint(2)/60;
    if txt_cast.lon>0
        txt_cast.lon = -txt_cast.lon;
    end
else
    txt_cast.lon = NaN;
end

tind = strfind(tfile,'DATE');
timeint = [tfile(tind+5:tind+12) ' ' tfile(tind+21:tind+22) ':' tfile(tind+23:tind+24)];
txt_cast.time= datenum(timeint,'yy-mm-dd HH:MM');


fseek(fid,0,-1);                % set read position to beginning of file
% while strcmp(fgetl(fid),'QUALITY') == 0; end        % go through lines until '*END*'
 while contains(fgetl(fid),'press','IgnoreCase',true) ==0; end 

n=1;                            
while 1
    tline = fgetl(fid) ;                % read in line
    if ~ischar(tline), break, end       % if eof, break and finish
    textfile(n,:) = sscanf(tline,'%f');     % put numbers in a matrix (in columns)
    n=n+1;
end

txt_cast.z = textfile(:,1);
txt_cast.T = textfile(:,2);
txt_cast.S = textfile(:,3);

fclose(fid);