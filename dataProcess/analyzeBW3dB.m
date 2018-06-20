function [ BW ] = analyzeBW3dB( spec )
%ANALYZEBW3DB 输入第一列为波长，第二列为光谱，单位为dB，

temp = spec;
[Max,I_max] = max(temp(:,2));
three_dB = Max - 3;
I_l = find(abs(temp(1:I_max,2) - three_dB) == min(abs(temp(1:I_max,2) - three_dB)));
I_r = find(abs(temp(I_max:end,2) - three_dB) == min(abs(temp(I_max:end,2) - three_dB)))+I_max;
BW = mean(temp(I_r,1)) - mean(temp(I_l,1));   %取平均，防止多点等dB值的情况出现报错

end

