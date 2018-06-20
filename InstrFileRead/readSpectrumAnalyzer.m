function [ M,Fig ] = readSpectrumAnalyzer( filePaths, cfg )
%READSPECTRUMANALYZER 绘制射频频谱仪的频谱图
%   How to Use：参见readYokowaga、readOscilloscope函数说明
%               并未实现上面两者的全部功能，只能绘制单个文件、单通道

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
setGcaByCfg(Fig,cfg);   % 设置绘图格式
end

