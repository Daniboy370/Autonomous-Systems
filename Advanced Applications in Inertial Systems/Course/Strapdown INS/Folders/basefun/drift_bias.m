function [eb, web, db, wdb] = drift_bias(val)

global glv
if exist('val')==0
    val = 1;
end
[m, n] = size(val);
if m == 1
    val = val*ones(4,1);
end
if n == 1
    val = repmat(val,1,3);
end
eb = val(1,:)'*0.01*glv.dph;
web = val(2,:)'*0.001*glv.dpsh;
db = val(3,:)'*100*glv.ug;
wdb = val(4,:)'*10*glv.ugpsHz;