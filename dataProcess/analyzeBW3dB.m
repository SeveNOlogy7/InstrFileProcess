function [ BW ] = analyzeBW3dB( spec )
%ANALYZEBW3DB �����һ��Ϊ�������ڶ���Ϊ���ף���λΪdB��

temp = spec;
[Max,I_max] = max(temp(:,2));
three_dB = Max - 3;
I_l = find(abs(temp(1:I_max,2) - three_dB) == min(abs(temp(1:I_max,2) - three_dB)));
I_r = find(abs(temp(I_max:end,2) - three_dB) == min(abs(temp(I_max:end,2) - three_dB)))+I_max;
BW = mean(temp(I_r,1)) - mean(temp(I_l,1));   %ȡƽ������ֹ����dBֵ��������ֱ���

end

