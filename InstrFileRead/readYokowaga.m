function [ M,Fig ] = readYokowaga(filePath, cfg,varargin)
%READYOKOWAGA 绘制光谱图 by CJH
%   How to Use：
%       cfg.dspTrace = {'A','B','C','D','E','F','G'};
%       cfg.smooth = 1;         %设置为大于1的值有平滑效果
%       cfg.LineWidth = 2;      %设置线宽，参考setPlotCfg(cfg)函数，不设置则使用其中定义的默认值
%       cfg.export = 1;         %设置为1后，M为平滑后的数据
%       readYokowaga( '',cfg);  %自动打开UI界面，选取光谱csv数据文件；等效于readYokowaga( [],cfg);
%       readYokowaga('C:\Documents\Research\Experiment\F8-DSR\CJH0407_1.CSV',cfg);
%       readYokowaga('C:\Documents\Research\Experiment\F8-DSR\CJH0409_1.CSV',cfg);
%       readYokowaga(~,~,Fig);  %传入Fig参数可在已有的图形上叠加光谱图

% 仅测试了两款型号（可见光、近红外）的all_trace.csv文件的读取和识别
cfg = setPlotCfg(cfg);          % 读取默认的画图配置，不会覆盖所有已设置的配置值
%% 检测配置参数，将未定义值设置为默认参数；不检查配置的合法性
if ~isfield(cfg,'dspTrace')     % 设置要绘制的通道编号
    cfg.dspTrace = {'A','B','C','D','E','F','G'};
end
if ~isfield(cfg,'smooth')       % 设置是否进行平滑化（目前的平滑算法可保留噪声限）
    cfg.smooth = 0;
end
if ~isfield(cfg,'export')       % 设为1则输出数据M为处理后的数据，否则为原始数据
    cfg.export = 0;
end
% 预处理输入的文件路径
if isempty(filePath) % 如果文件路径为空(输入''或[])
    [FileName,PathName,~] = uigetfile('*.csv'); % 打开UI界面进行输入
    if FileName == 0
        return
    end
    filePath = [PathName,FileName];
end
% 处理可变参数： Fig
if ~isempty(varargin) && isa(varargin{1},'matlab.ui.Figure')
    Fig = varargin{1};          % 如果第一个可变参数为Figure，则生成Fig变量
end
% 设置cfg.plot参数
if exist('Fig','var')           % 如果已传入Figure对象
    cfg.plot = 1;               % 设置cfg.plot为1，绘图
    Fig = figure(Fig);hold on;  % 在当前Figure对象上绘图
elseif ~isfield(cfg,'plot')     % 未传入Figure对象，且未设置cfg.plot参数
    cfg.plot = 1;               % 默认设置cfg.plot为1，绘图
    Fig = figure();hold on;     % 打开新的Figure对象
elseif cfg.plot == 1            % 未传入Figure对象，且设置cfg.plot为1
    Fig = figure();hold on;     % 打开新的Figure对象
else
    Fig = [];                   % 若已设置cfg.plot为0，则不绘图
end
% 读取csv文件
[M,txt,~] = xlsread(filePath);
% 设置要绘制的Trace
[r,~] = find(strcmp(txt,'[TRACE DATA]'));   % 根据文件结构，获取有用数据的行索引
M = M(r-2:end,:);               % 输出原始的csv数据
if cfg.export == 1
    % 若需要导出处理后的数据，则先为输出按照M的长度新建缓存，列数与通道数一致
    M_temp = nan(size(M,1),2*length(cfg.dspTrace));
end
%% 依次绘制各通道
strings = {'A','B','C','D','E','F','G'};
for ii= 1:length(cfg.dspTrace)
    idx = find(strcmp(strings,cfg.dspTrace{ii}));   % 得到要绘制的通道对应的列索引
    temp = M(1:end,2*idx-1:2*idx);          % 读取当前通道数据列
    temp = temp(~isnan(temp));              % 剔除无效数据（不同通道的数据长度可能不同）
    temp = reshape(temp,length(temp)/2,2);
    if cfg.smooth ~= 0
        % 信号平滑算法（主要对信号进行平滑，可保留噪声限的平均值）
        % 利用histogram获得噪声限（噪声平均值）
        [N,edges] = histcounts(temp(:,2),35);
        f = findExtMax(N);       % 在有光谱信号的情况下histogram为双峰结构(噪声峰+信号峰)
        f = f(N(f)>(length(temp)/100));
        Noise_lim = min(edges(f));
        %获得-210值的索引（如果不处理-210直接平滑会导致失真）
        %替换其为噪声限的大小，再平滑处理
        idx_not_210 = temp(:,2) ~= -210;    
        temp(~idx_not_210,2) = Noise_lim;   % 用min(temp(idx_not_210,2))不好
        %平滑处理,并恢复原为-210的值
        temp(:,2) = smooth(temp(:,2),cfg.smooth);	
        temp(~idx_not_210,2) = -210;                
    end
    if cfg.plot == 1
        plot(temp(:,1),temp(:,2),'LineWidth',cfg.LineWidth);
    end
    if cfg.export == 1  % 导出处理后的数据
        M_temp(1:size(temp,1),2*ii-1:2*ii) = temp;
    end
end
if cfg.export == 1
    M = M_temp; % 导出处理后的数据
end
if cfg.plot == 1
    hold off;
    setGcaByCfg(Fig,cfg);   % 设置绘图格式
end
end
