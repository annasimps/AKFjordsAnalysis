% read text data
clear txt_cast
clear textfile
% txtfile = [datapath  '/0000900/1.1/data/0-data/01130175.txt'];% 02079165.R1A'];
fid = fopen(txtfile); 
tfile = fscanf(fid,'%c');

fLat = strfind(tfile,'LATITUDE');
latint = str2num(tfile(fLat+16:fLat+24));
if ~isempty(latint)
    txt_cast.lat = latint;
else
   txt_cast.lat = NaN;
end

fLon = strfind(tfile,'LONGITUDE');
lonint =  str2num(tfile(fLon+17:fLon+27));
if ~isempty(lonint)
    txt_cast.lon = lonint; 
    if txt_cast.lon>0
        txt_cast.lon = -txt_cast.lon;
    end
else
    txt_cast.lon = NaN;
end

tind1 = strfind(tfile,'DATE');
timeint1 = tfile(tind1+6:tind1+15);
tind2 = strfind(tfile,'TIME');
timeint2 = tfile(tind2+6:tind2+9);
timeint = [timeint1 ' ' timeint2(1:2) ':' timeint2(3:4)];
txt_cast.time= datenum(timeint);


fseek(fid,0,-1);                % set read position to beginning of file
% while strcmp(fgetl(fid),'QUALITY') == 0; end        % go through lines until '*END*'
 while contains(fgetl(fid),'psu','IgnoreCase',true) ==0; end 

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