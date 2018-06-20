function [ M,Fig ] = readSpectrumAnalyzer( filePaths, cfg )
%READSPECTRUMANALYZER ������ƵƵ���ǵ�Ƶ��ͼ
%   How to Use���μ�readYokowaga��readOscilloscope����˵��
%               ��δʵ���������ߵ�ȫ�����ܣ�ֻ�ܻ��Ƶ����ļ�����ͨ��

Fig = [];
if ~isfield(cfg,'xFactor')
    cfg.xFactor = 1;
end
if ~isfield(cfg,'xBias')
    cfg.xBias = 0;
end
if ~isfield(cfg,'smooth')
    cfg.smooth = 1;
end
cfg = setPlotCfg(cfg);
if strcmp(filePaths, '')
    [FileName,PathName,~] = uigetfile('*.csv');
    if FileName == 0
        return
    end
    filePaths = [PathName,FileName];
end
[M,~,~] = xlsread(filePaths);

if isfield(cfg,'plot') && cfg.plot == 1
    Fig = figure();
    if cfg.smooth ~= 0
        M(:,3) = smooth(M(:,3),cfg.smooth);
    end
    plot(M(:,1)*cfg.xFactor - cfg.xBias,M(:,3),'LineWidth',cfg.LineWidth);
end
figure(Fig)
setGcaByCfg(Fig,cfg);   % ���û�ͼ��ʽ
end

