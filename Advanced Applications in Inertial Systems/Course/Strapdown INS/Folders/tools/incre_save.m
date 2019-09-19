function data = incre_save(data, factor, fname)
% ������������ʽ�������ݣ��Խ��ʹ洢�ռ�
    str = '*';
    for k=1:length(factor);
        data(:,k) = data(:,k)/factor(k);
        str = [str, '%d '];
    end
    data = diff( [zeros(size(factor)); fix(cumsum(data,1))] );
    str = [str(2:end-1), '\n'];    
    fid = fopen(fname, 'wt');
    fprintf(fid, str, data');
    fclose(fid);