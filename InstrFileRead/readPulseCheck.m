function [  M,Fig ] = readPulseCheck( filePaths, cfg, varargin )
%READPULSECHECK 绘制PulseCheck自相关仪的自相关迹
%       参考readOscilloscope，允许输入Fig参数，叠加绘图
%       多文件绘图时，设置cfg.align = 1，可以对齐zero level

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
if ~isempty(varargin) && strcmp(class(varargin{1}),'matlab.ui.Figure')
    Fig = varargin{1};
end
if exist('Fig','var')
    cfg.plot = 1;
    Fig = figure(Fig);hold on;
elseif ~isfield(cfg,'plot')
    cfg.plot = 1;
    Fig = figure();hold on;
elseif cfg.plot == 1
    Fig = figure();hold on;
else
    Fig = [];
end
% 输入了空路径
if isempty(filePaths)    % 输入空路径则打开UI界面进行输入
    [FileName,PathName,~] = uigetfile('*.csv'); % 可以考虑使用multiselect模式
    if FileName == 0
        return
    end
    filePaths = [PathName,FileName];
end
% 输入了多个路径(cell)
if iscell(filePaths) && length(filePaths)>1
    if ~isfield(cfg,'align')
        cfg.align = 1;
    end
else
    cfg.align = 0;
end

if iscell(filePaths)
    % 输入了多个单通道txt文件路径
    % 简单起见，假设是在同样的采样长度下测量的
    M = [];
    I_max = 0;
    for ii = 1:length(filePaths)
        [time,acf] = importAC(filePaths{ii});
        I_max = max([I_max;acf]); % 找最大值
        M = [M,time,acf];
    end
    
    for ii = 1:length(filePaths)
        if cfg.smooth ~= 0
            M(:,2*ii) = smooth(M(:,2*ii),cfg.smooth);   % 滑动平均平滑化
        end
        M(:,2*ii) = M(:,2*ii)/I_max;    % 归一化
    end
    if cfg.align == 1
        acf_range = 2*(1:length(filePaths));
        I_min = min(M(:,acf_range));    % 找最小值，不同测量的zero level可能不同
        M(:,acf_range) = M(:,acf_range)-repmat(I_min,length(acf),1);
    end
    if cfg.plot == 1
        for ii = 1:length(filePaths)
            plot(M(:,2*ii-1)*cfg.xFactor - cfg.xBias,M(:,2*ii),'LineWidth',cfg.LineWidth);
        end
        hold off;
    end
    
else
    [time,acf] = importAC(filePaths);
    acf = acf/max(acf);
    if cfg.smooth ~= 0
        acf = smooth(acf,cfg.smooth);   % 滑动平均平滑化
    end
    M = [time,acf];
    if isfield(cfg,'plot') && cfg.plot == 1
        plot(time*cfg.xFactor - cfg.xBias,acf,'LineWidth',cfg.LineWidth);
    end
end
if cfg.plot == 1
    setGcaByCfg(Fig,cfg);   % 设置绘图格式
end
end