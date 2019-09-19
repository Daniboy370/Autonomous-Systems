function gpx(fname, pos)
% 生成*.gpx文件，由"Google Earth"->工具->GPS->设备:从文件导入，显示航迹
global glv
fid = fopen(fname, 'wt');
fprintf(fid, '<?xml version="1.0"?>\n');
fprintf(fid, '<gpx\n');
fprintf(fid, 'version="1.1"\n');
fprintf(fid, 'creator="YanGongmin@NWPU"\n');
fprintf(fid, 'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"\n');
fprintf(fid, 'xmlns="http://www.topografix.com/GPX/1/1"\n');
fprintf(fid, 'xsi:schemaLocation="http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd">\n');
fprintf(fid, '<trk>\n');
fprintf(fid, '<name>converted</name>\n');
fprintf(fid, '<trkseg>\n');
for k=1:length(pos)
    fprintf(fid, '<trkpt lat="%.6f" lon="%.6f">\n', r2d(pos(k,1)), r2d(pos(k,2)));
    fprintf(fid, '<ele>%.6f</ele>\n',pos(k,3));
    [hms,str] = s2hms(k);
    fprintf(fid, '<time>2011-08-10T%sZ</time>\n', str);
    fprintf(fid, '</trkpt>\n');
end
fprintf(fid, '</trkseg>\n');
fprintf(fid, '</trk>\n');
fprintf(fid, '</gpx>\n');
fclose(fid);
