function [ M,Fig ] = readOscilloscope( filePaths, cfg)
%READOSCILLOSCOPE 绘制示波器波形图 by CJH
%   example：
%       cfg.xFactor = 1000;     % 横坐标的缩放因子
%       cfg.xBias = 100;        % 横坐标的平移因子
%       readOscilloscope('C:\Documents\Research\Experiment\F8-DSR\0409\cjh-0409-2000.csv',cfg);

% 测试了TDS 7154 型号的单通道csv文件
Fig = [];
cfg = setPlotCfg(cfg);
if ~isfield(cfg,'xFactor')
    cfg.xFactor = 1;
end
if ~isfield(cfg,'xBias')
    cfg.xBias = 0;
end
if ~isfield(cfg,'plot')
    cfg.plot = 1;
end
if ~isfield(cfg,'smooth')
    cfg.smooth = 0;
end
% 输入了空路径
if isempty(filePaths)    % 输入空路径则打开UI界面进行输入
    [FileName,PathName,~] = uigetfile('*.csv'); % 可以考虑使用multiselect模式
    if FileName == 0
        return
    end
    filePaths = [PathName,FileName];
end
if iscell(filePaths)
    % 输入了多个单通道csv文件路径
    % 简单起见，假设是在同样的采样长度下测量的
    M = [];
    I_max = 0;
    for ii = 1:length(filePaths)
        [temp,~,~] = xlsread(filePaths{ii});
        I_max = max([I_max;temp(:,4)]); % 找最大值
        M = [M,temp(:,3),temp(:,4)];
    end
    for ii = 1:length(filePaths)
        if cfg.smooth ~= 0
            M(:,2*ii) = smooth(M(:,2*ii),cfg.smooth);   % 滑动平均平滑化
        end
        M(:,2*ii) = M(:,2*ii)/I_max;    % 归一化
    end
    if cfg.plot == 1
        Fig = figure();hold on;
        for ii = 1:length(filePaths)
            plot(M(:,2*ii-1)*cfg.xFactor - cfg.xBias,M(:,2*ii),'LineWidth',cfg.LineWidth);
        end
        hold off;
    end
else
    % 输入了单文件路径
    [M,~,~] = xlsread(filePaths);
    if cfg.smooth ~= 0
        M(:,4) = smooth(M(:,4),cfg.smooth);   % 滑动平均平滑化
    end
    M(:,4) = M(:,4)/max(M(:,4));
    if isfield(cfg,'plot') && cfg.plot == 1
        Fig = figure();
        plot(M(:,3)*cfg.xFactor - cfg.xBias,M(:,4),'LineWidth',cfg.LineWidth);
    end
end
if cfg.plot == 1
    hold off;
    setGcaByCfg(Fig,cfg);   % 设置绘图格式
end
end