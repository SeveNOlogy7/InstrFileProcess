function [ extm ] = finExtMax( val )
%FINEXTMAX 找极大值点

yy1 = diff(val);
yy1 = sign(yy1);
yy1 = diff(yy1);
extm = find(yy1<0)+1;

end

